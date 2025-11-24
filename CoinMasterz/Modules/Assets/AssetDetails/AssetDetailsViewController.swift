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
    
    private var favoriteButton: UIBarButtonItem?
    
    override func setupNavigation() {
        super.setupNavigation()
        setupNavigationBarButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.loadContets()
    }
    
    func updateNavigation(title: String) {
        navigationItem.title = title
    }
    
    func updateFavorite(status: Bool) {
        favoriteButton?.image = UIImage(systemName: status ? "star.fill" : "star")
        favoriteButton?.tintColor = status ? .yellow : .label
    }
}

private extension AssetDetailsViewController {
    
    func setupNavigationBarButtons() {
        favoriteButton = UIBarButtonItem(
            image: UIImage(systemName: "star"),
            style: .plain,
            target: self,
            action: #selector(favoriteButtonTapped)
        )
        favoriteButton?.tintColor = .label
        navigationItem.rightBarButtonItem = favoriteButton
    }
    
    @objc func favoriteButtonTapped() {
        viewModel.toggleFavorite()
    }
}

struct AssetDetailsViewUI: View {
    
    @ObservedObject private var viewModel: AssetDetailsViewModel
    
    init(viewModel: AssetDetailsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Group {
            switch viewModel.model.state {
            case .loading:
                ProgressView("Loading details...")
            case .loaded:
                detailsContent
            case .empty:
                emptyStateView
            case let .failed(error):
                ViewStateFailureView(
                    error: error,
                    retrySelectAction: viewModel.retry
                )
            }
        }
    }
}

private extension AssetDetailsViewUI {
    
    var detailsContent: some View {
        ScrollView(.vertical) {
            VStack {
                if let details = viewModel.model.details {
                    AssetDetailsViewComponents.Details(details: details)
                        .padding(16)
                }
                
                AssetDetailsViewComponents.PriceChart(
                    priceChart: viewModel.model.priceChart,
                    intervalSelectAction: viewModel.selectPriceChartInterval,
                    retrySelectAction: viewModel.retryPriceChart
                )
            }
        }
    }
    
    private var emptyStateView: some View {
        ContentUnavailableView {
            Label("No Details Found", systemImage: "magnifyingglass")
        } description: {
                Text("Unable to load cryptocurrency details.")
        } actions: {
            Button("Retry") {
                viewModel.retry()
            }
            .buttonStyle(.bordered)
        }
    }
}
