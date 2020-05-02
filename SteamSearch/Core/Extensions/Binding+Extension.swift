//
//  Binding+Extension.swift
//  SteamSearch
//
//  Created by Joshua Simmons on 20/03/2020.
//  Copyright © 2020 Joshua. All rights reserved.
//

import SwiftUI

extension Binding {
    static func get(_ value: Value) -> Binding<Value> {
        State(wrappedValue: value).projectedValue
    }
}
