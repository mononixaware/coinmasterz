//
//  ContentStateView.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 24.11.2025.
//


import SwiftUI

// MARK: - Error State View (Typed)

struct ViewStateFailureView<Failure: AppError>: View {
    
    var error: Failure
    var retrySelectAction: EmptyCallback?
    
    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 24) {
                Image(systemName: errorIcon)
                    .font(.system(size: 64))
                    .foregroundStyle(.orange)
                
                VStack(spacing: 8) {
                    Text(error.title)
                        .font(.title2.weight(.semibold))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color(uiColor: .label))
                    
                    Text(error.message)
                        .font(.subheadline)
                        .foregroundStyle(Color(uiColor: .secondaryLabel))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                
                if error.isRecoverable,
                   let retrySelectAction {
                    Button(action: retrySelectAction) {
                        HStack(spacing: 8) {
                            Text(Image(systemName: "arrow.clockwise"))
                            
                            Text(error.recoveryAction ?? "Try Again")
                        }
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.accentColor)
                        .clipShape(.capsule)
                    }
                }
            }
        }
        .padding()
    }
    
    private var errorIcon: String {
        if let networkError = error as? AppErrorType.Network {
            return switch networkError {
            case .noConnection: "wifi.slash"
            case .timeout: "clock.badge.exclamationmark"
            case .serverError: "server.rack"
            default: "exclamationmark.triangle.fill"
            }
        }
        return "exclamationmark.triangle.fill"
    }
}

// MARK: - Previews

#Preview("Error - Network") {
    ViewStateFailureView(
        error: AppErrorType.Network.noConnection,
        retrySelectAction: {}
    )
}

#Preview("Error - Server") {
    ViewStateFailureView(
        error: AppErrorType.Network.serverError(statusCode: 500),
        retrySelectAction: {}
    )
}

#Preview("Inline Error Banner - Network") {
    ViewStateFailureView(
        error: AppErrorType.Network.timeout,
        retrySelectAction: {}
    )
}

#Preview("Inline Error Banner - Data") {
    ViewStateFailureView(
        error: AppErrorType.Data.parsingFailed,
        retrySelectAction: {}
    )
}
