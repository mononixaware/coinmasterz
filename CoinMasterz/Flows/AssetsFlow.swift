//
//  AssetsFlow.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import Combine
import Swinject
import UIKit

protocol AssetsFlow: NavigationFlow {
    
}

final class DefaultAssetsFlow: NavigationFlow, AssetsFlow, ModuleFactory {
    
    private var assetsViewCancellable: AnyCancellable?
    private var assetsSortViewCancellable: AnyCancellable?
    
    override func start() {
        controller.navigationBar.prefersLargeTitles = true
        showAssetsView()
    }
}

private extension DefaultAssetsFlow {
    
    func showAssetsView() {
        let view = makeAssetsView(with: AssetsModel())
        assetsViewCancellable = view.steps.sink { [weak self] in
            switch $0 {
            case let .sortSelected(selectedKind, selectCompletion):
                let model = AssetsSortModel(selectedKind: selectedKind)
                self?.showAssetsSortView(with: model, selectCompletion: selectCompletion)
            }
        }
        setRoot(view)
    }
    
    func showAssetsSortView(with model: AssetsSortModel, selectCompletion: Callback<AssetsSortModel.Kind>?) {
        let view = makeAssetsSortView(with: model)
        assetsSortViewCancellable = view.steps.sink { [weak self] in
            switch $0 {
            case let .selected(kind):
                selectCompletion?(kind)
                self?.pop(animated: true)
                self?.assetsSortViewCancellable = nil
            }
        }
        push(view)
    }
}
