//
//  AssetDetailsModel+PriceChart.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 23.11.2025.
//

import SwiftUI

extension AssetDetailsModel {
    
    struct PriceChart {
        
        private(set) var state: State
        private(set) var selectedInterval: Interval
        let intervals: [Interval]
        
        typealias State = ViewState<Data, AppErrorType>
        
        struct Data {
            
            let prices: [Price]
            let minPriceValue: Double
            let maxPriceValue: Double
            let color: Color
            let dateFormatStyle: Date.FormatStyle
            let metrics: Metrics
            
            struct Price: Identifiable {
                
                let id: Int
                let date: Date
                let value: Double
            }
            
            struct Metrics {
                
                let high: String
                let low: String
                let changeValue: String
                let changeAbsoluteValue: String
                let changeColor: Color
            }
        }
        
        struct Interval: Identifiable, Hashable {
            
            let id: Int
            let kind: Kind
            let title: String
            
            enum Kind: CaseIterable {
                
                case oneDay, oneWeek, oneMonth, threeMonths
            }
        }
    }
}

// MARK: Extensions

extension AssetDetailsModel.PriceChart {
    
    static let initial = Self.init(
        state: .loading,
        selectedInterval: .oneDay,
        intervals: AssetDetailsModel.builder.makeInitialIntervals()
    )
    
    var data: Data? {
        state.content
    }
}

extension AssetDetailsModel.PriceChart {
    
    mutating func changeState(to newState: State) {
        self.state = newState
    }
    
    mutating func accept(data: Data?) {
        if let data {
            self.state = .loaded(data)
        } else {
            self.state = .empty
        }
    }
    
    mutating func select(interval: Interval) {
        self.selectedInterval = interval
    }
}

extension AssetDetailsModel.PriceChart.Interval {
    
    static let oneDay = Self.init(id: 0, kind: .oneDay, title: "1D")
}

// MARK: Builder

extension AssetDetailsModelBuilder {
    
    static func makePriceChartData(prices: [CoinCap.HistoryPrice]) -> AssetDetailsModel.PriceChart.Data {
        let prices = prices.compactMap { price in
            Double(price.priceUsd).flatMap {
                AssetDetailsModel.PriceChart.Data.Price(
                    id: price.time,
                    date: Date(milliseconds: price.time),
                    value: $0
                )
            }
        }
        let priceValues = prices.map(\.value)
        
        let startPriceValue = priceValues.first.orZero
        let endPriceValue = priceValues.last.orZero
        let color = switch startPriceValue {
        case let value where value < endPriceValue: Color.green
        case let value where value == endPriceValue: Color(uiColor: .label)
        default: Color.red
        }
        
        let minPriceValue = priceValues.min().orZero
        let maxPriceValue = priceValues.max().orZero
        
        let changeValue = ((maxPriceValue - minPriceValue) / minPriceValue * 100).format2.appending("%")
        let changeAbsoluteValue = NumberFormatter.priceFormat((maxPriceValue - minPriceValue))
        
        let dates = prices.map(\.date)
        let startDate = dates.first.orJust(.now)
        let endDate = dates.last.orJust(.now)
        let dateFormatStyle: Date.FormatStyle = switch endDate.timeIntervalSince(startDate) {
        case 0...604_800: .dateTime.day().hour().minute()
        default: .dateTime.day().month()
        }
        
        let metrics = AssetDetailsModel.PriceChart.Data.Metrics(
            high: NumberFormatter.priceFormat(maxPriceValue),
            low: NumberFormatter.priceFormat(minPriceValue),
            changeValue: changeValue,
            changeAbsoluteValue: changeAbsoluteValue,
            changeColor: color
        )
        
        return AssetDetailsModel.PriceChart.Data(
            prices: prices,
            minPriceValue: minPriceValue,
            maxPriceValue: maxPriceValue,
            color: color,
            dateFormatStyle: dateFormatStyle,
            metrics: metrics
        )
    }
}

private extension AssetDetailsModelBuilder {
    
    static func makeInitialIntervals() -> [AssetDetailsModel.PriceChart.Interval] {
        let title = { (intervalKind: AssetDetailsModel.PriceChart.Interval.Kind) in
            switch intervalKind {
            case .oneDay: "1D"
            case .oneWeek: "1W"
            case .oneMonth: "1M"
            case .threeMonths: "3M"
            }
        }
        return AssetDetailsModel.PriceChart.Interval.Kind.allCases.enumerated().map { offset, intervalKind in
            AssetDetailsModel.PriceChart.Interval(
                id: offset,
                kind: intervalKind,
                title: title(intervalKind),
            )
        }
    }
}
