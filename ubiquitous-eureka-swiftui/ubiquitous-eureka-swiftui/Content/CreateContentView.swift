//
//  CreateContentView.swift
//  ubiquitous-eureka-swiftui
//
//  Created by m1_air on 9/2/24.
//

import SwiftUI

struct CreateContentView: View {
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
                            
                        if let user = authManager.currentUser {
                            
                            
                            VStack{
                                Text("User: \(user.displayName ?? "")")
                                Text("Longitude: \(location.coordinate.longitude)")
                                Text("Latitude: \(location.coordinate.latitude)")
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
        }
    }
}

#Preview {
    CreateContentView()
}
