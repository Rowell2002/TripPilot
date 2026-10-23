//
//  ContentView.swift
//  TripPilot
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var notificationManager = NotificationManager.shared
    @State private var activeLandmark: GeofenceLandmarkData? = nil
    
    var body: some View {
        NavigationStack {
            HomeDashboardView()
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
