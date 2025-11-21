//
//  FloatingPoint+Extensions.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

public extension FloatingPoint {
    
    @inlinable
    var nonZero: Self? {
        self != 0 ? self : nil
    }
}
