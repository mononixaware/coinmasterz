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
    
    override func start() {
        setupTabs()
    }
}

private extension DefaultMainTabBarFlow {
    
    func setupTabs() {
        let assetsNavigationController = UINavigationController()
        assetsNavigationController.title = "AssetsNavigationController"
        assetsNavigationController.tabBarItem = UITabBarItem(
            title: "Assets",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        let assetsFlow = makeAssetsFlow(navigationController: assetsNavigationController)
        
        let watchlistNavigationController = UINavigationController()
        watchlistNavigationController.title = "WatchlistNavigationController"
        watchlistNavigationController.tabBarItem = UITabBarItem(
            title: "Watchlist",
            image: UIImage(systemName: "star"),
            selectedImage: UIImage(systemName: "star.fill")
        )
        let watchlistFlow = makeWatchlistFlow(navigationController: watchlistNavigationController)
        
        setTabFlows([assetsFlow, watchlistFlow])
    }
}
