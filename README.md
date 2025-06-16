# ConcurrentImageDownloaderApp + Smart Receipt Scanner
A SwiftUI-based iOS app demonstrating parallel image downloading, memory-safe caching, and Core ML-powered on-device image classification. It includes two features:

1. **ConcurrentImageDownloader** – showcasing Swift Concurrency, caching, and progress handling
2. **Smart Receipt Scanner** – an on-device AI feature using Core ML and Vision to classify receipt content


# Overview
This project demonstrates:

* Parallel image downloading with `TaskGroup`
* Real-time progress tracking for each image
* Caching via `NSCache` managed by `actor`
* MVVM architecture with protocol-based Dependency Injection (DI)
* AI classification using **Vision** + **Core ML**
* On-device text classification for receipts (Smart Receipt Scanner)

# Features
* Download multiple images concurrently and display them in a list.
* Show a loading progress bar for each image while downloading.
* Cache images with thread-safe actor to improve performance.
* Handle proper memory management to avoid memory leaks.
* Integrate AI-powered image search for the downloaded Images to allow user to search using keywords like "human", "tree", "car", etc.

# Requirements
* iOS 15.0+
* Xcode 13.0+

# Key Concepts Implemented
  1. Concurrency Handling  
      This project uses Swift Concurrency (introduced in Swift 5.5) for managing concurrency in an efficient manner. The TaskGroup is used to download multiple images           concurrently,   reducing the waiting time for the user.
      TaskGroup is used to manage concurrent tasks.
      CheckedContinuation is used to bridge between async/await and the older URLSessionDelegate methods.

  2. Memory Management  
      Memory management is critical in iOS apps, especially when dealing with images and large data. In this project, we focus on:
      Using NSCache for efficient image caching.
      Using the actor design pattern to manage cache access safely across multiple threads.

  4. Progress Handling UI  
      Each image download shows a real-time progress bar. The progress is updated dynamically as the image is being downloaded using the onProgress closure.

# Getting Started
### Installation  
    Clone this repository -> git clone: https://github.com/yourusername/ConcurrentImageDownloader.git
    Open the project in Xcode:
    Open ImageDownloaderApp.xcodeproj
    Build and run the project on a simulator or real device.
    Running the App
    Launch the app.

The app will start downloading random images from an API (https://picsum.photos) and display them in a list.

A progress bar will show the download progress for each image in real-time.

# Project Structure
* ImageDownloader.swift: Contains the logic for downloading images using URLSession and managing download progress.
* ImageDownloadManager.swift: Manages concurrent downloads using TaskGroup and stores images in an NSCache.
* ImageListViewModel.swift: View model for managing image downloads and tracking progress.
* ImageListView.swift: SwiftUI view for displaying images and their download progress.
* ConcurrentImageDownloaderApp.swift: Entry point for the app, responsible for setting up the root view.

# Design Decisions
### Concurrency:  
We use TaskGroup to handle concurrent downloads, improving the user experience by downloading images simultaneously.

### Memory Management:   
Images are cached using NSCache inside an actor, which ensures thread-safe access while managing memory efficiently.

### Progress Indicator:   
A progress bar is displayed for each image being downloaded. This gives the user feedback on the ongoing process and improves UX.

# Concurrency and Memory Management Insights
### Using TaskGroup for Concurrency:  
TaskGroup is used to manage multiple asynchronous tasks in parallel. Each download is handled concurrently, reducing the overall waiting time.

### Thread-Safe Caching with actor:  
The actor is used to manage access to the cache in a thread-safe manner. This prevents race conditions and ensures the cache is updated correctly.

### Memory Efficiency:  
NSCache automatically manages memory by evicting objects when the system is low on memory.
Images are cached to avoid re-downloading them every time.

### Progress Handling:  
The download progress for each image is updated dynamically using a closure. This allows real-time feedback to the user.

## Key Files to Review

| File                                   | Purpose                                                 |
|----------------------------------------|----------------------------------------------------------|
| `ImageListViewModel.swift`             | Handles download logic and progress tracking             |
| `ImageDownloadManager.swift`           | Uses TaskGroup to download/categorize/cache images       |
| `ImageClassifier.swift`                | Classifies downloaded images using Vision + Core ML      |
| `ReceiptScannerViewModel.swift`        | (Smart Receipt) Handles receipt OCR and category mapping |
| `ImageListView.swift`                  | UI with SwiftUI + progress bars                          |
| `AIClassifierModel.mlmodel`            | Pretrained model used for image classification           |

### Technologies Used
- Swift 5.5+
- SwiftUI
- Combine (for reactive flow)
- TaskGroup, async/await, CheckedContinuation
- NSCache + actor for concurrency-safe caching
- Core ML (e.g. MobileNetV2)
- Vision framework (VNCoreMLRequest)
- Protocol-based DI for testability

## 🌱 Future Improvements

- Add disk-based image cache
- Expand classification filtering and receipt understanding
- Add retry and cancellation to image downloads
- Improve empty/loading/error UI states
- Write more UI and integration tests

## 🔐 Security & Privacy Practices

- On-device AI with Core ML ensures user privacy
- No network model inference — all classification runs locally
- No sensitive data is stored; ephemeral image handling

### Author  
Nyein  
iOS Developer
