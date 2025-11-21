//
//  AssetsViewController.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import SwiftUI

final class AssetsViewController: BaseHostingController<AssetsViewUI>, AssetsView {
    
    var viewModel: AssetsViewInput!
    
    override func setupNavigation() {
        super.setupNavigation()
        navigationItem.title = "Assets"
    }
}

struct AssetsViewUI: View {
    
    @ObservedObject private(set) var viewModel: AssetsViewModel
    
    var body: some View {
        Text("Assets View")
    }
}
