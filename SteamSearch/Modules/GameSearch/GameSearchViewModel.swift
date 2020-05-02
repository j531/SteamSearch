//
//  GameSearchViewModel.swift
//  SteamSearch
//
//  Created by Joshua Simmons on 17/03/2020.
//  Copyright © 2020 Joshua. All rights reserved.
//

import Foundation
import Combine

class GameSearchViewModel: ViewModel {
    var state: AnyPublisher<State, Never> { stateMachine.state }
    var currentState: State { stateMachine.currentState }

    private typealias StateMachine = ViewModelStateMachine<State, Event, Task>

    private static let searchToken = UUID()
    private var stateMachine: StateMachine

    convenience init(
        state: State = State(),
        injecting injected: Injected = Injected()
    ) {
        self.init(scheduler: DispatchQueue.main, state: state, injecting: injected)
    }

    init<S: Scheduler>(
        scheduler: S,
        state: State = State(),
        injecting injected: Injected = Injected()
    ) {
        stateMachine = ViewModelStateMachine(
            scheduler: scheduler,
            initial: State(),
            update: Self.update,
            sideEffect: { task in Self.sideEffect(for: task, injecting: injected, on: scheduler) }
        )
        stateMachine.send(.didInitialise)
    }

    func send(_ input: UserInput) {
        stateMachine.send(.ui(input))
    }

    private static func update(state: inout State, event: Event) -> Task? {
        switch event {

        case .didInitialise:
            state.status = .loading
            return .search(term: "")

        case let .ui(.didChangeSearchTerm(searchTerm)):
            state.searchTerm = searchTerm
            return .delayedSearch(term: searchTerm)

        case .didStartLoading:
            state.status = .loading

        case let .didLoadResults(results):
            state.status = .loaded(results)

        case let .didFailToLoadResults(error):
            state.status = .failed(error)
        }

        return nil
    }

    private static func sideEffect<S: Scheduler>(
        for task: Task,
        injecting injected: Injected,
        on scheduler: S
    ) -> StateMachine.SideEffect {
        switch task {

        case let .search(term):
            return .task(
                Self.search(for: term, with: injected.steamWebService),
                token: Self.searchToken
            )

        case let .delayedSearch(term):
            return .task(
                Self.delayedSearch(for: term, with: injected.steamWebService, on: scheduler),
                token: Self.searchToken
            )
        }
    }

    private static func search(for searchTerm: String, with service: SteamWebService) -> AnyPublisher<Event, Never> {
        let cleanSearchTerm = searchTerm.trimmingCharacters(in: .whitespacesAndNewlines)
        return service.search(term: cleanSearchTerm)
            .map(Event.didLoadResults)
            .prepend(Event.didStartLoading)
            .replaceError(Event.didFailToLoadResults)
            .eraseToAnyPublisher()
    }

    private static func delayedSearch<S: Scheduler>(
        for searchTerm: String,
        with service: SteamWebService,
        on scheduler: S
    ) -> AnyPublisher<Event, Never> {
        Just(())
            .delay(for: .milliseconds(300), scheduler: scheduler)
            .flatMap { self.search(for: searchTerm, with: service) }
            .eraseToAnyPublisher()
    }
}

extension GameSearchViewModel {
    struct Injected {
        let steamWebService: SteamWebService

        init(steamWebService: SteamWebService = SteamAPI()) {
            self.steamWebService = steamWebService
        }
    }

    struct State: Equatable {
        var status: Status = .loaded([])
        var searchTerm = ""
    }

    enum Status {
        case loaded([SteamSearchItem])
        case failed(NetworkError)
        case loading
    }

    enum Event {
        case ui(UserInput)
        case didInitialise
        case didStartLoading
        case didLoadResults([SteamSearchItem])
        case didFailToLoadResults(NetworkError)
    }

    enum UserInput {
        case didChangeSearchTerm(String)
    }

    enum Task {
        case search(term: String)
        case delayedSearch(term: String)
    }
}

extension GameSearchViewModel.Status: Equatable {
    static func == (lhs: GameSearchViewModel.Status, rhs: GameSearchViewModel.Status) -> Bool {
        switch (lhs, rhs) {

        case let (.loaded(lhsItems), .loaded(rhsItems)):
            return lhsItems == rhsItems

        case let (.failed(lhsError), .failed(rhsError)):
            return lhsError == rhsError

        case (.loading, .loading):
            return true

        default:
            return false
        }
    }
}
