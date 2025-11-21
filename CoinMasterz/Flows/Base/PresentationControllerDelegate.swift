//
//  PresentationControllerDelegate.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 22.11.2025.
//

import UIKit

protocol PresentationControllerDelegate: NSObject, UIAdaptivePresentationControllerDelegate {
    
    var adaptivePresentationStyleForController: ((UIPresentationController) -> UIModalPresentationStyle)? { get set }
    var presentationControllerDidDismiss: EmptyCallback? { get set }
}

final class DefaultPresentationControllerDelegate: NSObject, PresentationControllerDelegate {
    
    var adaptivePresentationStyleForController: ((UIPresentationController) -> UIModalPresentationStyle)?
    var presentationControllerDidDismiss: EmptyCallback?
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        presentationControllerDidDismiss?()
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        adaptivePresentationStyleForController?(controller) ?? .pageSheet
    }
}
