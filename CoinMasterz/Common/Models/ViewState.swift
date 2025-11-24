//
//  ViewState.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 24.11.2025.
//

import Foundation

/// A unified, generic state representation for any view or component
/// Usage: ViewState<MyDataType, MyErrorType>
enum ViewState<Content, Failure: AppError> {
    
    /// Initial loading state - no data yet
    case loading
    
    /// Successfully loaded with content
    case loaded(Content)
    
    /// No data available (empty result)
    case empty
    
    /// Failed to load with a specific error
    case failed(Failure)
}

// MARK: - Extensions

extension ViewState {
    
    /// Computed property to check if currently loading
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
    
    /// Computed property to check if loaded with content
    var isLoaded: Bool {
        if case .loaded = self { return true }
        return false
    }
    
    /// Computed property to check if empty
    var isEmpty: Bool {
        if case .empty = self { return true }
        return false
    }
    
    /// Computed property to check if failed
    var isFailed: Bool {
        if case .failed = self { return true }
        return false
    }
    
    /// Extract the content if available
    var content: Content? {
        if case .loaded(let content) = self { return content }
        return nil
    }
    
    /// Extract the error if available
    var error: Failure? {
        if case .failed(let error) = self { return error }
        return nil
    }
}

// MARK: - Equatable Conformance

extension ViewState: Equatable where Content: Equatable, Failure: Equatable {
    
    static func == (lhs: ViewState<Content, Failure>, rhs: ViewState<Content, Failure>) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.loaded(let lhsContent), .loaded(let rhsContent)):
            return lhsContent == rhsContent
        case (.empty, .empty):
            return true
        case (.failed(let lhsError), .failed(let rhsError)):
            return lhsError == rhsError
        default:
            return false
        }
    }
}

// MARK: - Map Transform

extension ViewState {
    
    /// Transform the content while preserving the state
    func map<NewContent>(_ transform: (Content) throws -> NewContent) rethrows -> ViewState<NewContent, Failure> {
        switch self {
        case .loading:
            return .loading
        case .loaded(let content):
            return .loaded(try transform(content))
        case .empty:
            return .empty
        case .failed(let error):
            return .failed(error)
        }
    }
}

// MARK: - Simple ViewState (for non-generic content)

/// Simple ViewState without generic content - useful for operations without data
typealias SimpleViewState = ViewState<Void, AppErrorType>

extension SimpleViewState {
    
    /// Convenience for loaded state without content
    static var success: SimpleViewState {
        .loaded(())
    }
}
