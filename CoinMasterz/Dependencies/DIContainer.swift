//
//  DIContainer.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import Swinject

final class DIContainer {
    
    static let main = DIContainer()
    
    let container: Container
    let asssembler: Assembler
    
    private init() {
        container = Container()
        asssembler = Assembler([
            FlowAssembly(),
            ModuleAssembly()
        ], container: container)
    }
}

