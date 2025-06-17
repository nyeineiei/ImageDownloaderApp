//
//  ImageListViewModelTest.swift
//  ImageDownloaderApp
//
//  Created by Nyein Ei Ei Tun on 17/6/25.
//

import XCTest
@testable import ImageDownloaderApp

@MainActor
final class ImageListViewModelTest: XCTestCase {

    func test_loadSampleImages_populatesClassifiedImages() async throws {
        // Arrange
        let mockManager = MockImageDownloadManager()
        let viewModel = ImageListViewModel(manager: mockManager)
        
        // Act
        await viewModel.loadSampleImages()
        
        // Assert
        XCTAssertEqual(viewModel.classifiedImages.count, 10)
    }
}
