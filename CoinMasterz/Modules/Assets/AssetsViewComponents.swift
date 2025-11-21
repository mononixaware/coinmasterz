//
//  AssetsViewComponents.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import SwiftUI

enum AssetsViewComponents {
    
    struct Entity: View {
        
        let entity: AssetsModel.Entity
        
        var body: some View {
            HStack(spacing: 0.0) {
                HStack(spacing: 12.0) {
                    EntityImage(initials: entity.initials)
                    
                    VStack(alignment: .leading, spacing: 4.0) {
                        Text(entity.symbol)
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.primary)
                        
                        Text(entity.name)
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
                
                Spacer(minLength: 24.0)
                
                VStack(alignment: .trailing, spacing: 4.0) {
                    Text(entity.priceDisplayValue)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                    
                    Text(entity.changePercentDynamics.displayValue)
                        .font(.body)
                        .foregroundStyle(entity.changePercentDynamics.color)
                        .lineLimit(1)
                }
            }
        }
    }
}


private extension AssetsViewComponents {
    
    struct EntityImage: View {
        
        let initials: String
        
        var body: some View {
            ZStack {
                Circle()
                    .foregroundStyle(.secondary)
                
                Text(initials)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                    .padding(4)
            }
            .frame(width: 48.0, height: 48.0)
        }
    }
}
