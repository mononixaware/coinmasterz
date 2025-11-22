//
//  Encodable+Extensions.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 22.11.2025.
//

import Foundation

extension Encodable {
    
    public func jsonData() throws -> Data {
        try JSONEncoder().encode(self)
    }
    
    public func jsonObject() throws -> Any {
        try JSONSerialization.jsonObject(with: jsonData(), options: .allowFragments)
    }
    
    public func jsonDictionary() -> [String: Any]? {
        try? jsonObject() as? [String: Any]
    }
    
    public func jsonString() -> String? {
        (try? jsonData()).flatMap {
            String(data: $0, encoding: .utf8)
        }
    }
}
