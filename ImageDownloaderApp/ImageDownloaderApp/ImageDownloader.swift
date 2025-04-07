//
//  ImageDownloader.swift
//  ImageDownloaderApp
//
//  Created by Nyein Ei Ei Tun on 5/4/25.
//

import UIKit

// MARK: - ImageDownloader (Downloads a single image with progress)
class ImageDownloader: NSObject, URLSessionDownloadDelegate {
    var onProgress: ((Double) -> Void)?
    private var continuation: CheckedContinuation<UIImage, Error>?

    func downloadImage(from url: URL) async throws -> UIImage {
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
            session.downloadTask(with: url).resume()
        }
    }

    /// TODO: Add the progress closure
//    let downloader = ImageDownloader()
//    downloader.onProgress = { progress in
//        // Update progress UI (e.g., ProgressView or UIProgressView)
//        DispatchQueue.main.async {
//            self.progressBar.progress = Float(progress)
//        }
//    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        onProgress?(progress) // Notify the progress to the ImageListViewModel.
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        guard let data = try? Data(contentsOf: location), let image = UIImage(data: data) else {
            continuation?.resume(throwing: URLError(.badServerResponse))
            return
        }
        continuation?.resume(returning: image)
    }
}
