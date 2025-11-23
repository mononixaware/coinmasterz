//
//  AssetDetailsViewModel.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 23.11.2025.
//

import Combine
import RxSwift

final class AssetDetailsViewModel: ObservableObject {
    
    @Published private(set) var model: AssetDetailsModel
    
    private weak var output: AssetDetailsViewOutput?
    private let coinCapProvider: CoinCapProvider
    private var disposeBag = DisposeBag()
    
    init(coinCapProvider: CoinCapProvider,
         model: AssetDetailsModel) {
        self.coinCapProvider = coinCapProvider
        self.model = model
    }
}

private extension AssetDetailsViewModel {
    
    func fetchDetails(assetID: String) {
        coinCapProvider.getAsset(slug: assetID)
            .map(AssetDetailsModel.builder.makeDetails)
            .subscribe(on: MainScheduler.instance)
            .weak(self) { $0.model.accept(details: $1) }
            .traceError()
            .disposed(by: disposeBag)
    }
}

extension AssetDetailsViewModel: AssetDetailsViewInput {
    
    func bind(output: any AssetDetailsViewOutput) {
        self.output = output
    }
    
    func loadContets() {
        fetchDetails(assetID: model.assetID)
    }
}
