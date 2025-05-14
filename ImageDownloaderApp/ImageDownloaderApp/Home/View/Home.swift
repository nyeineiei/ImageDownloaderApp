//
//  Home.swift
//  ImageDownloaderApp
//
//  Created by Nyein Ei Ei Tun on 14/5/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("🖼️ Image Downloader with Classification") {
                    ImageListView {
                        let classifier = ImageClassifier()
                        let manager = ImageDownloadManager(classifier: classifier)
                        return ImageListViewModel(manager: manager)
                    }
                }

                NavigationLink("🏷️ Image Tag Auto Detector") {
                    TagDetectionView(
                        viewModel: TagDetectionViewModel(
                            detector: ImageTagDetector()!
                        )
                    )
                }
                
                NavigationLink("🔍 Smart Receipt Scanner") {
                    ReceiptScannerView()
                }
            }
            .navigationTitle("AI Tools")
        }
    }
}
