//
//  ImageTagDetector.swift
//  ImageDownloaderApp
//
//  Created by Nyein Ei Ei Tun on 14/5/25.
//

import UIKit
import Vision
import CoreML

final class ImageTagDetector {
    private let model: VNCoreMLModel

    init?() {
        guard let mlModel = try? MobileNetV2(configuration: .init()).model,
              let visionModel = try? VNCoreMLModel(for: mlModel)
        else {
            return nil
        }
        self.model = visionModel
    }

    func detectTags(for image: UIImage) async throws -> [String] {
        guard let cgImage = image.cgImage else {
            return []
        }

        return try await withCheckedThrowingContinuation { continuation in
            let request = VNCoreMLRequest(model: model) { request, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                let tags = (request.results as? [VNClassificationObservation])?
                    .filter { $0.confidence > 0.5 }
                    .prefix(3)
                    .map { $0.identifier } ?? []

                continuation.resume(returning: tags)
            }

            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}
