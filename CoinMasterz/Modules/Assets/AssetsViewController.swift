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
    
    @ObservedObject private var viewModel: AssetsViewModel
    
    init(viewModel: AssetsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 12.0) {
                ForEach(viewModel.model.entities) { entity in
                    HStack {
                        Text(entity.id)
                            .font(.headline)
                            .foregroundStyle(.secondary)
                            .padding(4)
                            .background(.tertiary)
                            .clipShape(.capsule)
                        
                        Text(entity.name)
                            .font(.body.bold())
                            .foregroundStyle(.primary)
                        
                        Spacer()
                    }
                    
                    Divider()
                }
            }
            .padding(16)
        }
    }
}
