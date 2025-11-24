//
//  AssetsViewModel.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import Combine
import Foundation
import RxSwift
import SwiftUI

final class AssetsViewModel: ObservableObject {
    
    @Published private(set) var model: AssetsModel
    @Published var searchQuery: String = ""
    
    private weak var output: AssetsViewOutput?
    private let coinCapProvider: CoinCapProvider
    private let favoritesService: FavoritesService
    private var disposeBag = DisposeBag()
    private var cancelBag = CancelBag()
    
    init(coinCapProvider: CoinCapProvider,
         favoritesService: FavoritesService,
         model: AssetsModel) {
        self.coinCapProvider = coinCapProvider
        self.favoritesService = favoritesService
        self.model = model
        
        setupSearchDebouncing()
        observeFavorites()
    }
    
    func select(entity: AssetsModel.Entity) { output?.steps.send(.assetSelected(assetID: entity.id)) }
    
    func toggleFavorite(entityID: String) { favoritesService.toggleFavorite(assetID: entityID) }
    
    func getMoreAssets() { handleGetMoreAssets() }
    
    func refresh() async { await handleRefresh() }
    
    func retry() { handleRetry() }
}

private extension AssetsViewModel {
    
    func fetchEntities() -> Single<[AssetsModel.Entity]> {
        let search = searchQuery.nonEmpty
        let limit = AssetsModel.defaultEntitiesCount
        let offset = model.displayEntities.count
        
        return Single.zip(
            coinCapProvider.getAssets(search: search, ids: nil, limit: limit, offset: offset),
            Single.just(favoritesService.getAllFavoriteIDs())
        )
        .map(AssetsModel.builder.makeEntities)
        .onError(with: self) { $0.didFailToFetchEntities(error: $1) }
        .traceError()
    }
    
    func getEntities(loadMore: Bool) {
        if loadMore {
            model.changeLoadMoreState(to: .loading)
        }
        
        fetchEntities()
            .subscribe(on: MainScheduler.instance)
            .weak(self) { $0.didGet(entities: $1, loadMore: loadMore) }
            .disposed(by: disposeBag)
    }
}

private extension AssetsViewModel {
    
    func didGet(entities: [AssetsModel.Entity], loadMore: Bool) {
        withAnimation {
            if loadMore {
                model.append(newEntities: entities)
            } else {
                model.accept(entities: entities)
            }
        }
    }
    
    func didFailToFetchEntities(error: Error) {
        withAnimation {
            model.changeState(to: .failed(error.asAppError))
        }
    }
}

private extension AssetsViewModel {
    
    func handleGetMoreAssets() {
        guard model.state.isLoaded && model.loadMoreState.isLoaded else { return }
        
        getEntities(loadMore: true)
    }
    
    func handleSearchQueryChanged(_ query: String) {
        disposeBag = DisposeBag()
        model.resetForSearch()
        getEntities(loadMore: false)
    }
    
    func handleRefresh() async {
        disposeBag = DisposeBag()
        let entitiesRequest = fetchEntities().delay(.seconds(1), scheduler: MainScheduler.instance)
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

private extension AssetsViewModel {
    
    func setupSearchDebouncing() {
        $searchQuery
            .dropFirst() // Ignore initial empty value
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.handleSearchQueryChanged(query)
            }
            .store(in: &cancelBag)
    }
    
    func observeFavorites() {
        favoritesService.favoritesPublisher
            .sink { [weak self] favoriteIDs in
                self?.model.updateEntities(favoriteIDs: favoriteIDs)
            }
            .store(in: &cancelBag)
    }
}

extension AssetsViewModel: AssetsViewInput {
    
    func bind(output: any AssetsViewOutput) {
        self.output = output
    }
    
    func loadContets() {
        guard model.state.isLoaded.isFalse else { return }
        
        disposeBag = DisposeBag()
        model.reset()
        getEntities(loadMore: false)
    }
    
    func selectSort() {
        output?.steps.send(.sortSelected(selected: model.sortKind, selectCompletion: { [weak self] sortKind in
            withAnimation {
                self?.model.changeSortKind(to: sortKind)
            }
        }))
    }
}
