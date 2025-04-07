//
//  ImageCacheActor.swift
//  ImageDownloaderApp
//
//  Created by Nyein Ei Ei Tun on 5/4/25.
//

import  UIKit

// MARK: - ImageCacheActor (Thread-Safe Cache) Stores images with thread-safe access
actor ImageCacheActor {
    private var cache = NSCache<NSString, UIImage>()

    func get(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }

    func set(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
