//
//  RemoteImage.swift
//  SteamSearch
//
//  Created by Joshua Simmons on 18/04/2020.
//  Copyright © 2020 Joshua. All rights reserved.
//

import Foundation
import SwiftUI
import Nuke
import SFSafeSymbols

struct RemoteImage: View {
    @ObservedObject var imageLoader: ImageLoader
    let showActivityIndicator: Bool

    var body: some View {
        switch imageLoader.status {

        case .loading:
            return showActivityIndicator
                ? ActivityIndicator(
                    isAnimating: .get(true),
                    color: UIColor.white.withAlphaComponent(0.9),
                    style: .medium
                ).eraseToAnyView()
                : Color.clear.eraseToAnyView()

        case let .loaded(image):
            return GeometryReader { proxy in
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .clipped()
            }.eraseToAnyView()

        case .failed:
            return Image(systemSymbol: .multiply)
                .foregroundColor(.white)
                .eraseToAnyView()
        }
    }
}

struct RemoteImage_Previews: PreviewProvider {
    static var previews: some View {
        RemoteImage(
            imageLoader: ImageLoader(
                status: .loaded(
                    Image(imageLiteralResourceName: "test_1")
                )
            ),
            showActivityIndicator: true
        )
            .frame(width: 200, height: 200)
            .background(Color.black)
    }
}

private extension ImageLoader {
    convenience init(status: Status) {
        self.init(url: URL(string: "https://via.placeholder.com/150")!)
        self.status = status
    }
}
