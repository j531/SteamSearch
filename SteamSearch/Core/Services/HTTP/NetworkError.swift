//
//  NetworkError.swift
//  SteamSearch
//
//  Created by Joshua Simmons on 09/03/2020.
//  Copyright © 2020 Joshua. All rights reserved.
//

import Foundation

enum NetworkError: Error, Equatable {
    case statusCode(Int)
    case decodingError // Needs more context...
    case unknown
}
