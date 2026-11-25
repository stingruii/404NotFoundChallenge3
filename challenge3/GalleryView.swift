//
//  GalleryView.swift
//  challenge3
//
//  Created by Leung Lee Kiu on 13/11/26.
//
import SwiftUI
import UIKit

struct GalleryView: View {
    @EnvironmentObject private var photoLibrary: PhotoLibrary

    @State private var showClearConfirmation = false
    @State private var showDeleteConfirmation = false
    @State private var isSelecting = false
    @State private var selectedPhotos: Set<UUID> = []

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            Group {
                if photoLibrary.photos.isEmpty {
                    ContentUnavailableView(
                        "No Photos Yet",
                        systemImage: "photo.stack",
                        description: Text(
                            "Pictures you take from the Home tab will appear here."
                        )
                    )
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 15) {
                            ForEach(photoLibrary.photos) { photo in
                                if isSelecting {
                                    Button {
                                        toggleSelection(photo.id)
                                    } label: {
                                        photoThumbnail(
                                            photo,
                                            isSelected: selectedPhotos.contains(photo.id)
                                        )
                                    }
                                    .buttonStyle(.plain)
                                } else {
                                    NavigationLink {
                                        ResultView(
                                            image: photo.image,
                                            existingReview: photo.review
                                        )
                                    } label: {
                                        photoThumbnail(
                                            photo,
                                            isSelected: false
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle(
                isSelecting ? "\(selectedPhotos.count) Selected" : "Gallery"
            )
            .toolbar {
                if !photoLibrary.photos.isEmpty {
                    ToolbarItem(placement: .topBarLeading) {
                        if isSelecting {
                            Button("Cancel") {
                                cancelSelection()
                            }
                        } else {
                            Button("Select") {
                                isSelecting = true
                            }
                        }
                    }

                    ToolbarItem(placement: .topBarTrailing) {
                        if isSelecting {
                            Button("Delete", role: .destructive) {
                                showDeleteConfirmation = true
                            }
                            .disabled(selectedPhotos.isEmpty)
                        } else {
                            Button("Clear", role: .destructive) {
                                showClearConfirmation = true
                            }
                        }
                    }
                }
            }
            .alert(
                "Clear All Photos?",
                isPresented: $showClearConfirmation
            ) {
                Button("Cancel", role: .cancel) { }

                Button("Clear All", role: .destructive) {
                    photoLibrary.clearAll()
                    cancelSelection()
                }
            } message: {
                Text("Are you sure you want to remove all pictures from your gallery? This action cannot be undone.")
            }
            .alert(
                "Delete Selected Photos?",
                isPresented: $showDeleteConfirmation
            ) {
                Button("Cancel", role: .cancel) { }

                Button("Delete", role: .destructive) {
                    deleteSelectedPhotos()
                }
            } message: {
                Text(
                    "Are you sure you want to delete \(selectedPhotos.count) selected photo(s)? This action cannot be undone."
                )
            }
        }
    }

    private func photoThumbnail(
        _ photo: SavedPhoto,
        isSelected: Bool
    ) -> some View {
        ZStack(alignment: .topTrailing) {
            Image(uiImage: photo.image)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 150)
                .clipped()
                .clipShape(
                    RoundedRectangle(cornerRadius: 12)
                )
                .overlay {
                    if isSelecting && isSelected {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue, lineWidth: 4)
                    }
                }

            if isSelecting {
                Image(
                    systemName: isSelected
                    ? "checkmark.circle.fill"
                    : "circle"
                )
                .font(.title2)
                .foregroundStyle(
                    isSelected ? Color.blue : Color.white
                )
                .background {
                    Circle()
                        .fill(Color.black.opacity(0.45))
                }
                .padding(8)
            }
        }
        .contentShape(Rectangle())
    }

    private func toggleSelection(_ id: UUID) {
        if selectedPhotos.contains(id) {
            selectedPhotos.remove(id)
        } else {
            selectedPhotos.insert(id)
        }
    }

    private func deleteSelectedPhotos() {
        photoLibrary.delete(selectedPhotos)
        cancelSelection()
    }

    private func cancelSelection() {
        selectedPhotos.removeAll()
        isSelecting = false
    }
}

#Preview {
    GalleryView()
        .environmentObject(PhotoLibrary())
}
