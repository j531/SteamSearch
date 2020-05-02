//
//  GameSearchView.swift
//  SteamSearch
//
//  Created by Joshua Simmons on 17/03/2020.
//  Copyright © 2020 Joshua. All rights reserved.
//

import SwiftUI

struct GameSearchView: View {
    private typealias State = GameSearchViewModel.State

    @ObservedObject private var context: ViewContext<GameSearchViewModel>

    init(context: ViewContext<GameSearchViewModel>) {
        self.context = context
    }

    var body: some View {
        VStack(spacing: 0) {
            // Weird text jumping issue when text field has focus and cursor is showing. Seems to exist if
            // the default TextField view is used here too? SwiftUI bug?
            // Another bug exists where the typing tooltips that pop up don't persist between view refreshes -
            // e.g the spelling tooltip will flash or disappear as requests are made and the view switches between
            // loading / loaded states. Maybe this is another SwiftUI bug?
            SearchTextField(
                placeholder: Localization.Search.searchPlaceholder,
                binding: context.binding(
                    for: \.searchTerm,
                    action: GameSearchViewModel.UserInput.didChangeSearchTerm
                )
            )
                .frame(height: 60)
            content
        }
        .background(
            Color.black.edgesIgnoringSafeArea(.all)
        )
    }

    private var content: AnyView {
        switch context.state.status {

        case let .loaded(items) where items.isEmpty:
            return centeredText(Localization.Search.noResults).eraseToAnyView()

        case let .loaded(items):
            return results(items).eraseToAnyView()

        case .loading:
            return loading.eraseToAnyView()

        case .failed:
            return centeredText(Localization.Error.genericMessage).eraseToAnyView()
        }
    }

    private var loading: some View {
        VStack {
            Spacer()
            ActivityIndicator(
                isAnimating: .get(true),
                color: UIColor.white.withAlphaComponent(0.9),
                style: .large
            )
            Spacer()
        }
    }

    private func results(_ items: [SteamSearchItem]) -> some View {
        List {
            ForEach(items, content: ResultItem.init)
                .listRowBackground(Color.black)
        }
        .onAppear {
            // Hack...
            UITableView.appearance().separatorStyle = .none
            UITableView.appearance().backgroundColor = .clear
            UIScrollView.appearance().keyboardDismissMode = .onDrag
            UIScrollView.appearance().contentInset = UIEdgeInsets.top(8)
        }
    }

    private func centeredText(_ text: String) -> some View {
        VStack {
            Spacer()
            Text(text)
                .font(AppFont.default(size: 22))
                .foregroundColor(Color.white)
            Spacer()
        }
    }
}

private struct ResultItem: View {
    let item: SteamSearchItem

    var body: some View {
        // There's some weird jumping here once the image has loaded. It only seems to be noticable on the iPhone 11
        // simulator (doesn't happen on my smaller screen physical device). Maybe screen size related?
        // Probably fixable...
        HStack {
            RemoteImage(imageLoader: ImageLoader(url: item.image), showActivityIndicator: false)
                .frame(width: 120, height: 45)
                .background(Color.white.opacity(0.1))
            Text(item.name)
                .foregroundColor(.white)
                .font(AppFont.default(size: 18))
                .lineLimit(2)
        }
    }
}

struct GameSearchView_Previews: PreviewProvider {
    private enum FakeError: Error {
        case error
    }

    static var previews: some View {
        GameSearchView(
            context: ViewContext(
                viewModel: GameSearchViewModel(
                    state: .init(
                        status: .loaded([
                            .init(id: 0, name: "abc", image: URL(string: "https://via.placeholder.com/150")!)]
                        ),
                        searchTerm: ""
                    )
                )
            )
        )
    }
}
