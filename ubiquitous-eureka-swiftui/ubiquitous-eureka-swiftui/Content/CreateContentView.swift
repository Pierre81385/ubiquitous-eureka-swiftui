//
//  CreateContentView.swift
//  ubiquitous-eureka-swiftui
//
//  Created by m1_air on 9/2/24.
//

import SwiftUI

struct CreateContentView: View {
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
                                MediaPickerView(mediaManager: $mediaManager, uploadType: "content")
                                TextField("Title", text: $contentManager.content.title)
                                TextField("Description", text: $contentManager.content.description)
                                Button(action: {
                                    contentManager.content.dateCreated = Date().timeIntervalSince1970
                                    contentManager.content.locationCoordinate = location.coordinate
                                    contentManager.content.images = mediaManager.imageURLs
                                    contentManager.content.video = mediaManager.videoURL ?? URL(fileURLWithPath: "")
                                    contentManager.createContent()
                                }, label: {
                                    Text("Submit")
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

#Preview {
    CreateContentView()
}
