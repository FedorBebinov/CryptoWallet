//
//  UserSession.swift
//  Crypto wallet
//
//  Created by Fedor Bebinov on 08.05.2025.
//

import Foundation

final class UserSessionService {
    private let loggedInKey = "isLoggedIn"
    
    var isLoggedIn: Bool {
        UserDefaults.standard.bool(forKey: loggedInKey)
    }
    
    func setLoggedIn(_ loggedIn: Bool) {
        UserDefaults.standard.set(loggedIn, forKey: loggedInKey)
    }
}
