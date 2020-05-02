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

protocol ViewModelVerifying {
    associatedtype VM: ViewModel
    typealias State = VM.State
}

extension ViewModelVerifying {
    func verifyViewModel(
        viewModel: (TestScheduler) -> VM,
        run: (VM, TestScheduler) -> Void,
        verify: ([VM.State]) -> Void
    ) {
        let scheduler = TestScheduler()
        let viewModel = viewModel(scheduler)

        let stateSubscriber = scheduler.createTestableSubscriber(VM.State.self, Never.self)
        viewModel.state.subscribe(stateSubscriber)
        scheduler.resume()
        
        run(viewModel, scheduler)
        verify(stateSubscriber.recordedValues())
    }
}
