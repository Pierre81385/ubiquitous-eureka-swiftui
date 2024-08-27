//
//  Item.swift
//  ubiquitous-eureka
//
//  Created by m1_air on 8/27/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
