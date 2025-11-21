//
//  CancelBag.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 22.11.2025.
//

import Combine

typealias CancelBag = Set<AnyCancellable>

extension CancelBag {
    
    mutating func cancelAll() {
        forEach { $0.cancel() }
        removeAll()
    }
}
