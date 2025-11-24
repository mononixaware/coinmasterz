//
//  WatchlistFlow.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import Combine
import Swinject
import UIKit

protocol WatchlistFlow: NavigationFlow {
    
}

final class DefaultWatchlistFlow: NavigationFlow, WatchlistFlow, ModuleFactory {
    
    override func start() {
        controller.navigationBar.prefersLargeTitles = true
        showWatchlistView()
    }
}

private extension DefaultWatchlistFlow {
    
    func showWatchlistView() {
        let view = makeWatchlistView(with: WatchlistModel())
        view.steps.sink { [weak self] in
            switch $0 {
            case let .assetSelected(assetID):
                self?.showAssetDetailsView(with: AssetDetailsModel(assetID: assetID))
            }
        }
        .store(in: &view.stepsBag)
        setRoot(view)
    }
    
    func showAssetDetailsView(with model: AssetDetailsModel) {
        let view = makeAssetDetailsView(with: model)
        push(view, hideBottomBar: true)
    }
}
