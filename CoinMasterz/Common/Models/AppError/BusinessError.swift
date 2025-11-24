//
//  BusinessError.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 24.11.2025.
//

extension AppErrorType {
    
    enum Business: AppError {
        
        case serviceUnavailable
    }
}

extension AppErrorType.Business {
    
    var errorType: String { "BusinessError.\(self)" }
    
    var title: String {
        switch self {
        case .serviceUnavailable: "Service Unavailable"
        }
    }
    
    var message: String {
        switch self {
        case .serviceUnavailable: "The service is temporarily unavailable. Please try again later."
        }
    }
    
    var recoveryAction: String? {
        switch self {
        case .serviceUnavailable: "Try again later"
        }
    }
    
    var isRecoverable: Bool {
        switch self {
        case .serviceUnavailable: true
        }
    }
    
    func matches(_ other: any AppError) -> Bool {
        guard let other = other as? Self else { return false }
        
        return switch (self, other) {
        case (.serviceUnavailable, .serviceUnavailable): true
        default: false
        }
    }
}
