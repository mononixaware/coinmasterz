//
//  AssetDetailsViewComponents+Details.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 23.11.2025.
//

import SwiftUI

extension AssetDetailsViewComponents {
    
    // MARK: Details
    
    struct Details: View {
        
        let details: AssetDetailsModel.Details
        
        var body: some View {
            VStack(spacing: 12.0) {
                HStack(spacing: 0.0) {
                    Text(details.name)
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(Color(uiColor: .label))
                    
                    Spacer(minLength: 12.0)
                    
                    Text(details.rank)
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(Color(uiColor: .label))
                }
                
                VStack(alignment: .leading, spacing: 8.0) {
                    HStack(alignment: .top, spacing: 8.0) {
                        Text(details.price)
                            .font(.body)
                            .foregroundStyle(Color(uiColor: .label))
                        
                        Text("Price")
                            .font(.body)
                            .foregroundStyle(Color(uiColor: .secondaryLabel))
                    }
                    
                    HStack(alignment: .top, spacing: 8.0) {
                        Text(details.changeValue)
                            .font(.body)
                            .foregroundStyle(details.changeColor)
                        
                        Text("24Hr Change")
                            .font(.body)
                            .foregroundStyle(Color(uiColor: .secondaryLabel))
                    }
                    
                    HStack(alignment: .top, spacing: 8.0) {
                        Text(details.marketCap)
                            .font(.body)
                            .foregroundStyle(Color(uiColor: .label))
                        
                        Text("Market Capitalization")
                            .font(.body)
                            .foregroundStyle(Color(uiColor: .secondaryLabel))
                    }
                    
                    HStack(alignment: .top, spacing: 8.0) {
                        Text(details.supply)
                            .font(.body)
                            .foregroundStyle(Color(uiColor: .label))
                        
                        Text("Circulating Supply")
                            .font(.body)
                            .foregroundStyle(Color(uiColor: .secondaryLabel))
                    }
                    
                    if let maxSupply = details.maxSupply {
                        HStack(alignment: .top, spacing: 8.0) {
                            Text(maxSupply)
                                .font(.body)
                                .foregroundStyle(Color(uiColor: .label))
                            
                            Text("Maximum Supply")
                                .font(.body)
                                .foregroundStyle(Color(uiColor: .secondaryLabel))
                        }
                    }
                    
                    HStack(alignment: .top, spacing: 8.0) {
                        Text(details.volumeDay)
                            .font(.body)
                            .foregroundStyle(Color(uiColor: .label))
                        
                        Text("24Hr Volume")
                            .font(.body)
                            .foregroundStyle(Color(uiColor: .secondaryLabel))
                    }
                    
                    if let vwapDay = details.vwapDay {
                        HStack(alignment: .top, spacing: 8.0) {
                            Text(vwapDay)
                                .font(.body)
                                .foregroundStyle(Color(uiColor: .label))
                            
                            Text("24Hr Volume-Weighted Average Price")
                                .font(.body)
                                .foregroundStyle(Color(uiColor: .secondaryLabel))
                        }
                    }
                }
                .infiniteWidthFrame(alignment: .leading)
            }
        }
    }
}
