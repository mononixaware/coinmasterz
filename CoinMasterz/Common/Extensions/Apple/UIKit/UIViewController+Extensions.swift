//
//  UIViewController+Extensions.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 22.11.2025.
//

import UIKit

public extension UIViewController {
    
    var presentedViewControllers: [UIViewController] {
        presentedViewController.map { $0.presentedViewControllers.prepending($0) }.orEmpty
    }
    
    var presenter: UIViewController {
        presentedViewControllers.last ?? self
    }
}
