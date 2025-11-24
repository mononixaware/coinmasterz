//
//  OnboardingViewComponents.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 24.11.2025.
//

import SwiftUI

enum OnboardingViewComponents {
    
    // MARK: Page
    
    struct Page: View {
        
        @State private var iconScale: CGFloat = 0.5
        @State private var iconRotation: Double = -10
        @State private var textOpacity: Double = 0
        
        let page: OnboardingModel.Page
        let isActive: Bool
        
        var body: some View {
            VStack(spacing: 40) {
                Spacer()
                
                // Animated icon
                ZStack {
                    // Background circles for depth
                    Circle()
                        .fill(page.accentColor.opacity(0.1))
                        .frame(width: 200, height: 200)
                        .scaleEffect(isActive ? 1.0 : 0.8)
                    
                    Circle()
                        .fill(page.accentColor.opacity(0.15))
                        .frame(width: 160, height: 160)
                        .scaleEffect(isActive ? 1.0 : 0.8)
                    
                    // Main icon
                    Image(systemName: page.systemImageName)
                        .font(.system(size: 70, weight: .medium))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [page.accentColor,
                                         page.accentColor.opacity(0.7)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .scaleEffect(iconScale)
                        .rotationEffect(.degrees(iconRotation))
                }
                .padding(.bottom, 20)
                
                // Text content
                VStack(spacing: 16) {
                    Text(page.title)
                        .font(.system(size: 34, weight: .bold))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .opacity(textOpacity)
                    
                    Text(page.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                        .padding(.horizontal, 40)
                        .opacity(textOpacity)
                        .frame(height: 120, alignment: .top)
                }
                
                Spacer()
            }
            .padding(.vertical, 40)
            .onChange(of: isActive) { _, active in
                if active {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                        iconScale = 1.0
                        iconRotation = 0
                    }
                    withAnimation(.easeOut(duration: 0.4).delay(0.2)) {
                        textOpacity = 1.0
                    }
                } else {
                    iconScale = 0.5
                    iconRotation = -10
                    textOpacity = 0
                }
            }
            .onAppear {
                if isActive {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                        iconScale = 1.0
                        iconRotation = 0
                    }
                    withAnimation(.easeOut(duration: 0.4).delay(0.2)) {
                        textOpacity = 1.0
                    }
                }
            }
        }
    }
}
