//
//  DataTaskPublisher+Extensions.swift
//  SteamSearch
//
//  Created by Joshua Simmons on 19/03/2020.
//  Copyright © 2020 Joshua. All rights reserved.
//

import Foundation
import Combine

extension URLSession.DataTaskPublisher {
    func verify() -> AnyPublisher<Output, NetworkError> {
        tryMap { data, response -> Output in
            guard let response = response as? HTTPURLResponse else {
                fatalError("Can't cast response as `HTTPURLResponse.")
            }
            guard (200..<300).contains(response.statusCode) else {
                throw NetworkError.statusCode(response.statusCode)
            }
            return (data, response)
        }
        .mapError { error in
            if let networkError = error as? NetworkError {
                return networkError
            }
            return NetworkError.unknown
        }
        .eraseToAnyPublisher()
    }
}
