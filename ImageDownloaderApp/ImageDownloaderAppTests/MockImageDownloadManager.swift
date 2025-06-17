//
//  MockImageDownloadManager.swift
//  ImageDownloaderApp
//
//  Created by Nyein Ei Ei Tun on 17/6/25.
//
import UIKit
@testable import ImageDownloaderApp

class MockImageDownloadManager: ImageDownloadManagerInterface {
//    func fetchImages(from urls: [URL], progressHandler: @escaping (URL, Double) -> Void) async -> [(UIImage, String?)] {
//        let dummyImage = UIImage(systemName: "photo") ?? UIImage()
//        return [
//            (dummyImage, "white kitten"),
//            (dummyImage, "tiger cat")
//        ]
//    }
    func fetchImages(from urls: [URL], progressHandler: @escaping (URL, Double) -> Void) async -> [(UIImage, String?)] {
        let dummyImage = UIImage(systemName: "photo") ?? UIImage()
        return urls.map { url in
            progressHandler(url, 1.0)
            return (dummyImage, "mock-label")
        }
    }
}
