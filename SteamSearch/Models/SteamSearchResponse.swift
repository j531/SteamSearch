//
//  SteamSearchResponse.swift
//  SteamSearch
//
//  Created by Joshua Simmons on 10/03/2020.
//  Copyright © 2020 Joshua. All rights reserved.
//

import Foundation

struct SteamSearchResponse: Decodable {
    let items: [SteamSearchItem]
}
