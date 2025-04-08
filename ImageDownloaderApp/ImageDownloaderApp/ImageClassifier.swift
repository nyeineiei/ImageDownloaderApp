//
//  ImageClassifier.swift
//  ImageDownloaderApp
//
//  Created by Nyein Ei Ei Tun on 8/4/25.
//

import Foundation
import Vision
import CoreML
import UIKit

protocol ImageClassifying {
    func classify(_ image: UIImage) async throws -> String?
}

final class ImageClassifier: ImageClassifying {
    private let model: VNCoreMLModel
    
    init() {
        let config = MLModelConfiguration()
        let mlModel = try! MobileNetV2(configuration: config).model
        self.model = try! VNCoreMLModel(for: mlModel)
    }
    
    func classify(_ image: UIImage) async throws -> String? {
        guard let cgImage = image.cgImage else { return nil }

        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<String?, Error>) in
            let request = VNCoreMLRequest(model: model) { request, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let results = request.results as? [VNClassificationObservation], let top = results.first else {
                    continuation.resume(returning: nil)
                    return
                }
                
                // Check the confidence of the top result
                if let topResult = results.first, topResult.confidence > 0.2 {
                    continuation.resume(returning: topResult.identifier)
                } else {
                    // If confidence is below threshold, return nil or some default label
                    continuation.resume(returning: "Uncertain")
                }
            }
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try handler.perform([request])
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
