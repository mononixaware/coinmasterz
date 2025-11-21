//
//  MainTabBarFlow.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import Swinject
import UIKit

protocol MainTabBarFlow: TabBarFlow {
    
}

final class DefaultMainTabBarFlow: TabBarFlow, MainTabBarFlow, FlowFactory {
    
    private let tabs: [MainTab] = [.assets, .watchlist]
    
    override func start() {
        showMainView()
    }
}

private extension DefaultMainTabBarFlow {
    
    func showMainView() {
        show(tabs.map(makeSubflow))
    }
}

private extension DefaultMainTabBarFlow {
    
    func makeSubflow(_ tab: MainTab) -> Flow {
        switch tab {
        case .assets:
            let assetsNavigationController = UINavigationController()
            assetsNavigationController.title = "AssetsNavigationController"
            assetsNavigationController.tabBarItem = MainTab.assets.tabBarItem
            return makeAssetsFlow(navigationController: assetsNavigationController)
        case .watchlist:
            let watchlistNavigationController = UINavigationController()
            watchlistNavigationController.title = "WatchlistNavigationController"
            watchlistNavigationController.tabBarItem = MainTab.watchlist.tabBarItem
            return makeWatchlistFlow(navigationController: watchlistNavigationController)
        }
    }
}
