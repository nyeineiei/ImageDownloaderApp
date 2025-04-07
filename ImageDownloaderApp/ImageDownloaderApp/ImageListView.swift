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
        // Define the URLs statically
        private let urls = (1...10).compactMap { URL(string: "https://picsum.photos/2000/1500?random=\($0)") }
    
        var body: some View {
            NavigationView {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(urls.indices, id: \.self){ index in
                            VStack {
                                if viewModel.images.count > 0 {
                                    Image(uiImage: viewModel.images[index])
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 200)
                                        .cornerRadius(12)
                                }
                                
                                let urlString = "https://picsum.photos/2000/1500?random=\(index + 1)"
                                ProgressView(value: viewModel.imageProgress[urlString] ?? 0, total: 1)
                                    .progressViewStyle(LinearProgressViewStyle())
                                    .accentColor(.blue)
                                    .frame(height: 5)
                                    .padding(.top, 8)
                            }
                        }
                    }.padding()
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
