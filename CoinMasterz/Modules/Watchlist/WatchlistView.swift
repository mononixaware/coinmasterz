//
//  WatchlistView.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import Combine

enum WatchlistViewSteps {
    
    case assetSelected(assetID: String)
}

protocol WatchlistViewOutput: AnyObject {
    
    var steps: PassthroughSubject<WatchlistViewSteps, Never> { get }
}

protocol WatchlistViewInput {
    
    func bind(output: WatchlistViewOutput)
    func loadContets()
}

protocol WatchlistView: Presentable, WatchlistViewOutput {
    
    var viewModel: WatchlistViewInput! { get set }
}
