//
//  StyleGuide.swift
//  Munchies
//
//  Created by Brad Woodard on 10/21/25.
//

import SwiftUI

// MARK: - Custom Fonts
extension Font {
    static func poppins(size: CGFloat) -> Font {
        return Font.custom("Poppins-Medium", size: size)
    }
    static func inter(size: CGFloat) -> Font {
        return Font.custom("Inter-Regular_Medium", size: size)
    }
    static func helvetica(size: CGFloat) -> Font {
        return Font.custom("Helvetica", size: size)
    }
    static func helveticaBold(size: CGFloat) -> Font {
        return Font.custom("Helvetica-Bold", size: size)
    }
    

    // MARK: - Title Styles
    static let title1 = Font.system(size: 18, weight: .regular)
    static let title2 = Font.system(size: 14, weight: .regular)

    // MARK: - Subtitle Styles
    static let subtitle1 = Font.system(size: 12, weight: .regular)

    // MARK: - Footer Styles
    static let footer1 = Font.system(size: 10, weight: .regular)

    // MARK: - Headline Styles
    static let headline1 = Font.system(size: 24, weight: .regular)
    static let headline2 = Font.system(size: 16, weight: .regular)
}

// MARK: - Colors

extension Color {
    // Text Colors
    static let darkText = Color(hex: "1F2B2E")
    static let lightText = Color(hex: "FFFFFF")
    static let ratingText = Color(hex: "50555C")

    // Subtitle
    static let subtitle = Color(hex: "999999")

    // Background
    static let background = Color(hex: "F8F8F8")

    // Selected
    static let selected = Color(hex: "E2A364")

    // Positive
    static let positive = Color(hex: "2ECC71")

    // Negative
    static let negative = Color(hex: "C0392B")
    
    // Star
    static let star = Color(hex: "F9CA24")

    // Primary (for accents, buttons, etc.)
    static let primary = Color.blue
}

// MARK: - Color Hex Initializer

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
