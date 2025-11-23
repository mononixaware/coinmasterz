//
//  AssetDetailsViewController.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 23.11.2025.
//

import Combine
import SwiftUI

final class AssetDetailsViewController: BaseHostingController<AssetDetailsViewUI>, AssetDetailsView {
    
    var viewModel: AssetDetailsViewInput!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.loadContets()
    }
}

struct AssetDetailsViewUI: View {
    
    @ObservedObject private var viewModel: AssetDetailsViewModel
    
    init(viewModel: AssetDetailsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                if let details = viewModel.model.details {
                    AssetDetailsViewComponents.Details(details: details)
                        .padding(16)
                }
                
                Spacer()
            }
        }
        .navigationTitle(viewModel.model.details.flatMap(\.symbol).orEmpty)
    }
}
