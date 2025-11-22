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
    
    override func start() {
        controller.navigationBar.prefersLargeTitles = true
        showAssetsView()
    }
}

private extension DefaultAssetsFlow {
    
    func showAssetsView() {
        let view = makeAssetsView(with: AssetsModel())
        view.steps.sink { [weak self] in
            switch $0 {
            case let .sortSelected(selectedKind, selectCompletion):
                let model = AssetsSortModel(selectedKind: selectedKind)
                self?.showAssetsSortView(with: model, selectCompletion: selectCompletion)
            }
        }
        .store(in: &view.stepsBag)
        setRoot(view)
    }
    
    func showAssetsSortView(with model: AssetsSortModel, selectCompletion: Callback<AssetsSortModel.Kind>?) {
        let controller = UINavigationController()
        controller.title = "AssetsSortNavigationController"
        controller.sheetPresentationController?.prefersGrabberVisible = true
        controller.sheetPresentationController?.detents = [.medium(), .large()]
        let flow = NavigationFlow(r: r, controller: controller)
        let view = makeAssetsSortView(with: model)
        view.steps.sink { [weak self, weak flow] in
            switch $0 {
            case let .selected(kind):
                selectCompletion?(kind)
                flow.flatMap { self?.dismiss($0) }
            }
        }
        .store(in: &view.stepsBag)
        present(view, embeddingNavigationFlow: flow)
    }
}
