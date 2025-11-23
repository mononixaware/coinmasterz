//
//  AssetsSortViewModel.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 22.11.2025.
//

import Combine

final class AssetsSortViewModel: ObservableObject {
    
    @Published private(set) var model: AssetsSortModel
    
    private weak var output: AssetsSortViewOutput?
    
    init(model: AssetsSortModel) {
        self.model = model
    }
    
    func select(kind: AssetsSortModel.Kind) { output?.steps.send(.selected(kind)) }
}

extension AssetsSortViewModel: AssetsSortViewInput {
    
    func bind(output: any AssetsSortViewOutput) {
        self.output = output
    }
}
