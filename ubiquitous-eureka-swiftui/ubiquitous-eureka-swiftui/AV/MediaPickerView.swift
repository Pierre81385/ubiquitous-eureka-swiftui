//
//  MediaPickerView.swift
//  ubiquitous-eureka-swiftui
//
//  Created by m1_air on 8/28/24.
//

import SwiftUI
import PhotosUI
import FirebaseStorage

struct MediaPickerView: View {
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var images: [UIImage] = []
    @State private var videoURL: URL?
    @State private var isUploading = false

    var body: some View {
        VStack {
            PhotosPicker(
                selection: $selectedItems,
                matching: .any(of: [.images, .videos]),
                photoLibrary: .shared()) {
                Text("Select Images or Video")
            }
            .onChange(of: selectedItems) { oldItems, newItems in
                Task {
                    await loadMedia(from: newItems)
                }
            }

            if !images.isEmpty {
                ForEach(images, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                }
            }

            if let videoURL = videoURL {
                Text("Video Selected: \(videoURL.lastPathComponent)")
            }

            Button(action: uploadMedia) {
                Text("Upload Media")
            }
            .disabled(isUploading)
        }
        .padding()
    }

    private func loadMedia(from items: [PhotosPickerItem]) async {
        for item in items {
            // Load the media as either Data (for images) or URL (for video)
            if let imageData = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: imageData) {
                images.append(image)
            } else if let videoURL = try? await item.loadTransferable(type: URL.self) {
                // Load video URL
                self.videoURL = videoURL
            }
        }
    }

    private func uploadMedia() {
        isUploading = true

        let storage = Storage.storage().reference()
        let group = DispatchGroup()

        for image in images {
            group.enter()
            if let data = image.jpegData(compressionQuality: 0.8) {
                let imageRef = storage.child("images/\(UUID().uuidString).jpg")
                imageRef.putData(data, metadata: nil) { _, error in
                    if let error = error {
                        print("Error uploading image: \(error.localizedDescription)")
                    }
                    group.leave()
                }
            }
        }

        if let videoURL = videoURL {
            group.enter()
            let videoRef = storage.child("videos/\(UUID().uuidString).mov")
            videoRef.putFile(from: videoURL, metadata: nil) { _, error in
                if let error = error {
                    print("Error uploading video: \(error.localizedDescription)")
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            isUploading = false
            print("Upload completed")
        }
    }
}

#Preview {
    MediaPickerView()
}
