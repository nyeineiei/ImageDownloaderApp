//
//  ImageListView.swift
//  ImageDownloaderApp
//
//  Created by Nyein Ei Ei Tun on 5/4/25.
//

//SwiftUI or UIKit list of images with progress bars
import SwiftUI

struct ImageListView<ViewModel: ImageListViewModelInterface>: View {
    @StateObject private var viewModel: ViewModel

    // Inject with a factory closure to control lifecycle
    init(viewModelFactory: @escaping () -> ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModelFactory())
    }
    
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

class MockImageListViewModel: ImageListViewModelInterface {
    @Published var classifiedImages: [String: (UIImage, String?)] = [
        "mock1": (UIImage(systemName: "photo")!, "Mock Label 1"),
        "mock2": (UIImage(systemName: "photo")!, nil)
    ]

    @Published var imageProgress: [String: Double] = [
        "mock1": 0.6,
        "mock2": 1.0
    ]

    func loadSampleImages() {}
}

#Preview {
    ImageListView {
        MockImageListViewModel()
    }
}
