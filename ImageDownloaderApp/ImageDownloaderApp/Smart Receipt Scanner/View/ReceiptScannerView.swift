//
//  ReceiptScannerView.swift
//  ImageDownloaderApp
//
//  Created by Nyein Ei Ei Tun on 15/5/25.
//

import SwiftUI
import PhotosUI

struct ReceiptScannerView: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var image: UIImage?
    @State private var results: [(text: String, category: String)] = []

    let ocrService = OCRService()

    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            }

            PhotosPicker("Select Receipt Image", selection: $selectedItem, matching: .images)
                .padding()

            List {
                ForEach(Dictionary(grouping: results, by: \.category).sorted(by: { $0.key < $1.key }), id: \.key) { category, items in
                    Section(header: Text(category)) {
                        ForEach(items, id: \.text) { item in
                            Text(item.text)
                        }
                    }
                }
            }
        }
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    self.image = uiImage
                    ocrService.recognizeText(from: uiImage) { lines in
                        // 🧹 Filter out non-product lines
                        let cleanedLines = lines.filter { ocrService.isValidProductLine($0) }
                        
                        let classified = ocrService.classifyItems(from: cleanedLines)
                        DispatchQueue.main.async {
                            self.results = classified
                        }
                    }
                }
            }
        }
    }
}
