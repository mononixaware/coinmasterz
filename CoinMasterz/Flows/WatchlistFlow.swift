//
//  WatchlistFlow.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import Swinject
import UIKit

protocol WatchlistFlow: NavigationFlow {
    
}

final class DefaultWatchlistFlow: NavigationFlow, WatchlistFlow, ModuleFactory {
    
    override func start() {
        controller.navigationBar.prefersLargeTitles = true
        showWatchlistView()
    }
}

private extension DefaultWatchlistFlow {
    
    func showWatchlistView() {
        let view = makeWatchlistView(with: WatchlistModel())
        setRoot(view)
    }
}
