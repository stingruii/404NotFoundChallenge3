//
//  BackupView.swift
//  challenge3
//
//  Created by Leung Lee Kiu on 27/11/26.
//

import SwiftUI
import UIKit

// MARK: - Backup Result View

struct BackupView: View {

    let image: UIImage

    var assignmentImages: Binding<[String: UIImage]>? = nil
    var assignToSlotID: String? = nil
    var completedLessons: Binding<Set<String>>? = nil
    var onFinish: (() -> Void)? = nil

    @EnvironmentObject private var photoLibrary: PhotoLibrary
    @Environment(\.dismiss) private var dismiss

    @State private var selectedConceptID = "composition"

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


                // MARK: Availability Notice

                HStack(alignment: .top, spacing: 10) {

                    Image(systemName: "sparkles")
                        .foregroundColor(.blue)

                    Text("Apple Intelligence isn't available on this device, so here is general photography guidance instead of a personalised AI review.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.blue.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 14))


                // MARK: Concept Feedback

                conceptTabs


                // MARK: - Action Buttons

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
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .navigationTitle("Result")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Finish Lesson

    private func finishLesson(savePhoto: Bool) {

        if savePhoto {

            // There is no AI review to store, so save the photo on its own.
            photoLibrary.add(image, review: nil)

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

    // MARK: - Concept Structure

    private struct Concept: Identifiable {

        let id: String
        let title: String
        let symbol: String
        let feedback: String
        let tip: String
    }

    // MARK: - Concepts

    private var concepts: [Concept] {

        [

            Concept(
                id: "composition",
                title: "Composition",
                symbol: "square.grid.3x3",
                feedback: "Composition is how the elements of your photo are arranged. A clear focal point, balanced negative space and a subject placed near a rule-of-thirds intersection usually make a frame feel intentional.",
                tip: "Move your subject off-centre, simplify the background, and check the edges of the frame for anything that pulls attention away from your subject."
            ),

            Concept(
                id: "lighting",
                title: "Lighting",
                symbol: "sun.max",
                feedback: "Lighting shapes the mood and texture of a photo. Soft, even light flatters most subjects, while hard light creates strong shadows and contrast. Watch for blown-out highlights or shadows with no detail.",
                tip: "Shoot near a window or during golden hour, avoid harsh midday sun, and tap your subject on screen so the camera exposes for it."
            ),

            Concept(
                id: "angles",
                title: "Angles",
                symbol: "angle",
                feedback: "The angle you choose changes how a subject reads. Eye-level feels natural, low angles add presence, and high angles can simplify a busy scene. A deliberate angle makes a photo look considered rather than accidental.",
                tip: "Walk around your subject and try at least three heights - low, eye-level and above - then keep the one that best tells the story."
            ),

            Concept(
                id: "framing",
                title: "Framing",
                symbol: "viewfinder",
                feedback: "Framing decides what is included and what is left out. Tight framing emphasises detail and emotion, while wider framing gives context. Clean edges and an uncluttered border keep attention on the subject.",
                tip: "Use natural frames such as doorways or branches, keep the horizon level, and crop out anything that doesn't support the subject."
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

                // Concept Title

                HStack {

                    Label(
                        selectedConcept.title,
                        systemImage: selectedConcept.symbol
                    )
                    .font(.headline)
                    .foregroundColor(.blue)

                    Spacer()

                    Text("General")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.blue)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.12))
                        .clipShape(Capsule())
                }

                Divider()

                // General Feedback

                VStack(alignment: .leading, spacing: 8) {

                    Label(
                        "General Feedback",
                        systemImage: "checkmark.circle.fill"
                    )
                    .font(.headline)
                    .foregroundColor(.green)

                    Text(selectedConcept.feedback)
                        .font(.body)
                        .foregroundColor(.primary)
                }

                Divider()

                // Tips to Improve

                VStack(alignment: .leading, spacing: 8) {

                    Label(
                        "Tips to Improve",
                        systemImage: "lightbulb.fill"
                    )
                    .font(.headline)
                    .foregroundColor(.orange)

                    Text(selectedConcept.tip)
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
}

// MARK: - Preview

#Preview {

    NavigationStack {

        BackupView(
            image: UIImage(systemName: "photo") ?? UIImage()
        )
        .environmentObject(PhotoLibrary())
    }
}
