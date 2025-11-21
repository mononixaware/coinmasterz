//
//  ModuleFactoryProtocol.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import Swinject

protocol ModuleFactory {
    
    func makeAssetsSortView(with model: AssetsSortModel) -> AssetsSortView
    func makeAssetsView(with model: AssetsModel) -> AssetsView
    func makeWatchlistView(with model: WatchlistModel) -> WatchlistView
}

extension ModuleFactory where Self: AnyFactory {
    
    func makeAssetsSortView(with model: AssetsSortModel) -> AssetsSortView {
        r.resolve(with: model)
    }
    
    func makeAssetsView(with model: AssetsModel) -> AssetsView {
        r.resolve(with: model)
    }
    
    func makeWatchlistView(with model: WatchlistModel) -> WatchlistView {
        r.resolve(with: model)
    }
}

final class DefaultModuleFactory: BaseFactory, ModuleFactory {}
