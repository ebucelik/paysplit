//
//  AppStyler.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 08.08.24.
//

import UIKit
import SwiftUI

class AppStyler {
    static let shared = AppStyler()

    fileprivate init() {}

    enum Color {
        case primary
        case secondary
        case divider
        case success
        case error
        case info
    }

    enum Font {
        case title(FontWeight, size: CGFloat = 30)
        case title1(FontWeight, size: CGFloat = 26)
        case title2(FontWeight, size: CGFloat = 22)
        case subtitle(FontWeight, size: CGFloat = 20)
        case subtitle1(FontWeight, size: CGFloat = 18)
        case body(FontWeight, size: CGFloat = 16)
        case body1(FontWeight, size: CGFloat = 14)
        case body2(FontWeight, size: CGFloat = 12)
        case caption(FontWeight, size: CGFloat = 10)
    }

    enum FontWeight: String {
        case regular = "Regular"
        case bold = "Bold"
        case light = "Light"
        case italic = "Italic"
        case hairline = "Hairline"
        case black = "Black"
    }

    func color(_ color: Color) -> UIColor {
        switch color {
        case .primary:
            return .black
        case .secondary:
            return .white
        case .divider:
            return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        case .success:
            return #colorLiteral(red: 0, green: 0.5972192287, blue: 0, alpha: 1)
        case .error:
            return #colorLiteral(red: 0.6584659219, green: 0, blue: 0.05306704342, alpha: 1)
        case .info:
            return #colorLiteral(red: 0.6472735405, green: 0.6472735405, blue: 0.6472735405, alpha: 1)
        }
    }

    func font(_ font: Font) -> SwiftUI.Font {
        switch font {
        case let .title(fontWeight, size):
            return .custom("Lato-\(fontWeight.rawValue)", size: size)
        case let .title1(fontWeight, size):
            return .custom("Lato-\(fontWeight.rawValue)", size: size)
        case let .title2(fontWeight, size):
            return .custom("Lato-\(fontWeight.rawValue)", size: size)
        case let .subtitle(fontWeight, size):
            return .custom("Lato-\(fontWeight.rawValue)", size: size)
        case let .subtitle1(fontWeight, size):
            return .custom("Lato-\(fontWeight.rawValue)", size: size)
        case let .body(fontWeight, size):
            return .custom("Lato-\(fontWeight.rawValue)", size: size)
        case let .body1(fontWeight, size):
            return .custom("Lato-\(fontWeight.rawValue)", size: size)
        case let .body2(fontWeight, size):
            return .custom("Lato-\(fontWeight.rawValue)", size: size)
        case let .caption(fontWeight, size):
            return .custom("Lato-\(fontWeight.rawValue)", size: size)
        }
    }
}

extension UIColor {
    var color: Color {
        Color(uiColor: self)
    }
}

extension Color {
    static func app(_ color: AppStyler.Color) -> Color {
        AppStyler.shared.color(color).color
    }
}

extension Font {
    static func app(_ font: AppStyler.Font) -> Font {
        AppStyler.shared.font(font)
    }
}
