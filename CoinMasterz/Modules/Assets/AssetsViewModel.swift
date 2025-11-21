//
//  AssetsViewModel.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import Combine

final class AssetsViewModel: ObservableObject {
    
    @Published private(set) var model: AssetsModel
    
    private weak var output: AssetsViewOutput?
    
    init(model: AssetsModel) {
        self.model = model
    }
}

extension AssetsViewModel: AssetsViewInput {
    
    func bind(output: any AssetsViewOutput) {
        self.output = output
    }
}
