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
                webService.stubbedSearchResult = makeResultsPublisher(for: itemFixtures)
                viewModel.send(.didChangeSearchTerm(searchTerm))
                scheduler.resume()
        },
            verify: { states in
                XCTAssertEqual(
                    states,
                    [
                        State(status: .loaded([]), searchTerm: ""),
                        State(status: .loading, searchTerm: ""),
                        State(status: .loading, searchTerm: ""),
                        State(status: .loaded([]), searchTerm: ""),
                        State(status: .loaded([]), searchTerm: searchTerm),
                        State(status: .loading, searchTerm: searchTerm),
                        State(status: .loaded(itemFixtures), searchTerm: searchTerm),
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
