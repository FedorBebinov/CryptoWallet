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
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        let value = formatter.string(from: NSNumber(value: crypto.price)) ?? "\(crypto.price)"
        return "$" + value
    }

    var priceChangeFormatted: String {
        let sign = crypto.priceChange >= 0 ? "▲" : "▼"
        let percent = String(format: "%.2f%%", abs(crypto.priceChange))
        return "\(sign) \(percent)"
    }

    var priceChangeColor: UIColor {
        crypto.priceChange >= 0 ? UIColor(red: 44/255, green: 168/255, blue: 95/255, alpha: 1) : UIColor.systemRed
    }

    var marketCapFormatted: String {
        // Здесь для демонстрации
        return "$231,233"
    }
    var circulatingSupplyFormatted: String {
        return "114.211 \(crypto.symbol)"
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
