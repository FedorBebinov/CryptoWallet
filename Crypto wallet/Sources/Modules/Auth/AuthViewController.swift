//
//  AuthViewController.swift
//  Crypto wallet
//
//  Created by Fedor Bebinov on 08.05.2025.
//

import UIKit

class AuthViewController: UIViewController {
    
    var onLoginSuccess: (() -> Void)?
    
    override func viewDidLoad() {
        view.backgroundColor = .blue
    }
}
