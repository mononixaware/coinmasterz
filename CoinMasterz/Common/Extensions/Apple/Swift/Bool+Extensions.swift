//
//  Bool+Extensions.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 22.11.2025.
//

public extension Bool {
    
    @inline(__always)
    var isFalse: Bool {
        !self
    }
}
