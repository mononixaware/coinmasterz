//
//  AssetsView.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import Combine

enum AssetsViewSteps {
    
    case sortSelected(selected: AssetsModel.SortKind, selectCompletion: Callback<AssetsModel.SortKind>?)
}

protocol AssetsViewOutput: AnyObject {
    
    var steps: PassthroughSubject<AssetsViewSteps, Never> { get }
}

protocol AssetsViewInput {
    
    func bind(output: AssetsViewOutput)
    func loadContets()
    func selectSort()
}

protocol AssetsView: Presentable, AssetsViewOutput {
    
    var viewModel: AssetsViewInput! { get set }
}
