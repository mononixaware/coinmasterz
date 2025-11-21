//
//  AssetsFlow.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import Swinject
import UIKit

protocol AssetsFlow: NavigationFlow {
    
}

final class DefaultAssetsFlow: NavigationFlow, AssetsFlow, ModuleFactory {
    
    override func start() {
        navigationController.navigationBar.prefersLargeTitles = true
        showAssetsView()
    }
}

private extension DefaultAssetsFlow {
    
    func showAssetsView() {
        let view = makeAssetsView(with: AssetsModel())
        setRoot(view)
    }
}
