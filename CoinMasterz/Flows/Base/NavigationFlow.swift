//
//  NavigationFlow.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import Combine
import Swinject
import UIKit

class NavigationFlow: Flow {
    
    var childFlows: [Flow] = []
    weak var parentFlow: Flow?
    let r: Resolver
    
    let navigationController: UINavigationController
    
    init(r: Resolver, navigationController: UINavigationController) {
        self.r = r
        self.navigationController = navigationController
    }
    
    // MARK: Presentable
    
    func toPresent() -> UIViewController {
        navigationController
    }
    
    // MARK: Flow
    
    func start() {
        preconditionFailure("Subclass must implement start()")
    }
    
    // MARK: -
    
    func setRoot(_ presentable: Presentable,
                 showTopBar: Bool = true) {
        let viewController = presentable.toPresent()
        navigationController.setNavigationBarHidden(!showTopBar, animated: false)
        navigationController.setViewControllers([viewController], animated: false)
    }
}
