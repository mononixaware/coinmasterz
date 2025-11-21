//
//  WatchlistViewModel.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import Combine

final class WatchlistViewModel: ObservableObject {
    
    @Published private(set) var model: WatchlistModel
    
    private weak var output: WatchlistViewOutput?
    
    init(model: WatchlistModel) {
        self.model = model
    }
}

extension WatchlistViewModel: WatchlistViewInput {
    
    func bind(output: any WatchlistViewOutput) {
        self.output = output
    }
}
