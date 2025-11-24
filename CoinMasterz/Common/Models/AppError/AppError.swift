//
//  AppError.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 24.11.2025.
//

/// Protocol that all app errors must conform to
/// Provides structured error information with user-facing messages
protocol AppError: Error, Sendable {
    
    /// Technical error type for logging
    var errorType: String { get }
    
    /// User-friendly title
    var title: String { get }
    
    /// User-friendly description
    var message: String { get }
    
    /// Suggested recovery action message (if any)
    var recoveryAction: String? { get }
    
    /// Whether this error is recoverable (can retry)
    var isRecoverable: Bool { get }
    
    /// The underlying error (if wrapping a system error)
    var underlyingError: (any Error)? { get }
    
    /// Check if this error matches another
    func matches(_ other: any AppError) -> Bool
}

// MARK: - Default Implementations

extension AppError {
    
    var recoveryAction: String? { nil }
    var isRecoverable: Bool { true }
    var underlyingError: (any Error)? { nil }
}

// MARK: - Convenience Extensions

extension Error {
    
    /// Convert any Error to AppErrorType
    var asAppError: AppErrorType {
        AppErrorType.from(self)
    }
}
