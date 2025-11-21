//
//  AssetsSortModel.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 22.11.2025.
//

struct AssetsSortModel {
    
    let selectedKind: Kind
    let entities: [Entity]
    
    init(selectedKind: Kind) {
        self.selectedKind = selectedKind
        self.entities = Self.builder.makeEntities(sortKinds: AssetsSortModel.Kind.allCases)
    }
    
    typealias Kind = AssetsModel.SortKind
    
    struct Entity: Identifiable {
        
        let id: Int
        let kind: Kind
        let title: String
    }
}

// MARK: Extensions

extension AssetsSortModel {
    
    static let builder = AssetsSortModelBuilder.self
}


// MARK: Kind

extension AssetsSortModel.Kind {
    
    static let allCases: [Self] = [.default, .marketCapDescending, .marketCapAscending, .priceDescending,
                                   .priceAscending, .changePercentDescending, .changePercentAscending]
}

// MARK: Builder

enum AssetsSortModelBuilder {
    
    static func makeEntities(sortKinds: [AssetsModel.SortKind]) -> [AssetsSortModel.Entity] {
        sortKinds.enumerated().map { offset, sortKind in
            AssetsSortModel.Entity(
                id: offset,
                kind: sortKind,
                title: makeSortKindTitle(sortKind: sortKind)
            )
        }
    }
}

private extension AssetsSortModelBuilder {
    
    static func makeSortKindTitle(sortKind: AssetsModel.SortKind) -> String {
        switch sortKind {
        case .default: "Default"
        case .marketCapDescending: "Market Cap (High to Low)"
        case .marketCapAscending: "Market Cap (Low to High)"
        case .priceDescending: "Price (High to Low)"
        case .priceAscending: "Price (Low to High)"
        case .changePercentDescending: "Change (%) (High to Low)"
        case .changePercentAscending: "Change (%) (Low to High)"
        }
    }
}
