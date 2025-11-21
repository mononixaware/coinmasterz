//
//  AppFlow.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import Swinject
import Combine
import UIKit

protocol AppFlow: NavigationFlow {
    
}

final class DefaultAppFlow: NavigationFlow, AppFlow, FlowFactory {
    
    private let window: UIWindow
    
    init(r: Resolver, window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        super.init(r: r, navigationController: navigationController)
    }
    
    override func start() {
        removeAllChildren()
        
        showMainTabBarFlow()
    }
}

private extension DefaultAppFlow {
    
    func showMainTabBarFlow() {
        let tabBarController = UITabBarController()
        tabBarController.title = "MainTabBarController"
        let mainTabFlow = makeMainTabBarFlow(tabBarController: tabBarController)
        addChild(mainTabFlow)
        setRoot(mainTabFlow, showTopBar: false)
    }
}
