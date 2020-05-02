//
//  EdgeInsets+Extensions.swift
//  SteamSearch
//
//  Created by Joshua Simmons on 05/03/2020.
//  Copyright © 2020 Joshua. All rights reserved.
//

import SwiftUI

extension EdgeInsets {
    static var zero: EdgeInsets {
        EdgeInsets()
    }

    init(vertical: CGFloat = 0, horizontal: CGFloat = 0) {
        self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }

    static func leading(_ value: CGFloat) -> EdgeInsets {
        EdgeInsets(top: 0, leading: value, bottom: 0, trailing: 0)
    }

    static func + (left: EdgeInsets, right: EdgeInsets) -> EdgeInsets {
        EdgeInsets(
            top: left.top + right.top,
            leading: left.leading + right.leading,
            bottom: left.bottom + right.bottom,
            trailing: left.trailing + right.trailing
        )
    }
}
