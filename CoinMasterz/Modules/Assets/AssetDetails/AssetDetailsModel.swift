//
//  AssetDetailsModel.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 23.11.2025.
//

struct AssetDetailsModel {
    
    let assetID: String
    private(set) var details: Details?
    
    init(assetID: String,
         details: Details? = nil) {
        self.assetID = assetID
        self.details = details
    }
}

// MARK: Extensions

extension AssetDetailsModel {
    
    static let builder = AssetDetailsModelBuilder.self
}

extension AssetDetailsModel {
    
    mutating func accept(details: Details) {
        self.details = details
    }
}

// MARK: Builder

enum AssetDetailsModelBuilder {
    
}
