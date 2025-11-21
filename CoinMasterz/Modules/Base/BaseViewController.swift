//
//  BaseViewController.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

import UIKit

class BaseViewController: UIViewController {
    
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
