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

    let columns = [
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
                                NavigationLink {
                                    ResultView(
                                        image: photo.image,
                                        existingReview: photo.review
                                    )
                                } label: {
                                    Image(uiImage: photo.image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 175, height: 150)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Gallery")
        }
    }
}

#Preview {
    GalleryView()
        .environmentObject(PhotoLibrary())
}
