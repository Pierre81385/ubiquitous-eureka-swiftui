//
//  AuthenticationSuccessView.swift
//  ubiquitous-eureka-swiftui
//
//  Created by m1_air on 8/27/24.
//

import SwiftUI
import FirebaseAuth

struct UserSetupView: View {
    @Binding var user: User?
    @State var showAvatar: Bool = false
    @State var setupComplete: Bool = false
    @State var mediaManager: MediaPickerViewModel = MediaPickerViewModel()
    @State var authenticationManager: FireAuthViewModel = FireAuthViewModel()
    
    var body: some View {
        VStack{
            Text("ID: \(user?.uid ?? "")")
            Spacer()
            Text("Hello, World!")
            if (showAvatar) {
                AsyncAwaitImageView(imageUrl: URL(string: mediaManager.imageURLs[0])!)
                    .scaledToFit()
                    .frame(height: 200)
                    .clipShape(Circle())
            } else {
                MediaPickerView(mediaManager: $mediaManager)
            }
            TextField(text: $authenticationManager.displayName, label: {
                Text("Username???")
            }).multilineTextAlignment(.center)
            Spacer()
            Button(action: {
                authenticationManager.avatarURL = mediaManager.imageURLs[0]
                authenticationManager.updateAvatar()
                authenticationManager.updateDisplayName()
                setupComplete = true
            }, label: {
                Text("Save")
            }).navigationDestination(isPresented: $setupComplete, destination: {
                HomeView()
            })
        }.onChange(of: mediaManager.imageURLs) { oldValue, newValue in
            if (!newValue.isEmpty) {
                showAvatar = true
            }
        }
    }
}

//#Preview {
//    AuthenticationSuccessView()
//}
