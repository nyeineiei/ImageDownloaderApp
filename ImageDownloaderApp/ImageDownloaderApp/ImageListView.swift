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

        var body: some View {
            NavigationView {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.images.indices, id: \.self){ index in
                            Image(uiImage: viewModel.images[index])
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .cornerRadius(12)
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
