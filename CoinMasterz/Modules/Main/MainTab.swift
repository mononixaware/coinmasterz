//
//  MainTab.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import UIKit

enum MainTab {
    
    case assets, watchlist
}

extension MainTab {
    
    var title: String {
        switch self {
        case .assets: "Assets"
        case .watchlist: "Watchlist"
        }
    }
    
    var imageSystemName: String {
        switch self {
        case .assets: "house"
        case .watchlist: "star"
        }
    }
    
    var selectedSystemImageName: String {
        switch self {
        case .assets: "house.fill"
        case .watchlist: "star.fill"
        }
    }
    
    var tabBarItem: UITabBarItem {
        UITabBarItem(
            title: title,
            image: UIImage(systemName: imageSystemName),
            selectedImage: UIImage(systemName: selectedSystemImageName)
        )
    }
}
