//
//  PhotoLibrary.swift
//  challenge3
//

import SwiftUI
import Combine

// MARK: - Photo Review

struct PhotoReview: Codable {
    
    // Legacy fields retained for previously saved reviews.
    let score: Double
    let feedback: String
    let strengths: String
    let improvements: String
    
    // Component scores (0–2.5 each).
    var compositionScore: Double? = nil
    var lightingScore: Double? = nil
    var anglesScore: Double? = nil
    var framingScore: Double? = nil
    
    // Legacy concept descriptions.
    var compositionDescription: String? = nil
    var lightingDescription: String? = nil
    var anglesDescription: String? = nil
    var framingDescription: String? = nil
    
    var compositionStrengths: String? = nil
    var compositionImprovements: String? = nil
    
    var lightingStrengths: String? = nil
    var lightingImprovements: String? = nil
    
    var anglesStrengths: String? = nil
    var anglesImprovements: String? = nil
    
    var framingStrengths: String? = nil
    var framingImprovements: String? = nil
}


// MARK: - Saved Photo

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


// MARK: - Photo Library

@MainActor
final class PhotoLibrary: ObservableObject {
    
    @Published private(set) var photos: [SavedPhoto] = []
    
    private let storeURL: URL
    
    init() {
        
        let fm = FileManager.default
        
        let dir = fm.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        )[0]
        
        try? fm.createDirectory(
            at: dir,
            withIntermediateDirectories: true
        )
        
        storeURL = dir.appendingPathComponent("savedPhotos.json")
        
        load()
    }
    
    func add(_ image: UIImage, review: PhotoReview?) {
        
        photos.insert(
            SavedPhoto(image: image, review: review),
            at: 0
        )
        
        save()
    }
    
    func delete(_ ids: Set<UUID>) {
        photos.removeAll { ids.contains($0.id) }
        save()
    }
    
    func clearAll() {
        photos.removeAll()
        save()
    }
    
    // MARK: Persistence
    
    private func load() {
        
        guard let data = try? Data(contentsOf: storeURL) else {
            return
        }
        
        do {
            
            photos = try JSONDecoder().decode(
                [SavedPhoto].self,
                from: data
            )
            
        } catch {
            
            print("PhotoLibrary: failed to load - \(error)")
        }
    }
    
    private func save() {
        
        do {
            
            let data = try JSONEncoder().encode(photos)
            
            try data.write(
                to: storeURL,
                options: .atomic
            )
            
        } catch {
            
            print("PhotoLibrary: failed to save - \(error)")
        }
    }
}


// MARK: - Image Encoding

extension UIImage {
    
    func normalizedJPEGData(quality: CGFloat = 0.85) -> Data? {
        
        let normalized: UIImage
        
        if imageOrientation == .up {
            
            normalized = self
            
        } else {
            
            let format = UIGraphicsImageRendererFormat.default()
            format.scale = scale
            
            normalized = UIGraphicsImageRenderer(
                size: size,
                format: format
            ).image { _ in
                
                draw(in: CGRect(origin: .zero, size: size))
            }
        }
        
        return normalized.jpegData(compressionQuality: quality)
    }
}


// MARK: - Lesson Progress Persistence

struct LessonProgress: Codable {
    
    var explainedButtons: Set<String> = []
    var completedLessons: Set<String> = []
    var assignmentImages: [String: Data] = [:]
}


enum LessonProgressStorage {
    
    private static var storeURL: URL {
        
        let fm = FileManager.default
        
        let dir = fm.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        )[0]
        
        try? fm.createDirectory(
            at: dir,
            withIntermediateDirectories: true
        )
        
        return dir.appendingPathComponent("lessonProgress.json")
    }
    
    static func load() -> LessonProgress {
        
        guard let data = try? Data(contentsOf: storeURL) else {
            return LessonProgress()
        }
        
        do {
            
            return try JSONDecoder().decode(
                LessonProgress.self,
                from: data
            )
            
        } catch {
            
            print("LessonProgress: failed to load - \(error)")
            
            return LessonProgress()
        }
    }
    
    static func save(_ progress: LessonProgress) {
        
        do {
            
            let data = try JSONEncoder().encode(progress)
            
            try data.write(
                to: storeURL,
                options: .atomic
            )
            
        } catch {
            
            print("LessonProgress: failed to save - \(error)")
        }
    }
}
