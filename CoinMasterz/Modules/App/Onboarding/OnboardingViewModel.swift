//
//  OnboardingViewModel.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 24.11.2025.
//

import Combine

final class OnboardingViewModel: ObservableObject {
    
    @Published private(set) var model: OnboardingModel
    
    private weak var output: OnboardingViewOutput?
    private let userDefaults: UserDefaultsService
    
    init(userDefaults: UserDefaultsService,
         model: OnboardingModel) {
        self.userDefaults = userDefaults
        self.model = model
    }
    
    func finish() {
        userDefaults.completeOnboarding()
        output?.steps.send(.finish)
    }
}

extension OnboardingViewModel: OnboardingViewInput {
    
    func bind(output: any OnboardingViewOutput) {
        self.output = output
    }
}
