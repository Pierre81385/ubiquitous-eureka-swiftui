//
//  ContentModel.swift
//  ubiquitous-eureka-swiftui
//
//  Created by m1_air on 9/2/24.
//

import Foundation
import MapKit

struct ContentData {
    var creatorUID: String
    var creatorName: String
    var creatorAvatar: URL
    var locationCoordinate: CLLocationCoordinate2D
    var dateCreated: Double
    var images: [String]
    var video: URL
    var title: String
    var description: String
    var likes: [String]
    var disLikes: [String]
}
