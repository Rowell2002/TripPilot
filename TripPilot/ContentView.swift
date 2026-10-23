//
//  ContentView.swift
//  TripPilot
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var authViewModel = AuthViewModel.shared
    @ObservedObject private var notificationManager = NotificationManager.shared
    @State private var activeLandmark: GeofenceLandmarkData? = nil
    
    var body: some View {
        NavigationStack {
            if authViewModel.isAuthenticated || authViewModel.isGuestSession {
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
    }
}

#Preview {
    ContentView()
}
