//
//  WatchlistModel.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import SwiftUI

struct WatchlistModel {
    
    private(set) var state: State
    
    init(state: State = .loading) {
        self.state = state
    }
    
    typealias State = ViewState<[Entity], AppErrorType>
    
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
    
    var entities: [Entity] {
        state.content.orEmpty
    }
}

extension WatchlistModel {
    
    mutating func changeState(to newState: State) {
        self.state = newState
    }
    
    mutating func accept(entities: [Entity]) {
        if entities.isEmpty {
            self.state = .empty
        } else {
            self.state = .loaded(entities)
        }
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
