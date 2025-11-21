//
//  ModuleAssembly.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import Swinject

final class ModuleAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(AssetsSortView.self) { r, model in
            let viewModel = AssetsSortViewModel(
                model: model
            )
            let viewUI = AssetsSortViewUI(viewModel: viewModel)
            let view = AssetsSortViewController(rootView: viewUI)
            viewModel.bind(output: view)
            view.viewModel = viewModel
            return view
        }
        
        container.register(AssetsView.self) { r, model in
            let viewModel = AssetsViewModel(
                coinCapProvider: r.resolve(),
                model: model
            )
            let viewUI = AssetsViewUI(viewModel: viewModel)
            let view = AssetsViewController(rootView: viewUI)
            viewModel.bind(output: view)
            view.viewModel = viewModel
            return view
        }
        
        container.register(WatchlistView.self) { r, model in
            let viewModel = WatchlistViewModel(model: model)
            let viewUI = WatchlistViewUI(viewModel: viewModel)
            let view = WatchlistViewController(rootView: viewUI)
            viewModel.bind(output: view)
            view.viewModel = viewModel
            return view
        }
    }
}
