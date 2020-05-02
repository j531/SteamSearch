//
//  TestSubscriber+Extensions.swift
//  SteamSearchTests
//
//  Created by Joshua Simmons on 29/04/2020.
//  Copyright © 2020 Joshua. All rights reserved.
//

import Foundation
import EntwineTest

extension TestableSubscriber {
    func recordedValues() -> Array<Input> {
        recordedOutput.compactMap { _, event in
            guard case let .input(input) = event else { return nil }
            return input
        }
    }
}
