//
//  TestView2.swift
//  challenge3
//
//  Created by T Krobot on 25/11/26.
//

import SwiftUI
import UIKit

struct TestView2: View {
    
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

//    private func buttonColor(_ number: Int) -> Color {
//        let colors: [Color] = [
//            .red,
//            .orange,
//            .yellow,
//            .green,
//            .blue,
//            .indigo,
//            .purple
//        ]
//
//        return colors[number % colors.count]
//    }
    
    private func buttonColor(_ number: Int) -> Color {
        let colors: [Color] = [
            .accentcolor1,
            .accentcolor2,
            .accentcolor3,
            .accentcolor4,
            .accentcolor5,
            .accentcolor6,
            .accentcolor7,
            .accentcolor8
            
        ]

        return colors[number % colors.count]
    }

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 20) {
                    Spacer()
                    Spacer()

                    titleHeader

                    lessonList
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Color(
                    red: 1,
                    green: 0.8,
                    blue: 0.6,
                    opacity: 0.4
                )
            )
            .fullScreenCover(
                isPresented: $showCamera,
                onDismiss: resetCapture
            ) {
                if let capturedImage = cameraImage {
                    NavigationStack {
                        ResultView(
                            image: capturedImage,
                            assignmentImages: $assignmentImages,
                            assignToSlotID: pressedButton,
                            completedLessons: $completedLessons,
                            onFinish: {
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
                .fill(Color.black)
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
        }

        if number == 14 {
            sectionHeader(
                "Framing",
                icon: "photo.artframe"
            )
        }

        if number == 21 {
            sectionHeader(
                "Lighting",
                icon: "sun.max.fill"
            )
        }

        lessonRow(number)
    }

    @ViewBuilder
    private func sectionHeader(
        _ title: String,
        icon: String
    ) -> some View {
        VStack(spacing: 70) {
            HStack {
                Spacer()

                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black)
                    .frame(width: 300, height: 90)
                    .shadow(
                        color: Color.gray.opacity(0.7),
                        radius: 20,
                        y: 8
                    )
                    .overlay {
                        HStack(spacing: 6) {
                            Text(title)
                                .foregroundColor(.white)
                                .font(.largeTitle)

                            Image(systemName: icon)
                                .font(.title3.bold())
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
            Circle()
                .fill(buttonColor(number).gradient)
                .frame(width: 100, height: 100)
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
                .overlay {
                    Circle()
                        .stroke(
                            Color.white.opacity(0.45),
                            lineWidth: 1.5
                        )
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
}

#Preview {
    TestView2()
}
