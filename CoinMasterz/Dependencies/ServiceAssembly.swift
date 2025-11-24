//
//  ServiceAssembly.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import Swinject
import UIKit

final class ServiceAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(CoinCapProvider.self) { r in
            DefaultCoinCapProvider()
        }
        .inObjectScope(.container)
        
        container.register(FavoritesService.self) { r in
            let appDelegate = (UIApplication.shared.delegate as? AppDelegate).unsafelyUnwrapped
            return DefaultFavoritesService(persistentContainer: appDelegate.persistentContainer)
        }
        .inObjectScope(.container)
    }
}
