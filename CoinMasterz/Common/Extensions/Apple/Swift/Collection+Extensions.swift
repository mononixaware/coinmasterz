//
//  Collection+Extensions.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

public extension Collection {
    
    @inline(__always)
    var isNotEmpty: Bool {
        !isEmpty
    }
    
    @inline(__always)
    var nonEmpty: Self? {
        isEmpty ? nil : self
    }
}
