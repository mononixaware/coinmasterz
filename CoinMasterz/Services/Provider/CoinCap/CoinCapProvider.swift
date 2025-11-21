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
    
    func getAssets() -> Single<[CoinCap.Asset]>
}

final class DefaultCoinCapProvider: ApiProvider, CoinCapProvider {
    
    // MARK: Assets
    
    func getAssets() -> Single<[CoinCap.Asset]> {
        request {
            .coinCap
            .get("/assets")
        }
        .map([CoinCap.Asset].self, atKeyPath: "data")
    }
}
