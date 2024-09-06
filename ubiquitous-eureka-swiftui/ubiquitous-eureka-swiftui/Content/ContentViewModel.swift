//
//  ContentViewModel.swift
//  ubiquitous-eureka-swiftui
//
//  Created by m1_air on 9/2/24.
//

import Foundation
import Observation
import FirebaseFirestore
import MapKit

@Observable class ContentViewModel {
    var content: ContentData = ContentData(creatorUID: "", creatorName: "", creatorAvatar: URL(fileURLWithPath: ""), locationCoordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), dateCreated: 0.0, images: [], video: URL(fileURLWithPath: ""), title: "", description: "", likes: [], disLikes: [])
    var queriedContent: [ContentData] = []
    var status: String = ""
    var success: Bool = false
    private var db = Firestore.firestore()
    
    func getLocationByAddress(address: String) {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
                if error != nil {
                    print("Failed to retrieve location")
                    return
                }
                
                var location: CLLocation?
                
                if let placemarks = placemarks, placemarks.count > 0 {
                    location = placemarks.first?.location
                }
                
                if let location = location {
                    let coordinate = location.coordinate
                    self.content.locationCoordinate = coordinate
                }
                else
                {
                    print("No Matching Location Found")
                }
            })
        }
    
    func createContent() {
            
            let docRef = db.collection("content").document()
            
            do {
                try docRef.setData(from: self.content)
                self.status = "Success!"
                self.success = true
            }
            catch {
                self.status = "Error: \(error.localizedDescription)"
                self.success = false
            }
        }
    
    func getContents() async {
            db.collection("content")
                .addSnapshotListener { querySnapshot, error in
                    guard let documents = querySnapshot?.documents else {
                        self.status = "Error: \(String(describing: error?.localizedDescription))"
                        self.success = false
                        return
                    }
                    self.queriedContent = documents.compactMap { queryDocumentSnapshot -> ContentData? in
                        return try? queryDocumentSnapshot.data(as: ContentData.self)
                    }
                    self.status = "Success! Found Owners"
                    self.success = true
                }

        }
    
    func updateContributor(documentId: String) {
            
               let docRef = db.collection("contributors").document(documentId)
               do {
                 try docRef.setData(from: content)
                   self.status = "Success!"
                   self.success = true
               }
               catch {
                   self.status = "Error: \(error.localizedDescription)"
                   self.success = false
               }
             
        }
     
     func deleteContributor() {
         
     }
        
}
