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
    
    static let marketCapFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.groupingSeparator = ","
        f.locale = Locale(identifier: "en_US")
        f.minimumFractionDigits = 0
        f.maximumFractionDigits = 0
        return f
    }()
    
    static let supplyFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.locale = Locale(identifier: "en_US")
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        return f
    }()
    
    static func formatAbbreviated(_ value: Double, suffix: String? = nil) -> String {
        let absValue = abs(value)
        let billion = 1_000_000_000.0
        let million = 1_000_000.0
        let thousand = 1_000.0
        
        let formatted: String
        if absValue >= billion {
            formatted = String(format: "%.1fB", absValue / billion)
        } else if absValue >= million {
            formatted = String(format: "%.1fM", absValue / million)
        } else if absValue >= thousand {
            formatted = String(format: "%.1fK", absValue / thousand)
        } else {
            formatted = String(format: "%.2f", absValue)
        }
        return suffix != nil ? "\(formatted) \(suffix!)" : formatted
    }
    
    static func formatMarketCap(_ value: Double) -> String {
        let absValue = abs(value)
        let trillion = 1_000_000_000_000.0
        if absValue >= trillion {
            return String(format: "$%.1fT", absValue / trillion)
        } else {
            return "$" + formatAbbreviated(value)
        }
    }
    
    static func formatCirculatingSupply(_ value: Double, symbol: String) -> String {
        return formatAbbreviated(value, suffix: symbol)
    }
    
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
            return ("arrowUp", .systemGreen)
        } else {
            return ("arrowDown", .systemRed)
        }
    }
}
