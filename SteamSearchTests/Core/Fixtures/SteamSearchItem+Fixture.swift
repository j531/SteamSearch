//
//  SteamSearchItem+Fixture.swift
//  SteamSearchTests
//
//  Created by Joshua Simmons on 30/04/2020.
//  Copyright © 2020 Joshua. All rights reserved.
//

import Foundation
@testable import SteamSearch

extension SteamSearchItem {
    static func fixture() -> SteamSearchItem {
        SteamSearchItem(id: 0, name: "Game", image: URL(string: "http://www.game.com")!)
    }
}
