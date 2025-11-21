//
//  AssetsViewController.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import Combine
import SwiftUI

final class AssetsViewController: BaseHostingController<AssetsViewUI>, AssetsView {
    
    var steps = PassthroughSubject<AssetsViewSteps, Never>()
    var viewModel: AssetsViewInput!
    
    override func setupNavigation() {
        super.setupNavigation()
        navigationItem.title = "Assets"
        setupNavigationBarButtons()
    }
}

private extension AssetsViewController {
    
    func setupNavigationBarButtons() {
        let sortButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.up.arrow.down"),
            style: .plain,
            target: self,
            action: #selector(sortButtonTapped)
        )
        navigationItem.rightBarButtonItem = sortButton
    }
    
    @objc func sortButtonTapped() {
        viewModel.selectSort()
    }
}

struct AssetsViewUI: View {
    
    @ObservedObject private var viewModel: AssetsViewModel
    
    init(viewModel: AssetsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 16.0) {
                ForEach(viewModel.model.displayEntities) { entity in
                    AssetsViewComponents.Entity(entity: entity)
                    
                    Divider()
                        .padding(.leading, 60)
                }
            }
            .padding(16)
        }
    }
}
