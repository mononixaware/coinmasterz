//
//  PresentationControllerDelegate.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 22.11.2025.
//

import UIKit

protocol PresentationControllerDelegate: NSObject, UIAdaptivePresentationControllerDelegate {
    
    var didDismiss: EmptyCallback? { get set }
}

final class DefaultPresentationControllerDelegate: NSObject, PresentationControllerDelegate {
    
    var didDismiss: EmptyCallback?
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        didDismiss?()
    }
}
