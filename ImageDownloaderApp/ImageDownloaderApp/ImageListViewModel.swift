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
class ImageListViewModel: ObservableObject {
    @Published var images: [UIImage] = []
    @Published var imageProgress: [String: Double] = [:]  //Dictionary to hold progress per image
    let manager = ImageDownloadManager()

    func loadSampleImages() {
        let urls = (1...10).compactMap { URL(string: "https://picsum.photos/2000/1500?random=\($0)") }
        
        // Define the progress handler closure
        let progressHandler: (URL, Double) -> Void = { url, progress in
            // Update progress for each image URL
            DispatchQueue.main.async {
                if abs((self.imageProgress[url.absoluteString] ?? 0) - progress) > 0.0005 {
                    withAnimation {
                        self.imageProgress[url.absoluteString] = progress
                        print("Progress for \(url.absoluteString): \(progress)")
                    }
                }
            }
        }
        
        Task {
            let downloaded = await manager.fetchImages(from: urls, progressHandler: progressHandler)
            self.images = downloaded
        }
    }
}
