//
//  ApiRequest.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import Alamofire
import Foundation
import Moya

class ApiRequest: TargetType {
    
    private(set) var baseURL: URL
    private(set) var path: String = .empty
    private(set) var method: Moya.Method = .get
    private(set) var task: Moya.Task = .requestPlain
    private(set) var headers: [String : String]?
    
    private(set) var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    private(set) var handleCookies: Bool = true
    private(set) var timeout: TimeInterval = 60
    
    private(set) var began: TimeInterval?
    
    private init(baseUrl: URL) {
        self.baseURL = baseUrl
    }
}

extension ApiRequest {
    
    // MARK: - Set base URL
    
    static func to(_ baseUrl: URL) -> ApiRequest {
        ApiRequest(baseUrl: baseUrl)
    }
    
    static var coinCap: ApiRequest {
        guard let baseURL = try? Configuration.coinCapBaseURL,
              let authKey = try? Configuration.coinCapAuthBearerKey,
              let authToken = try? Configuration.coinCapBearerToken else {
            fatalError("CoinCap base URL not configured properly")
        }
        
        return ApiRequest(baseUrl: baseURL)
            .header(authKey, "Bearer " + authToken)
    }
    
    // MARK: - Set method and path
    
    func delete(_ path: String) -> ApiRequest {
        self.path = path
        self.method = .delete
        return self
    }
    
    /// Set path using GET method.
    func get(_ path: String) -> ApiRequest {
        self.path = path
        self.method = .get
        return self
    }
    
    func patch(_ path: String) -> ApiRequest {
        self.path = path
        self.method = .patch
        return self
    }
    
    func post(_ path: String) -> ApiRequest {
        self.path = path
        self.method = .post
        return self
    }
    
    func put(_ path: String) -> ApiRequest {
        self.path = path
        self.method = .put
        return self
    }
    
    // MARK: - Provide task
    
    func task(_ task: Task) -> ApiRequest {
        self.task = task
        return self
    }
    
    func query(_ parameters: [String: Any]) -> ApiRequest {
        task(.requestParameters(
            parameters: parameters,
            encoding: URLEncoding(
                destination: .queryString,
                arrayEncoding: .noBrackets,
                boolEncoding: .literal
            )
        ))
    }
    
    func query<T: Encodable>(_ encodable: T) -> ApiRequest {
        query(encodable.jsonDictionary() ?? [:])
    }
    
    // MARK: - Add headers
    
    func headers(_ headers: [String: String]) -> ApiRequest {
        self.headers = headers
        return self
    }
    
    func header(_ key: String, _ value: String) -> ApiRequest {
        let header = [key: value]
        self.headers = headers?.merging(header) { old, new in new } ?? header
        return self
    }
    
    // MARK: - Lifetime
    
    /// Set began time to current.
    func begin() -> ApiRequest {
        self.began = CFAbsoluteTimeGetCurrent()
        return self
    }
}
