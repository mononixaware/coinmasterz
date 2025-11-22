//
//  AssetsViewModel.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import Combine
import RxSwift

final class AssetsViewModel: ObservableObject {
    
    @Published private(set) var model: AssetsModel
    
    private weak var output: AssetsViewOutput?
    private let coinCapProvider: CoinCapProvider
    private var disposeBag = DisposeBag()
    
    init(coinCapProvider: CoinCapProvider,
         model: AssetsModel) {
        self.coinCapProvider = coinCapProvider
        self.model = model
    }
    
    func getMoreAssets() { handleGetMoreAssets() }
}

private extension AssetsViewModel {
    
    func getAssets(loadMore: Bool) {
        if loadMore {
            model.changeLoadMoreContext(to: .loading)
        }
        
        let limit = AssetsModel.defaultEntitiesCount
        let offset = model.displayEntities.count
        
        coinCapProvider.getAssets(search: nil, ids: nil, limit: limit, offset: offset)
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
