//
//  TestingView.swift
//  challenge3
//
//  Created by Leung Lee Kiu on 20/11/26.
//
import SwiftUI
import UIKit

struct TestView: View {
    
    var onShowOnboarding: (() -> Void)? = nil
    
    @Environment(\.dismiss) private var dismiss

    @State private var assignmentImages: [String: UIImage] = [:]
    @State var pressedButton: String = ""
    @State private var tutorialButton: String = ""

    @State private var showExplain = false
    @State private var showCamera = false

    @State var explainedButtons: Set<String> = []
    @State var completedLessons: Set<String> = []

    @State private var cameraImage: UIImage?
    @State private var hasLoadedProgress = false

    @State private var showEnding = false
    @State private var presentEndingAfterDismiss = false

    @AppStorage("hasShownEnding") private var hasShownEnding = false
    
//    private let forest = Color(red: 0.10, green: 0.3, blue: 0.15)
//    private let moss = Color(red: 0.30, green: 0.43, blue: 0.29)
//    private let cream = Color(red: 0.792, green: 0.306, blue: 0.2)
//    private let brown = Color(red: 0.596, green: 0.337, blue: 0.161)
//    private let gold = Color(red: 0.91, green: 0.67, blue: 0.32)

    private let lessonTitles: [String] = [
        "Eye level photos",
        "Close-ups",
        "Long Shot photos",
        "Low Angle photos",
        "High Angle photos",
        "Dutch Angle photos",
        "Wide Angle photos",
        "Rule of Thirds",
        "Centre Composition",
        "Frame within a frame",
        "Negative Space",
        "Patterns and Repetition",
        "Diagonal Lines and Triangles",
        "Isolating the Subject",
        "Architectural Frames",
        "Natural Frames",
        "Human or Animal Shapes",
        "Tunnels and Underpasses",
        "Geometric and Fence Lines",
        "Partial Framing",
        "Reflective Framing",
        "Hard Light",
        "Soft Light",
        "Front Light",
        "Side Light",
        "Back Light",
        "Natural Light",
        "Butterfly Lighting"
    ]

    private var edgeInset: CGFloat {
        UIScreen.main.bounds.width / 4
    }

    private func hasFinished(_ id: String) -> Bool {
        completedLessons.contains(id)
    }

    private func buttonColor(_ number: Int) -> Color {
        let colors: [Color] = [
//            brown,
//            moss,
//            cream,
//            gold
            .red,
            .orange,
            .yellow,
            .green,
            .blue,
            .indigo,
            .purple

        ]

        return colors[number % colors.count]
    }

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 20) {

                    titleHeader
                    
                    Spacer()

                    lessonList
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Color(
                    red: 0.902,
                    green: 0.902,
                    blue: 0.980
                )
//                Color(red: 0.96, green: 0.95, blue: 0.88)
            )
            .fullScreenCover(
                isPresented: $showCamera,
                onDismiss: handleCameraDismiss
            ) {
                if let capturedImage = cameraImage {
                    NavigationStack {
                        ResultView(
                            image: capturedImage,
                            assignmentImages: $assignmentImages,
                            assignToSlotID: pressedButton,
                            completedLessons: $completedLessons,
                            onFinish: {
                                let finishedAllLessons = lessonTitles.indices.allSatisfy {
                                    completedLessons.contains(String($0))
                                }

                                // Only present the ending the first time every
                                // lesson has been completed.
                                if finishedAllLessons && !hasShownEnding {
                                    hasShownEnding = true
                                    presentEndingAfterDismiss = true
                                }

                                showCamera = false
                            }
                        )
                        .toolbar {
                            ToolbarItem(
                                placement: .cancellationAction
                            ) {
                                Button {
                                    cameraImage = nil
                                } label: {
                                    Image(
                                        systemName: "arrow.counterclockwise"
                                    )
                                }
                            }
                        }
                    }
                } else {
                    NavigationStack{
                        ZStack {
                            CameraView(
                                image: $cameraImage,
                                dismissAfterCapture: false
                            )
                            OverlayOverlayView(
                                pressedButton: $pressedButton
                            )
                            .ignoresSafeArea()
                        }
                        .toolbar{
                            ToolbarItem(placement: .cancellationAction) {
                                Button{
                                    showCamera = false
                                } label:{
                                    Image(systemName: "xmark")
                                }
                            }
                        }
                    }
                }
            }
            .navigationDestination(
                isPresented: $showExplain
            ) {
                TutorialView(
                    pressedButton: $tutorialButton
                )
            }
            .toolbar {
                if let onShowOnboarding {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: onShowOnboarding) {
                            Image(systemName: "questionmark.circle")
                        }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showEnding) {
            EndingView(onClose: { showEnding = false })
        }
        .onAppear {
            if !hasLoadedProgress {
                hasLoadedProgress = true
                loadProgress()
            }
        }
        .onChange(of: explainedButtons) {
            saveProgress()
        }
        .onChange(of: completedLessons) {
            saveProgress()
        }
        .onChange(of: assignmentImages) {
            saveProgress()
        }
    }

    private var titleHeader: some View {
        HStack {
            Spacer()

            RoundedRectangle(cornerRadius: 16)
                .glassEffect(in: .rect(cornerRadius: 16))
                .frame(width: 300, height: 90)
                .shadow(
                    color: Color.gray.opacity(0.7),
                    radius: 20,
                    y: 8
                )
                .overlay {
                    HStack(spacing: 6) {
                        Text("Angle")
                            .foregroundColor(.white)
                            .font(.largeTitle)

                        Image(systemName: "angle")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                    }
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            Color.white.opacity(0.35),
                            lineWidth: 1
                        )
                }

            Spacer()
        }
//            VStack {
//                HStack(spacing: 6) {
//                    Text("Angle")
//                        .foregroundColor(.black)
//                        .font(.system(size: 50).bold())
//                    Image(systemName: "angle")
//                        .font(.system(size: 50).bold())
//                        .foregroundColor(.black)
//                }
//                
//                Spacer()
//                Spacer()
//                
//                
//            }
    }

    private var lessonList: some View {
        ForEach(0..<lessonTitles.count, id: \.self) { number in
            lessonItem(number)
        }
    }

    @ViewBuilder
    private func lessonItem(_ number: Int) -> some View {
        if number == 7 {
            sectionHeader(
                "Composition",
                icon: "aspectratio"
            )

            Spacer()
        }

        if number == 14 {
            sectionHeader(
                "Framing",
                icon: "photo.artframe"
            )

            Spacer()
        }

        if number == 21 {
            sectionHeader(
                "Lighting",
                icon: "sun.max.fill"
            )

            Spacer()
        }

        lessonRow(number)

        if number == 6 || number == 13 || number == 20 || number == 27 {
            Spacer()
        }
    }

    @ViewBuilder
    private func sectionHeader(
        _ title: String,
        icon: String
    ) -> some View {
        VStack(spacing: 70) {
            Spacer()
            HStack {
                Spacer()

//                RoundedRectangle(cornerRadius: 16)
//                    .fill(Color.black)
//                    .frame(width: 300, height: 90)
//                    .shadow(
//                        color: Color.gray.opacity(0.7),
//                        radius: 20,
//                        y: 8
//                    )
                RoundedRectangle(cornerRadius: 16)
                    .glassEffect(in: .rect(cornerRadius: 16))
                    .frame(width: 300, height: 90)
                    .shadow(
                        color: Color.gray.opacity(0.7),
                        radius: 20,
                        y: 8
                    )
                    .overlay {
                        HStack(spacing: 6) {
                            Text(title)
                                .foregroundColor(.black)
                                .font(.system(size: 50).bold())

                            Image(systemName: icon)
                                .font(.system(size: 50).bold())
                                .foregroundColor(.black)
                        }

                Spacer()
            }
            Spacer()
        }
    }

    @ViewBuilder
    private func lessonRow(_ number: Int) -> some View {
        let id = String(number)

        HStack {
            if number % 2 == 1 {
                lessonButton(number, id: id)

                if explainedButtons.contains(id) {
                    explainButton(
                        id,
                        title: lessonTitles[number]
                    )
                }

                Spacer()
            } else {
                Spacer()

                if explainedButtons.contains(id) {
                    explainButton(
                        id,
                        title: lessonTitles[number]
                    )
                }

                lessonButton(number, id: id)
            }
        }
        .padding(
            number % 2 == 0 ? .trailing : .leading,
            edgeInset
        )
    }

    private func lessonButton(
        _ number: Int,
        id: String
    ) -> some View {
        Button {
            pressedButton = id

            if explainedButtons.contains(id) {
                showCamera = true
            } else {
                explainedButtons.insert(id)
                tutorialButton = id
                showExplain = true
            }
        } label: {
            Image(systemName: "pawprint.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundStyle(buttonColor(number).gradient)
                .shadow(
                    color: buttonColor(number).opacity(0.8),
                    radius: 12
                )
                .overlay {
                    if let image = assignmentImages[id] {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    }
                }
        }
        .buttonStyle(.plain)
        .disabled(
            number > 0 &&
            !hasFinished(String(number - 1))
        )
        .opacity(
            number == 0 ||
            hasFinished(String(number - 1)) ? 1 : 0.35
        )
        .grayscale(
            number == 0 ||
            hasFinished(String(number - 1)) ? 0 : 1
        )
    }

    private func explainButton(
        _ id: String,
        title: String
    ) -> some View {
        Button(title) {
            tutorialButton = id
            showExplain = true
        }
        .font(.caption.weight(.semibold))
        .foregroundColor(.cyan)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Color.white.opacity(0.12))
        .clipShape(Capsule())
    }

    private func loadProgress() {
        let progress = LessonProgressStorage.load()

        explainedButtons = progress.explainedButtons
        completedLessons = progress.completedLessons

        assignmentImages = progress.assignmentImages.compactMapValues {
            UIImage(data: $0)
        }
    }

    private func saveProgress() {
        let progress = LessonProgress(
            explainedButtons: explainedButtons,
            completedLessons: completedLessons,
            assignmentImages: assignmentImages.mapValues {
                $0.normalizedJPEGData() ?? $0.pngData() ?? Data()
            }
        )

        LessonProgressStorage.save(progress)
    }

    private func resetCapture() {
        cameraImage = nil
    }

    private func handleCameraDismiss() {
        resetCapture()
        
        guard presentEndingAfterDismiss else { return }
        
        presentEndingAfterDismiss = false
        
        // Give the first cover time to finish dismissing before
        // presenting the ending flow.
        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(350))
            showEnding = true
        }
    }
    }
    
#Preview {
    TestView()
}
