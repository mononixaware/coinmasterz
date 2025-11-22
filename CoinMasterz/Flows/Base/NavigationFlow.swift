//
//  NavigationFlow.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import Combine
import Swinject
import UIKit

class NavigationFlow: BaseFlow<UINavigationController> {
    
    func setRoot(_ presentable: Presentable,
                 showTopBar: Bool = true) {
        controller.setNavigationBarHidden(showTopBar.isFalse, animated: false)
        controller.setViewControllers([presentable.toPresent()], animated: false)
    }
    
    func push(_ presentable: Presentable, animated: Bool = true) {
        controller.pushViewController(presentable.toPresent(), animated: animated)
    }
    
    func pop(animated: Bool = true) {
        controller.popViewController(animated: animated)
    }
    
    func popToRoot(animated: Bool = true) {
        controller.popToRootViewController(animated: animated)
    }
}
