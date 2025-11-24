//
//  UserDefaultsService.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 24.11.2025.
//

import Foundation
import Combine

protocol UserDefaultsService {
    
    /// Check if onboarding has been completed
    var isOnboardingCompleted: Bool { get }
    
    /// Mark onboarding as completed
    func completeOnboarding()
    
    /// Reset onboarding status (useful for testing/debugging)
    func resetOnboarding()
}

final class DefaultUserDefaultsService: UserDefaultsService {
    
    private let userDefaults: UserDefaults
    
    private enum Keys {
        
        static let onboardingCompleted = "com.coinmasterz.app.onboardingCompleted"
    }
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    var isOnboardingCompleted: Bool {
        get {
            userDefaults.bool(forKey: Keys.onboardingCompleted)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.onboardingCompleted)
        }
    }
    
    func completeOnboarding() {
        isOnboardingCompleted = true
    }
    
    func resetOnboarding() {
        isOnboardingCompleted = false
    }
}
