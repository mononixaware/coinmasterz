//
//  BaseFactory.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import Swinject

protocol AnyFactory {
    
    var r: Resolver { get }
}

class BaseFactory: AnyFactory {
    
    let r: Resolver
    
    init(r: Resolver) {
        self.r = r
    }
}
