# ImageDownloaderApp
Concurrent Image Downloader. A SwiftUI-based image downloader app that demonstrates Swift Concurrency, memory management, and UI updates with progress indicators while fetching images from URLs.


# Overview
This project demonstrates the following key concepts:
* Concurrent image downloading with TaskGroup
* Image caching with actor for thread safety
* Memory management with careful deallocation of images
* Real-time progress tracking for each image download
* SwiftUI integration to display images with progress indicators

# Features
* Download multiple images concurrently and display them in a list.
* Show a loading progress bar for each image while downloading.
* Cache images with thread-safe actor to improve performance.
* Handle proper memory management to avoid memory leaks.

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

### Future Improvements
Implement image retries if a download fails.
Add support for custom image caching strategies (e.g., disk cache).
Add a detailed error handling mechanism for network issues.
Enhance the UI with animations when images are loaded or failed to load.

### Technologies Used
Swift 5.5+  
SwiftUI  
Combine for reactive programming.  
URLSession for networking.  
Concurrency: TaskGroup, CheckedContinuation, actor, async/await.  
NSCache for caching images.

### Author  
Nyein  
iOS Developer
