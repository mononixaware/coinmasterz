//
//  WatchlistView.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import UIKit
import SwiftUI

protocol WatchlistViewOutput: AnyObject {
    
}

protocol WatchlistViewInput {
    
    func bind(output: WatchlistViewOutput)
}

protocol WatchlistView: Presentable, WatchlistViewOutput {
    
    var viewModel: WatchlistViewInput! { get set }
}
