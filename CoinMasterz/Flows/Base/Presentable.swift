//
//  Presentable.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import UIKit

protocol Presentable: AnyObject {
    
    var presentationDelegate: PresentationControllerDelegate { get }
    
    func toPresent() -> UIViewController
}

private var presentationDelegateAssociation = UInt8()

extension UIViewController: Presentable {
    
    var presentationDelegate: PresentationControllerDelegate {
        if let delegate = objc_getAssociatedObject(self, &presentationDelegateAssociation) as? PresentationControllerDelegate {
            return delegate
        } else {
            let delegate = DefaultPresentationControllerDelegate()
            presentationController?.delegate = delegate
            objc_setAssociatedObject(self, &presentationDelegateAssociation, delegate, .OBJC_ASSOCIATION_RETAIN)
            return delegate
        }
    }
    
    func toPresent() -> UIViewController {
        self
    }
}
