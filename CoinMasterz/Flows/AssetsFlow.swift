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
        navigationController.navigationBar.prefersLargeTitles = true
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
        .store(in: &stepsBag)
        setRoot(view)
    }
    
    func showAssetsSortView(with model: AssetsSortModel, selectCompletion: Callback<AssetsSortModel.Kind>?) {
        let view = makeAssetsSortView(with: model)
        let flow = NavigationFlow(r: r, navigationController: UINavigationController())
        flow.navigationController.sheetPresentationController?.prefersGrabberVisible = true
        flow.navigationController.sheetPresentationController?.detents = [.medium(), .large()]
        view.steps.sink { [weak self, weak flow] in
            switch $0 {
            case let .selected(kind):
                selectCompletion?(kind)
                self?.dismiss(flow)
            }
        }
        .store(in: &stepsBag)
        present(view, embeddingFlow: flow)
    }
}
