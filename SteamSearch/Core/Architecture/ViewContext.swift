//
//  ViewContext.swift
//  SteamSearch
//
//  Created by Joshua Simmons on 28/04/2020.
//  Copyright © 2020 Joshua. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class ViewContext<VM: ViewModel>: ObservableObject {
    @Published private(set) var state: VM.State

    private let viewModel: VM
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: VM) {
        state = viewModel.currentState
        self.viewModel = viewModel

        viewModel.state.sink { [weak self] newState in
            guard let self = self else { return }
            self.state = newState
        }
        .store(in: &cancellables)
    }

    func binding<Value>(
        for keyPath: KeyPath<VM.State, Value>,
        action: @escaping (Value) -> VM.UserInput
    ) -> Binding<Value> {
        Binding(
            get: { self.state[keyPath: keyPath] },
            set: { value in
                self.viewModel.send(action(value))
        })
    }
}
