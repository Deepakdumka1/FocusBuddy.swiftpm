import SwiftUI

extension Color {
    // Premium Palette
    static let midnightBlue = Color(red: 0.02, green: 0.02, blue: 0.08) // Darker, richer blue
    static let candleWax = Color(red: 0.96, green: 0.94, blue: 0.88) // Warm Cream
    static let candleFlame = Color(red: 1.0, green: 0.6, blue: 0.2) // Orange
    static let softOrange = Color(red: 1.0, green: 0.8, blue: 0.5)
    static let luxuryGold = Color(red: 0.85, green: 0.75, blue: 0.45) // Muted Gold
    static let glassBackground = Color.white.opacity(0.08)
    
    // iOS 26 "Fluid Spatial" Palette
    static let deepSpace = Color(red: 0.0, green: 0.0, blue: 0.05)
    static let neonBlue = Color(red: 0.2, green: 0.2, blue: 1.0)
    static let electricPurple = Color(red: 0.6, green: 0.1, blue: 1.0)
    static let vividOrange = Color(red: 1.0, green: 0.4, blue: 0.1)
    
    static let glassMaterial = Color.white.opacity(0.1)
    static let glassBorder = Color.white.opacity(0.2)
    
    // Mesh Gradient Colors
    static let meshColors: [Color] = [
        .deepSpace, .neonBlue.opacity(0.3), .electricPurple.opacity(0.3), .deepSpace
    ]
}
