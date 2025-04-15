//
//  ImageDownloadManager.swift
//  ImageDownloaderApp
//
//  Created by Nyein Ei Ei Tun on 5/4/25.
//

import UIKit

// MARK: - ImageDownloadManager (Manages parallel downloads using TaskGroup)
class ImageDownloadManager: ImageDownloadManagerInterface {
    let cache = ImageCacheActor()
    private let classifier: ImageClassifierInterface

    init(classifier: ImageClassifierInterface) {
        self.classifier = classifier
    }

    func fetchImages(from urls: [URL], progressHandler: @escaping (URL, Double) -> Void) async -> [(UIImage, String?)] {
        var results: [(UIImage, String?)] = []

        await withTaskGroup(of: (UIImage, String?)?.self) { group in
            for url in urls {
                group.addTask {
                    if let cached = await self.cache.get(forKey: url.absoluteString) {
                        // You might want to re-classify cached images too if not already done
                        let label = try? await self.classifier.classify(cached)
                        return (cached, label)
                    }

                    let downloader = ImageDownloader()
                    downloader.onProgress = { progress in
                        progressHandler(url, progress)
                    }

                    do {
                        let image = try await downloader.downloadImage(from: url)
                        await self.cache.set(image, forKey: url.absoluteString)
                        let label = try? await self.classifier.classify(image)
                        return (image, label)
                    } catch {
                        // If download failed, don't add to the result
                        return nil
                    }
                }
            }

            for await result in group {
                if let (image, label) = result {
                    results.append((image, label))
                }
            }
        }

        return results
    }
}
