//
//  GameSearchViewModelTests.swift
//  SteamSearchTests
//
//  Created by Joshua Simmons on 29/04/2020.
//  Copyright © 2020 Joshua. All rights reserved.
//

import XCTest
import Combine
@testable import SteamSearch

class GameSearchViewModelTests: XCTestCase, ViewModelVerifying {
    typealias VM = GameSearchViewModel

    func test_viewModel_whenFetchedResults_shouldHaveLoadedState() {
        let webService = MockSteamWebService()
        webService.stubbedSearchResult = makeResultsPublisher()

        let searchTerm = "Game"
        let itemFixtures = [SteamSearchItem.fixture()]

        verifyViewModel(
            viewModel: { scheduler in
                GameSearchViewModel(
                    scheduler: scheduler,
                    injecting: .init(steamWebService: webService)
                )
        },
            run: { viewModel, scheduler in
                scheduler.resume()
                webService.stubbedSearchResult = makeResultsPublisher(for: itemFixtures)
                viewModel.send(.didChangeSearchTerm(searchTerm))
                scheduler.resume()
        },
            verify: { snapshots in
                XCTAssertEqual(
                    snapshots,
                    [
                        .init(State(status: .loaded([]), searchTerm: "")),
                        .init(State(status: .loading, searchTerm: ""), .search(term: "")),
                        .init(State(status: .loading, searchTerm: "")),
                        .init(State(status: .loaded([]), searchTerm: "")),
                        .init(State(status: .loaded([]), searchTerm: searchTerm), .delayedSearch(term: searchTerm)),
                        .init(State(status: .loading, searchTerm: searchTerm)),
                        .init(State(status: .loaded(itemFixtures), searchTerm: searchTerm))
                    ]
                )
        })
    }

    private func makeResultsPublisher(
        for items: [SteamSearchItem] = []
    ) -> AnyPublisher<[SteamSearchItem], NetworkError> {
        Just<[SteamSearchItem]>(items)
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
}
