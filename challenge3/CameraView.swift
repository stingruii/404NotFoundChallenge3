//
//  CameraView.swift
//  challenge3
//
//  Created by Leung Lee Kiu on 11/11/26.
//
//

import AVFoundation
import SwiftUI
import Combine

enum CameraEnvironment {
    static var isSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
}

struct CameraView: View {
    
    @Binding var image: UIImage?
    var dismissAfterCapture: Bool = false
    
    @StateObject private var camera = CameraController()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            //            Color.black
            //                .ignoresSafeArea()
            
            if CameraEnvironment.isSimulator {
                LinearGradient(
                    colors: [Color.gray.opacity(0.55), Color.black],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                .overlay {
                    VStack(spacing: 10) {
                        Image(systemName: "camera.fill")
                            .font(.largeTitle)
                        Text("Simulator preview")
                            .font(.headline)
                        Text("Tap the shutter to use a test photo")
                            .font(.caption)
                    }
                    .foregroundColor(.white)
                }
            } else {
                CameraPreview(session: camera.session)
                    .ignoresSafeArea()
            }
            VStack{
                HStack{
                    Button {
                        camera.toggleFlash()
                    } label: {
                        Image(systemName: flashIcon)
                            .font(.title2)
                            .foregroundColor(.black)
                            .frame(width: 44, height: 44)
                            .clipShape(Circle())
                            .glassEffect()
                    }
                    
                    Spacer()
                    
                    Button {
                        camera.switchCamera()
                    } label: {
                        Image(systemName: "arrow.triangle.2.circlepath.camera")
                            .font(.title2)
                            .foregroundColor(.black)
                            .frame(width: 44, height: 44)
                            .clipShape(Circle())
                            .glassEffect()
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                Spacer()
                
                Button {
                    camera.capturePhoto()
                } label: {
                    ZStack {
                        Circle()
                            .stroke(Color.white, lineWidth: 5)
                            .frame(width: 78, height: 78)
                        Circle()
                            .fill(Color.white)
                            .frame(width: 62, height: 62)
                    }
                }
                .disabled(!canCapture)
                .opacity(canCapture ? 1 : 0.5)
                .padding(.bottom, 32)
            }
        }
        .onAppear {
            if !CameraEnvironment.isSimulator {
                camera.checkAuthorization()
            }
        }
        .onDisappear {
            camera.stopSession()
        }
        //*//
        .onChange(of: camera.capturedImage) { _, newImage in
            guard let newImage = newImage else { return }
            image = newImage
            camera.capturedImage = nil
            
            if dismissAfterCapture {
                dismiss()
            }
        }
    }
    
    private var flashIcon: String {
        switch camera.flashMode {
        case .on: return "bolt.fill"
        case .auto: return "bolt.badge.a.fill"
        default: return "bolt.slash.fill"
        }
    }

    private var canCapture: Bool {
        CameraEnvironment.isSimulator || camera.isSessionRunning
    }
}


//struct CameraPreview: UIViewRepresentable {
//    let session: AVCaptureSession
//
//    func makeUIView(context: Context) -> PreviewView {
//        let view = PreviewView()
//        view.previewLayer.session = session
//        view.previewLayer.videoGravity = .resizeAspectFill
//
//        if let connection = view.previewLayer.connection,
//           connection.isVideoRotationAngleSupported(90) {
//            connection.videoRotationAngle = 90
//        }
//
//        return view
//    }
//}

struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession
    // specify the type (let 67: Int)
    
    func makeUIView(context: Context) -> PreviewView {
        //swiftui needs uikit to create this ui view and display the preview
        let view = PreviewView()
        view.previewLayer.session = session
        view.previewLayer.videoGravity = .resizeAspectFill
        view.updateVideoRotation()
        return view
    }
    
    func updateUIView(_ uiView: PreviewView, context: Context) {
        if uiView.previewLayer.session !== session {
            uiView.previewLayer.session = session
        }
        
        uiView.updateVideoRotation()
    }
    
    final class PreviewView: UIView {
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }
        
        var previewLayer: AVCaptureVideoPreviewLayer {
            layer as! AVCaptureVideoPreviewLayer
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            updateVideoRotation()
        }
        
        func updateVideoRotation() {
            guard let connection = previewLayer.connection else {
                return
            }
            
            let orientation = window?.windowScene?.interfaceOrientation ?? .portrait
            
            let angle: CGFloat
            
            switch orientation {
            case .portrait:
                angle = 90
            case .portraitUpsideDown:
                angle = 270
            case .landscapeLeft:
                angle = 0
            case .landscapeRight:
                angle = 180
            default:
                angle = 90
            }
            
            if connection.isVideoRotationAngleSupported(angle) {
                connection.videoRotationAngle = angle
            }
        }
    }
}


final class CameraController: NSObject, ObservableObject {
    
    @Published var capturedImage: UIImage?
    @Published var isSessionRunning = false
    @Published var authorizationStatus: AVAuthorizationStatus = .notDetermined
    @Published var flashMode: AVCaptureDevice.FlashMode = .off
    
    @Published var zoomFactor: CGFloat = 1.0
    private let minZoomFactor: CGFloat = 1.0
    private let maxZoomFactor: CGFloat = 5.0
    
    // AVFoundation components
    let session = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    private var currentInput: AVCaptureDeviceInput?
    
    // Queue for session configuration (off main thread)
    // waiting to be executed
    private let sessionQueue = DispatchQueue(label: "com.customcamera.sessionQueue") // queue's namee
    private var isConfigured = false
//    
//    //literally overriding
//    override init() {
//        super.init() //<- inherit from parent
//    }
//    
    //*//
    func checkAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            authorizationStatus = .authorized
            setupSession()
            
        case .notDetermined:
            authorizationStatus = .notDetermined
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    self?.authorizationStatus = granted ? .authorized : .denied
                    if granted {
                        self?.setupSession()
                    }
                }
            }
            
        case .denied, .restricted:
            authorizationStatus = .denied
            
        @unknown default:
            authorizationStatus = .denied
        }
    }
    
    //*
    private func setupSession() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            
            if self.isConfigured {
                if !self.session.isRunning {
                    self.session.startRunning()
                }
                DispatchQueue.main.async {
                    self.isSessionRunning = self.session.isRunning
                }
                return
            }
            //            self.isConfigured = true
            
            self.session.beginConfiguration()
            self.session.sessionPreset = .high
            
            guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                       for: .video,
                                                       position: .back),
                  let input = try? AVCaptureDeviceInput(device: camera) else {
                print("Failed to access camera")
                self.session.commitConfiguration()
                return
            }
            
            if self.session.canAddInput(input) {
                self.session.addInput(input)
                self.currentInput = input
            }
            
            if self.session.canAddOutput(self.photoOutput) {
                self.session.addOutput(self.photoOutput) //add photo output to the capture session
                
                // Configure photo output settings
                if let maxDimensions = camera.activeFormat.supportedMaxPhotoDimensions
                    .max(by: { $0.width * $0.height < $1.width * $1.height }) {
                    self.photoOutput.maxPhotoDimensions = maxDimensions
                }
                self.photoOutput.maxPhotoQualityPrioritization = .quality
            }
            
            self.session.commitConfiguration()
            
            //changed it here, only when the configuration is successful
            self.isConfigured = true
            
            self.session.startRunning()
            
            DispatchQueue.main.async {
                self.isSessionRunning = self.session.isRunning
            }
        }
    }
    
    func stopSession() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            
            if self.session.isRunning {
                self.session.stopRunning()
            }
            
            DispatchQueue.main.async {
                self.isSessionRunning = false
            }
        }
    }
    
    func capturePhoto() {
        // No camera in the Simulator, so hand back a generated test image instead.
        if CameraEnvironment.isSimulator {
            capturedImage = CameraController.simulatedPhoto()
            return
        }

        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            
            let settings = AVCapturePhotoSettings()
            if self.currentInput?.device.hasFlash == true {
                settings.flashMode = self.flashMode
            }
            
            settings.maxPhotoDimensions = self.photoOutput.maxPhotoDimensions
            
            self.photoOutput.capturePhoto(with: settings, delegate: self)
        }
    }
    
    func switchCamera() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            
            self.session.beginConfiguration()
            
            if let currentInput = self.currentInput {
                self.session.removeInput(currentInput)
            }
            
            let currentPosition = self.currentInput?.device.position ?? .back
            let newPosition: AVCaptureDevice.Position = (currentPosition == .back) ? .front : .back
            
            guard let newCamera = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                          for: .video,
                                                          position: newPosition),
                  let newInput = try? AVCaptureDeviceInput(device: newCamera) else {
                if let currentInput = self.currentInput,
                   self.session.canAddInput(currentInput) {
                    self.session.addInput(currentInput)
                }
                self.session.commitConfiguration()
                return
            }
            
            if self.session.canAddInput(newInput) {
                self.session.addInput(newInput)
                self.currentInput = newInput
            }
            
            self.session.commitConfiguration()
        }
    }
    
    func toggleFlash() {
        flashMode = switch flashMode {
        case .off: .on
        case .on: .auto
        case .auto: .off
        @unknown default: .off
        }
    }
    
    
    func zoom(factor: CGFloat) {
        sessionQueue.async { [weak self] in
            guard let self = self,
                  let device = self.currentInput?.device else { return }
            
            do {
                try device.lockForConfiguration()
                
                let clampedZoom = max(self.minZoomFactor,
                                      min(factor,
                                          min(self.maxZoomFactor, device.activeFormat.videoMaxZoomFactor)))
                
                device.videoZoomFactor = clampedZoom
                
                DispatchQueue.main.async {
                    self.zoomFactor = clampedZoom
                }
                
                device.unlockForConfiguration()
            } catch {
                print("Zoom error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Simulator support

    static func simulatedPhoto() -> UIImage {
        let size = CGSize(width: 1080, height: 1920)
        let renderer = UIGraphicsImageRenderer(size: size)

        return renderer.image { context in
            let hue = CGFloat.random(in: 0...1)
            let top = UIColor(hue: hue, saturation: 0.65, brightness: 0.95, alpha: 1)
            let bottom = UIColor(
                hue: (hue + 0.25).truncatingRemainder(dividingBy: 1),
                saturation: 0.75,
                brightness: 0.55,
                alpha: 1
            )

            let colors = [top.cgColor, bottom.cgColor] as CFArray
            if let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: colors,
                locations: [0, 1]
            ) {
                context.cgContext.drawLinearGradient(
                    gradient,
                    start: .zero,
                    end: CGPoint(x: size.width, y: size.height),
                    options: []
                )
            }

            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .center
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 88),
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraph
            ]
            let text = "Simulated Photo"
            (text as NSString).draw(
                in: CGRect(x: 80, y: size.height / 2 - 70, width: size.width - 160, height: 140),
                withAttributes: attributes
            )
        }
    }
    
}

nonisolated extension CameraController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        
        if let error = error {
            print("Photo capture error: \(error.localizedDescription)")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(),
              let uiImage = UIImage(data: imageData) else {
            print("Failed to convert photo to image")
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.capturedImage = uiImage
        }
    }
}
