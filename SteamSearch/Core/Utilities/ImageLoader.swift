//
//  ImageLoader.swift
//  SteamSearch
//
//  Created by Joshua Simmons on 18/04/2020.
//  Copyright © 2020 Joshua. All rights reserved.
//

import Foundation
import UIKit
import Nuke

class ImageLoader: ObservableObject {
    @Published var status = Status.loading

    enum Status {
        case loading
        case loaded(UIImage)
        case failed
    }

    init(url: URL) {
        ImagePipeline.shared.loadImage(with: url) { result in
            switch result {

            case let .success(response):
                self.status = .loaded(response.image)

            case .failure:
                self.status = .failed
            }
        }
    }
}
