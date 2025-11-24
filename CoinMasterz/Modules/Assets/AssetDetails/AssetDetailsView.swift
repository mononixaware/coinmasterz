//
//  AssetDetailsView.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 23.11.2025.
//

protocol AssetDetailsViewOutput: AnyObject {
    
    func updateNavigation(title: String)
    func updateFavorite(status: Bool)
}

protocol AssetDetailsViewInput {
    
    func bind(output: AssetDetailsViewOutput)
    func loadContets()
    func toggleFavorite()
}

protocol AssetDetailsView: Presentable, AssetDetailsViewOutput {
    
    var viewModel: AssetDetailsViewInput! { get set }
}
