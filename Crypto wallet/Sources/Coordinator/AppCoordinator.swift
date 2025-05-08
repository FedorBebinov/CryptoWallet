//
//  AppCoordinator.swift
//  Crypto wallet
//
//  Created by Fedor Bebinov on 08.05.2025.
//

import UIKit

protocol Coordiantor: AnyObject {
    func start()
}

class AppCoordinator: Coordiantor {
    private let window: UIWindow
    private let userSessionService: UserSessionService
    private var currentFlow: AppFlow?
    
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
            let loginVC = AuthViewController()
            // Клоужер для успешного входа:
            loginVC.onLoginSuccess = { [weak self] in
                self?.userSessionService.setLoggedIn(true)
                self?.show(flow: .cryptoList)
            }
            window.rootViewController = loginVC
            window.makeKeyAndVisible()
            
        case .cryptoList:
            let listVC = CryptoListViewController()
            // Клоужер для выхода:
            listVC.onLogout = { [weak self] in
                self?.userSessionService.setLoggedIn(false)
                self?.show(flow: .auth)
            }
            // Клоужер для выбора монеты:
            listVC.onCoinSelect = { [weak self] coin in
                self?.show(flow: .coinDetail(coin: coin))
            }
            window.rootViewController = listVC
            window.makeKeyAndVisible()
            
        case .coinDetail(let coin):
            let coinVC = CoinDetailViewController(coin: coin)
            // Кнопка Back, для возвращения назад:
            coinVC.onBack = { [weak self] in
                self?.show(flow: .cryptoList)
            }
            window.rootViewController = coinVC
            window.makeKeyAndVisible()
        }
    }
}
