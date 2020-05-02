//
//  Localization.swift
//  SteamSearch
//
//  Created by Joshua Simmons on 19/03/2020.
//  Copyright © 2020 Joshua. All rights reserved.
//

import Foundation

enum Localization {
    enum Error {
        static let genericMessage = localized("generic_error_message")
    }

    enum Search {
        static let searchPlaceholder = localized("search_placeholder")
        static let loading = localized("search_loading")
        static let noResults = localized("search_no_results")
    }
}

private func localized(_ key: String) -> String {
    NSLocalizedString(key, comment: "")
}
