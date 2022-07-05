//
//  Notes.swift
//  Notes
//
//  Created by Gokul on 19/05/22.
//

import Foundation
import CoreData

struct BackendNotes: Decodable {
    let title: String?
    let image: String?
    let date: String?
    let body: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case image = "image"
        case date = "time"
        case body = "body"
    }
    
}
