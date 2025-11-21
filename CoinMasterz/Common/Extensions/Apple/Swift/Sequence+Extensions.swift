//
//  Sequence+Extensions.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

public extension Sequence {
    
    func compactMap<T>(_ type: T.Type) -> [T] {
        compactMap { $0 as? T }
    }
}
