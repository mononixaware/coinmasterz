//
//  WatchlistViewModel.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import Combine
import Foundation
import RxSwift
import SwiftUI

final class WatchlistViewModel: ObservableObject {
    
    @Published private(set) var model: WatchlistModel
    
    private weak var output: WatchlistViewOutput?
    private let coinCapProvider: CoinCapProvider
    private let favoritesService: FavoritesService
    private var disposeBag = DisposeBag()
    private var cancelBag = Set<AnyCancellable>()
    
    init(coinCapProvider: CoinCapProvider,
         favoritesService: FavoritesService,
         model: WatchlistModel) {
        self.coinCapProvider = coinCapProvider
        self.favoritesService = favoritesService
        self.model = model
        
        observeFavorites()
    }
    
    func select(entity: WatchlistModel.Entity) { output?.steps.send(.assetSelected(assetID: entity.id)) }
    
    func toggleFavorite(entityID: String) { favoritesService.toggleFavorite(assetID: entityID) }
    
    func refresh() async { await handleRefresh() }
    
    func retry() { handleRetry() }
}

private extension WatchlistViewModel {
    
    func fetchEntities(assetsIDs: [String]) -> Single<[WatchlistModel.Entity]> {
        guard assetsIDs.isNotEmpty else { return Single.just([]) }
        
        let ids = assetsIDs.joined(separator: ",")
        return coinCapProvider.getAssets(search: nil, ids: ids, limit: nil, offset: nil)
            .map(\.data)
            .map(WatchlistModelBuilder.makeEntities)
            .onError(with: self) { $0.didFailToFetchEntities(error: $1) }
            .traceError()
    }
    
    func getEntities() {
        let assetsIDs = Array(favoritesService.getAllFavoriteIDs())
        fetchEntities(assetsIDs: assetsIDs)
            .subscribe(on: MainScheduler.instance)
            .weak(self) { $0.didGet(entities: $1) }
            .disposed(by: disposeBag)
    }
}

private extension WatchlistViewModel {
    
    func didGet(entities: [WatchlistModel.Entity]) {
        withAnimation {
            model.accept(entities: entities)
        }
    }
    
    func didFailToFetchEntities(error: Error) {
        withAnimation {
            model.changeState(to: .failed(error.asAppError))
        }
    }
}

private extension WatchlistViewModel {
    
    func handleRefresh() async {
        disposeBag = DisposeBag()
        let assetsIDs = Array(favoritesService.getAllFavoriteIDs())
        let entitiesRequest = fetchEntities(assetsIDs: assetsIDs).delay(.seconds(1), scheduler: MainScheduler.instance)
        guard let entities = try? await entitiesRequest.value else { return }
        
        model.accept(entities: entities)
    }
    
    func handleRetry() {
        withAnimation {
            model.changeState(to: .loading)
        }
        loadContets()
    }
}

private extension WatchlistViewModel {
    
    func observeFavorites() {
        favoritesService.favoritesPublisher
            .dropFirst() // Ignore initial value
            .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.getEntities()
            }
            .store(in: &cancelBag)
    }
}

extension WatchlistViewModel: WatchlistViewInput {
    
    func bind(output: any WatchlistViewOutput) {
        self.output = output
    }
    
    func loadContets() {
        guard model.state.isLoaded.isFalse else { return }
        
        disposeBag = DisposeBag()
        model.reset()
        getEntities()
    }
}
