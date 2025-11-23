//
//  AssetDetailsViewComponents+PriceChart.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 23.11.2025.
//

import Charts
import SwiftUI

extension AssetDetailsViewComponents {
    
    // MARK: PriceChart
    
    struct PriceChart: View {
        
        let priceChart: AssetDetailsModel.PriceChart
        let intervalSelectAction: Callback<AssetDetailsModel.PriceChart.Interval>
        
        var body: some View {
            VStack(alignment: .leading, spacing: 16.0) {
                if let data = priceChart.data {
                    VStack(spacing: 12.0) {
                        ChartComponent(data: data)
                        
                        IntervalSelection(
                            intervals: priceChart.intervals,
                            selectedInterval: priceChart.selectedInterval,
                            selectAction: intervalSelectAction
                        )
                        .padding(.horizontal, 64)
                    }
                
                Metrics(metrics: data.metrics)
                    .padding(.horizontal, 16)
                }
            }
        }
    }
}

private extension AssetDetailsViewComponents {
    
    // MARK: ChartComponent
    
    struct ChartComponent: View {
        
        @State private var selectedDate: Date? = nil
        let data: AssetDetailsModel.PriceChart.Data
        
        var body: some View {
            Chart(data.prices) { price in
                LineMark(
                    x: .value("Date", price.date),
                    y: .value("Price", price.value)
                )
                .foregroundStyle(data.color)
                
                AreaMark(
                    x: .value("Date", price.date),
                    yStart: .value("Baseline", (data.minPriceValue * 0.99)),
                    yEnd: .value("Price", price.value)
                )
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [data.color.opacity(0.3), data.color.opacity(0.05)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
                if let selectedDate {
                    RuleMark(x: .value("Selected", selectedDate))
                        .foregroundStyle(Color(uiColor: .secondarySystemFill).opacity(0.5))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))
                        .annotation(position: .top, spacing: 0) {
                            if let selectedPrice = findPrice(for: selectedDate) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(selectedDate, format: data.dateFormatStyle)
                                        .font(.caption)
                                        .foregroundStyle(Color(uiColor: .secondaryLabel))
                                    
                                    Text(NumberFormatter.priceFormat(selectedPrice))
                                        .font(.headline)
                                        .foregroundStyle(data.color)
                                }
                                .padding(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .strokeBorder(Color(uiColor: .systemFill), lineWidth: 0.5)
                                )
                                .background {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(uiColor: .systemBackground))
                                        .shadow(
                                            color: Color(uiColor: .systemBackground).opacity(0.1),
                                            radius: 4,
                                            x: 0,
                                            y: 2
                                        )
                                }
                            }
                        }
                }
            }
            .chartYScale(domain: (data.minPriceValue * 0.99)...(data.maxPriceValue * 1.01))
            .chartXSelection(value: $selectedDate)
            .chartXAxis {
                AxisMarks(values: .automatic) { value in
                    AxisGridLine()
                    AxisValueLabel(format: data.dateFormatStyle)
                }
            }
            .chartYAxis {
                AxisMarks(position: .trailing) { value in
                    AxisGridLine()
                    AxisValueLabel {
                        if let price = value.as(Double.self) {
                            Text(NumberFormatter.priceFormat(price))
                        }
                    }
                }
            }
        }
        
        private func findPrice(for date: Date) -> Double? {
            data.prices
                .min(by: { abs($0.date.timeIntervalSince(date)) < abs($1.date.timeIntervalSince(date)) })?
                .value
        }
    }
    
    // MARK: IntervalSelection
    
    struct IntervalSelection: View {
        
        let intervals: [AssetDetailsModel.PriceChart.Interval]
        let selectedInterval: AssetDetailsModel.PriceChart.Interval
        let selectAction: Callback<AssetDetailsModel.PriceChart.Interval>?
        
        var body: some View {
            Picker("Interval", selection: Binding(get: { selectedInterval }, set: { selectAction?($0) })) {
                ForEach(intervals) { interval in
                    Text(interval.title).tag(interval)
                }
            }
            .pickerStyle(.segmented)
        }
    }
    
    // MARK: Metrics
    
    struct Metrics: View {
        
        let metrics: AssetDetailsModel.PriceChart.Data.Metrics
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8.0) {
                HStack(alignment: .top, spacing: 8.0) {
                    Text(metrics.high)
                        .font(.body)
                        .foregroundStyle(Color(uiColor: .label))
                    
                    Text("High")
                        .font(.body)
                        .foregroundStyle(Color(uiColor: .secondaryLabel))
                }
                
                HStack(alignment: .top, spacing: 8.0) {
                    Text(metrics.low)
                        .font(.body)
                        .foregroundStyle(Color(uiColor: .label))
                    
                    Text("Low")
                        .font(.body)
                        .foregroundStyle(Color(uiColor: .secondaryLabel))
                }
                
                HStack(alignment: .top, spacing: 8.0) {
                    Text(metrics.changeValue)
                        .font(.body)
                        .foregroundStyle(metrics.changeColor)
                    
                    Text("Period Change")
                        .font(.body)
                        .foregroundStyle(Color(uiColor: .secondaryLabel))
                }
                
                HStack(alignment: .top, spacing: 8.0) {
                    Text(metrics.changeAbsoluteValue)
                        .font(.body)
                        .foregroundStyle(metrics.changeColor)
                    
                    Text("Period Absolute Change")
                        .font(.body)
                        .foregroundStyle(Color(uiColor: .secondaryLabel))
                }
            }
        }
    }
}
