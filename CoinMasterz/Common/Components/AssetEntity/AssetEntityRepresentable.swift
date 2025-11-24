//
//  AssetEntityRepresentable.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 24.11.2025.
//

import SwiftUI

protocol AssetEntityRepresentable: Identifiable {
    
    var id: String { get }
    var initials: String { get }
    var symbol: String { get }
    var name: String { get }
    var price: String { get }
    var change: String { get }
    var changeColor: Color { get }
}
