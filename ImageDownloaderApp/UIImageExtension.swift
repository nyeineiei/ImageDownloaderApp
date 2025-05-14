//
//  UIImageExtension.swift
//  ImageDownloaderApp
//
//  Created by Nyein Ei Ei Tun on 14/5/25.
//
import UIKit

extension UIImage {
    func centerCropped(to size: CGSize) -> UIImage? {
        let minLength = min(self.size.width, self.size.height)
        let x = (self.size.width - minLength) / 2
        let y = (self.size.height - minLength) / 2
        let cropRect = CGRect(x: x, y: y, width: minLength, height: minLength)
        
        guard let cgImage = self.cgImage?.cropping(to: cropRect) else { return nil }
        return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
    }
}
