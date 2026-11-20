//
//  PhotoLibrary.swift
//  challenge3
//

import SwiftUI
import Combine

// The AI review attached to a saved photo.
struct PhotoReview: Codable {
    let score: Int
    let feedback: String
    let strengths: String
    let improvements: String
}

// A photo plus the review that was generated for it.
// Stored on disk as JSON, so the image is kept as Data.
struct SavedPhoto: Identifiable, Codable {
    let id: UUID
    let imageData: Data
    var review: PhotoReview?

    var image: UIImage {
        UIImage(data: imageData) ?? UIImage()
    }

    init(id: UUID = UUID(), image: UIImage, review: PhotoReview?) {
        self.id = id
        self.imageData = image.normalizedJPEGData() ?? image.pngData() ?? Data()
        self.review = review
    }
}

// Shared, observable list of photos so HomeView and GalleryView stay in sync.
// Persists to the app's Application Support directory.
@MainActor
final class PhotoLibrary: ObservableObject {
    @Published private(set) var photos: [SavedPhoto] = []

    private let storeURL: URL

    init() {
        let fm = FileManager.default
        let dir = fm.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? fm.createDirectory(at: dir, withIntermediateDirectories: true)
        storeURL = dir.appendingPathComponent("savedPhotos.json")
        load()
    }

    func add(_ image: UIImage, review: PhotoReview?) {
        photos.insert(SavedPhoto(image: image, review: review), at: 0)
        save()
    }

    // MARK: - Persistence

    private func load() {
        guard let data = try? Data(contentsOf: storeURL) else { return }
        do {
            photos = try JSONDecoder().decode([SavedPhoto].self, from: data)
        } catch {
            print("PhotoLibrary: failed to load - \(error)")
        }
    }

    private func save() {
        do {
            let data = try JSONEncoder().encode(photos)
            try data.write(to: storeURL, options: .atomic)
        } catch {
            print("PhotoLibrary: failed to save - \(error)")
        }
    }
}

// MARK: - Image encoding

extension UIImage {
    // JPEG data with the orientation baked into the pixels, so it reloads correctly.
    func normalizedJPEGData(quality: CGFloat = 0.85) -> Data? {
        let normalized: UIImage
        if imageOrientation == .up {
            normalized = self
        } else {
            let format = UIGraphicsImageRendererFormat.default()
            format.scale = scale
            normalized = UIGraphicsImageRenderer(size: size, format: format).image { _ in
                draw(in: CGRect(origin: .zero, size: size))
            }
        }
        return normalized.jpegData(compressionQuality: quality)
    }
}

// MARK: - Lesson progress persistence

struct LessonProgress: Codable {
    var explainedButtons: Set<String> = []
    var completedLessons: Set<String> = []
    var assignmentImages: [String: Data] = [:]
}

enum LessonProgressStorage {
    private static var storeURL: URL {
        let fm = FileManager.default
        let dir = fm.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? fm.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent("lessonProgress.json")
    }

    static func load() -> LessonProgress {
        guard let data = try? Data(contentsOf: storeURL) else { return LessonProgress() }
        do {
            return try JSONDecoder().decode(LessonProgress.self, from: data)
        } catch {
            print("LessonProgress: failed to load - \(error)")
            return LessonProgress()
        }
    }

    static func save(_ progress: LessonProgress) {
        do {
            let data = try JSONEncoder().encode(progress)
            try data.write(to: storeURL, options: .atomic)
        } catch {
            print("LessonProgress: failed to save - \(error)")
        }
    }
}
