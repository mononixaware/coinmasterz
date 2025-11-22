//
//  StepsBagTests.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 22.11.2025.
//

@testable import CoinMasterz
import Combine
import Testing
import UIKit

@Suite("Steps Bag Pattern Tests")
@MainActor
struct StepsBagTests {
    
    // MARK: - Basic Functionality
    
    @Test("stepsBag is accessible from any Presentable")
    func stepsBagAccessible() {
        let viewController = UIViewController()
        let bag = viewController.stepsBag
        
        #expect(bag.isEmpty, "New stepsBag should be empty")
    }
    
    @Test("Can store cancellables in stepsBag")
    func canStoreCancellables() {
        let viewController = UIViewController()
        let subject = PassthroughSubject<Int, Never>()
        
        subject
            .sink { _ in }
            .store(in: &viewController.stepsBag)
        
        #expect(viewController.stepsBag.count == 1, "Should have 1 cancellable")
    }
    
    @Test("Multiple cancellables can be stored")
    func multipleSubscriptions() {
        let viewController = UIViewController()
        let subject1 = PassthroughSubject<Int, Never>()
        let subject2 = PassthroughSubject<String, Never>()
        let subject3 = PassthroughSubject<Bool, Never>()
        
        subject1.sink { _ in }.store(in: &viewController.stepsBag)
        subject2.sink { _ in }.store(in: &viewController.stepsBag)
        subject3.sink { _ in }.store(in: &viewController.stepsBag)
        
        #expect(viewController.stepsBag.count == 3, "Should have 3 cancellables")
    }
    
    // MARK: - Memory Management
    
    @Test("stepsBag deallocates with view controller")
    func stepsBagDeallocatesWithViewController() async throws {
        var viewController: UIViewController? = UIViewController()
        weak var weakViewController = viewController
        
        let subject = PassthroughSubject<Int, Never>()
        subject.sink { _ in }.store(in: &viewController!.stepsBag)
        
        #expect(viewController?.stepsBag.count == 1)
        
        // Release view controller
        viewController = nil
        try await Task.sleep(for: .milliseconds(100))
        
        #expect(weakViewController == nil, "View controller should be deallocated")
    }
    
    @Test("Subscriptions are cancelled when view deallocates")
    func subscriptionsCancelledOnDeallocation() async throws {
        var receivedValue = false
        let subject = PassthroughSubject<String, Never>()
        
        do {
            let viewController = UIViewController()
            subject
                .sink { _ in
                    receivedValue = true
                }
                .store(in: &viewController.stepsBag)
            
            // View controller goes out of scope here
        }
        
        try await Task.sleep(for: .milliseconds(100))
        
        // Send value after view is deallocated
        subject.send("test")
        
        #expect(receivedValue == false, "Subscription should be cancelled")
    }
    
    @Test("Each view controller has independent stepsBag")
    func independentStepsBags() {
        let viewController1 = UIViewController()
        let viewController2 = UIViewController()
        
        let subject = PassthroughSubject<Int, Never>()
        
        subject.sink { _ in }.store(in: &viewController1.stepsBag)
        subject.sink { _ in }.store(in: &viewController2.stepsBag)
        
        #expect(viewController1.stepsBag.count == 1)
        #expect(viewController2.stepsBag.count == 1)
        
        // They should be independent
        let bag1Count = viewController1.stepsBag.count
        let bag2Count = viewController2.stepsBag.count
        
        #expect(bag1Count == bag2Count)
        #expect(bag1Count == 1)
    }
    
    // MARK: - Flow Integration
    
    @Test("stepsBag works with NavigationFlow push")
    func worksWithNavigationFlow() async throws {
        let container = DIContainer.main.container
        let navigationController = UINavigationController()
        let flow = DefaultAssetsFlow(r: container, controller: navigationController)
        
        flow.start()
        
        // Get the root view controller
        let rootVC = navigationController.viewControllers.first
        
        #expect(rootVC != nil, "Root view controller should be set")
        
        // stepsBag should be accessible
        let bag = rootVC?.stepsBag
        #expect(bag != nil, "stepsBag should be accessible")
    }
    
    // MARK: - Real-World Scenario
    
    @Test("Multiple views pushed and popped")
    func multipleViewsPushedAndPopped() async throws {
        var receivedValues: [String] = []
        let subject = PassthroughSubject<String, Never>()
        
        // Simulate pushing 3 views
        var view1: UIViewController? = UIViewController()
        weak var weakView1 = view1
        subject.sink { receivedValues.append($0 + "-view1") }.store(in: &view1!.stepsBag)
        
        var view2: UIViewController? = UIViewController()
        weak var weakView2 = view2
        subject.sink { receivedValues.append($0 + "-view2") }.store(in: &view2!.stepsBag)
        
        var view3: UIViewController? = UIViewController()
        weak var weakView3 = view3
        subject.sink { receivedValues.append($0 + "-view3") }.store(in: &view3!.stepsBag)
        
        subject.send("event1")
        #expect(receivedValues.count == 3, "All 3 views should receive")
        
        // Pop view3
        view3 = nil
        try await Task.sleep(for: .milliseconds(50))
        receivedValues.removeAll()
        
        subject.send("event2")
        #expect(receivedValues.count == 2, "Only 2 views should receive")
        #expect(weakView3 == nil, "View 3 should be deallocated")
        
        // Pop view2
        view2 = nil
        try await Task.sleep(for: .milliseconds(50))
        receivedValues.removeAll()
        
        subject.send("event3")
        #expect(receivedValues.count == 1, "Only 1 view should receive")
        #expect(weakView2 == nil, "View 2 should be deallocated")
        
        // Pop view1
        view1 = nil
        try await Task.sleep(for: .milliseconds(50))
        receivedValues.removeAll()
        
        subject.send("event4")
        #expect(receivedValues.isEmpty, "No views should receive")
        #expect(weakView1 == nil, "View 1 should be deallocated")
    }
    
    // MARK: - Edge Cases
    
    @Test("stepsBag survives multiple accesses")
    func stepsBagPersistence() {
        let viewController = UIViewController()
        
        // Access multiple times
        let bag1 = viewController.stepsBag
        let bag2 = viewController.stepsBag
        let bag3 = viewController.stepsBag
        
        // All should be empty
        #expect(bag1.isEmpty)
        #expect(bag2.isEmpty)
        #expect(bag3.isEmpty)
        
        // Store something
        let subject = PassthroughSubject<Int, Never>()
        subject.sink { _ in }.store(in: &viewController.stepsBag)
        
        // Should persist
        #expect(viewController.stepsBag.count == 1)
    }
    
    @Test("stepsBag with convenience store method")
    func convenienceStoreMethod() {
        let viewController = UIViewController()
        let subject = PassthroughSubject<Int, Never>()
        
        let cancellable = subject.sink { _ in }
        viewController.store(cancellable)
        
        #expect(viewController.stepsBag.count == 1)
    }
    
    @Test("No retain cycle with weak self")
    func noRetainCycleWithWeakSelf() async throws {
        class TestViewController: UIViewController {
            var value = 0
            
            func setupSubscription() {
                let subject = PassthroughSubject<Int, Never>()
                subject
                    .sink { [weak self] newValue in
                        self?.value = newValue
                    }
                    .store(in: &stepsBag)
            }
        }
        
        var viewController: TestViewController? = TestViewController()
        weak var weakViewController = viewController
        
        viewController?.setupSubscription()
        
        viewController = nil
        try await Task.sleep(for: .milliseconds(100))
        
        #expect(weakViewController == nil, "Should not create retain cycle")
    }
    
    // MARK: - Debugging
    
    #if DEBUG
    @Test("printStepsBagInfo works")
    func debugPrintWorks() {
        let viewController = UIViewController()
        let subject = PassthroughSubject<Int, Never>()
        
        subject.sink { _ in }.store(in: &viewController.stepsBag)
        subject.sink { _ in }.store(in: &viewController.stepsBag)
        
        // This should not crash
        viewController.traceStepsBagInfo()
        
        #expect(viewController.stepsBag.count == 2)
    }
    #endif
}
