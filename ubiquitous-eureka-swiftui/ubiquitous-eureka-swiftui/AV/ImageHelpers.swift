//
//  ImageHelpers.swift
//  ubiquitous-eureka-swiftui
//
//  Created by m1_air on 8/28/24.
//

import Foundation
import SwiftUI
import PhotosUI

class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    func loadImage(from url: URL) async {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            image = UIImage(data: data)
        } catch {
            print("Error loading image: \(error.localizedDescription)")
        }
    }
}

struct AsyncAwaitImageView: View {
    @StateObject private var imageLoader = ImageLoader()
    let imageUrl: URL

    var body: some View {
        Group {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                ProgressView()
            }
        }
        .onAppear {
            Task {
                await imageLoader.loadImage(from: imageUrl)
            }
        }
    }
}

