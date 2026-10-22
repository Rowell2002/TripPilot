//
//  ThemeAppearanceMode.swift
//  TripPilot
//
//  Theme Mode & Color Scheme Management
//

import SwiftUI

public enum ThemeAppearanceMode: String, CaseIterable, Identifiable {
    case light = "Light"
    case dark = "Dark"
    case auto = "Auto"
    
    public var id: String { rawValue }
    
    public var colorScheme: ColorScheme? {
        switch self {
        case .dark:
            return .dark
        case .light:
            return .light
        case .auto:
            return nil
        }
    }
    
    public var iconName: String {
        switch self {
        case .light:
            return "sun.max.fill"
        case .dark:
            return "moon.stars.fill"
        case .auto:
            return "circle.righthalf.filled"
        }
    }
}
