//
//  ViewModelStateMachine.swift
//  SteamSearch
//
//  Created by Joshua Simmons on 18/03/2020.
//  Copyright © 2020 Joshua. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class ViewModelStateMachine<State, Event, Task> {
    typealias Update = (_ state: inout State, _ event: Event) -> Task?
    typealias MakeSideEffect = (Task) -> SideEffect

    let state: AnyPublisher<(State, Task?), Never> // Should be a "list" of tasks (equal on contents, not order)
    var currentState: (State, Task?) { stateSubject.value }

    private let update: Update
    private let sideEffect: MakeSideEffect?

    private let stateSubject: CurrentValueSubject<(State, Task?), Never>
    private let events = PassthroughSubject<Event, Never>()

    private var cancellables = Set<AnyCancellable>()
    private var tokensToTasks = [SideEffect.Token: AnyCancellable]()

    enum SideEffect {
        typealias Token = UUID

        case task(AnyPublisher<Event, Never>, token: Token? = nil)
        case cancel(Token)
    }

    init<S: Scheduler>(
        scheduler: S,
        initial: State,
        update: @escaping Update,
        sideEffect: MakeSideEffect? = nil
    ) {
        self.stateSubject = CurrentValueSubject((initial, nil))
        self.state = stateSubject.eraseToAnyPublisher()
        self.update = update
        self.sideEffect = sideEffect

        start(on: scheduler)
    }

    func send(_ event: Event) {
        events.send(event)
    }

    // There's still a weird issue with typing updates - e.g. entering / deleting text isn't always in sync.
    // I'm 99% sure it's an issue with the simulator not handling inputs from a external keyboard fast enough
    // (the problem exists if you type quickly in other apps in the sim)...
    private func start<S: Scheduler>(on scheduler: S) {
        events.receive(on: scheduler)
            .sink { [weak self] event in
                guard let self = self else { return }
                var state = self.stateSubject.value.0
                let task = self.update(&state, event)

                if let task = task, let sideEffect = self.sideEffect?(task) {
                    self.handle(sideEffect)
                }

                self.stateSubject.value = (state, task)
        }
        .store(in: &cancellables)
    }

    private func handle(_ sideEffect: SideEffect) {
        switch sideEffect {

        case let .task(publisher, token):
            if let token = token {
                tokensToTasks.removeValue(forKey: token)?.cancel()
            }
            tokensToTasks[token ?? UUID()] = publisher.sink(receiveValue: events.send)

        case let .cancel(token):
            tokensToTasks.removeValue(forKey: token)?.cancel()
        }
    }
}
