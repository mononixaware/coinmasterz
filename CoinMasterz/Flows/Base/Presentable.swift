//
//  Presentable.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import UIKit

protocol Presentable: AnyObject {
    
    func toPresent() -> UIViewController
}

extension UIViewController: Presentable {
    
    func toPresent() -> UIViewController {
        self
    }
}
