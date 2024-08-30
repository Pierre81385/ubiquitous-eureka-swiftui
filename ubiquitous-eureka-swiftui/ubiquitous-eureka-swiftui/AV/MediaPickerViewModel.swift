//
//  MediaPickerViewModel.swift
//  ubiquitous-eureka-swiftui
//
//  Created by m1_air on 8/29/24.
//

import Foundation
import Observation
import PhotosUI
import FirebaseStorage
import _PhotosUI_SwiftUI

@Observable class MediaPickerViewModel {
    var selectedItems: [PhotosPickerItem] = []
    var images: [UIImage] = []
    var imageURLs: [String] = []
    var videoURL: URL?
    var isUploading = false
    
    func loadMedia(from items: [PhotosPickerItem]) async {
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

    func uploadMedia() {
        isUploading = true

        let storage = Storage.storage().reference()
        let group = DispatchGroup()

        for image in images {
                group.enter()
                if let data = image.jpegData(compressionQuality: 0.2) {
                    let imageRef = storage.child("images/\(UUID().uuidString).jpg")
                    imageRef.putData(data, metadata: nil) { _, error in
                        if let error = error {
                            print("Error uploading image: \(error.localizedDescription)")
                            group.leave() // Leave the group if there is an error
                            return
                        }
                        
                        imageRef.downloadURL { (url, error) in
                            guard let downloadURL = url else {
                                print("Error: \(String(describing: error?.localizedDescription))")
                                group.leave() // Leave the group if there is an error
                                return
                            }
                            print(downloadURL.absoluteString)
                            self.imageURLs.append(downloadURL.absoluteString)
                            group.leave()
                        }
                    }
                } else {
                    group.leave() // Leave the group if image data could not be created
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
            self.isUploading = false
            print("Upload completed")
        }
    }
    
}
