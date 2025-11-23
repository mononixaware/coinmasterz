//
//  AssetsViewComponents.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import SwiftUI

enum AssetsViewComponents {
    
    // MARK: Entity
    
    struct Entity: View {
        
        let entity: AssetsModel.Entity
        
        var body: some View {
            HStack(spacing: 0.0) {
                HStack(spacing: 12.0) {
                    EntityImage(initials: entity.initials)
                    
                    VStack(alignment: .leading, spacing: 4.0) {
                        Text(entity.symbol)
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(Color(uiColor: .label))
                        
                        Text(entity.name)
                            .font(.body)
                            .foregroundStyle(Color(uiColor: .secondaryLabel))
                            .lineLimit(1)
                    }
                }
                
                Spacer(minLength: 24.0)
                
                VStack(alignment: .trailing, spacing: 4.0) {
                    Text(entity.priceDisplayValue)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(Color(uiColor: .label))
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
    
    // MARK: EntityImage
    
    struct EntityImage: View {
        
        let initials: String
        
        var body: some View {
            ZStack {
                Circle()
                    .foregroundStyle(Color(uiColor: .secondarySystemFill))
                
                Text(initials)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(uiColor: .label))
                    .padding(4)
            }
            .frame(width: 48.0, height: 48.0)
        }
    }
}
