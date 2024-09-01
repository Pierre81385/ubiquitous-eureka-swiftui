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
    @Binding var mediaManager: MediaPickerViewModel
    var uploadType: String
    @State private var showImagePicker: Bool = true

    var body: some View {
        VStack {
            if (showImagePicker) {
                PhotosPicker(
                    selection: $mediaManager.selectedItems,
                    matching: uploadType == "profile" ? .any(of: [.images]) : .any(of: [.images, .videos]),
                    photoLibrary: .shared()) {
                        Image(systemName: "person.crop.circle.badge.plus").resizable()
                            .fontWeight(.ultraLight)
                            .foregroundStyle(.teal)
                            .frame(width: 60, height: 50)
                    }
                    .onChange(of: mediaManager.selectedItems) { oldItems, newItems in

                        Task {
                                await mediaManager.loadMedia(from: newItems)
                            }
                        
                    }
                    .onChange(of: mediaManager.images) {
                        if !mediaManager.images.isEmpty {
                            showImagePicker = false
                        }
                    }
            }

            if !mediaManager.images.isEmpty {
                if(uploadType == "profile") {
                    ForEach(mediaManager.images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 325, height: 325)
                            .clipShape(Circle())
                            .onTapGesture {
                                mediaManager.selectedItems = []
                                mediaManager.images = []
                                mediaManager.imageURLs = []
                                mediaManager.videoURL = nil
                                showImagePicker = true
                            }
                    }
                } else {
                    ForEach(mediaManager.images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 250)
                            .onTapGesture {
                                mediaManager.selectedItems = []
                                mediaManager.images = []
                                mediaManager.imageURLs = []
                                mediaManager.videoURL = nil
                                showImagePicker = true
                            }
                    }
                }
            }

            if let videoURL = mediaManager.videoURL {
                Text("Video Selected: \(mediaManager.videoURL!.lastPathComponent)")
                //needs player
            }
            
            if (!showImagePicker) {
                HStack{
                    Spacer()
                    Button(action: {
                        mediaManager.selectedItems = []
                        mediaManager.images = []
                        mediaManager.imageURLs = []
                        mediaManager.videoURL = nil
                        showImagePicker = true
                    }, label: {
                        Image(systemName: "xmark").tint(Color.black)
                    })
                    Spacer()
                    Button(action: mediaManager.uploadMedia) {
                        Image(systemName: "checkmark").tint(Color.black)
                    }
                    .disabled(mediaManager.isUploading)
                    Spacer()
                }.padding()
            }
        }
        .padding()
    }

   
}

//#Preview {
//    MediaPickerView()
//}
