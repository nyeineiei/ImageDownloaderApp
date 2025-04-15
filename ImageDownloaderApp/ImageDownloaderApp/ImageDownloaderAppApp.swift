//
//  ImageDownloaderAppApp.swift
//  ImageDownloaderApp
//
//  Created by Nyein Ei Ei Tun on 5/4/25.
//

import SwiftUI

@main
struct ImageDownloaderAppApp: App {
    var body: some Scene {
        WindowGroup {
            ImageListView {
                let classifier = ImageClassifier()
                let manager = ImageDownloadManager(classifier: classifier)
                return ImageListViewModel(manager: manager)
            }
        }
    }
}
