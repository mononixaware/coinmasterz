//
//  AppErrorType.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 24.11.2025.
//

import Foundation

enum AppErrorType: AppError {
    
    /// Network-related errors
    case network(Network)
    
    /// Data parsing/validation errors
    case data(Data)
    
    /// Business logic errors
    case business(Business)
    
    /// Unknown/unexpected errors
    case unknown(Error)
}

extension AppErrorType {
    
    var errorType: String {
        switch self {
        case .network: "NetworkError"
        case .data: "DataError"
        case .business: "BusinessError"
        case .unknown: "UnknownError"
        }
    }
    
    var title: String {
        switch self {
        case let .network(error): error.title
        case let .data(error): error.title
        case let .business(error): error.title
        case .unknown: "Something Went Wrong"
        }
    }
    
    var message: String {
        switch self {
        case let .network(error): error.message
        case let .data(error): error.message
        case let .business(error): error.message
        case let .unknown(error): error.localizedDescription
        }
    }
    
    var recoveryAction: String? {
        switch self {
        case let .network(error): error.recoveryAction
        case let .data(error): error.recoveryAction
        case let .business(error): error.recoveryAction
        case .unknown: "Try again"
        }
    }
    
    var isRecoverable: Bool {
        switch self {
        case let .network(error): error.isRecoverable
        case let .data(error): error.isRecoverable
        case let .business(error): error.isRecoverable
        case .unknown: true
        }
    }
    
    var underlyingError: (any Error)? {
        switch self {
        case let .network(error): error.underlyingError
        case let .data(error): error.underlyingError
        case let .business(error): error.underlyingError
        case let .unknown(error): error
        }
    }
    
    func matches(_ other: any AppError) -> Bool {
        guard let other = other as? AppErrorType else { return false }
        
        return self.errorType == other.errorType && self.message == other.message
    }
}

// MARK: - Error Mapping from System Errors

extension AppErrorType {
    
    static func from(_ error: Error) -> AppErrorType {
        if let network = Network(from: error) {
            return .network(network)
        }
        
        if let appError = error as? AppErrorType {
            return appError
        }
        
        return .unknown(error)
    }
}
