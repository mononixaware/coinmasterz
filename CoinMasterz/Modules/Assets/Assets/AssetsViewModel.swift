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
    
    private weak var output: AssetsViewOutput?
    private let coinCapProvider: CoinCapProvider
    private var disposeBag = DisposeBag()
    private var cancelBag = CancelBag()
    
    init(coinCapProvider: CoinCapProvider,
         model: AssetsModel) {
        self.coinCapProvider = coinCapProvider
        self.model = model
        
        setupSearchDebouncing()
    }
    
    func changeSearchQuery(_ query: String) { model.accept(searchQuery: query) }
    
    func getMoreAssets() { handleGetMoreAssets() }
}

private extension AssetsViewModel {
    
    func getAssets(loadMore: Bool) {
        if loadMore {
            model.changeLoadMoreContext(to: .loading)
        }
        
        let search = model.searchQuery.nonEmpty
        let limit = AssetsModel.defaultEntitiesCount
        let offset = model.displayEntities.count
        
        coinCapProvider.getAssets(search: search, ids: nil, limit: limit, offset: offset)
            .map(AssetsModel.builder.makeEntities)
            .subscribe(on: MainScheduler.instance)
            .weak(self) {
                if loadMore {
                    $0.model.append(newEntities: $1)
                } else {
                    $0.model.accept(entities: $1)
                }
            }
            .traceError()
            .disposed(by: disposeBag)
    }
}

private extension AssetsViewModel {
    
    func handleGetMoreAssets() {
        guard model.context == .loaded && model.loadMoreContext == .loaded else { return }
        
        getAssets(loadMore: true)
    }
    
    func handleSearchQueryChanged(_ query: String) {
        disposeBag = DisposeBag()
        model.accept(searchQuery: query)
        model.resetForSearch()
        getAssets(loadMore: false)
    }
}

private extension AssetsViewModel {
    
    func setupSearchDebouncing() {
        $model
            .map(\.searchQuery)
            .dropFirst() // Ignore initial empty value
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.handleSearchQueryChanged(query)
            }
            .store(in: &cancelBag)
    }
}

extension AssetsViewModel: AssetsViewInput {
    
    func bind(output: any AssetsViewOutput) {
        self.output = output
    }
    
    func loadContets() {
        model.reset()
        getAssets(loadMore: false)
    }
    
    func selectSort() {
        output?.steps.send(.sortSelected(selected: model.sortKind, selectCompletion: { [weak self] sortKind in
            self?.model.changeSortKind(to: sortKind)
        }))
    }
}
