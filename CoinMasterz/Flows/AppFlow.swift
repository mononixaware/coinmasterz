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

final class DefaultAppFlow: NavigationFlow, AppFlow, FlowFactory, ModuleFactory {
    
    private let window: UIWindow
    private let userDefaultsService: UserDefaultsService
    
    init(r: Resolver,
         window: UIWindow,
         controller: UINavigationController,
         userDefaultsService: UserDefaultsService) {
        self.window = window
        self.userDefaultsService = userDefaultsService
        super.init(r: r, controller: controller)
    }
    
    override func start() {
        removeAllChildren()
        
        guard userDefaultsService.isOnboardingCompleted else {
            showOnboardingView()
            return
        }
        
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
    
    func showOnboardingView() {
        let view = makeOnboardingView(with: OnboardingModel())
        view.steps.sink { [weak self] in
            switch $0 {
            case .finish:
                self?.start()
            }
        }
        .store(in: &view.stepsBag)
        setRoot(view, showTopBar: false)
    }
}
