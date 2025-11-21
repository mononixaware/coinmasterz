//
//  Data+Extensions.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import Foundation

extension Data {
    
    public var utf8String: String? {
        String(data: self, encoding: .utf8)
    }
}
