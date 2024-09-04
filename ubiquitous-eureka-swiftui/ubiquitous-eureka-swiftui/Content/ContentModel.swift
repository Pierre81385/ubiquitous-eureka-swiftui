//
//  ContentModel.swift
//  ubiquitous-eureka-swiftui
//
//  Created by m1_air on 9/2/24.
//

import Foundation
import MapKit
import FirebaseFirestore
import CoreLocation

struct ContentData: Codable {
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

    enum CodingKeys: String, CodingKey {
        case creatorUID
        case creatorName
        case creatorAvatar
        case locationCoordinate
        case dateCreated
        case images
        case video
        case title
        case description
        case likes
        case disLikes
    }

    // Custom encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(creatorUID, forKey: .creatorUID)
        try container.encode(creatorName, forKey: .creatorName)
        try container.encode(creatorAvatar, forKey: .creatorAvatar)
        
        // Encode CLLocationCoordinate2D as a dictionary
        let locationDict = ["latitude": locationCoordinate.latitude, "longitude": locationCoordinate.longitude]
        try container.encode(locationDict, forKey: .locationCoordinate)
        
        try container.encode(dateCreated, forKey: .dateCreated)
        try container.encode(images, forKey: .images)
        try container.encode(video, forKey: .video)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(likes, forKey: .likes)
        try container.encode(disLikes, forKey: .disLikes)
    }

    // Custom decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        creatorUID = try container.decode(String.self, forKey: .creatorUID)
        creatorName = try container.decode(String.self, forKey: .creatorName)
        creatorAvatar = try container.decode(URL.self, forKey: .creatorAvatar)
        
        // Decode CLLocationCoordinate2D from a dictionary
        let locationDict = try container.decode([String: Double].self, forKey: .locationCoordinate)
        locationCoordinate = CLLocationCoordinate2D(latitude: locationDict["latitude"] ?? 0.0, longitude: locationDict["longitude"] ?? 0.0)
        
        dateCreated = try container.decode(Double.self, forKey: .dateCreated)
        images = try container.decode([String].self, forKey: .images)
        video = try container.decode(URL.self, forKey: .video)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        likes = try container.decode([String].self, forKey: .likes)
        disLikes = try container.decode([String].self, forKey: .disLikes)
    }

    // Default initializer
    init(creatorUID: String, creatorName: String, creatorAvatar: URL, locationCoordinate: CLLocationCoordinate2D, dateCreated: Double, images: [String], video: URL, title: String, description: String, likes: [String], disLikes: [String]) {
        self.creatorUID = creatorUID
        self.creatorName = creatorName
        self.creatorAvatar = creatorAvatar
        self.locationCoordinate = locationCoordinate
        self.dateCreated = dateCreated
        self.images = images
        self.video = video
        self.title = title
        self.description = description
        self.likes = likes
        self.disLikes = disLikes
    }
}

