//
//  MapView.swift
//  ubiquitous-eureka-swiftui
//
//  Created by m1_air on 8/27/24.
//

import SwiftUI
import MapKit

struct MapView: View {

    @StateObject private var locationManager = LocationManager()

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
                        Text("Latitude: \(location.coordinate.latitude)")
                        Text("Longitude: \(location.coordinate.longitude)")
                        Text("Altitude: \(location.altitude)")
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
            Map()
        }
    }
}

#Preview {
    MapView()
}
