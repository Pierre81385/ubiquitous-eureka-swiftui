//
//  ContentViewModel.swift
//  ubiquitous-eureka-swiftui
//
//  Created by m1_air on 9/2/24.
//

import Foundation
import Observation
import MapKit

@Observable class ContentViewModel {
    var content: ContentData = ContentData(creatorUID: "", creatorName: "", creatorAvatar: URL(fileURLWithPath: ""), locationCoordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), dateCreated: 0.0, images: [], video: URL(fileURLWithPath: ""), title: "", description: "", likes: [], disLikes: [])
    var queriedContent: [ContentData] = []
}
