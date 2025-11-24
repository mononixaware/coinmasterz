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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            switch viewModel.model.state {
            case .loading:
                ProgressView("Loading assets...")
            case .loaded:
                assetsListContent
            case .empty:
                emptyStateView
            case let .failed(error):
                ViewStateFailureView(
                    error: error,
                    retrySelectAction: viewModel.retry
                )
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
        List {
            ForEach(viewModel.model.displayEntities) { entity in
                Button {
                    viewModel.select(entity: entity)
                } label: {
                    AssetEntityRow(entity: entity)
                }
                .swipeActions(edge: .leading) {
                    Button {
                        viewModel.toggleFavorite(entityID: entity.id)
                    } label: {
                        Label(
                            entity.isFavorite ? "Delete" : "Favorite",
                            systemImage: entity.isFavorite ? "star.fill" : "star"
                        )
                    }
                    .tint(entity.isFavorite ? .yellow : .gray)
                }
            }
            
            if viewModel.model.state.isLoaded && viewModel.model.loadMoreState.isLoaded {
                ProgressView()
                    .opacity(viewModel.model.loadMoreState.isLoading ? 1.0 : 0.0)
                    .padding()
                    .onAppear {
                        viewModel.getMoreAssets()
                    }
            }
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
