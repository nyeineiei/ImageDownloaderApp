//
//  ImageListViewModel.swift
//  ImageDownloaderApp
//
//  Created by Nyein Ei Ei Tun on 5/4/25.
//

import UIKit
import SwiftUI

// MARK: - ImageListViewModel (Calls downloader, updates UI state)
@MainActor
class ImageListViewModel: ImageListViewModelInterface {
    @Published var classifiedImages: [String: (UIImage, String?)] = [:]
    @Published var imageProgress: [String: Double] = [:]  //Dictionary to hold progress per image
    private let manager: ImageDownloadManagerInterface
    
    init(manager: ImageDownloadManagerInterface) {
        self.manager = manager
    }

    func loadSampleImages() {
        let urls = (1...10).compactMap { URL(string: "https://picsum.photos/2000/1500?random=\($0)") }
        
        // Define the progress handler closure
        let progressHandler: (URL, Double) -> Void = { url, progress in
            // Update progress for each image URL
            DispatchQueue.main.async {
                withAnimation() {
                    self.imageProgress[url.absoluteString] = progress
                    print("Progress for \(url.absoluteString): \(progress)")
                }
            }
        }
        
        Task {
            let downloaded = await manager.fetchImages(from: urls, progressHandler: progressHandler)
            for (image, label) in downloaded {
                // Use absoluteString as key
                if let index = downloaded.firstIndex(where: { $0.0 == image }) {
                    let urlKey = urls[index].absoluteString
                    self.classifiedImages[urlKey] = (image, label)
                }
            }
        }
    }
}
