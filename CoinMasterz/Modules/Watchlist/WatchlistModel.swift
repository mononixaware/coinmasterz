//
//  WatchlistModel.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import SwiftUI

struct WatchlistModel {
    
    private(set) var context: Context
    private(set) var entities: [Entity]
    
    init(context: Context = .loading,
         entities: [Entity] = []) {
        self.context = context
        self.entities = entities
    }
    
    enum Context {
        
        case loading, loaded, empty
    }
    
    struct Entity: Identifiable, AssetEntityRepresentable {
        
        let id: String
        let initials: String
        let symbol: String
        let name: String
        let price: String
        let change: String
        let changeColor: Color
    }
}

// MARK: Extensions

extension WatchlistModel {
    
    mutating func changeContext(to state: Context) {
        self.context = state
    }
    
    mutating func accept(entities: [Entity]) {
        self.entities = entities
        changeContext(to: entities.isEmpty ? .empty : .loaded)
    }
    
    mutating func reset() {
        self = Self.init()
    }
}

// MARK: Builder

enum WatchlistModelBuilder {
    
    static func makeEntities(assets: [CoinCap.Asset]) -> [WatchlistModel.Entity] {
        assets.map { asset in
            let initials = String(asset.name.initials.prefix(2))
            let price = NumberFormatter.priceFormat(Double(asset.priceUsd).orZero)
            
            return WatchlistModel.Entity(
                id: asset.id,
                initials: initials,
                symbol: asset.symbol,
                name: asset.name,
                price: price,
                change: asset.relativeChangeDisplayValue,
                changeColor: asset.changeColor
            )
        }
    }
}
