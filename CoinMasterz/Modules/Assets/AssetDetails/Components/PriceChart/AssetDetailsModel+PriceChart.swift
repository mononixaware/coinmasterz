//
//  AssetDetailsModel+PriceChart.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 23.11.2025.
//

import SwiftUI

extension AssetDetailsModel {
    
    struct PriceChart {
        
        let pricesData: [PriceData]
        let minPrice: Double
        let maxPrice: Double
        let color: Color
        let metrics: Metrics
        
        struct PriceData: Identifiable {
            
            let id: Int
            let date: Date
            let price: Double
        }
        
        struct Metrics {
            
            let high: String
            let low: String
            let changeValue: String
            let changeAbsoluteValue: String
            let changeColor: Color
        }
    }
}

// MARK: Builder

extension AssetDetailsModelBuilder {
    
    static func makePriceChart(prices: [CoinCap.HisotryPrice]) -> AssetDetailsModel.PriceChart {
        let pricesData = prices.compactMap { price in
            Double(price.priceUsd).flatMap {
                AssetDetailsModel.PriceChart.PriceData(
                    id: price.time,
                    date: Date(milliseconds: price.time),
                    price: $0
                )
            }
        }
        let prices = pricesData.map(\.price)
        
        let startPrice = prices.first.orZero
        let endPrice = prices.last.orZero
        let color = switch startPrice {
        case let value where value < endPrice: Color.green
        case let value where value == endPrice: Color(uiColor: .label)
        default: Color.red
        }
        
        let minPrice = prices.min().orZero
        let maxPrice = prices.max().orZero
        
        let changeValue = ((maxPrice - minPrice) / minPrice * 100).format2.appending("%")
        let changeAbsoluteValue = NumberFormatter.priceFormat((maxPrice - minPrice))
        
        let metrics = AssetDetailsModel.PriceChart.Metrics(
            high: NumberFormatter.priceFormat(maxPrice),
            low: NumberFormatter.priceFormat(minPrice),
            changeValue: changeValue,
            changeAbsoluteValue: changeAbsoluteValue,
            changeColor: color
        )
        
        return AssetDetailsModel.PriceChart(
            pricesData: pricesData,
            minPrice: minPrice,
            maxPrice: maxPrice,
            color: color,
            metrics: metrics
        )
    }
}
