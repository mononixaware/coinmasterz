//
//  ApiProvider.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import Moya
import RxMoya
import RxSwift

class ApiProvider {
    
    private let provider = MoyaProvider<ApiRequest>(plugins: [ApiRequestUpdaterPlugin()])
    
    func request(_ buildTarget: () -> ApiRequest) -> Single<Response> {
        let target = buildTarget().begin()
        return self.provider.rx.request(target)
            .traceError()
    }
}
