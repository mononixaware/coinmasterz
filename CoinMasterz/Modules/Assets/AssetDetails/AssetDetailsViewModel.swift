//
//  AssetDetailsViewModel.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 23.11.2025.
//

import Combine
import Foundation
import RxSwift
import SwiftUI

final class AssetDetailsViewModel: ObservableObject {
    
    @Published private(set) var model: AssetDetailsModel
    
    private weak var output: AssetDetailsViewOutput?
    private let coinCapProvider: CoinCapProvider
    private let favoritesService: FavoritesService
    private var disposeBag = DisposeBag()
    private var cancelBag = CancelBag()
    
    init(coinCapProvider: CoinCapProvider,
         favoritesService: FavoritesService,
         model: AssetDetailsModel) {
        self.coinCapProvider = coinCapProvider
        self.favoritesService = favoritesService
        self.model = model
        
        observeFavoriteStatus()
    }
    
    func selectPriceChartInterval(_ interval: AssetDetailsModel.PriceChart.Interval) { handlePriceChartIntervalSelection(interval) }
    
    func retryPriceChart() { handleRetryPriceChart() }
    
    func retry() { handleRetry() }
}

private extension AssetDetailsViewModel {
    
    func getDetails(assetID: String) {
        coinCapProvider.getAsset(slug: assetID)
            .map(AssetDetailsModel.builder.makeDetails)
            .subscribe(on: MainScheduler.instance)
            .weak(self) { $0.didGet(details: $1) }
            .onError(with: self) { $0.didFailToGethDetails(error: $1) }
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
            .weak(self) { $0.didGet(priceChartData: $1) }
            .onError(with: self) { $0.didFailToGetPriceChartData(error: $1) }
            .traceError()
            .disposed(by: disposeBag)
    }
}

private extension AssetDetailsViewModel {
    
    func didGet(details: AssetDetailsModel.Details) {
        output?.updateNavigation(title: details.symbol)
        withAnimation {
            model.accept(details: details)
        }
        getPriceChart(assetID: model.assetID)
    }
    
    func didFailToGethDetails(error: Error) {
        withAnimation {
            model.changeState(to: .failed(error.asAppError))
        }
    }
    
    func didGet(priceChartData: AssetDetailsModel.PriceChart.Data) {
        withAnimation {
            model.acceptPriceChart(data: priceChartData)
        }
    }
    
    func didFailToGetPriceChartData(error: Error) {
        withAnimation {
            model.changePriceChartState(to: .failed(error.asAppError))
        }
    }
}

private extension AssetDetailsViewModel {
    
    func handlePriceChartIntervalSelection(_ interval: AssetDetailsModel.PriceChart.Interval) {
        guard model.state.isLoaded,
              model.priceChart.selectedInterval.kind != interval.kind else { return }
        
        disposeBag = DisposeBag()
        model.selectPriceChart(interval: interval)
        getPriceChart(assetID: model.assetID)
    }
    
    func handleRetryPriceChart() {
        withAnimation {
            model.changePriceChartState(to: .loading)
        }
        getPriceChart(assetID: model.assetID)
    }
    
    func handleRetry() {
        withAnimation {
            model.changeState(to: .loading)
        }
        loadContets()
    }
}

private extension AssetDetailsViewModel {
    
    func observeFavoriteStatus() {
        favoritesService.favoritesPublisher
            .map { [weak self] favoriteIDs -> Bool in
                self.flatMap({ favoriteIDs.contains($0.model.assetID) }).orJust(false)
            }
            .sink { [weak self] isFavorite in
                self?.model.updateFavorite(status: isFavorite)
                self?.output?.updateFavorite(status: isFavorite)
            }
            .store(in: &cancelBag)
    }
}

extension AssetDetailsViewModel: AssetDetailsViewInput {
    
    func bind(output: any AssetDetailsViewOutput) {
        self.output = output
    }
    
    func loadContets() {
        getDetails(assetID: model.assetID)
        output?.updateFavorite(status: model.isFavorite)
    }
    
    func toggleFavorite() {
        favoritesService.toggleFavorite(assetID: model.assetID)
    }
}
