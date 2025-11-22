//
//  FlowMemoryTests.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 22.11.2025.
//

@testable import CoinMasterz
import Combine
import Swinject
import Testing
import UIKit

@Suite("Flow Memory Management")
@MainActor
struct FlowMemoryTests {
    
    @Test("Flow deallocates properly")
    func flowDoesNotLeak() async throws {
        let resolver = DIContainer.main.container
        var flow: WatchlistFlow? = DefaultWatchlistFlow(
            r: resolver,
            controller: UINavigationController()
        )
        weak var weakFlow = flow
        
        flow?.start()
        flow?.finish()
        flow = nil
        
        // Give ARC time to clean up
        try await Task.sleep(for: .milliseconds(100))
        
        #expect(weakFlow == nil, "Flow should be deallocated after finish()")
    }
    
    @Test("Child flows are cleaned up")
    func childFlowsCleanup() async throws {
        let container = DIContainer.main.container
        // Register the necessary flows for the test
        container.register(AssetsFlow.self) { r, navigationController in
            DefaultAssetsFlow(r: r, controller: navigationController)
        }
        container.register(WatchlistFlow.self) { r, navigationController in
            DefaultWatchlistFlow(r: r, controller: navigationController)
        }
        
        let tabBarFlow = DefaultMainTabBarFlow(
            r: container,
            controller: UITabBarController()
        )
        
        tabBarFlow.start()
        
        let childCount = tabBarFlow.childFlows.count
        #expect(childCount == 2, "Should have 2 tab children")
        
        weak var firstChild = tabBarFlow.childFlows.first
        
        tabBarFlow.finish()
        
        try await Task.sleep(for: .milliseconds(100))
        
        #expect(firstChild == nil, "Child flows should be deallocated")
        #expect(tabBarFlow.childFlows.isEmpty, "Child flows array should be empty")
    }
}
