//
//  AnyPublisher+Extensions.swift
//  SteamSearch
//
//  Created by Joshua Simmons on 25/03/2020.
//  Copyright © 2020 Joshua. All rights reserved.
//

import Foundation
import Combine

extension AnyPublisher where Output == URLSession.DataTaskPublisher.Output {
    func data() -> AnyPublisher<Data, Failure> {
        map { data, _ in data }.eraseToAnyPublisher()
    }
}
