//
//  NumberFormatter.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import Foundation

extension NumberFormatter {
    
    static let integer: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.usesSignificantDigits = false
        return formatter
    }()
    
    static let twoDigits: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = .enUs
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    static let threeDigits: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = .enUs
        formatter.minimumFractionDigits = 3
        formatter.maximumFractionDigits = 3
        return formatter
    }()
    
    static let fourDigits: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = .enUs
        formatter.minimumFractionDigits = 4
        formatter.maximumFractionDigits = 4
        return formatter
    }()
    
    static let scientific: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.positiveFormat = "0.###E+0"
        formatter.exponentSymbol = "e"
        return formatter
    }()
    
    static let twoSignificantDigits: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = .enUs
        formatter.minimumSignificantDigits = 2
        formatter.maximumSignificantDigits = 2
        return formatter
    }()
    
    static func priceFormat(_ price: Double) -> String {
        if price == 0 {
            return "0"
        }
        
        if price < 0.0000001 {
            return scientific.string(for: price).orEmpty
        }
        
        if price <= 0.01 {
            return twoSignificantDigits.string(for: price).orEmpty
        }
        
        return switch NumberFormatter.integer.string(for: price).orEmpty.count {
        case 1: NumberFormatter.fourDigits.string(for: price).orEmpty
        case 2: NumberFormatter.threeDigits.string(for: price).orEmpty
        default: NumberFormatter.twoDigits.string(for: price).orEmpty
        }
    }
}
