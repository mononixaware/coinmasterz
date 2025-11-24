//
//  DataError.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 24.11.2025.
//

extension AppErrorType {
    
    enum Data: AppError {
        
        case parsingFailed
        case invalidData
        case missingRequiredField(String)
        case dataCorrupted
    }
}

extension AppErrorType.Data {
    
    var errorType: String { "DataError.\(self)" }
    
    var title: String {
        switch self {
        case .parsingFailed:  "Data Error"
        case .invalidData:  "Invalid Data"
        case .missingRequiredField:  "Incomplete Data"
        case .dataCorrupted:  "Corrupted Data"
        }
    }
    
    var message: String {
        switch self {
        case .parsingFailed:  "Unable to process the data received. Please try again."
        case .invalidData:  "The data format is not supported."
        case let .missingRequiredField(field):  "Missing required information: \(field)"
        case .dataCorrupted:  "The data is corrupted and cannot be processed."
        }
    }
    
    var recoveryAction: String? {
        "Try again"
    }
    
    func matches(_ other: any AppError) -> Bool {
        guard let other = other as? Self else { return false }
        
        return switch (self, other) {
        case (.parsingFailed, .parsingFailed),
             (.invalidData, .invalidData),
             (.dataCorrupted, .dataCorrupted): true
        case let (.missingRequiredField(lhsFielD), .missingRequiredField(rhsFielD)): lhsFielD == rhsFielD
        default: false
        }
    }
}
