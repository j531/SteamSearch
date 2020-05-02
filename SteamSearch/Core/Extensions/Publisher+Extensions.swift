//
//  Publisher+Extensions.swift
//  SteamSearch
//
//  Created by Joshua Simmons on 14/04/2020.
//  Copyright © 2020 Joshua. All rights reserved.
//

import Foundation
import Combine

extension Publisher {
    func replaceError(_ transform: @escaping (Self.Failure) -> Self.Output) -> AnyPublisher<Self.Output, Never> {
        self.catch { error in Just(transform(error)) }
            .eraseToAnyPublisher()
    }
}
