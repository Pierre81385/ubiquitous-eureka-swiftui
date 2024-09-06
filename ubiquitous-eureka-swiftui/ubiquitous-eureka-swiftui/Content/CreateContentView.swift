//
//  CreateContentView.swift
//  ubiquitous-eureka-swiftui
//
//  Created by m1_air on 9/2/24.
//

import SwiftUI
import Observation

struct CreateContentView: View {
    @Binding var showSheet: Bool
    @State private var contentManager: ContentViewModel = ContentViewModel()
    @State private var locationManager = LocationManager()
    @State private var authManager: FireAuthViewModel = FireAuthViewModel()
    @State private var mediaManager: MediaPickerViewModel = MediaPickerViewModel()
    
    var body: some View {
        VStack{
            VStack {
                switch locationManager.authorizationStatus {
                case .notDetermined:
                    Text("Requesting permission...")
                case .restricted, .denied:
                    Text("Location access denied.")
                case .authorizedWhenInUse, .authorizedAlways:
                    if let location = locationManager.location {
                            
                        if let user = authManager.currentUser {
                            
                            
                            VStack{
                                ScrollView(content: {
                                    VStack{
                                        Spacer()
                                        MediaPickerView(mediaManager: $mediaManager, uploadType: "content")
                                        Spacer()
                                        TextField("Title (required)", text: $contentManager.content.title).padding()
                                            .background(
                                                ZStack {
                                                    // Outer shadow (to create depth)
                                                    RoundedRectangle(cornerRadius: 15)
                                                        .fill(Color.white)
                                                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                                                    
                                                    // Inner shadow simulation
                                                    RoundedRectangle(cornerRadius: 15)
                                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                                        .shadow(color: Color.black.opacity(0.2), radius: 3, x: 2, y: 2)
                                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                                }
                                            )
                                            .cornerRadius(15)
                                            .padding()
                                        TextEditor(text: $contentManager.content.description)
                                            .padding()
                                            .frame(height: 200) // Height to display about 4 lines
                                            .background(
                                                ZStack {
                                                    // Outer shadow (to create depth)
                                                    RoundedRectangle(cornerRadius: 15)
                                                        .fill(Color.white)
                                                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                                                    
                                                    // Inner shadow simulation (optional)
                                                    RoundedRectangle(cornerRadius: 15)
                                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                                        .shadow(color: Color.black.opacity(0.2), radius: 3, x: 2, y: 2)
                                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                                }
                                            )
                                            .cornerRadius(15)
                                            .padding()
                                        Spacer()
                                    }
                                    HStack{
                                        Spacer()
                                        Button(action: {
                                                   showSheet = false
                                                }) {
                                                    Text("Cancel")
                                                        .font(.headline)
                                                        .foregroundColor(.white)
                                                        .padding()
                                                        .frame(maxWidth: .infinity)
                                                        .background(
                                                            RoundedRectangle(cornerRadius: 15)
                                                                .fill(Color.teal)
                                                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                                                        )
                                                }
                                                .padding(.horizontal)
                                        Spacer()
                                        Button(action: {
                                            contentManager.content.dateCreated = Date().timeIntervalSince1970
                                            contentManager.content.locationCoordinate = location.coordinate
                                            contentManager.content.images = mediaManager.imageURLs
                                            contentManager.content.video = mediaManager.videoURL ?? URL(fileURLWithPath: "")
                                            contentManager.createContent()
                                            showSheet = false
                                                }) {
                                                    Text("Submit")
                                                        .font(.headline)
                                                        .foregroundColor(.white)
                                                        .padding()
                                                        .frame(maxWidth: .infinity)
                                                        .background(
                                                            RoundedRectangle(cornerRadius: 15)
                                                                .fill(Color.teal)
                                                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                                                        )
                                                }
                                                .padding(.horizontal)
                                        Spacer()
                                    }
                                })
                            }
                            
                        }
                        
                    } else {
                        Text("Fetching location...")
                    }
                default:
                    Text("Error determining location.")
                }
                
            }
            .onAppear {
                locationManager.startUpdatingLocation()
            }
            .onDisappear {
                locationManager.stopUpdatingLocation()
            }
        }.onAppear {
            authManager.GetCurrentUser()
            contentManager.content.creatorUID = authManager.currentUser!.uid
            contentManager.content.creatorName = (authManager.currentUser?.displayName)!
            contentManager.content.creatorAvatar = (authManager.currentUser?.photoURL)!
        }
    }
}
