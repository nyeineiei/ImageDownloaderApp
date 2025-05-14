//
//  TagDetection.swift
//  ImageDownloaderApp
//
//  Created by Nyein Ei Ei Tun on 14/5/25.
//
import SwiftUI
import PhotosUI

struct TagDetectionView: View {
    @StateObject private var viewModel: TagDetectionViewModel
    @State private var selectedItem: PhotosPickerItem? = nil

    init(viewModel: @autoclosure @escaping () -> TagDetectionViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }

    var body: some View {
        VStack(spacing: 20) {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .cornerRadius(12)
            }

            PhotosPicker("Select Image", selection: $selectedItem, matching: .images)
                .task(id: selectedItem) {
                    if let selectedItem {
                        await viewModel.handlePhotoSelection(selectedItem)
                    }
                }

            if !viewModel.tags.isEmpty {
                Text("Detected Tags:")
                    .font(.headline)

                ForEach(viewModel.tags, id: \.self) { tag in
                    Text("• \(tag)")
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .navigationTitle("Image Tag Auto Detector")
    }
}
