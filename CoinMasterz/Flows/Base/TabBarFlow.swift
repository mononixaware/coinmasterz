//
//  TabBarFlow.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import Combine
import Swinject
import UIKit

class TabBarFlow: Flow {
    
    var childFlows: [Flow] = []
    weak var parentFlow: Flow?
    let r: Resolver
    
    let tabBarController: UITabBarController
    
    init(r: Resolver, tabBarController: UITabBarController) {
        self.r = r
        self.tabBarController = tabBarController
    }
    
    // MARK: Presentable
    
    var presentationDelegate: PresentationControllerDelegate {
        tabBarController.presentationDelegate
    }
    
    func toPresent() -> UIViewController {
        tabBarController
    }
    
    // MARK: Flow
    
    func start() {
        
    }
    
    // MARK: -
    
    func show(_ presentables: [Presentable]) {
        presentables.compactMap(Flow.self).forEach { addChild($0) }
        tabBarController.viewControllers = presentables.map { $0.toPresent() }
    }
}
