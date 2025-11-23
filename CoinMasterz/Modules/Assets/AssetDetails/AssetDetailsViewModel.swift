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
    
    func selectPriceChartInterval(_ interval: AssetDetailsModel.PriceChart.Interval) { handlePriceChartIntervalSelection(interval) }
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
        let interval: CoinCap.AssetHistoryInterval = switch model.priceChart.selectedInterval.kind {
        case .oneDay: .fifteenMinutes
        case .oneWeek: .oneHour
        case .oneMonth: .sixHours
        case .threeMonths: .oneDay
        }
        let days = switch model.priceChart.selectedInterval.kind {
        case .oneDay: 1
        case .oneWeek: 7
        case .oneMonth: 30
        case .threeMonths: 90
        }
        let start = Date.now.addingDays(days * -1)?.milliseconds
        let end = Date.now.milliseconds
        
        coinCapProvider.getAssetHistory(slug: assetID, interval: interval, start: start, end: end)
            .map(AssetDetailsModel.builder.makePriceChartData)
            .subscribe(on: MainScheduler.instance)
            .weak(self) { $0.model.acceptPriceChart(data: $1) }
            .traceError()
            .disposed(by: disposeBag)
    }
}

private extension AssetDetailsViewModel {
    
    func handlePriceChartIntervalSelection(_ interval: AssetDetailsModel.PriceChart.Interval) {
        guard model.priceChart.selectedInterval.kind != interval.kind else { return }
        
        disposeBag = DisposeBag()
        model.selectPriceChart(interval: interval)
        model.changePriceChartContext(to: .loading)
        getPriceChart(assetID: model.assetID)
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
