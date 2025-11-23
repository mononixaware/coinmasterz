//
//  AssetsModel.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import SwiftUI

struct AssetsModel {
    
    private(set) var context: Context
    private(set) var loadMoreContext: Context
    private(set) var sortKind: SortKind
    private var entities: [Entity]
    
    init(context: Context = .loading,
         loadMoreContext: Context = .loaded,
         sortKind: SortKind = .default,
         entities: [Entity] = [],
         searchQuery: String = .empty) {
        self.context = context
        self.loadMoreContext = loadMoreContext
        self.sortKind = sortKind
        self.entities = entities
    }
    
    enum Context {
        
        case loading, loaded, empty
    }
    
    enum SortKind {
        
        case `default`
        case marketCapDescending, marketCapAscending
        case priceDescending, priceAscending
        case changePercentDescending, changePercentAscending
    }
    
    struct Entity: Identifiable {
        
        let id: String
        let initials: String
        let symbol: String
        let name: String
        let price: Double
        let priceDisplayValue: String
        let changePercentDynamics: Dynamics
        let marketCap: Double
        
        struct Dynamics {
            
            let value: Double
            let displayValue: String
            let color: Color
        }
    }
}

// MARK: Extensions

extension AssetsModel {
    
    static let builder = AssetsModelBuilder.self
    
    static let defaultEntitiesCount = 64
    
    var displayEntities: [Entity] {
        switch sortKind {
        case .default: entities
        case .marketCapDescending: entities.sorted(by: \.marketCap, >)
        case .marketCapAscending: entities.sorted(by: \.marketCap, <)
        case .priceDescending: entities.sorted(by: \.price, >)
        case .priceAscending: entities.sorted(by: \.price, <)
        case .changePercentDescending: entities.sorted(by: \.changePercentDynamics.value, >)
        case .changePercentAscending: entities.sorted(by: \.changePercentDynamics.value, <)
        }
    }
}

extension AssetsModel {
    
    mutating func changeContext(to state: Context) {
        self.context = state
    }
    
    mutating func changeLoadMoreContext(to state: Context) {
        self.loadMoreContext = state
    }
    
    mutating func changeSortKind(to kind: SortKind) {
        self.sortKind = kind
    }
    
    mutating func accept(entities: [Entity]) {
        self.entities = entities
        changeContext(to: entities.isEmpty ? .empty : .loaded)
    }
    
    mutating func append(newEntities: [Entity]) {
        self.entities.append(contentsOf: newEntities)
        changeLoadMoreContext(to: newEntities.count < Self.defaultEntitiesCount ? .empty : .loaded)
    }
    
    mutating func reset() {
        self = Self.init()
    }
    
    mutating func resetForSearch() {
        self.entities = []
        self.context = .loading
        self.loadMoreContext = .loaded
    }
}

// MARK: Dynamics

extension AssetsModel.Entity.Dynamics {
    
    static let zero = AssetsModel.Entity.Dynamics(value: 0, displayValue: "0.00%", color: .secondary)
}

// MARK: Builder

enum AssetsModelBuilder {
    
    static func makeEntities(assets: [CoinCap.Asset]) -> [AssetsModel.Entity] {
        assets.map { asset in
            let initials = String(asset.name.initials.prefix(2))
            let price = Double(asset.priceUsd).orZero
            let priceDisplayValue = NumberFormatter.priceFormat(price)
            let changePercentDynamics = asset.changePercent24Hr.flatMap(makeEntityDynamics).orJust(.zero)
            let marketCap = Double(asset.marketCapUsd).orZero
            
            return AssetsModel.Entity(
                id: asset.id,
                initials: initials,
                symbol: asset.symbol,
                name: asset.name,
                price: price,
                priceDisplayValue: priceDisplayValue,
                changePercentDynamics: changePercentDynamics,
                marketCap: marketCap
            )
        }
    }
    
    static func makeEntityDynamics(value: String) -> AssetsModel.Entity.Dynamics {
        guard let value = Double(value) else { return .zero }
        
        let color: Color = switch value {
        case ..<0: .red
        case 0: .secondary
        default: .green
        }
        
        return AssetsModel.Entity.Dynamics(
            value: value,
            displayValue: value.format2.appending("%"),
            color: color
        )
    }
}
