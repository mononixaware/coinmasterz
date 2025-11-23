//
//  AssetDetailsView.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 23.11.2025.
//

protocol AssetDetailsViewOutput: AnyObject {
    
}

protocol AssetDetailsViewInput {
    
    func bind(output: AssetDetailsViewOutput)
    func loadContets()
}

protocol AssetDetailsView: Presentable, AssetDetailsViewOutput {
    
    var viewModel: AssetDetailsViewInput! { get set }
}
