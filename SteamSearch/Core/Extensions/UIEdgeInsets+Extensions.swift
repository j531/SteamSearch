//
//  UIEdgeInsets+Extensions.swift
//  SteamSearch
//
//  Created by Joshua Simmons on 18/04/2020.
//  Copyright © 2020 Joshua. All rights reserved.
//

import Foundation
import UIKit

extension UIEdgeInsets {
    static func top(_ value: CGFloat) -> UIEdgeInsets {
        UIEdgeInsets(top: value, left: 0, bottom: 0, right: 0)
    }
}
