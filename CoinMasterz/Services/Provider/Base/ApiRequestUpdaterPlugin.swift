//
//  ApiRequestUpdaterPlugin.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import Alamofire
import Foundation
import Moya

final class ApiRequestUpdaterPlugin: PluginType {
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard let target = target as? ApiRequest else { return request }
        
        var request = request
        request.cachePolicy = target.cachePolicy
        request.httpShouldHandleCookies = target.handleCookies
        request.timeoutInterval = target.timeout
        
        return request
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        guard let target = target as? ApiRequest else { return }
        
        switch result {
        case let .success(response):
            var status: String {
                switch response.statusCode {
                case 200...299: "🟢"
                case 300...399: "🟡"
                default: "🔴"
                }
            }
            
            var elapsed: String {
                if let began = target.began {
                    let ended = CFAbsoluteTimeGetCurrent()
                    return "⏱ \(Int((ended - began) * 1000))"
                }
                return ""
            }
            
            var parameters: String {
                let query = response.request?.url?.query ?? .empty
                let body = response.request?.httpBody?.utf8String ?? .empty
                return [query, body].joined(.space)
            }
            
            trace(target.method.rawValue,
                  target.path,
                  status,
                  response.statusCode,
                  elapsed,
                  parameters,
                  file: "ApiRequest",
                  function: "receive")
            
        case let .failure(error):
            trace(target.method.rawValue,
                  target.path,
                  "⛔️",
                  error.localizedDescription,
                  file: "ApiRequest",
                  function: "receive")
        }
    }
}
