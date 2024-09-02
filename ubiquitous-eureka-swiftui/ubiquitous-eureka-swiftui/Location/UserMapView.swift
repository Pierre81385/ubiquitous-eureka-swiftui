//
//  MapView.swift
//  ubiquitous-eureka-swiftui
//
//  Created by m1_air on 8/27/24.
//

import SwiftUI
import MapKit

struct UserMapView: View {

    @State private var locationManager = LocationManager()
    @State private var authManager: FireAuthViewModel = FireAuthViewModel()

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
                            Map {
                                Annotation(authManager.currentUser?.displayName ?? "No Name", coordinate: location.coordinate) {
                                    VStack{
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 30, height: 30)
                                            .overlay {
                                                if(authManager.currentUser?.photoURL != nil) {
                                                    AsyncAwaitImageView(imageUrl: (authManager.currentUser?.photoURL)!)
                                                        .scaledToFill()
                                                        .frame(width: 50, height: 50)
                                                        .clipShape(Circle())
                                                } else {
                                                    Image(systemName: "person.circle.fill")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                }
                                                
                                            }
                                            .padding()
                                    }
                                }
                            }.mapControls {
                                MapUserLocationButton()
                                MapCompass()
                                MapScaleView()
                            }
                            .frame(height: UIScreen.main.bounds.height * 0.7) // Set height to half of the viewport
                                       .cornerRadius(10) // Adjust the corner radius as needed
                                       .padding() //
                        
                        
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
            
        }.onAppear{
            authManager.GetCurrentUser()
        }
    }
}

#Preview {
    UserMapView()
}
