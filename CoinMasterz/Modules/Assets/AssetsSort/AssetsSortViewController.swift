//
//  AssetsSortViewController.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 22.11.2025.
//

import Combine
import SwiftUI

final class AssetsSortViewController: BaseHostingController<AssetsSortViewUI>, AssetsSortView {
    
    var steps = PassthroughSubject<AssetsSortViewSteps, Never>()
    var viewModel: AssetsSortViewInput!
    
    override func setupNavigation() {
        super.setupNavigation()
        navigationItem.title = "Sort"
    }
}

struct AssetsSortViewUI: View {
    
    @ObservedObject private var viewModel: AssetsSortViewModel
    
    init(viewModel: AssetsSortViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 12.0) {
                ForEach(viewModel.model.entities) { entity in
                    Button {
                        viewModel.select(kind: entity.kind)
                    } label: {
                        HStack(spacing: 0.0) {
                            Text(entity.title)
                                .font(.body)
                                .foregroundStyle(Color(uiColor: .label))
                                .lineLimit(1)
                            
                            Spacer(minLength: 0.0)
                            
                            if viewModel.model.selectedKind == entity.kind {
                                Spacer(minLength: 24.0)
                                
                                Image(systemName: "checkmark")
                                    .font(.headline)
                                    .foregroundStyle(Color(uiColor: .label))
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    
                    Divider()
                }
            }
            .padding(16)
        }
    }
}
