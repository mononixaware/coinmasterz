//
//  FlowAssembly.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import Swinject

final class FlowAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(AppFlow.self) { r, window, navigationController in
            DefaultAppFlow(r: r, window: window, controller: navigationController)
        }
        .inObjectScope(.weak)
        
        container.register(AssetsFlow.self) { r, navigationController in
            DefaultAssetsFlow(r: r, controller: navigationController)
        }
        
        container.register(MainTabBarFlow.self) { r, tabBarController in
            DefaultMainTabBarFlow(r: r, controller: tabBarController)
        }
        
        container.register(WatchlistFlow.self) { r, navigationController in
            DefaultWatchlistFlow(r: r, controller: navigationController)
        }
    }
}
