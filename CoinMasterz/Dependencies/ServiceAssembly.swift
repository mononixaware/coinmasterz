//
//  ServiceAssembly.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import Swinject

final class ServiceAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(CoinCapProvider.self) { r in
            DefaultCoinCapProvider()
        }
        .inObjectScope(.container)
    }
}
