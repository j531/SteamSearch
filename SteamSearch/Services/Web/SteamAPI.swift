//
//  SteamAPI.swift
//  SteamSearch
//
//  Created by Joshua Simmons on 09/03/2020.
//  Copyright © 2020 Joshua. All rights reserved.
//

import Foundation
import Combine

struct SteamAPI: SteamWebService {
    private let httpService = NetworkService(baseURL: URL(string: "https://store.steampowered.com/api/")!)
    
    func search(term: String) -> AnyPublisher<[SteamSearchItem], NetworkError> {
        httpService.get(
            path: "storesearch",
            query: ["term": term, "cc": "GB"],
            mappingTo: SteamSearchResponse.self
        )
            .map(\.items)
            .eraseToAnyPublisher()
    }
}
