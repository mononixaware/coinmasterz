//
//  Date+Extensions.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import Foundation

public extension Date {
    
    var seconds: Int {
        Int(timeIntervalSince1970)
    }
    
    var milliseconds: Int {
        Int(timeIntervalSince1970 * 1000)
    }
    
    static var seconds: Int {
        Date().seconds
    }
    
    static var milliseconds: Int {
        Date().milliseconds
    }
    
    init(seconds: Int) {
        self.init(timeIntervalSince1970: TimeInterval(seconds))
    }
    
    init(milliseconds: Int) {
        self.init(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    
    func string(format dateFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.calendar = .gregorian
        formatter.dateFormat = dateFormat
        return formatter.string(from: self)
    }
    
    func addingDays(_ days: Int) -> Date? {
        Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)
    }
}
