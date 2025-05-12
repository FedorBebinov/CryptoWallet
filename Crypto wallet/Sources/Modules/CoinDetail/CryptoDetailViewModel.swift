//
//  CryptoDetailViewModel.swift
//  Crypto wallet
//
//  Created by Fedor Bebinov on 11.05.2025.
//

import Foundation
import UIKit

enum CryptoPeriod: Int, CaseIterable {
    case day = 0
    case week
    case year
    case all
    case point
    
    var title: String {
        switch self {
        case .day: return "24H"
        case .week: return "1W"
        case .year: return "1Y"
        case .all: return "ALL"
        case .point: return "Point"
        }
    }
}

final class CryptoDetailViewModel {
    
    // MARK: - Properties
    
    private let crypto: Crypto
    
    // MARK: - State
    
    private(set) var selectedPeriod: CryptoPeriod = .day {
        didSet {
            onPeriodChanged?(selectedPeriod)
        }
    }
    
    // MARK: - Outputs
    
    var name: String { crypto.name }
    var symbol: String { crypto.symbol }
    var iconName: String { crypto.iconName }
    
    var priceFormatted: String {
        CryptoFormatter.formatPrice(crypto.price)
    }
    
    var percentFormatted: String {
        CryptoFormatter.formatPercent(crypto.priceChange)
    }
    
    var percentColor: UIColor {
        UIColor(red: 147/255, green: 149/255, blue: 164/255, alpha: 1) // Cерый
    }
    
    var arrowImageName: String {
        CryptoFormatter.arrowInfo(for: crypto.priceChange).name
    }
    
    var arrowColor: UIColor {
        CryptoFormatter.arrowInfo(for: crypto.priceChange).color
    }
    
    var marketCapFormatted: String {
        if let cap = crypto.marketCap {
            return CryptoFormatter.formatMarketCap(cap)
        } else {
            return "—"
        }
    }
    
    var circulatingSupplyFormatted: String {
        if let circ = crypto.circulatingSupply {
            return CryptoFormatter.formatCirculatingSupply(circ, symbol: crypto.symbol)
        } else {
            return "—"
        }
    }
    
    // MARK: - Callbacks
    
    var onPeriodChanged: ((CryptoPeriod) -> Void)?
    
    // MARK: - Init
    
    init(crypto: Crypto) {
        self.crypto = crypto
    }
    
    // MARK: - Actions
    
    func setPeriod(index: Int) {
        guard let period = CryptoPeriod(rawValue: index) else { return }
        selectedPeriod = period
    }
}
