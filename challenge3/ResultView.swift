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

    @Environment(\.dismiss) private var dismiss

    @State private var score: Int = 0

    // AI properties
    @State private var isAnalyzing = false
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

                Button {
                    Task {
                        await analysePhoto()
                    }
                } label: {
                    HStack {
                        if isAnalyzing {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Image(systemName: "sparkles")
                        }

                        Text(isAnalyzing
                             ? "Analysing Photo..."
                             : "Analyse My Photo")
                    }
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(isAnalyzing)

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

                // MARK: - Original Assignment Button

                if let assignToSlotID, let assignmentImages {
                    Button("Set to assignment's picture") {
                        assignmentImages.wrappedValue[assignToSlotID] = image
                        dismiss()
                    }
                    .font(.system(size: 30))
                    .foregroundColor(.purple)
                    .padding()
                    .multilineTextAlignment(.center)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .navigationTitle("Result")
        .navigationBarTitleDisplayMode(.inline)
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

                Give a score between 0 and 10.

                Explain the photograph's strengths.
                Suggest realistic improvements.

                Be constructive, specific and encouraging.
                Only describe things visible in the photo.
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
    }
}

