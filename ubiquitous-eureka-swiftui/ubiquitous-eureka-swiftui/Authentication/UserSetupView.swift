//
//  AuthenticationSuccessView.swift
//  ubiquitous-eureka-swiftui
//
//  Created by m1_air on 8/27/24.
//

import SwiftUI
import FirebaseAuth

struct UserSetupView: View {
    @State var mediaManager: MediaPickerViewModel = MediaPickerViewModel()
    @State var authenticationManager: FireAuthViewModel = FireAuthViewModel()
    @State var checkingUser: Bool = true
    @State var showAvatar: Bool = false
    @State var setupComplete: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack{
                if(checkingUser) {
                    VStack{
                        ProgressView()
                        Text("Verifying your Account.")
                    }
                } else {
                    VStack{
                        Spacer()
                        if (showAvatar) {
                            AsyncAwaitImageView(imageUrl: URL(string: mediaManager.imageURLs[0])!)
                                .scaledToFill()
                                .frame(width: 325, height: 325)
                                .clipShape(Circle())
                        } else {
                            VStack{
                                MediaPickerView(mediaManager: $mediaManager, uploadType: "profile")
                                Text("Upload a Profile Picture")
                            }
                        }
                        TextField(text: $authenticationManager.displayName, label: {
                            Text("Display Name")
                        }).multilineTextAlignment(.center).padding()
                        Spacer()
                        Button(action: {
                            authenticationManager.updateDisplayName()
                        }, label: {
                            Text("Save")
                        }).onChange(of: authenticationManager.status, {
                            if(authenticationManager.success) {
                                setupComplete = true
                            }
                        })
                        .padding()
                    }
                }
            }
            .onAppear{
                authenticationManager.GetCurrentUser()
                if(authenticationManager.currentUser?.photoURL != nil && authenticationManager.currentUser?.displayName != nil)
                {
                    setupComplete = true
                } else {
                    checkingUser = false
                }
            }
            .onChange(of: mediaManager.imageURLs) { oldValue, newValue in
                if (!newValue.isEmpty) {
                    authenticationManager.avatarURL = newValue[0]
                    authenticationManager.updateAvatar()
                }
            }
            .onChange(of: authenticationManager.status, {
                oldValue, newValue in
                showAvatar = authenticationManager.success
            })
            .navigationDestination(isPresented: $setupComplete, destination: {
                HomeView()
            })
        }
    }
}

#Preview {
    UserSetupView()
}
