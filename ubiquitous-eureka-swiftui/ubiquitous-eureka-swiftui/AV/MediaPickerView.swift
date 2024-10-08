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
    @State private var checkColor: Color = Color.black

    var body: some View {
        VStack {
            if (showImagePicker) {
                Rectangle()
                            .fill(Color.white)
                            .frame(width: 325, height: 325)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                            .overlay(
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
                            )
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
                                    .scaledToFill()
                                    .frame(width: 320, height: 320)
                                    .cornerRadius(20)
                                    .clipped() // Ensures the image doesn't overflow outside the rounded corners
                                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
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
                    }.onChange(of: mediaManager.imageURLs) { oldValue, newValue in
                        if(oldValue.count < newValue.count) {
                            checkColor = Color.green
                        }
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
