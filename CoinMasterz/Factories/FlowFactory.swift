//
//  FlowFactory.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import Swinject
import UIKit

protocol FlowFactory {
    
    func makeAssetsFlow(navigationController: UINavigationController) -> AssetsFlow
    func makeMainTabBarFlow(tabBarController: UITabBarController) -> MainTabBarFlow
    func makeWatchlistFlow(navigationController: UINavigationController) -> WatchlistFlow
}

extension FlowFactory where Self: AnyFactory {
    
    func makeAssetsFlow(navigationController: UINavigationController) -> AssetsFlow {
        r.resolve(with: navigationController)
    }
    
    func makeMainTabBarFlow(tabBarController: UITabBarController) -> MainTabBarFlow {
        r.resolve(with: tabBarController)
    }
    
    func makeWatchlistFlow(navigationController: UINavigationController) -> WatchlistFlow {
        r.resolve(with: navigationController)
    }
}

final class DefaultFlowFactory: BaseFactory, FlowFactory {}
