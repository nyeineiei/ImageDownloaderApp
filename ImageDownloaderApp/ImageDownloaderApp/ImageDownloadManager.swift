//
//  ImageDownloadManager.swift
//  ImageDownloaderApp
//
//  Created by Nyein Ei Ei Tun on 5/4/25.
//

import UIKit

// MARK: - ImageDownloadManager (Manages parallel downloads using TaskGroup)
class ImageDownloadManager {
    let cache = ImageCacheActor()

    func fetchImages(from urls: [URL], progressHandler: @escaping (URL, Double) -> Void) async -> [UIImage] {
        var results: [UIImage] = []

        await withTaskGroup(of: UIImage?.self) { group in
            for url in urls {
                group.addTask {
                    if let cached = await self.cache.get(forKey: url.absoluteString) {
                        return cached
                    }
                    let downloader = ImageDownloader()
                    downloader.onProgress = { progress in
                        // Pass the progress back to the view model
                        progressHandler(url, progress)
                    }
                    do {
                        let image = try await downloader.downloadImage(from: url)
                        await self.cache.set(image, forKey: url.absoluteString)
                        return image
                    } catch {
                        return nil
                    }
                }
            }

            for await image in group {
                if let img = image {
                    results.append(img)
                }
            }
        }

        return results
    }
}
