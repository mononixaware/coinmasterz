//
//  AssetsSortView.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 22.11.2025.
//

import Combine

enum AssetsSortViewSteps {
    
    case selected(AssetsSortModel.Kind)
}

protocol AssetsSortViewOutput: AnyObject {
    
    var steps: PassthroughSubject<AssetsSortViewSteps, Never> { get }
}

protocol AssetsSortViewInput {
    
    func bind(output: AssetsSortViewOutput)
}

protocol AssetsSortView: Presentable, AssetsSortViewOutput {
    
    var viewModel: AssetsSortViewInput! { get set }
}
