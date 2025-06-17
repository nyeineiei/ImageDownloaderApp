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
    @Published var imageURLs: [URL] = (1...10).compactMap {
        URL(string: "https://picsum.photos/2000/1500?random=\($0)")
    }
    
    private let manager: ImageDownloadManagerInterface
    
    init(manager: ImageDownloadManagerInterface) {
        self.manager = manager
    }

    func loadSampleImages() async {
        let urls = imageURLs
        
        // Define the progress handler closure
        let progressHandler: (URL, Double) -> Void = { url, progress in
            Task { @MainActor in
                self.imageProgress[url.absoluteString] = progress
                //print("Progress for \(url.absoluteString): \(progress)")
            }
        }
        
        let downloaded = await manager.fetchImages(from: urls, progressHandler: progressHandler)
        for (index, (image, label)) in downloaded.enumerated() {
           guard index < urls.count else { continue }
           let urlKey = urls[index].absoluteString
           self.classifiedImages[urlKey] = (image, label)
        }
    }
}
