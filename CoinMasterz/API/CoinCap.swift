//
//  CoinCap.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

enum CoinCap {
    
    // MARK: Decodable
    
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
    
    struct HistoryPrice: Decodable {
        
        let priceUsd: String
        let time: Int
        let date: String
    }
    
    struct Response<T: Decodable>: Decodable {
        
        let timestamp: Int
        let data: T
    }
    
    struct ResponseArray<T: Decodable>: Decodable {
        
        let timestamp: Int
        let data: [T]
    }
    
    // MARK: Codable
    
    enum AssetHistoryInterval: String, Codable {
        
        case oneMinute = "m1"
        case fiveMinutes = "m5"
        case fifteenMinutes = "m15"
        case thirtyMinutes = "m30"
        case oneHour = "h1"
        case twoHours = "h2"
        case sixHours = "h6"
        case twelveHours = "h12"
        case oneDay = "d1"
    }
}
