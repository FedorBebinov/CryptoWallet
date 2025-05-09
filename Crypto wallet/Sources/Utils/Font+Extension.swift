//
//  Font+Extension.swift
//  Crypto wallet
//
//  Created by Fedor Bebinov on 09.05.2025.
//

import UIKit

enum Font {
    static let regular = "Poppins-Regular"
}

extension UIFont {
    static func poppinsRegular(size: CGFloat) -> UIFont {
        return UIFont(name: Font.regular, size: size)!
    }
}
