//
//  SteamSearchItem.swift
//  SteamSearch
//
//  Created by Joshua Simmons on 10/03/2020.
//  Copyright © 2020 Joshua. All rights reserved.
//

import Foundation

struct SteamSearchItem: Decodable, Identifiable, Equatable {
    let id: Int
    let name: String
    let image: URL

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image = "tiny_image"
    }
}
