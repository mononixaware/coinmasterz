//
//  AssetDetailsViewModel.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 23.11.2025.
//

import Combine
import Foundation
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
    
    func getDetails(assetID: String) {
        coinCapProvider.getAsset(slug: assetID)
            .map(AssetDetailsModel.builder.makeDetails)
            .subscribe(on: MainScheduler.instance)
            .weak(self) { $0.model.accept(details: $1) }
            .traceError()
            .disposed(by: disposeBag)
    }
    
    func getPriceChart(assetID: String) {
        let start = Date.now.addingDays(-1)?.milliseconds
        let end = Date.now.milliseconds
        
        coinCapProvider.getAssetHistory(slug: assetID, interval: "m15", start: start, end: end)
            .map(AssetDetailsModel.builder.makePriceChart)
            .subscribe(on: MainScheduler.instance)
            .weak(self) { $0.model.accept(priceChart: $1) }
            .traceError()
            .disposed(by: disposeBag)
    }
}

extension AssetDetailsViewModel: AssetDetailsViewInput {
    
    func bind(output: any AssetDetailsViewOutput) {
        self.output = output
    }
    
    func loadContets() {
        getDetails(assetID: model.assetID)
        getPriceChart(assetID: model.assetID)
    }
}
