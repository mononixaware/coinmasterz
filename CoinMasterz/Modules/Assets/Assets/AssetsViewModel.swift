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
        
        getAssets()
    }
}

private extension AssetsViewModel {
    
    func getAssets() {
        coinCapProvider.getAssets()
            .map(AssetsModel.builder.makeEntities)
            .subscribe(on: MainScheduler.instance)
            .weak(self) { $0.model.accept(entities: $1) }
            .traceError()
            .disposed(by: disposeBag)
    }
}

extension AssetsViewModel: AssetsViewInput {
    
    func bind(output: any AssetsViewOutput) {
        self.output = output
    }
    
    func selectSort() {
        output?.steps.send(.sortSelected(selected: model.sortKind, selectCompletion: { [weak self] sortKind in
            self?.model.changeSortKind(to: sortKind)
        }))
    }
}
