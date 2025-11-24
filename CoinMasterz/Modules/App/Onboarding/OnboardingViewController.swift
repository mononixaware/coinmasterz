//
//  OnboardingViewController.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 24.11.2025.
//

import Combine
import SwiftUI

final class OnboardingViewController: BaseHostingController<OnboardingViewUI>, OnboardingView {
    
    var steps = PassthroughSubject<OnboardingViewSteps, Never>()
    var viewModel: OnboardingViewInput!
}

struct OnboardingViewUI: View {
    
    @ObservedObject private var viewModel: OnboardingViewModel
    @State private var currentPage: Int
    @State private var offset: CGFloat
    @State private var scale: CGFloat
    
    init(viewModel: OnboardingViewModel,
         currentPage: Int = 0,
         offset: CGFloat = 0,
         scale: CGFloat = 1.0) {
        self.viewModel = viewModel
        self.currentPage = currentPage
        self.offset = offset
        self.scale = scale
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(viewModel.model.pages) { page in
                    page.accentColor
                        .opacity(currentPage == page.id ? 0.15 : 0)
                        .ignoresSafeArea()
                        .animation(.easeInOut(duration: 0.5), value: currentPage)
                }
                
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        
                        Button {
                            viewModel.finish()
                        } label: {
                            Text("Skip")
                                .font(.body.weight(.semibold))
                                .foregroundStyle(viewModel.model.pages[currentPage].accentColor)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(viewModel.model.pages[currentPage].accentColor.opacity(0.1))
                                .clipShape(.capsule)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                    }
                    
                    TabView(selection: $currentPage) {
                        ForEach(viewModel.model.pages) { page in
                            OnboardingViewComponents.Page(
                                page: page,
                                isActive: currentPage == page.id
                            )
                            .tag(page.id)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .onChange(of: currentPage) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            scale = 0.95
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                scale = 1.0
                            }
                        }
                    }
                    
                    VStack(spacing: 24) {
                        HStack(spacing: 8) {
                            ForEach(0..<viewModel.model.pages.count, id: \.self) { index in
                                Capsule()
                                    .fill(currentPage == index ?
                                           viewModel.model.pages[currentPage].accentColor :
                                            Color.secondary.opacity(0.3))
                                    .frame(width: currentPage == index ? 24 : 8, height: 8)
                                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
                            }
                        }
                        .padding(.top, 8)
                        
                        Button {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                if currentPage < viewModel.model.pages.count - 1 {
                                    currentPage += 1
                                } else {
                                    viewModel.finish()
                                }
                            }
                        } label: {
                            HStack(spacing: 12) {
                                Text(currentPage < viewModel.model.pages.count - 1 ? "Continue" : "Get Started")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                Image(systemName: currentPage < viewModel.model.pages.count - 1 ? "arrow.right" : "checkmark")
                                    .font(.headline.weight(.semibold))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(viewModel.model.pages[currentPage].accentColor)
                                    .shadow(color: viewModel.model.pages[currentPage].accentColor.opacity(0.3),
                                            radius: 12, x: 0, y: 6)
                            )
                            .foregroundColor(.white)
                        }
                        .scaleEffect(scale)
                        .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 40)
                }
            }
        }
    }
}
