//
//  GameSearchBuilder.swift
//  SteamSearch
//
//  Created by Joshua Simmons on 17/03/2020.
//  Copyright © 2020 Joshua. All rights reserved.
//

import Foundation
import SwiftUI

enum GameSearchBuilder {
    static func make() -> UIViewController {
        let viewModel = GameSearchViewModel()
        let context = ViewContext<GameSearchViewModel>(viewModel: viewModel)
        let view = GameSearchView(context: context)

        return UIHostingController(rootView: view)
    }
}
