//
//  AppCoordinator.swift
//  Crypto wallet
//
//  Created by Fedor Bebinov on 08.05.2025.
//

import UIKit

protocol Coordinator: AnyObject {
    func start()
}

class AppCoordinator: Coordinator {
    
    private let window: UIWindow
    private let userSessionService: UserSessionService
    private var currentFlow: AppFlow?
    private var mainTabBarController: MainTabBarController?
    
    init(window: UIWindow, userSessionService: UserSessionService){
        self.window = window
        self.userSessionService = userSessionService
    }
    func start() {
        let initialFlow: AppFlow = userSessionService.isLoggedIn ? .cryptoList : .auth
        show(flow: initialFlow)
    }
    
    func show(flow: AppFlow) {
        self.currentFlow = flow
        
        switch flow {
        case .auth:
            let viewModel = AuthViewModel(userSessionService: userSessionService)
            viewModel.onAuthSuccess = { [weak self] in
                self?.userSessionService.setLoggedIn(true)
                self?.show(flow: .cryptoList)
            }
            let loginVC = AuthViewController(viewModel: viewModel)
            window.rootViewController = loginVC
            window.makeKeyAndVisible()
            
        case .cryptoList:
            if let tabBar = mainTabBarController {
                window.rootViewController = tabBar
                window.makeKeyAndVisible()
                return
            }
            
            let tabBar = MainTabBarController()
            tabBar.onLogout = { [weak self] in
                self?.userSessionService.setLoggedIn(false)
                self?.show(flow: .auth)
            }
            tabBar.onShowCryptoDetail = { [weak self] crypto in
                self?.show(flow: .coinDetail(crypto: crypto))
            }
            window.rootViewController = tabBar
            window.makeKeyAndVisible()
            mainTabBarController = tabBar
            
        case .coinDetail(let crypto):
            guard let tabBar = mainTabBarController,
                  let nav = tabBar.selectedViewController as? UINavigationController else { return }
            
            let viewModel = CryptoDetailViewModel(crypto: crypto)
            let coinVC = CryptoDetailViewController(viewModel: viewModel)
            coinVC.onBack = {
                nav.popViewController(animated: true)
            }
            nav.pushViewController(coinVC, animated: true)
        }
    }
}
