//
//  ActivityIndicator.swift
//  SteamSearch
//
//  Created by Joshua Simmons on 18/04/2020.
//  Copyright © 2020 Joshua. All rights reserved.
//

import Foundation
import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
    @Binding var isAnimating: Bool
    let color: UIColor // There's probably a better way to set this.
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
        uiView.color = color
    }
}

struct ActivityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ActivityIndicator(isAnimating: .get(true), color: .red, style: .large)
    }
}
