//
//  ImageListViewModel.swift
//  ImageDownloaderApp
//
//  Created by Nyein Ei Ei Tun on 5/4/25.
//

import UIKit

// MARK: - ImageListViewModel (Calls downloader, updates UI state)
@MainActor
class ImageListViewModel: ObservableObject {
    @Published var images: [UIImage] = []
    let manager = ImageDownloadManager()

    func loadSampleImages() {
        let urls = (1...10).compactMap { URL(string: "https://picsum.photos/300/200?random=\($0)") }
        Task {
            let downloaded = await manager.fetchImages(from: urls)
            self.images = downloaded
        }
    }
}
