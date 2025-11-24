//
//  WatchlistViewController.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import Combine
import SwiftUI

final class WatchlistViewController: BaseHostingController<WatchlistViewUI>, WatchlistView {
    
    var steps = PassthroughSubject<WatchlistViewSteps, Never>()
    var viewModel: WatchlistViewInput!
    
    override func setupNavigation() {
        super.setupNavigation()
        navigationItem.title = "Watchlist"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.loadContets()
    }
}

struct WatchlistViewUI: View {
    
    @ObservedObject private(set) var viewModel: WatchlistViewModel
    
    var body: some View {
        Group {
            switch viewModel.model.context {
            case .loading:
                ProgressView("Loading favorites...")
            case .loaded:
                watchlistContent
            case .empty:
                emptyStateView
            }
        }
        .refreshable(action: viewModel.refresh)
    }
}

private extension WatchlistViewUI {
    
    var watchlistContent: some View {
        List {
            ForEach(viewModel.model.entities) { entity in
                Button {
                    viewModel.select(entity: entity)
                } label: {
                    WatchlistViewComponents.Entity(entity: entity)
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        viewModel.toggleFavorite(entityID: entity.id)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    .tint(.red)
                }
            }
        }
    }
    
    var emptyStateView: some View {
        ContentUnavailableView {
            Label("No Favorites", systemImage: "star")
        } description: {
            Text("Add cryptocurrencies to your watchlist by tapping the star icon.")
        }
    }
}
