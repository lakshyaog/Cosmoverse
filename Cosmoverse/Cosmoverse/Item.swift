//
//  Item.swift
//  Cosmoverse
//
//  Created by Lakshya Solanki on 19/05/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var title: String
    var timestamp: Date
    
    init(title: String, timestamp: Date) {
        self.title = title
        self.timestamp = timestamp
    }
}
