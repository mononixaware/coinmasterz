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
    
    /// Fetches historical price data for a cryptocurrency asset.
    ///
    /// - Parameters:
    ///   - slug: The unique identifier for the asset (e.g., "bitcoin", "ethereum").
    ///   - interval: Time interval for data points. Valid choices: "m1", "m5", "m15", "m30", "h1", "h2", "h6", "h12", "d1".
    ///   - start: UNIX time in milliseconds for the start of the historical data range. Omitting will return the most recent asset history. Optional.
    ///   - end: UNIX time in milliseconds for the end of the historical data range. Optional.
    /// - Returns: A `Single` that emits an array of `CoinCap.HisotryPrice` objects on success.
    func getAssetHistory(slug: String, interval: String, start: Int?, end: Int?) -> Single<[CoinCap.HisotryPrice]>
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
    
    func getAssetHistory(slug: String, interval: String, start: Int?, end: Int?) -> Single<[CoinCap.HisotryPrice]> {
        struct QueryParameters: Encodable {
            
            let interval: String
            let start: Int?
            let end: Int?
        }
        return request {
            .coinCap
            .get("/assets/\(slug)/history")
            .query(QueryParameters(
                interval: interval,
                start: start,
                end: end
            ))
        }
        .map([CoinCap.HisotryPrice].self, atKeyPath: "data")
    }
}
