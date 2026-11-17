//
//  CamerView.swift
//  challenge3
//
//  Created by Leung Lee Kiu on 11/11/26.
//

import SwiftUI
import Combine
@preconcurrency import AVFoundation
import UIKit

struct CameraView: View {
    @Binding var image: UIImage?
    var dismissAfterCapture = true

    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

    @StateObject private var camera = CameraController()
    @State private var captureFailed = false

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            CameraPreview(session: camera.session)
                .ignoresSafeArea()

            if let message = camera.errorMessage {
                errorView(message)
            } else if camera.isReady {
                shutterButton
            }

            closeButton
        }
        .task {
            await camera.start()
        }
        .onDisappear {
            camera.stop()
        }
        .statusBarHidden()
        .alert("Couldn't Take Photo", isPresented: $captureFailed) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Something went wrong while taking the photo. Please try again.")
        }
    }

    private var shutterButton: some View {
        VStack {
            Spacer()

            Button {
                takePhoto()
            } label: {
                ZStack {
                    Circle()
                        .stroke(Color.white, lineWidth: 5)
                        .frame(width: 78, height: 78)

                    Circle()
                        .fill(Color.white)
                        .frame(width: 62, height: 62)
                        .scaleEffect(camera.isCapturing ? 0.85 : 1)
                }
            }
            .buttonStyle(.plain)
            .disabled(!camera.isReady || camera.isCapturing)
            .opacity(camera.isCapturing ? 0.6 : 1)
            .animation(.easeInOut(duration: 0.15), value: camera.isCapturing)
            .accessibilityLabel("Take photo")
            .padding(.bottom, 36)
        }
    }

    private var closeButton: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(Color.white)
                        .frame(width: 42, height: 42)
                        .background(Color.black.opacity(0.45), in: Circle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Close camera")

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)

            Spacer()
        }
    }

    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "camera.fill")
                .font(.system(size: 44))
                .foregroundStyle(Color.white.opacity(0.8))

            Text(message)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.white)

            Button("Open Settings") {
                guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                openURL(settingsURL)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(32)
    }

    private func takePhoto() {
        camera.capturePhoto { capturedImage in
            guard let capturedImage else {
                captureFailed = true
                return
            }

            image = capturedImage

            if dismissAfterCapture {
                dismiss()
            }
        }
    }
}

// MARK: - Preview

private struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> CameraPreviewView {
        let view = CameraPreviewView()
        view.previewLayer.session = session
        view.previewLayer.videoGravity = .resizeAspectFill
        return view
    }

    func updateUIView(_ uiView: CameraPreviewView, context: Context) {
        if uiView.previewLayer.session !== session {
            uiView.previewLayer.session = session
        }
        uiView.updateVideoRotation()
    }
}

private final class CameraPreviewView: UIView {
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }

    var previewLayer: AVCaptureVideoPreviewLayer {
        guard let previewLayer = layer as? AVCaptureVideoPreviewLayer else {
            fatalError("Expected the view's backing layer to be an AVCaptureVideoPreviewLayer.")
        }
        return previewLayer
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateVideoRotation()
    }

    func updateVideoRotation() {
        guard let connection = previewLayer.connection else { return }

        let orientation = window?.windowScene?.interfaceOrientation ?? .portrait
        let angle = cameraRotationAngle(for: orientation)

        if connection.isVideoRotationAngleSupported(angle) {
            connection.videoRotationAngle = angle
        }
    }
}

// MARK: - Camera controller

@MainActor
private final class CameraController: NSObject, ObservableObject {
    nonisolated(unsafe) let session = AVCaptureSession()

    @Published private(set) var isReady = false
    @Published private(set) var isCapturing = false
    @Published private(set) var errorMessage: String?

    private let photoOutput = AVCapturePhotoOutput()
    private let sessionQueue = DispatchQueue(label: "com.challenge3.camera.session")

    private var isConfigured = false
    private var isActive = false
    private var captureCompletion: ((UIImage?) -> Void)?

    func start() async {
        isActive = true

        guard await requestCameraAccess() else {
            guard isActive else { return }
            errorMessage = "Camera access is off. Enable it in Settings to take photos."
            return
        }

        guard isActive else { return }

        configureSessionIfNeeded()
        guard errorMessage == nil else { return }

        await startSessionIfNeeded()
        guard isActive else { return }

        isReady = true
    }

    func stop() {
        isActive = false
        isReady = false
        isCapturing = false
        captureCompletion = nil

        sessionQueue.async { [session] in
            if session.isRunning {
                session.stopRunning()
            }
        }
    }

    func capturePhoto(completion: @escaping (UIImage?) -> Void) {
        guard isReady, !isCapturing else { return }

        isCapturing = true
        captureCompletion = completion

        let settings = AVCapturePhotoSettings()
        settings.photoQualityPrioritization = .quality

        if let connection = photoOutput.connection(with: .video) {
            let angle = cameraRotationAngle(for: currentInterfaceOrientation)

            if connection.isVideoRotationAngleSupported(angle) {
                connection.videoRotationAngle = angle
            }
        }

        photoOutput.capturePhoto(with: settings, delegate: self)
    }

    private func requestCameraAccess() async -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return true
        case .notDetermined:
            return await AVCaptureDevice.requestAccess(for: .video)
        default:
            return false
        }
    }

    private func configureSessionIfNeeded() {
        guard !isConfigured else { return }
        isConfigured = true

        session.beginConfiguration()
        session.sessionPreset = .photo

        guard let device = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: .back
        ),
        let input = try? AVCaptureDeviceInput(device: device),
        session.canAddInput(input) else {
            session.commitConfiguration()
            errorMessage = "No camera is available on this device."
            return
        }

        session.addInput(input)

        guard session.canAddOutput(photoOutput) else {
            session.commitConfiguration()
            errorMessage = "The camera could not be configured."
            return
        }

        session.addOutput(photoOutput)
        photoOutput.maxPhotoQualityPrioritization = .quality
        session.commitConfiguration()
    }

    private func startSessionIfNeeded() async {
        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            sessionQueue.async { [session] in
                if !session.isRunning {
                    session.startRunning()
                }
                continuation.resume()
            }
        }
    }

    private var currentInterfaceOrientation: UIInterfaceOrientation {
        let windowScene = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }

        return windowScene?.interfaceOrientation ?? .portrait
    }

    private func finishCapture(with image: UIImage?) {
        isCapturing = false

        let completion = captureCompletion
        captureCompletion = nil
        completion?(image)
    }
}

// MARK: - Photo capture delegate

extension CameraController: AVCapturePhotoCaptureDelegate {
    nonisolated func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {
        let image: UIImage?

        if error == nil, let data = photo.fileDataRepresentation() {
            image = UIImage(data: data)
        } else {
            image = nil
        }

        Task { @MainActor [weak self] in
            self?.finishCapture(with: image)
        }
    }
}

// MARK: - Orientation

private func cameraRotationAngle(for orientation: UIInterfaceOrientation) -> CGFloat {
    switch orientation {
    case .portrait:
        return 90
    case .portraitUpsideDown:
        return 270
    case .landscapeLeft:
        return 0
    case .landscapeRight:
        return 180
    default:
        return 90
    }
}

#Preview {
    CameraView(image: .constant(nil))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .ignoresSafeArea()
}
