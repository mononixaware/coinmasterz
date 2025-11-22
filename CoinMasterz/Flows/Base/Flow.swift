//
//  Flow.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import Swinject
import UIKit

protocol Flow: AnyObject, Presentable {
    
    var childFlows: [Flow] { get set }
    var parentFlow: Flow? { get set }
    var firstViewController: UIViewController? { get }
    var lastViewController: UIViewController? { get }
    
    func start()
    func addChild(_ flow: Flow)
    func removeChild(_ flow: Flow)
    func removeAllChildren()
    func finish()
}

class BaseFlow<Controller: UIViewController>: Flow, AnyFactory {
    
    var childFlows = [Flow]()
    weak var parentFlow: Flow?
    let r: Resolver
    
    private(set) var controller: Controller
    
    init(r: Resolver, controller: Controller) {
        self.r = r
        self.controller = controller
    }
    
    // MARK: Presentable
    
    func toPresent() -> UIViewController {
        controller
    }
    
    // MARK: Flow
    
    var firstViewController: UIViewController? {
        nil
    }
    
    var lastViewController: UIViewController? {
        nil
    }
    
    func start() {
        // Default implementation does nothing
        // Subclasses should override to provide custom behavior
    }
    
    func addChild(_ flow: Flow) {
        childFlows.append(flow)
        flow.parentFlow = self
        flow.start()
    }
    
    func removeChild(_ flow: Flow) {
        childFlows.removeAll { $0 === flow }
    }
    
    func removeAllChildren() {
        childFlows.forEach { $0.finish() }
        childFlows.removeAll()
    }
    
    func finish() {
        removeAllChildren()
        parentFlow?.removeChild(self)
    }
    
    // MARK: - Lifecycle
    
    #if DEBUG
    deinit {
        // Help catch memory leaks during development
        trace("ℹ \(type(of: self)) deallocated")
    }
    #endif
}
