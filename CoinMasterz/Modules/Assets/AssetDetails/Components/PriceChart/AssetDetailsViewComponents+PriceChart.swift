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
        
        @State private var selectedDate: Date?
        let priceChart: AssetDetailsModel.PriceChart
        
        init(selectedDate: Date? = nil,
             priceChart: AssetDetailsModel.PriceChart) {
            self.selectedDate = selectedDate
            self.priceChart = priceChart
        }
        
        var body: some View {
            Chart(priceChart.pricesData) { priceData in
                LineMark(
                    x: .value("Date", priceData.date),
                    y: .value("Price", priceData.price)
                )
                .foregroundStyle(priceChart.color)
                
                AreaMark(
                    x: .value("Date", priceData.date),
                    yStart: .value("Baseline", (priceChart.minPrice * 0.995)),
                    yEnd: .value("Price", priceData.price)
                )
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [priceChart.color.opacity(0.3), priceChart.color.opacity(0.05)]),
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
                                    Text(selectedDate, format: .dateTime.hour().minute())
                                        .font(.caption)
                                        .foregroundStyle(Color(uiColor: .secondaryLabel))
                                    
                                    Text(NumberFormatter.priceFormat(selectedPrice))
                                        .font(.headline)
                                        .foregroundStyle(priceChart.color)
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
            .chartYScale(domain: (priceChart.minPrice * 0.995)...(priceChart.maxPrice * 1.005))
            .chartXSelection(value: $selectedDate)
            .chartXAxis {
                AxisMarks(values: .automatic) { value in
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.hour().minute())
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
            // Find the closest data point to the selected date
            priceChart.pricesData
                .min(by: { abs($0.date.timeIntervalSince(date)) < abs($1.date.timeIntervalSince(date)) })?
                .price
        }
    }
}
