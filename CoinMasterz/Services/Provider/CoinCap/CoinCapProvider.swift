//
//  CoinCapProvider.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import RxMoya
import RxSwift

protocol CoinCapProvider {
    
    // MARK: Assets
    
    /// Fetches a list of cryptocurrency assets.
    ///
    /// - Parameters:
    ///   - search: Search by asset slug (e.g., "bitcoin") or symbol (e.g., "BTC"). Optional.
    ///   - ids: Comma-separated list of asset ids (e.g., "bitcoin,ethereum"). Optional.
    ///   - limit: Number of results to return. Default is 100 if not specified. Optional.
    ///   - offset: Number of results to skip for pagination. Default is 0 if not specified. Optional.
    /// - Returns: A `Single` that emits an array of `CoinCap.Asset` objects on success.
    func getAssets(search: String?, ids: String?, limit: Int?, offset: Int?) -> Single<[CoinCap.Asset]>
    
    /// Fetches a single cryptocurrency asset by its identifier.
    ///
    /// - Parameter slug: The unique identifier for the asset (e.g., "bitcoin", "ethereum").
    /// - Returns: A `Single` that emits a `CoinCap.Asset` object on success.
    func getAsset(slug: String) -> Single<CoinCap.Asset>
}

final class DefaultCoinCapProvider: ApiProvider, CoinCapProvider {
    
    // MARK: Assets
    
    func getAssets(search: String?, ids: String?, limit: Int?, offset: Int?) -> Single<[CoinCap.Asset]> {
        struct QueryParameters: Encodable {
            
            let search: String?
            let ids: String?
            let limit: Int?
            let offset: Int?
        }
        return request {
            .coinCap
            .get("/assets")
            .query(QueryParameters(
                search: search,
                ids: ids,
                limit: limit,
                offset: offset
            ))
        }
        .map([CoinCap.Asset].self, atKeyPath: "data")
    }
    
    func getAsset(slug: String) -> Single<CoinCap.Asset> {
        request {
            .coinCap
            .get("/assets/\(slug)")
        }
        .map(CoinCap.Asset.self, atKeyPath: "data")
    }
}
