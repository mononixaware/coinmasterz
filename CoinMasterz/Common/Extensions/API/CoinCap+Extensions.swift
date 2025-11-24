//
//  CoinCap+Extensions.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 24.11.2025.
//

import SwiftUI

// MARK: Asset

extension CoinCap.Asset {
    
    var relativeChangeDisplayValue: String {
        changePercent24Hr
            .flatMap { Double($0) }
            .flatMap { $0.format2.appending("%") }
            .orJust("0.00%")
    }
    
    var changeColor: Color {
        changePercent24Hr
            .flatMap { Double($0) }
            .flatMap {
                switch $0 {
                case ..<0: Color.red
                case 0: Color(uiColor: .secondaryLabel)
                default: Color.green
                }
            }
            .orJust(Color(uiColor: .secondaryLabel))
    }
}
