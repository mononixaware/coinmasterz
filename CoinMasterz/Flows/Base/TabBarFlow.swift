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
    
    func toPresent() -> UIViewController {
        tabBarController
    }
    
    // MARK: Flow
    
    func start() {
        preconditionFailure("Subclass must implement start()")
    }
    
    // MARK: -
    
    func setTabFlows(_ flows: [NavigationFlow]) {
        flows.forEach { addChild($0) }
        
        let viewControllers = flows.map { $0.toPresent() }
        tabBarController.setViewControllers(viewControllers, animated: false)
    }
}
