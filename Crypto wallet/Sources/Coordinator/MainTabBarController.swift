//
//  MainTabBarController.swift
//  Crypto wallet
//
//  Created by Fedor Bebinov on 10.05.2025.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    var onLogout: (() -> Void)?
    var onShowCryptoDetail: ((Crypto) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .white
        tabBar.tintColor = .black
    }
    
    private func setupTabs() {
        let cryptoListViewModel = CryptoListViewModel()
        let cryptoListVC = CryptoListViewController(viewModel: cryptoListViewModel)
        let navHome = UINavigationController(rootViewController: cryptoListVC)
        navHome.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "homeTab"), selectedImage: UIImage(named: "homeTab"))
        navHome.tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)
        cryptoListVC.onLogout = { [weak self] in self?.onLogout?() }
        cryptoListVC.onCoinSelect = { [weak self] crypto in self?.onShowCryptoDetail?(crypto) }
        
        let statsVC = UIViewController()
        statsVC.view.backgroundColor = .white
        statsVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "statsTab"), selectedImage: UIImage(named: "statsTab"))
        statsVC.tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)
        
        let walletVC = UIViewController()
        walletVC.view.backgroundColor = .white
        walletVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "walletTab"), selectedImage: UIImage(named: "walletTab"))
        walletVC.tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)
        
        let docVC = UIViewController()
        docVC.view.backgroundColor = .white
        docVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "docTab"), selectedImage: UIImage(named: "docTab"))
        docVC.tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)
        
        let userVC = UIViewController()
        userVC.view.backgroundColor = .white
        userVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "userTab"), selectedImage: UIImage(named: "userTab"))
        userVC.tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)
        
        viewControllers = [navHome, statsVC, walletVC, docVC, userVC]
    }
}
