//
//  OnboardingModel.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 24.11.2025.
//

import SwiftUI

struct OnboardingModel {
    
    let pages: [Page]
    
    init(pages: [Page] = Self.defaultPages) {
        self.pages = pages
    }
    
    struct Page: Identifiable {
        let id: Int
        let title: String
        let description: String
        let systemImageName: String
        let accentColor: Color
    }
}

extension OnboardingModel {
    
    static let defaultPages: [Page] = [
        Page(
            id: 0,
            title: "Track Your Portfolio",
            description: "Monitor your cryptocurrency assets in real-time with live price updates and market data.",
            systemImageName: "chart.line.uptrend.xyaxis",
            accentColor: .blue
        ),
        Page(
            id: 1,
            title: "Create Watchlists",
            description: "Build custom watchlists to keep an eye on your favorite cryptocurrencies.",
            systemImageName: "star.circle.fill",
            accentColor: .orange
        ),
        Page(
            id: 2,
            title: "Stay Informed",
            description: "Get instant notifications on price changes and market trends to make better investment decisions.",
            systemImageName: "bell.badge.fill",
            accentColor: .green
        )
    ]
}
