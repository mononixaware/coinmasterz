//
//  OnboardingView.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 24.11.2025.
//

import Combine

enum OnboardingViewSteps {
    
    case finish
}

protocol OnboardingViewOutput: AnyObject {
    
    var steps: PassthroughSubject<OnboardingViewSteps, Never> { get }
}

protocol OnboardingViewInput {
    
    func bind(output: OnboardingViewOutput)
}

protocol OnboardingView: Presentable, OnboardingViewOutput {
    
    var viewModel: OnboardingViewInput! { get set }
}
