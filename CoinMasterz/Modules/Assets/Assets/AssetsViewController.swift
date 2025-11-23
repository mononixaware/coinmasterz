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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.loadContets()
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
        Group {
            switch viewModel.model.context {
            case .loading:
                ProgressView("Loading assets...")
            case .loaded:
                assetsListContent
            case .empty:
                emptyStateView
            }
        }
        .searchable(
            text: $viewModel.searchQuery,
            placement: .navigationBarDrawer(displayMode: .automatic),
            prompt: "Search by name or symbol"
        )
        .scrollDismissesKeyboard(.interactively)
        .refreshable(action: viewModel.refresh)
    }
}

private extension AssetsViewUI {
    
    var assetsListContent: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 16.0) {
                ForEach(viewModel.model.displayEntities) { entity in
                    AssetsViewComponents.Entity(entity: entity)
                    
                    Divider()
                        .padding(.leading, 60)
                }
                
                if viewModel.model.context == .loaded && viewModel.model.loadMoreContext == .loaded {
                    ProgressView()
                        .opacity(viewModel.model.loadMoreContext == .loading ? 1.0 : 0.0)
                        .padding()
                        .onAppear {
                            viewModel.getMoreAssets()
                        }
                }
            }
            .padding(16)
        }
    }
    
    private var emptyStateView: some View {
        ContentUnavailableView {
            Label("No Assets Found", systemImage: "magnifyingglass")
        } description: {
            if viewModel.searchQuery.isEmpty {
                Text("Unable to load cryptocurrency assets.")
            } else {
                Text("No results for '\(viewModel.searchQuery)'")
            }
        } actions: {
            if viewModel.searchQuery.isNotEmpty {
                Button("Clear Search") {
                    viewModel.searchQuery = ""
                }
                .buttonStyle(.bordered)
            }
        }
    }
}
