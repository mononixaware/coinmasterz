//
//  TabBarFlow.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import Combine
import Swinject
import UIKit

class TabBarFlow: BaseFlow<UITabBarController> {
    
    func show(_ presentables: [Presentable]) {
        // Clean up existing children
        removeAllChildren()
        
        // Add new children
        presentables.compactMap { $0 as? Flow }.forEach { addChild($0) }
        controller.viewControllers = presentables.map { $0.toPresent() }
    }
}
