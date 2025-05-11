//
//  CoinDetailViewController.swift
//  Crypto wallet
//
//  Created by Fedor Bebinov on 08.05.2025.
//

import UIKit

class CryptoDetailViewController: UIViewController {
    
    var onBack: (() -> Void)?
    let crypto: Crypto
    
    init(crypto: Crypto) {
        self.crypto = crypto
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .brown
    }
}
