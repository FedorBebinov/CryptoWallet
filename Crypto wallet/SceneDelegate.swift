//
//  SceneDelegate.swift
//  Crypto wallet
//
//  Created by Fedor Bebinov on 07.05.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    var userSessionService: UserSessionService?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        let userSessionService = UserSessionService()
        self.userSessionService = userSessionService
        
        let appCoordinator = AppCoordinator(window: window, userSessionService: userSessionService)
        self.appCoordinator = appCoordinator
        appCoordinator.start()
    }
}

