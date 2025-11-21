//
//  AssetsView.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import UIKit
import SwiftUI

protocol AssetsViewOutput: AnyObject {
    
}

protocol AssetsViewInput {
    
    func bind(output: AssetsViewOutput)
}

protocol AssetsView: Presentable, AssetsViewOutput {
    
    var viewModel: AssetsViewInput! { get set }
}
