//
//  ImageListView.swift
//  ImageDownloaderApp
//
//  Created by Nyein Ei Ei Tun on 5/4/25.
//

//SwiftUI or UIKit list of images with progress bars
import SwiftUI

struct ImageListView: View {
    @StateObject private var viewModel = ImageListViewModel()

    // Use the same URLs used in ViewModel
    private let urls = (1...10).compactMap { URL(string: "https://picsum.photos/2000/1500?random=\($0)") }

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(urls, id: \.absoluteString) { url in
                        VStack(alignment: .leading, spacing: 8) {
                            if let (image, label) = viewModel.classifiedImages[url.absoluteString] {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                                    .cornerRadius(12)

                                Text("Label: \(label ?? "Unknown")")
                                    .font(.caption)
                                    .foregroundColor(label != nil ? .gray : .red)
                            } else {
                                ProgressView(value: viewModel.imageProgress[url.absoluteString] ?? 0)
                                    .progressViewStyle(LinearProgressViewStyle())
                                    .accentColor(.blue)
                                    .frame(height: 5)
                                    .padding(.top, 8)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Image Downloader")
        }
        .onAppear {
            viewModel.loadSampleImages()
        }
    }
}


#Preview {
    ImageListView()
}
