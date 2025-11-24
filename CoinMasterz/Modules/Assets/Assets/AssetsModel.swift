//
//  AssetsModel.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import SwiftUI

struct AssetsModel {
    
    private(set) var state: State
    private(set) var loadMoreState: State
    private(set) var sortKind: SortKind
    
    init(state: State = .loading,
         loadMoreState: State = .loaded([]),
         sortKind: SortKind = .default,
         searchQuery: String = .empty) {
        self.state = state
        self.loadMoreState = loadMoreState
        self.sortKind = sortKind
    }
    
    typealias State = ViewState<[Entity], AppErrorType>
    
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
        let priceValue: Double
        let priceDisplayValue: String
        let changeDynamics: Dynamics
        let marketCap: Double
        private(set) var isFavorite: Bool
        
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
    
    var entities: [Entity] {
        state.content ?? []
    }
    
    var displayEntities: [Entity] {
        switch sortKind {
        case .default: entities
        case .marketCapDescending: entities.sorted(by: \.marketCap, >)
        case .marketCapAscending: entities.sorted(by: \.marketCap, <)
        case .priceDescending: entities.sorted(by: \.price, >)
        case .priceAscending: entities.sorted(by: \.price, <)
        case .changePercentDescending: entities.sorted(by: \.changeDynamics.value, >)
        case .changePercentAscending: entities.sorted(by: \.changeDynamics.value, <)
        }
    }
}

extension AssetsModel {
    
    mutating func changeState(to newState: State) {
        self.state = newState
    }
    
    mutating func changeLoadMoreState(to newState: State) {
        self.loadMoreState = newState
    }
    
    mutating func changeSortKind(to kind: SortKind) {
        self.sortKind = kind
    }
    
    mutating func accept(entities: [Entity]) {
        if entities.isEmpty {
            self.state = .empty
        } else {
            self.state = .loaded(entities)
        }
    }
    
    mutating func append(newEntities: [Entity]) {
        let currentEntities = self.entities
        let updatedEntities = currentEntities + newEntities
        self.state = .loaded(updatedEntities)
        
        if newEntities.count < Self.defaultEntitiesCount {
            self.loadMoreState = .empty
        } else {
            self.loadMoreState = .loaded([])
        }
    }
    
    mutating func updateEntities(favoriteIDs: Set<String>) {
        guard case var .loaded(currentEntities) = state else { return }
        
        currentEntities.mutate { entity in
            let isFavorite = favoriteIDs.contains(entity.id)
            entity.update(favoriteStatus: isFavorite)
        }
        
        self.state = .loaded(currentEntities)
    }
    
    mutating func toggleEntityFavoriteStatus(entityID: String) {
        guard case var .loaded(currentEntities) = state else { return }
        
        if let index = currentEntities.firstIndex(where: { $0.id == entityID }) {
            currentEntities[index].toggleFavoriteStatus()
            self.state = .loaded(currentEntities)
        }
    }
    
    mutating func reset() {
        self = Self.init()
    }
    
    mutating func resetForSearch() {
        self.state = .loading
        self.loadMoreState = .loaded([])
    }
}

// MARK: Entity

extension AssetsModel.Entity: AssetEntityRepresentable {
    
    var price: String {
        priceDisplayValue
    }
    
    var change: String {
        changeDynamics.displayValue
    }
    
    var changeColor: Color {
        changeDynamics.color
    }
}

extension AssetsModel.Entity {
    
    mutating func update(favoriteStatus: Bool) {
        self.isFavorite = favoriteStatus
    }
    
    mutating func toggleFavoriteStatus() {
        self.isFavorite.toggle()
    }
}

// MARK: Dynamics

extension AssetsModel.Entity.Dynamics {
    
    static let zero = AssetsModel.Entity.Dynamics(
        value: 0,
        displayValue: "0.00%",
        color: Color(uiColor: .secondaryLabel)
    )
}

// MARK: Builder

enum AssetsModelBuilder {
    
    static func makeEntities(assets: [CoinCap.Asset], favoriteIDs: Set<String>) -> [AssetsModel.Entity] {
        assets.map { asset in
            let initials = String(asset.name.initials.prefix(2))
            let price = Double(asset.priceUsd).orZero
            let priceDisplayValue = NumberFormatter.priceFormat(price)
            let changeDynamics = AssetsModel.Entity.Dynamics(
                value: asset.changePercent24Hr.flatMap({ Double($0) }).orZero,
                displayValue: asset.relativeChangeDisplayValue,
                color: asset.changeColor
            )
            let marketCap = Double(asset.marketCapUsd).orZero
            let isFavorite = favoriteIDs.contains(asset.id)
            
            return AssetsModel.Entity(
                id: asset.id,
                initials: initials,
                symbol: asset.symbol,
                name: asset.name,
                priceValue: price,
                priceDisplayValue: priceDisplayValue,
                changeDynamics: changeDynamics,
                marketCap: marketCap,
                isFavorite: isFavorite
            )
        }
    }
}
