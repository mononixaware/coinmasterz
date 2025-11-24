//
//  AssetDetailsModel.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 23.11.2025.
//

struct AssetDetailsModel {
    
    let assetID: String
    private(set) var isFavorite: Bool
    private(set) var state: State
    private(set) var priceChart: PriceChart
    
    init(assetID: String,
         isFavorite: Bool = false,
         state: State = .loading,
         priceChart: PriceChart = .initial) {
        self.assetID = assetID
        self.isFavorite = isFavorite
        self.state = state
        self.priceChart = priceChart
    }
    
    typealias State = ViewState<Details, AppErrorType>
}

// MARK: Extensions

extension AssetDetailsModel {
    
    static let builder = AssetDetailsModelBuilder.self
    
    var details: Details? {
        state.content
    }
}

extension AssetDetailsModel {
    
    mutating func updateFavorite(status: Bool) {
        self.isFavorite = status
    }
    
    mutating func changeState(to newState: State) {
        self.state = newState
    }
    
    mutating func accept(details: Details?) {
        if let details {
            self.state = .loaded(details)
        } else {
            self.state = .empty
        }
    }
    
    mutating func changePriceChartState(to newState: PriceChart.State) {
        priceChart.changeState(to: newState)
    }
    
    mutating func acceptPriceChart(data: PriceChart.Data?) {
        priceChart.accept(data: data)
    }
    
    mutating func selectPriceChart(interval: PriceChart.Interval) {
        priceChart.select(interval: interval)
    }
    
    mutating func reset() {
        self = Self.init(assetID: assetID)
    }
}

// MARK: Builder

enum AssetDetailsModelBuilder {
    
}
