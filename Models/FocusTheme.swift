import SwiftUI

enum FocusTheme: String, CaseIterable, Identifiable {
    case candle
    case ice
    case portal
    case hourglass
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .candle: return "Candle"
        case .ice: return "Ice"
        case .portal: return "Portal"
        case .hourglass: return "Hourglass"
        }
    }
    
    var icon: String {
        switch self {
        case .candle: return "flame.fill"
        case .ice: return "snowflake"
        case .portal: return "circle.hexagongrid.fill"
        case .hourglass: return "hourglass"
        }
    }
    
    // Theme-specific colors could go here or in Theme.swift
    var mainColor: Color {
        switch self {
        case .candle: return .vividOrange
        case .ice: return .cyan
        case .portal: return .electricPurple
        case .hourglass: return .luxuryGold
        }
    }
}
