//
//  Configuration.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import Foundation

enum Configuration {
    
    enum Error: Swift.Error {
        
        case missingKey
        case invalidValue
    }
    
    // MARK: - CoinCap API Configuration
    
    static var coinCapBaseURL: URL {
        get throws {
            guard let urlString = Bundle.main.infoDictionary?["COINCAP_BASE_URL"] as? String else {
                throw Error.missingKey
            }
            
            guard let url = URL(string: urlString) else {
                throw Error.invalidValue
            }
            
            return url
        }
    }
    
    static var coinCapAuthBearerKey: String {
        get throws {
            guard let key = Bundle.main.infoDictionary?["COINCAP_AUTHORIZATION_BEARER_KEY"] as? String else {
                throw Error.missingKey
            }
            return key
        }
    }
    
    static var coinCapBearerToken: String {
        get throws {
            guard let token = Bundle.main.infoDictionary?["COINCAP_BEARER_TOKEN"] as? String else {
                throw Error.missingKey
            }
            return token
        }
    }
}
