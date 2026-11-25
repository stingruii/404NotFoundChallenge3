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
    
    @Guide(description: "Score for composition, from 0 to 2.5.", .range(0...2.5))
    var scoreForComposition: Double
    
    @Guide(description: "Score for lighting, from 0 to 2.5.", .range(0...2.5))
    var scoreForLighting: Double
    
    @Guide(description: "Score for angles, from 0 to 2.5.", .range(0...2.5))
    var scoreForAngles: Double
    
    @Guide(description: "Score for framing, from 0 to 2.5.", .range(0...2.5))
    var scoreForFraming: Double
    
    @Guide(description: "Strengths of the photograph's composition.")
    var compositionStrengths: String
    
    @Guide(description: "Areas to improve in the photograph's composition.")
    var compositionImprovements: String
    
    @Guide(description: "Strengths of the photograph's lighting.")
    var lightingStrengths: String
    
    @Guide(description: "Areas to improve in the photograph's lighting.")
    var lightingImprovements: String
    
    @Guide(description: "Strengths of the photograph's angles.")
    var anglesStrengths: String
    
    @Guide(description: "Areas to improve in the photograph's angles.")
    var anglesImprovements: String
    
    @Guide(description: "Strengths of the photograph's framing.")
    var framingStrengths: String
    
    @Guide(description: "Areas to improve in the photograph's framing.")
    var framingImprovements: String
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
    
    // MARK: Scores
    
    @State private var score: Double = 0
    
    @State private var compositionScore: Double = 0
    @State private var lightingScore: Double = 0
    @State private var anglesScore: Double = 0
    @State private var framingScore: Double = 0
    
    @State private var hasComponentScores = false
    
    // MARK: Composition Feedback
    
    @State private var compositionStrengths = ""
    @State private var compositionImprovements = ""
    
    // MARK: Lighting Feedback
    
    @State private var lightingStrengths = ""
    @State private var lightingImprovements = ""
    
    // MARK: Angles Feedback
    
    @State private var anglesStrengths = ""
    @State private var anglesImprovements = ""
    
    // MARK: Framing Feedback
    
    @State private var framingStrengths = ""
    @State private var framingImprovements = ""
    
    // MARK: UI Properties
    
    @State private var selectedConceptID = "composition"
    
    @State private var isAnalyzing = false
    @State private var analysisFinished = false
    @State private var errorMessage: String? = nil
    
    
    // MARK: - Body
    
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 16) {
                
                // MARK: Original Image
                
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
                .overlay(alignment: .bottomTrailing) {
                    
                    if analysisFinished && hasComponentScores {
                        
                        scoreBadge
                            .padding(16)
                    }
                }
                
                
                // MARK: Loading Indicator
                
                if isAnalyzing {
                    
                    HStack {
                        
                        ProgressView()
                            .tint(.black)
                        
                        Text("Analysing Your Photo...")
                            .foregroundStyle(.black)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
                
                
                // MARK: Error Message
                
                if let errorMessage {
                    
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.system(size: 14))
                }
                
                
                // MARK: Concept Feedback
                
                if hasComponentScores {
                    
                    conceptTabs
                }
                
                // MARK: - Action Buttons
                
                if analysisFinished && existingReview == nil {
                    
                    HStack(spacing: 12) {
                        
                        // Dismiss Button
                        Button("Dismiss") {
                            finishLesson(savePhoto: false)
                        }
                        .buttonStyle(.bordered)
                        
                        // Save Button
                        Button("Save") {
                            finishLesson(savePhoto: true)
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(!hasComponentScores)
                    }
                }            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .navigationTitle("Result")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            
            if let existingReview {
                
                loadExistingReview(existingReview)
                
            } else {
                
                await analysePhoto()
                
                analysisFinished = hasComponentScores
            }
        }
    }
     
    // MARK: - Load Existing Review
    
    private func loadExistingReview(_ review: PhotoReview) {
        
        score = review.score
        
        compositionScore = review.compositionScore ?? 0
        lightingScore = review.lightingScore ?? 0
        anglesScore = review.anglesScore ?? 0
        framingScore = review.framingScore ?? 0
        
        hasComponentScores = review.compositionScore != nil
        
        compositionStrengths = review.compositionStrengths ?? ""
        compositionImprovements = review.compositionImprovements ?? ""
        
        lightingStrengths = review.lightingStrengths ?? ""
        lightingImprovements = review.lightingImprovements ?? ""
        
        anglesStrengths = review.anglesStrengths ?? ""
        anglesImprovements = review.anglesImprovements ?? ""
        
        framingStrengths = review.framingStrengths ?? ""
        framingImprovements = review.framingImprovements ?? ""
        
        analysisFinished = true
    }
    
    
    // MARK: - Current Review
    
    private var currentReview: PhotoReview? {
        
        guard hasComponentScores else {
            return nil
        }
        
        return PhotoReview(
            
            score: score,
            
            // Legacy fields
            feedback: "",
            strengths: "",
            improvements: "",
            
            // Component scores
            compositionScore: compositionScore,
            lightingScore: lightingScore,
            anglesScore: anglesScore,
            framingScore: framingScore,
            
            // Legacy descriptions
            compositionDescription: "",
            lightingDescription: "",
            anglesDescription: "",
            framingDescription: "",
            
            // Composition
            compositionStrengths: compositionStrengths,
            compositionImprovements: compositionImprovements,
            
            // Lighting
            lightingStrengths: lightingStrengths,
            lightingImprovements: lightingImprovements,
            
            // Angles
            anglesStrengths: anglesStrengths,
            anglesImprovements: anglesImprovements,
            
            // Framing
            framingStrengths: framingStrengths,
            framingImprovements: framingImprovements
        )
    }
    
    
    // MARK: - Finish Lesson
    
    // MARK: - Finish Lesson
    
    private func finishLesson(savePhoto: Bool) {
        
        if savePhoto {
            
            // Save photo AND its complete AI review.
            photoLibrary.add(image, review: currentReview)
            
            // Save to assignment slot if applicable.
            if let assignToSlotID, let assignmentImages {
                assignmentImages.wrappedValue[assignToSlotID] = image
            }
        }
        
        // Unlock next lesson if applicable.
        if let assignToSlotID, let completedLessons {
            completedLessons.wrappedValue.insert(assignToSlotID)
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
        
        guard SystemLanguageModel.default.isAvailable else {
            
            errorMessage = "Apple Intelligence is unavailable."
            return
        }
        
        do {
            
            let session = LanguageModelSession()
            
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
                
                                                Evaluate all 5 components, rating them from 0 to 10. 
                                                Proceed to take the mean of the rating of all 5 components, rounding the mean value to 1 decimal place. This is the final score.
                                                Following this, reveal the final score between 0 and 10.
                                                When evaluating the final score, be strict and maintain professional standards, and only describe the things visible in the photo.
                                                
                                                Provide a short paragraph evaluating the photo, stating specifically and realistically:
                                                The photo's strengths
                                                Realistic areas for improvement
                                
                                                Do not ramble. Keep the feedback as concise and precise as possible, maximum 3 sentences per paragraph.
                                                If a lot of feedback needs to be provided, provide the main points in bullet points, organised, neat and with a specific flow.
                """
                
                Attachment(image)
            }
            
            let content = response.content
            
            // Component Scores
            
            compositionScore = content.scoreForComposition
            lightingScore = content.scoreForLighting
            anglesScore = content.scoreForAngles
            framingScore = content.scoreForFraming
            
            // Calculate total score out of 10
            
            score = compositionScore
            + lightingScore
            + anglesScore
            + framingScore
            
            // Composition
            
            compositionStrengths = content.compositionStrengths
            compositionImprovements = content.compositionImprovements
            
            // Lighting
            
            lightingStrengths = content.lightingStrengths
            lightingImprovements = content.lightingImprovements
            
            // Angles
            
            anglesStrengths = content.anglesStrengths
            anglesImprovements = content.anglesImprovements
            
            // Framing
            
            framingStrengths = content.framingStrengths
            framingImprovements = content.framingImprovements
            
            hasComponentScores = true
            
        } catch {
            
            errorMessage = "Analysis failed: \(error.localizedDescription)"
        }
    }
    
    // MARK: - Concept Structure
    
    private struct Concept: Identifiable {
        
        let id: String
        let title: String
        let symbol: String
        let score: Double
        let strengths: String
        let improvements: String
    }
    
    
    // MARK: - Concepts
    
    private var concepts: [Concept] {
        
        [
            
            Concept(
                id: "composition",
                title: "Composition",
                symbol: "square.grid.3x3",
                score: compositionScore,
                strengths: compositionStrengths,
                improvements: compositionImprovements
            ),
            
            Concept(
                id: "lighting",
                title: "Lighting",
                symbol: "sun.max",
                score: lightingScore,
                strengths: lightingStrengths,
                improvements: lightingImprovements
            ),
            
            Concept(
                id: "angles",
                title: "Angles",
                symbol: "angle",
                score: anglesScore,
                strengths: anglesStrengths,
                improvements: anglesImprovements
            ),
            
            Concept(
                id: "framing",
                title: "Framing",
                symbol: "viewfinder",
                score: framingScore,
                strengths: framingStrengths,
                improvements: framingImprovements
            )
        ]
    }
    
    
    // MARK: - Selected Concept
    
    private var selectedConcept: Concept {
        
        concepts.first {
            $0.id == selectedConceptID
        } ?? concepts[0]
    }
    
    
    // MARK: - Concept Tabs
    
    private var conceptTabs: some View {
        
        VStack(spacing: 12) {
            
            // Concept Selection Buttons
            
            HStack(spacing: 10) {
                
                ForEach(concepts) { concept in
                    
                    Button {
                        
                        selectedConceptID = concept.id
                        
                    } label: {
                        
                        VStack(spacing: 6) {
                            
                            Image(systemName: concept.symbol)
                                .font(.system(size: 20, weight: .semibold))
                            
                            Text(concept.title)
                                .font(.caption2)
                                .lineLimit(1)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .foregroundColor(
                            selectedConceptID == concept.id
                            ? .white
                            : .blue
                        )
                        .background(
                            
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    
                                    selectedConceptID == concept.id
                                    ? Color.blue
                                    : Color.blue.opacity(0.08)
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            
            
            // Selected Concept Details
            
            VStack(alignment: .leading, spacing: 16) {
                
                // Concept Title and Score
                
                HStack {
                    
                    Label(
                        selectedConcept.title,
                        systemImage: selectedConcept.symbol
                    )
                    .font(.headline)
                    .foregroundColor(.blue)
                    
                    Spacer()
                    
                    Text(
                        "\(formatScore(selectedConcept.score))/2.5"
                    )
                    .font(.headline)
                    .foregroundColor(.blue)
                }
                
                Divider()
                
                // Strengths
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    Label(
                        "Strengths",
                        systemImage: "checkmark.circle.fill"
                    )
                    .font(.headline)
                    .foregroundColor(.green)
                    
                    Text(
                        selectedConcept.strengths.isEmpty
                        ? "No strengths available."
                        : selectedConcept.strengths
                    )
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
                    
                    Text(
                        selectedConcept.improvements.isEmpty
                        ? "No suggestions available."
                        : selectedConcept.improvements
                    )
                    .font(.body)
                    .foregroundColor(.primary)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.blue.opacity(0.07))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    
    // MARK: - Overall Score Badge
    
    private var scoreBadge: some View {
        
        Text("\(formatScore(score))/10")
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.black)
            .frame(width: 64, height: 64)
            .background(Color.white)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(score >= 5 ? .green : .red, lineWidth: 3)
            )
            .shadow(radius: 4)
    }
    
    
    // MARK: - Format Score
    
    private func formatScore(_ value: Double) -> String {
        
        value == value.rounded()
        ? String(Int(value))
        : String(format: "%.1f", value)
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
