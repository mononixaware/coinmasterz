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
    
    struct Entity: Identifiable {
        
        let id: String
        let initials: String
        let symbol: String
        let name: String
        let price: String
        let changePercentDynamics: Dynamics
        
        struct Dynamics {
            
            let value: String
            let color: Color
        }
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

// MARK: Dynamics

extension WatchlistModel.Entity.Dynamics {
    
    static let zero = WatchlistModel.Entity.Dynamics(
        value: "0.00%",
        color: Color(uiColor: .secondaryLabel)
    )
}

// MARK: Builder

enum WatchlistModelBuilder {
    
    static func makeEntities(assets: [CoinCap.Asset]) -> [WatchlistModel.Entity] {
        assets.map { asset in
            let initials = String(asset.name.initials.prefix(2))
            let price = NumberFormatter.priceFormat(Double(asset.priceUsd).orZero)
            let changePercentDynamics = asset.changePercent24Hr.flatMap(makeEntityDynamics).orJust(.zero)
            
            return WatchlistModel.Entity(
                id: asset.id,
                initials: initials,
                symbol: asset.symbol,
                name: asset.name,
                price: price,
                changePercentDynamics: changePercentDynamics
            )
        }
    }
    
    static func makeEntityDynamics(value: String) -> WatchlistModel.Entity.Dynamics {
        guard let value = Double(value) else { return .zero }
        
        let color: Color = switch value {
        case ..<0: .red
        case 0: Color(uiColor: .secondaryLabel)
        default: .green
        }
        
        return WatchlistModel.Entity.Dynamics(
            value: value.format2.appending("%"),
            color: color
        )
    }
}
