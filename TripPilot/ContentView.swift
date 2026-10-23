//
//  ContentView.swift
//  TripPilot
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var authViewModel = AuthViewModel.shared
    @ObservedObject private var notificationManager = NotificationManager.shared
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @State private var activeLandmark: GeofenceLandmarkData? = nil
    @State private var isSplashActive: Bool = true
    
    var body: some View {
        ZStack {
            NavigationStack {
                if !hasCompletedOnboarding {
                    AppOnboardingView {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            hasCompletedOnboarding = true
                        }
                    }
                } else if authViewModel.isAuthenticated || authViewModel.isGuestSession {
                    HomeDashboardView()
                } else {
                    WelcomeLandingView()
                }
            }
            .fullScreenCover(item: $activeLandmark) { landmark in
                GeofencedAudioGuideDetailView(landmark: landmark)
            }
            .onReceive(notificationManager.$activeGeofenceAlert) { landmark in
                if let landmark = landmark {
                    self.activeLandmark = landmark
                }
            }
            
            // Animated Splash Screen Overlay
            if isSplashActive {
                SplashScreenView {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isSplashActive = false
                    }
                }
                .transition(.opacity)
                .zIndex(100)
            }
        }
    }
}

#Preview {
    ContentView()
}
