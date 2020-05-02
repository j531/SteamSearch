//
//  SearchTextField.swift
//  SteamSearch
//
//  Created by Joshua Simmons on 19/03/2020.
//  Copyright © 2020 Joshua. All rights reserved.
//

import SwiftUI
import SFSafeSymbols

struct SearchTextField: View {
    let placeholder: String
    let binding: Binding<String>

    private let insets = EdgeInsets(vertical: 16, horizontal: 12)
    private let font = AppFont.default(size: 22)

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                HStack {
                    Image(systemSymbol: .magnifyingglass)
                        .foregroundColor(Color.white.opacity(0.4))
                    Text(self.placeholder)
                        .font(self.font)
                        .foregroundColor(
                            Color.white.opacity(
                                self.binding.wrappedValue.isEmpty ? 0.4 : 0
                            )
                    )
                        .padding(.leading, 1)
                    Spacer()
                }
                .padding(.leading, self.insets.leading)
                .frame(height: proxy.size.height)
                TextField("", text: self.binding)
                    .font(self.font)
                    .padding(self.insets + .leading(26))
                    .foregroundColor(Color.white)
                    .frame(height: proxy.size.height)
            }
        }
        .overlay(
            Rectangle()
                .fill(Color.white)
                .frame(height: 1)
                .padding(.leading, insets.leading),
            alignment: .bottom
        )
    }
}

struct SearchTextField_Previews: PreviewProvider {
    static var previews: some View {
        List {
            SearchTextField(placeholder: "Search", binding: .get(""))
                .listRowInsets(.zero)
        }
    }
}
