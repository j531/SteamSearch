//
//  SteamWebService.swift
//  SteamSearch
//
//  Created by Joshua Simmons on 29/04/2020.
//  Copyright © 2020 Joshua. All rights reserved.
//

import Foundation
import Combine

protocol SteamWebService {
    func search(term: String) -> AnyPublisher<[SteamSearchItem], NetworkError>
}
