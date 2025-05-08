//
//  AppFlow.swift
//  Crypto wallet
//
//  Created by Fedor Bebinov on 08.05.2025.
//

import Foundation

enum AppFlow {
    case auth
    case cryptoList
    case coinDetail(coin: Coin)
}
