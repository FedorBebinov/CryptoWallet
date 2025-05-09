//
//  AuthViewModel.swift
//  Crypto wallet
//
//  Created by Fedor Bebinov on 08.05.2025.
//

import Foundation

final class AuthViewModel {
    var username: String = ""
    var password: String = ""
    
    var onAuthSuccess: (() -> Void)?
    var onAuthFailure: ((String) -> Void)?
    
    private let userSessionService: UserSessionService

    init(userSessionService: UserSessionService) {
        self.userSessionService = userSessionService
    }

    func login() {
        guard !username.isEmpty, !password.isEmpty else {
            onAuthFailure?("Поля не должны быть пустыми")
            return
        }
        if userSessionService.login(username: username, password: password) {
            onAuthSuccess?()
        } else {
            onAuthFailure?("Введены неправильный логин или пароль.")
        }
    }
}
