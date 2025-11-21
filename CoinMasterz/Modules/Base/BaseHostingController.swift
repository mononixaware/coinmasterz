//
//  BaseHostingController.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import SwiftUI

class BaseHostingController<T: View>: UIHostingController<T> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupUI()
    }
    
    func setupNavigation() {
        navigationController?.navigationBar.tintColor = UIColor.label
    }
    
    func setupUI() {
        view.backgroundColor = UIColor.systemBackground
    }
}
