//
//  NetworkError.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 24.11.2025.
//

import Alamofire
import Foundation
import Moya

extension AppErrorType {
    
    enum Network: AppError {
        
        case noConnection
        case timeout
        case serverError(statusCode: Int)
        case requestFailed(Error)
        
        init?(from error: Error) {
            guard let moyaError = error as? MoyaError else { return nil }
            
            switch moyaError {
            case let .underlying(underlyingError as NSError, _):
                guard
                    let afError = underlyingError as? AFError,
                    case let .sessionTaskFailed(sessionError) = afError,
                    let urlError = sessionError as? URLError
                else {
                    return nil
                }
                
                self = switch urlError.code {
                case .notConnectedToInternet, .networkConnectionLost: .noConnection
                case .timedOut: .timeout
                default: .requestFailed(urlError)
                }
                
            case let .statusCode(response):
                self = .serverError(statusCode: response.statusCode)
                
            default:
                return nil
            }
        }
    }
}

extension AppErrorType.Network {
    
    var errorType: String { "NetworkError.\(self)" }
    
    var title: String {
        switch self {
        case .noConnection: "No Internet Connection"
        case .timeout: "Request Timed Out"
        case .serverError: "Server Error"
        case .requestFailed: "Network Error"
        }
    }
    
    var message: String {
        switch self {
        case .noConnection: "Please check your internet connection and try again."
        case .timeout: "The request took too long. Please try again."
        case let .serverError(code): "The server returned an error (Code: \(code)). Please try again later."
        case .requestFailed: "Failed to connect to the server. Please try again."
        }
    }
    
    var recoveryAction: String? {
        switch self {
        case .noConnection: "Check connection and retry"
        case .timeout: "Try again"
        case .serverError: "Try again later"
        case .requestFailed: "Try again"
        }
    }
    
    var isRecoverable: Bool {
        true // All network errors are recoverable
    }
    
    var underlyingError: (any Error)? {
        if case let .requestFailed(error) = self {
            return error
        }
        return nil
    }
    
    func matches(_ other: any AppError) -> Bool {
        guard let other = other as? Self else { return false }
        
        return switch (self, other) {
        case (.noConnection, .noConnection),
             (.timeout, .timeout): true
        case let (.serverError(lhsCode), .serverError(rhsCode)): lhsCode == rhsCode
        case (.requestFailed, .requestFailed):  true // Compare by type only
        default: false
        }
    }
}
