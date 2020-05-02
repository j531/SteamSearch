//
//  AppFont.swift
//  SteamSearch
//
//  Created by Joshua Simmons on 15/04/2020.
//  Copyright © 2020 Joshua. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

enum AppFont {
    private static let defaultFamily = "Inter"

    static func `default`(size: CGFloat) -> Font {
        Font(CTFontCreateWithName(defaultFamily as CFString, size, nil))
    }
}
