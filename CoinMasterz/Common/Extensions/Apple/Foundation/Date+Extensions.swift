//
//  Date+Extensions.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import Foundation

public extension Date {
    
    func string(format dateFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.calendar = .gregorian
        formatter.dateFormat = dateFormat
        return formatter.string(from: self)
    }
}
