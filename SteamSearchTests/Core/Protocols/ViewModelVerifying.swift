//
//  ViewModelVerifying.swift
//  SteamSearchTests
//
//  Created by Joshua Simmons on 29/04/2020.
//  Copyright © 2020 Joshua. All rights reserved.
//

import XCTest
import Combine
import EntwineTest
@testable import SteamSearch

struct StateSnapshot<State: Equatable, Task: Equatable>: Equatable {
    let state: State
    let task: Task?

    init(_ state: State, _ task: Task? = nil) {
        self.state = state
        self.task = task
    }
}

protocol ViewModelVerifying {
    associatedtype VM: ViewModel where VM.State: Equatable, VM.Task: Equatable
    typealias State = VM.State
    typealias Task = VM.Task
}

extension ViewModelVerifying {
    func verifyViewModel(
        viewModel: (TestScheduler) -> VM,
        run: (VM, TestScheduler) -> Void,
        verify: ([StateSnapshot<State, Task>]) -> Void
    ) {
        let scheduler = TestScheduler()
        let viewModel = viewModel(scheduler)

        let stateSubscriber = scheduler.createTestableSubscriber((State, Task?).self, Never.self)
        viewModel.state.subscribe(stateSubscriber)

        run(viewModel, scheduler)
        verify(stateSubscriber.recordedValues().map(StateSnapshot.init))
    }
}
