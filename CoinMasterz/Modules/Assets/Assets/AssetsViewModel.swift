//
//  AssetsViewModel.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import Combine
import Foundation
import RxSwift

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
        .traceError()
    }
    
    func getEntities(loadMore: Bool) {
        if loadMore {
            model.changeLoadMoreContext(to: .loading)
        }
        
        fetchEntities()
            .subscribe(on: MainScheduler.instance)
            .weak(self) {
                if loadMore {
                    $0.model.append(newEntities: $1)
                } else {
                    $0.model.accept(entities: $1)
                }
            }
            .disposed(by: disposeBag)
    }
}

private extension AssetsViewModel {
    
    func handleGetMoreAssets() {
        guard model.context == .loaded && model.loadMoreContext == .loaded else { return }
        
        getEntities(loadMore: true)
    }
    
    func handleSearchQueryChanged(_ query: String) {
        disposeBag = DisposeBag()
        model.resetForSearch()
        getEntities(loadMore: false)
    }
    
    func handleRefresh() async {
        disposeBag = DisposeBag()
        let entities = try? await fetchEntities().value
        model.accept(entities: entities ?? [])
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
        guard model.context != .loaded else { return }
        
        disposeBag = DisposeBag()
        model.reset()
        getEntities(loadMore: false)
    }
    
    func selectSort() {
        output?.steps.send(.sortSelected(selected: model.sortKind, selectCompletion: { [weak self] sortKind in
            self?.model.changeSortKind(to: sortKind)
        }))
    }
}
