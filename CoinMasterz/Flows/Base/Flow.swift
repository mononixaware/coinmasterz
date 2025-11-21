//
//  Flow.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

protocol Flow: AnyObject, Presentable, AnyFactory {
    
    var childFlows: [Flow] { get set }
    var parentFlow: Flow? { get set }
    
    func start()
    func finish()
    func addChild(_ flow: Flow)
    func removeChild(_ flow: Flow)
    func removeAllChildren()
}

extension Flow {
    
    func finish() {
        removeAllChildren()
        parentFlow?.removeChild(self)
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
        childFlows.removeAll()
    }
}
