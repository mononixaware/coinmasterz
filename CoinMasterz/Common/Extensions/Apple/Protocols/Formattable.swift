//
//  Formattable+Extensions.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import Foundation

public protocol Formattable {
    
    func format(fraction: Int) -> String
}

public extension Formattable {
    
    var format0: String {
        format(fraction: 0)
    }
    
    var format1: String {
        format(fraction: 1)
    }
    
    var format2: String {
        format(fraction: 2)
    }
    
    var format3: String {
        format(fraction: 3)
    }
}

extension Double: Formattable {
    
    public func format(fraction: Int) -> String {
        String(format: "%.\(fraction)lf", self)
    }
}
