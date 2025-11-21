//
//  WatchlistViewController.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import SwiftUI

final class WatchlistViewController: BaseHostingController<WatchlistViewUI>, WatchlistView {
    
    var viewModel: WatchlistViewInput!
    
    override func setupNavigation() {
        super.setupNavigation()
        navigationItem.title = "Watchlist"
    }
}

struct WatchlistViewUI: View {
    
    @ObservedObject private(set) var viewModel: WatchlistViewModel
    
    var body: some View {
        Text("Watchlist View")
    }
}
