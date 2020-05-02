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
    associatedtype Task

    var state: AnyPublisher<(State, Task?), Never> { get }
    var currentState: (State, Task?) { get }

    func send(_ input: UserInput)
}
