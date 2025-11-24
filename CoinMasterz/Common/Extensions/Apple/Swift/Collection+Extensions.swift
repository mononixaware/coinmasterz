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

// MARK: RandomAccessCollection

public extension RandomAccessCollection where Self: MutableCollection {
    
    mutating func mutate(_ mutation: (inout Element) -> Void) {
        indices.forEach { mutation(&self[$0]) }
    }
}
