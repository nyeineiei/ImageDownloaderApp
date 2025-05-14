//
//  TagDetectionViewModel.swift
//  ImageDownloaderApp
//
//  Created by Nyein Ei Ei Tun on 14/5/25.
//
import SwiftUI
import PhotosUI

@MainActor
class TagDetectionViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var tags: [String] = []

    private let detector: ImageTagDetector

    init(detector: ImageTagDetector) {
        self.detector = detector
    }

    func handlePhotoSelection(_ item: PhotosPickerItem?) async {
        guard let item,
              let data = try? await item.loadTransferable(type: Data.self),
              let uiImage = UIImage(data: data)
        else {
            print("Failed to load image")
            return
        }

        // Preprocess before display and classification
        let cropped = uiImage.centerCropped(to: CGSize(width: 224, height: 224)) ?? uiImage
        self.image = cropped

        

        do {
            // Run classifier on preprocessed image
            self.tags = try await detector.detectTags(for: cropped)
        } catch {
            print("Detection failed: \(error)")
        }
    }
}
