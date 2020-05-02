//
//  ViewModel.swift
//  SteamSearch
//
//  Created by Joshua Simmons on 28/04/2020.
//  Copyright © 2020 Joshua. All rights reserved.
//

import Foundation
import Combine

protocol ViewModel {
    associatedtype State
    associatedtype UserInput

    var state: AnyPublisher<State, Never> { get }
    var currentState: State { get }

    func send(_ input: UserInput)
}
