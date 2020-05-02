//
//  MockSteamWebService.swift
//  SteamSearchTests
//
//  Created by Joshua Simmons on 29/04/2020.
//  Copyright © 2020 Joshua. All rights reserved.
//

import Foundation
import Combine
@testable import SteamSearch

class MockSteamWebService: SteamWebService {
    var invokedSearch = false
    var invokedSearchCount = 0
    var invokedSearchParameters: (term: String, Void)?
    var invokedSearchParametersList = [(term: String, Void)]()
    var stubbedSearchResult: AnyPublisher<[SteamSearchItem], NetworkError>!

    func search(term: String) -> AnyPublisher<[SteamSearchItem], NetworkError> {
        invokedSearch = true
        invokedSearchCount += 1
        invokedSearchParameters = (term, ())
        invokedSearchParametersList.append((term, ()))
        return stubbedSearchResult
    }
}
