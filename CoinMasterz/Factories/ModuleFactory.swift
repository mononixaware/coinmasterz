//
//  ModuleFactoryProtocol.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import Swinject

protocol ModuleFactory {
    
    func makeAssetDetailsView(with model: AssetDetailsModel) -> AssetDetailsView
    func makeAssetsSortView(with model: AssetsSortModel) -> AssetsSortView
    func makeAssetsView(with model: AssetsModel) -> AssetsView
    func makeOnboardingView(with model: OnboardingModel) -> OnboardingView
    func makeWatchlistView(with model: WatchlistModel) -> WatchlistView
}

extension ModuleFactory where Self: AnyFactory {
    
    func makeAssetDetailsView(with model: AssetDetailsModel) -> AssetDetailsView {
        r.resolve(with: model)
    }
    
    func makeAssetsSortView(with model: AssetsSortModel) -> AssetsSortView {
        r.resolve(with: model)
    }
    
    func makeAssetsView(with model: AssetsModel) -> AssetsView {
        r.resolve(with: model)
    }
    
    func makeOnboardingView(with model: OnboardingModel) -> OnboardingView {
        r.resolve(with: model)
    }
    
    func makeWatchlistView(with model: WatchlistModel) -> WatchlistView {
        r.resolve(with: model)
    }
}

final class DefaultModuleFactory: BaseFactory, ModuleFactory {}
