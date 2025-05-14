//
//  ImageDownloaderAppInterfaces.swift
//  ImageDownloaderApp
//
//  Created by Nyein Ei Ei Tun on 9/4/25.
//

import UIKit

protocol ImageDownloadManagerInterface {
    func fetchImages(from urls: [URL], progressHandler: @escaping (URL, Double) -> Void) async -> [(UIImage, String?)]
}

protocol ImageClassifierInterface {
    func classify(_ image: UIImage) async throws -> String?
}

protocol ImageListViewModelInterface: ObservableObject {
    var classifiedImages: [String: (UIImage, String?)] { get set }
    var imageProgress: [String: Double] { get set }

    func loadSampleImages()
}
