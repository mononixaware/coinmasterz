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
    
    func sorted<Key: Comparable>(by keyPath: (Element) -> Key,
                                 _ comparator: (Key, Key) -> Bool = { $0 < $1 }) -> [Element] {
        sorted { comparator(keyPath($0), keyPath($1)) }
    }
}
