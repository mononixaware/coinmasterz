//
//  AssetDetailsModel+Details.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 23.11.2025.
//

import SwiftUI

extension AssetDetailsModel {
    
    struct Details {
        
        let initials: String
        let symbol: String
        let name: String
        let rank: String
        let price: String
        let change: String
        let changeColor: Color
        let marketCap: String
        let supply: String
        let maxSupply: String?
        let volumeDay: String
        let vwapDay: String?
    }
}

// MARK: Builder

extension AssetDetailsModelBuilder {
    
    static func makeDetails(asset: CoinCap.Asset) -> AssetDetailsModel.Details {
        let initials = String(asset.name.initials.prefix(2))
        let rank = asset.rank.flatMap({ "#" + $0 }).orEmpty
        let price = NumberFormatter.priceFormat(Double(asset.priceUsd).orZero)
        let marketCap = NumberFormatter.bigNumberFormat(Double(asset.marketCapUsd).orZero).appending(" USD")
        let supply = NumberFormatter.bigNumberFormat(Double(asset.supply).orZero)
        let maxSupply = asset.maxSupply.flatMap { NumberFormatter.bigNumberFormat(Double($0).orZero) }
        let volumeDay = NumberFormatter.bigNumberFormat(Double(asset.volumeUsd24Hr).orZero).appending(" USD")
        let vwapDay = asset.vwap24Hr.flatMap { NumberFormatter.priceFormat(Double($0).orZero) }
        
        return AssetDetailsModel.Details(
            initials: initials,
            symbol: asset.symbol,
            name: asset.name,
            rank: rank,
            price: price,
            change: asset.relativeChangeDisplayValue,
            changeColor: asset.changeColor,
            marketCap: marketCap,
            supply: supply,
            maxSupply: maxSupply,
            volumeDay: volumeDay,
            vwapDay: vwapDay
        )
    }
}
