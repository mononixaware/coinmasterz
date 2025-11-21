//
//  CoinCap.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

enum CoinCap {
    
    struct Asset: Decodable {
        
        let id: String
        let rank: String?
        let symbol: String
        let name: String
        let supply: String
        let maxSupply: String?
        let marketCapUsd: String
        let volumeUsd24Hr: String
        let priceUsd: String
        let changePercent24Hr: String?
        let vwap24Hr: String?
        let explore: String?
    }
}
