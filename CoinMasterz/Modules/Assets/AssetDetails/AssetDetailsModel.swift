//
//  AssetDetailsModel.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 23.11.2025.
//

struct AssetDetailsModel {
    
    let assetID: String
    private(set) var details: Details?
    private(set) var priceChart: PriceChart?
    
    init(assetID: String,
         details: Details? = nil,
         priceChart: PriceChart? = nil) {
        self.assetID = assetID
        self.details = details
        self.priceChart = priceChart
    }
}

// MARK: Extensions

extension AssetDetailsModel {
    
    static let builder = AssetDetailsModelBuilder.self
}

extension AssetDetailsModel {
    
    mutating func accept(details: Details?) {
        self.details = details
    }
    
    mutating func accept(priceChart: PriceChart?) {
        self.priceChart = priceChart
    }
}

// MARK: Builder

enum AssetDetailsModelBuilder {
    
}
