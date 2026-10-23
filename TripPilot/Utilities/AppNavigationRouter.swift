//
//  AppNavigationRouter.swift
//  TripPilot
//
//  Created for TripPilot - Unified Root Tab Navigation
//

import SwiftUI
import Combine

@MainActor
final class AppNavigationRouter: ObservableObject {
    static let shared = AppNavigationRouter()
    
    @Published var selectedTab: AppTab = .home
    @Published var isBottomBarVisible: Bool = true
    
    private init() {}
    
    func switchTab(to tab: AppTab) {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
            selectedTab = tab
        }
    }
}
