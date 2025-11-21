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
    var stepsBag = CancelBag()
    
    private var popCompletions = [ObjectIdentifier: EmptyCallback]()
    
    init(r: Resolver, navigationController: UINavigationController) {
        self.r = r
        self.navigationController = navigationController
    }
    
    // MARK: Presentable
    
    var presentationDelegate: PresentationControllerDelegate {
        navigationController.presentationDelegate
    }
    
    func toPresent() -> UIViewController {
        navigationController
    }
    
    // MARK: Flow
    
    func start() {
        
    }
    
    // MARK: -
    
    func setRoot(_ presentable: Presentable,
                 showTopBar: Bool = true) {
        let viewController = presentable.toPresent()
        navigationController.viewControllers.forEach { runPopCompletion($0) }
        navigationController.setNavigationBarHidden(showTopBar.isFalse, animated: false)
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func present(_ presentable: Presentable,
                 embeddingFlow: NavigationFlow? = nil,
                 animated: Bool = true,
                 completion: EmptyCallback? = nil,
                 onDidDismiss: EmptyCallback? = nil) {
        embeddingFlow?.setRoot(presentable)
        let flow = embeddingFlow ?? presentable as? Flow
        if let flow {
            addChild(flow)
        }
        let resolvedPresentable = embeddingFlow ?? presentable
        resolvedPresentable.presentationDelegate.presentationControllerDidDismiss = { [weak self, weak flow] in
            if let flow {
                self?.removeChild(flow)
            }
            onDidDismiss?()
        }
        let viewController = resolvedPresentable.toPresent()
        navigationController.presenter.present(viewController, animated: animated, completion: completion)
    }
    
    func dismiss(_ presentable: Presentable?,
                 animated: Bool = true,
                 completion: EmptyCallback? = nil) {
        if let flow = presentable as? Flow {
            removeChild(flow)
        }
        
        if let presentable,
           presentable.toPresent().isBeingDismissed.isFalse,
           let presenting = presentable.toPresent().presentingViewController {
            presenting.dismiss(animated: animated, completion: completion)
        } else {
            completion?()
        }
    }
}

private extension NavigationFlow {
    
    func runPopCompletion(_ viewController: UIViewController) {
        popCompletions.removeValue(forKey: ObjectIdentifier(viewController))?()
    }
}
