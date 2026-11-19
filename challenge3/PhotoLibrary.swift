//
//  PhotoLibrary.swift
//  challenge3
//

import SwiftUI
import Combine

// Shared, observable list of photos so HomeView and GalleryView stay in sync.
@MainActor
final class PhotoLibrary: ObservableObject {
    @Published private(set) var photos: [UIImage] = []

    func add(_ image: UIImage) {
        photos.insert(image, at: 0)
    }
}
