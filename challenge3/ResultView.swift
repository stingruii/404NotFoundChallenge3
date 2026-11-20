//
//  ResultView.swift
//  challenge3
//
//  Created by Leung Lee Kiu on 13/11/26.
//


import SwiftUI
import UIKit
import FoundationModels

// MARK: - AI Feedback Structure

@Generable
struct PhotoFeedback {
    @Guide(description: "A score from 0 to 10.", .range(0...10))
    var score: Int

    @Guide(description: "Detailed feedback about the photograph.")
    var feedback: String

    @Guide(description: "The strengths of the photograph.")
    var strengths: String

    @Guide(description: "Practical suggestions for improving the photograph.")
    var improvements: String
}

// MARK: - Result View

struct ResultView: View {
    let image: UIImage
    var assignmentImages: Binding<[String: UIImage]>? = nil
    var assignToSlotID: String? = nil
    var completedLessons: Binding<Set<String>>? = nil
    var onFinish: (() -> Void)? = nil
    var existingReview: PhotoReview? = nil

    @EnvironmentObject private var photoLibrary: PhotoLibrary
    @Environment(\.dismiss) private var dismiss

    @State private var score: Int = 0

    // AI properties
    @State private var isAnalyzing = false
    @State private var analysisFinished = false
    @State private var errorMessage: String? = nil

    @State private var aiFeedback: String = ""
    @State private var strengths: String = ""
    @State private var improvements: String = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                // MARK: - Original Image Display

                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 400)

                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 400)
                }
                .clipShape(RoundedRectangle(cornerRadius: 15))

                // MARK: - AI Analysis Button

//                Button {
//                    Task {
//                        await analysePhoto()
//                    }
//                } label: {
//                    HStack {
//                        if isAnalyzing {
//                            ProgressView()
//                                .tint(.white)
//                        } else {
//                            Image(systemName: "sparkles")
//                        }
//
//                        Text(isAnalyzing
//                             ? "Analysing Photo..."
//                             : "Analyse My Photo")
//                    }
//                    .font(.system(size: 20, weight: .bold))
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.blue)
//                    .clipShape(RoundedRectangle(cornerRadius: 12))
//                }
//                .disabled(isAnalyzing)
                VStack{
                    if isAnalyzing {
                        HStack {
                            ProgressView()
                                .tint(.black)
                            
                            Text("Analysing Your Photo...")
                        }
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                    }
                }
                .task {
                    if let existingReview {
                        score = existingReview.score
                        aiFeedback = existingReview.feedback
                        strengths = existingReview.strengths
                        improvements = existingReview.improvements
                        analysisFinished = true
                    } else {
                        await analysePhoto()
                        analysisFinished = true
                    }
                }

                // MARK: - Error Message

                if let errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.system(size: 14))
                }

                // MARK: - AI Feedback Section

                if !aiFeedback.isEmpty {

                    VStack(alignment: .leading, spacing: 16) {

                        // AI Heading

                        HStack {
                            Image(systemName: "sparkles")
                                .foregroundColor(.blue)

                            Text("AI Photo Feedback")
                                .font(.title2)
                                .fontWeight(.bold)
                        }

                        // Overall Score

                        HStack {
                            Spacer()

                            VStack(spacing: 4) {
                                Text("\(score)/10")
                                    .font(.system(size: 48))
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)

                                Text("Overall Photo Score")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()
                        }

                        Divider()

                        // Overall Feedback

                        VStack(alignment: .leading, spacing: 8) {
                            Label(
                                "Overall Feedback",
                                systemImage: "text.alignleft"
                            )
                            .font(.headline)

                            Text(aiFeedback)
                                .font(.body)
                        }

                        Divider()

                        // Strengths

                        VStack(alignment: .leading, spacing: 8) {
                            Label(
                                "What You Did Well",
                                systemImage: "checkmark.circle.fill"
                            )
                            .font(.headline)
                            .foregroundColor(.green)

                            Text(strengths)
                                .font(.body)
                                .foregroundColor(.primary)
                        }

                        Divider()

                        // Areas to Improve

                        VStack(alignment: .leading, spacing: 8) {
                            Label(
                                "Areas to Improve",
                                systemImage: "lightbulb.fill"
                            )
                            .font(.headline)
                            .foregroundColor(.orange)

                            Text(improvements)
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.blue.opacity(0.07))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }

                // MARK: - Original Score Display

                HStack {
                    Spacer()

                    Text("Score: \(score)/10")
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                        .foregroundColor(.blue)

                    Spacer()
                }
                if analysisFinished {
                    // Reviewing a photo opened from the Gallery: the photo is
                    // already saved, so hide the Dismiss button entirely.
                    if existingReview == nil {
                        //Dismiss and go to home view
                        Button("Dismiss"){
                            finishLesson(savePhoto: false)
                        }
                        .buttonStyle(.bordered)
                    }
                    
                    // MARK: - Original Assignment Button
                    
                    if assignToSlotID != nil, assignmentImages != nil {
                        Button("Save") {
                            finishLesson(savePhoto: true)
                        }
                        .buttonStyle(.bordered)
                        //                    .font(.system(size: 30))
                        .foregroundColor(.accentColor)
                        .padding()
                        .multilineTextAlignment(.center)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .navigationTitle("Result")
        .navigationBarTitleDisplayMode(.inline)
    }

    // The review to store with the photo. Nil if analysis hasn't finished.
    private var currentReview: PhotoReview? {
        guard !aiFeedback.isEmpty else { return nil }
        return PhotoReview(
            score: score,
            feedback: aiFeedback,
            strengths: strengths,
            improvements: improvements
        )
    }

    // MARK: - Finish Lesson

    private func finishLesson(savePhoto: Bool) {
        if let assignToSlotID {
            // "Save" sets the lesson's circle background; "Done" leaves it empty.
            if savePhoto, let assignmentImages {
                assignmentImages.wrappedValue[assignToSlotID] = image
            }

            // Both buttons add the photo to the library...
            photoLibrary.add(image, review: currentReview)

            // ...and unlock the next lesson.
            if let completedLessons {
                completedLessons.wrappedValue.insert(assignToSlotID)
            }
        }

        if let onFinish {
            onFinish()
        } else {
            dismiss()
        }
    }

    // MARK: - Foundation Models AI Analysis

    @MainActor
    private func analysePhoto() async {

        isAnalyzing = true
        errorMessage = nil

        defer {
            isAnalyzing = false
        }

        // Check Apple Intelligence availability

        guard SystemLanguageModel.default.isAvailable else {
            errorMessage = "Apple Intelligence is unavailable."
            return
        }

        do {

            // Create AI session

            let session = LanguageModelSession()

            // Analyse actual photograph

            let response = try await session.respond(
                generating: PhotoFeedback.self
            ) {
                """
                Analyse the attached photograph.

                                Evaluate:
                                1. Composition
                                2. Lighting
                                3. Focus and clarity
                                4. Colour balance
                                5. Overall visual appeal

                                Evaluate all 5 components, rating them from 0 to 10. Do not reveal the scores of individual components.
                                Proceed to take the mean of the rating of all 5 components, rounding the mean value to 1 decimal place. This is the final score.
                                Following this, reveal the final score between 0 and 10.
                                When evaluating the final score, be strict and maintain professional standards, and only describe the things visible in the photo.
                                
                                Provide a short paragraph evaluating the photo, stating specifically and realistically:
                                The photo's strengths
                                Realistic areas for improvement
                """

                Attachment(image)
            }

            // Update AI feedback and score

            score = response.content.score

            aiFeedback = response.content.feedback
            strengths = response.content.strengths
            improvements = response.content.improvements

        } catch {

            errorMessage = "Analysis failed: \(error.localizedDescription)"
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ResultView(
            image: UIImage(systemName: "photo") ?? UIImage()
        )
        .environmentObject(PhotoLibrary())
    }
}

