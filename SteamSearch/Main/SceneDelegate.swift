//
//  SceneDelegate.swift
//  SteamSearch
//
//  Created by Joshua Simmons on 04/03/2020.
//  Copyright © 2020 Joshua. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {

        guard
            !ProcessInfo.processInfo.arguments.contains("TEST"), // There's probably a better way to do this...
            let windowScene = scene as? UIWindowScene else {
                return
        }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = GameSearchBuilder.make()
        self.window = window
        window.makeKeyAndVisible()
    }
}

