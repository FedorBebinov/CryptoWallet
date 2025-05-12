//
//  Font+Extension.swift
//  Crypto wallet
//
//  Created by Fedor Bebinov on 09.05.2025.
//

import UIKit

enum Font {
    static let regular = "Poppins-Regular"
    static let bold = "Poppins-Bold"
    static let semiBold = "Poppins-SemiBold"
}

extension UIFont {
    static func poppinsRegular(size: CGFloat) -> UIFont {
        return UIFont(name: Font.regular, size: size)!
    }
    
    static func poppinsBold(size: CGFloat) -> UIFont {
        return UIFont(name: Font.bold, size: size)!
    }
    
    static func poppinsSemiBold(size: CGFloat) -> UIFont {
        return UIFont(name: Font.semiBold, size: size)!
    }
}


