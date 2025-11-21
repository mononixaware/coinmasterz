//
//  AssetsModel.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

struct AssetsModel {
    
    private(set) var contenxt: Context
    private(set) var entities: [Entity]
    
    init(contenxt: Context = .loading,
         entities: [Entity] = []) {
        self.contenxt = contenxt
        self.entities = entities
    }
    
    enum Context {
        
        case loading, loaded, empty
    }
    
    struct Entity: Identifiable {
        
        let id: String
        let name: String
    }
}

extension AssetsModel {
    
    static let builder = AssetsModelBuilder.self
}

extension AssetsModel {
    
    mutating func changeContext(to state: Context) {
        self.contenxt = state
    }
    
    mutating func accept(entities: [Entity]) {
        self.entities = entities
        changeContext(to: entities.isEmpty ? .empty : .loaded)
    }
}

// MARK: Builder

enum AssetsModelBuilder {
    
    nonisolated static func makeEntities(assets: [CoinCap.Asset]) -> [AssetsModel.Entity] {
        assets.map { asset in
            AssetsModel.Entity(
                id: asset.id,
                name: asset.name
            )
        }
    }
}
