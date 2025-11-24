//
//  AssetDetailsModel.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 23.11.2025.
//

struct AssetDetailsModel {
    
    let assetID: String
    private(set) var isFavorite: Bool
    private(set) var details: Details?
    private(set) var priceChart: PriceChart
    
    init(assetID: String,
         isFavorite: Bool = false,
         details: Details? = nil,
         priceChart: PriceChart = .initial) {
        self.assetID = assetID
        self.isFavorite = isFavorite
        self.details = details
        self.priceChart = priceChart
    }
    
    enum Context {
        
        case loading, loaded, empty
    }
}

// MARK: Extensions

extension AssetDetailsModel {
    
    static let builder = AssetDetailsModelBuilder.self
}

extension AssetDetailsModel {
    
    mutating func updateFavorite(status: Bool) {
        self.isFavorite = status
    }
    
    mutating func accept(details: Details?) {
        self.details = details
    }
    
    mutating func changePriceChartContext(to state: Context) {
        priceChart.changeContext(to: state)
    }
    
    mutating func acceptPriceChart(data: PriceChart.Data?) {
        priceChart.accept(data: data)
    }
    
    mutating func selectPriceChart(interval: PriceChart.Interval) {
        priceChart.select(interval: interval)
    }
}

// MARK: Builder

enum AssetDetailsModelBuilder {
    
}
