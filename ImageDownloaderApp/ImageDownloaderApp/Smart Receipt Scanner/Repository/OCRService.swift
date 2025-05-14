//
//  OCRService.swift
//  ImageDownloaderApp
//
//  Created by Nyein Ei Ei Tun on 15/5/25.
//

import Vision
import UIKit

final class OCRService {
    func recognizeText(from image: UIImage, completion: @escaping ([String]) -> Void) {
        guard let cgImage = image.cgImage else {
            completion([]); return
        }

        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion([]); return
            }

            let lines = observations.compactMap {
                $0.topCandidates(1).first?.string
            }
            completion(lines)
        }

        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        request.recognitionLanguages = ["fr-FR"]

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
        }
    }
    
    private func normalize(_ text: String) -> String {
        var cleaned = text

        // 1. Remove quantities like "2*1,61" or "3,14"
        cleaned = cleaned.replacingOccurrences(of: #"\d+\*\d+,\d{2}"#, with: "", options: .regularExpression)
        cleaned = cleaned.replacingOccurrences(of: #"\d+,\d{2}"#, with: "", options: .regularExpression)

        // 2. Remove special characters
        cleaned = cleaned.replacingOccurrences(of: #"[*]"#, with: "", options: .regularExpression)
        cleaned = cleaned.replacingOccurrences(of: #"\.\.*"#, with: "", options: .regularExpression)

        // 3. Remove extra whitespace
        cleaned = cleaned.trimmingCharacters(in: .whitespacesAndNewlines)
        cleaned = cleaned.replacingOccurrences(of: #"^\s+|\s+$"#, with: "", options: .regularExpression)
        cleaned = cleaned.replacingOccurrences(of: #"[^a-zA-Zéèàçùêâ0-9\s-]"#, with: "", options: .regularExpression)


        // 4. Lowercase and clean accents (optional)
        cleaned = cleaned.lowercased()

        return cleaned
    }

    func classifyItems(from texts: [String]) -> [(text: String, category: String)] {
        let model = try! MyTextClassifierFrench(configuration: .init())
        return texts.map { original in
            let cleaned = normalize(original)
            //print("🔍 Normalized: '\(original)' → '\(cleaned)'")

            let prediction = try? model.prediction(text: cleaned)
            let label = prediction?.label ?? "INCONNU"
            return (original, label)
        }
    }
    
    func isValidProductLine(_ line: String) -> Bool {
        let cleaned = line
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)

        // Filter out prices or quantities
        if cleaned.range(of: #"^\d+([,\.]\d+)?$"#, options: .regularExpression) != nil { return false }
        if cleaned.range(of: #"^\d+\*\d+[,\.]?\d*$"#, options: .regularExpression) != nil { return false }

        // Filter column headers and known garbage
        let stopWords = ["prix", "t libelle", "qté", "p/u", "total"]
        if stopWords.contains(cleaned) { return false }

        // Filter short uppercase lines (e.g., "PRIX")
        if cleaned.range(of: #"^[a-z\s]{1,3}$"#, options: .regularExpression) != nil { return false }

        return true
    }
}
