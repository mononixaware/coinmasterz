//
//  View+Extensions.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 23.11.2025.
//

import SwiftUI

extension View {
    
    func infiniteWidthFrame(alignment: Alignment = .center) -> some View {
        self.frame(minWidth: .zero, maxWidth: .infinity, alignment: alignment)
    }
    
    func infiniteHeightFrame(alignment: Alignment = .center) -> some View {
        self.frame(minHeight: .zero, maxHeight: .infinity, alignment: alignment)
    }
    
    func infiniteFrame(alignment: Alignment = .center) -> some View {
        self.frame(minWidth: .zero, maxWidth: .infinity, minHeight: .zero, maxHeight: .infinity, alignment: alignment)
    }
}
