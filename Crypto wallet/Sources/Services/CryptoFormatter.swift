//
//  CryptoFormatter.swift
//  Crypto wallet
//
//  Created by Fedor Bebinov on 12.05.2025.
//

import UIKit

struct CryptoFormatter {
    static let priceFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.locale = Locale(identifier: "en_US")
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        return f
    }()

    static let percentFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.minimumFractionDigits = 1
        f.maximumFractionDigits = 1
        f.numberStyle = .decimal
        f.locale = Locale(identifier: "en_US")
        return f
    }()

    static func formatPrice(_ value: Double) -> String {
        let str = priceFormatter.string(from: NSNumber(value: value)) ?? "\(value)"
        return "$\(str)"
    }

    static func formatPercent(_ value: Double) -> String {
        let str = percentFormatter.string(from: NSNumber(value: abs(value))) ?? "\(abs(value))"
        return "\(str)%"
    }

    static func arrowInfo(for change: Double) -> (name: String, color: UIColor) {
        if change >= 0 {
            return ("arrow.up", .systemGreen)
        } else {
            return ("arrow.down", .systemRed)
        }
    }
}
