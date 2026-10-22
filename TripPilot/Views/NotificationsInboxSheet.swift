//
//  NotificationsInboxSheet.swift
//  TripPilot
//
//  Created for In-App Notifications & Geofence Alert Triggering.
//

import SwiftUI

public struct NotificationsInboxSheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var notificationManager = NotificationManager.shared
    
    // Theme Colors
    private let bgCanvas = Color(red: 15/255, green: 19/255, blue: 28/255)       // #0f131c
    private let cardSurface = Color(red: 24/255, green: 28/255, blue: 36/255)     // #181c24
    private let darkDock = Color(red: 10/255, green: 14/255, blue: 22/255)       // #0a0e16
    private let primaryCyan = Color(red: 56/255, green: 189/255, blue: 248/255)  // #38bdf8
    private let secondaryMint = Color(red: 68/255, green: 226/255, blue: 205/255)// #44e2cd
    private let borderStroke = Color.white.opacity(0.08)
    private let slateMuted = Color(red: 148/255, green: 163/255, blue: 184/255)  // #94a3b8
    
    // Callback to open detail directly
    public var onSelectLandmark: ((GeofenceLandmarkData) -> Void)? = nil
    
    public init(onSelectLandmark: ((GeofenceLandmarkData) -> Void)? = nil) {
        self.onSelectLandmark = onSelectLandmark
    }
    
    public var body: some View {
        NavigationStack {
            ZStack {
                bgCanvas.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header Bar
                    headerBar
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 16) {
                            // Quick Simulation Panel for Testing
                            simulationTestingBox
                            
                            // Notifications Section Header
                            HStack {
                                Text("Recent Notifications")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                if notificationManager.unreadCount > 0 {
                                    Button(action: {
                                        withAnimation {
                                            notificationManager.markAllAsRead()
                                        }
                                    }) {
                                        Text("Mark all read")
                                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                                            .foregroundColor(primaryCyan)
                                    }
                                }
                            }
                            .padding(.top, 4)
                            
                            // Notification List
                            if notificationManager.notifications.isEmpty {
                                emptyStateView
                            } else {
                                ForEach(notificationManager.notifications) { item in
                                    notificationRow(item)
                                }
                            }
                            
                            Spacer(minLength: 40)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 14)
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            notificationManager.requestAuthorization()
        }
    }
    
    // MARK: - Header Bar
    private var headerBar: some View {
        HStack(spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "bell.badge.fill")
                    .font(.system(size: 18))
                    .foregroundColor(primaryCyan)
                
                Text("Notifications")
                    .font(.system(size: 19, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                
                if notificationManager.unreadCount > 0 {
                    Text("\(notificationManager.unreadCount) new")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundColor(Color(red: 10/255, green: 14/255, blue: 22/255))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(primaryCyan)
                        .clipShape(Capsule())
                }
            }
            
            Spacer()
            
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(slateMuted)
                    .frame(width: 32, height: 32)
                    .background(Color.white.opacity(0.08))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(cardSurface)
        .overlay(
            Rectangle()
                .fill(borderStroke)
                .frame(height: 1),
            alignment: .bottom
        )
    }
    
    // MARK: - Simulation Testing Box
    private var simulationTestingBox: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "antenna.radiowaves.left.and.right")
                    .font(.system(size: 14))
                    .foregroundColor(secondaryMint)
                
                Text("GEOFENCE RADAR SIMULATOR")
                    .font(.system(size: 10, weight: .heavy, design: .rounded))
                    .foregroundColor(secondaryMint)
                    .tracking(0.8)
            }
            
            Text("Trigger Geofence Detection")
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text("Simulates entering a landmark boundary. Dispatches an iOS Push Banner and updates the notification list below. Tapping navigates to the Stitch Audio Guide UI.")
                .font(.system(size: 12, weight: .regular, design: .rounded))
                .foregroundColor(slateMuted)
                .lineSpacing(3)
            
            HStack(spacing: 10) {
                // Shibuya Hachiko Trigger
                Button(action: {
                    withAnimation {
                        notificationManager.triggerGeofenceAlert(for: .defaultShibuya)
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 12))
                        Text("Tokyo Hachiko (45m)")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(.black)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 9)
                    .background(
                        LinearGradient(
                            colors: [primaryCyan, secondaryMint],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
                    .shadow(color: primaryCyan.opacity(0.3), radius: 6)
                }
                
                // Sigiriya Trigger
                Button(action: {
                    withAnimation {
                        notificationManager.triggerGeofenceAlert(for: .sigiriyaSriLanka)
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "building.columns.fill")
                            .font(.system(size: 12))
                        Text("Sigiriya Rock (30m)")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 9)
                    .background(Color.white.opacity(0.1))
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(borderStroke, lineWidth: 1))
                }
            }
        }
        .padding(14)
        .background(cardSurface.opacity(0.9))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(primaryCyan.opacity(0.25), lineWidth: 1)
        )
    }
    
    // MARK: - Notification Row
    @ViewBuilder
    private func notificationRow(_ item: AppNotificationItem) -> some View {
        Button(action: {
            handleTapNotification(item)
        }) {
                HStack(alignment: .top, spacing: 12) {
                    // Leading Icon with pulsing/glow for geofence
                    ZStack {
                        Circle()
                            .fill(
                                item.type == .geofence
                                ? primaryCyan.opacity(0.18)
                                : Color.white.opacity(0.08)
                            )
                            .frame(width: 42, height: 42)
                        
                        Image(systemName: iconNameForType(item.type))
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(item.type == .geofence ? primaryCyan : slateMuted)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(item.title)
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                                .foregroundColor(item.isRead ? .white : primaryCyan)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            if !item.isRead {
                                Circle()
                                    .fill(primaryCyan)
                                    .frame(width: 7, height: 7)
                            }
                        }
                        
                        Text(item.subtitle)
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .lineLimit(1)
                        
                        Text(item.body)
                            .font(.system(size: 12, weight: .regular, design: .rounded))
                            .foregroundColor(slateMuted)
                            .lineLimit(2)
                            .lineSpacing(2)
                            .padding(.top, 1)
                        
                        if item.type == .geofence, let landmark = item.landmarkData {
                            HStack(spacing: 6) {
                                Image(systemName: "headphones")
                                    .font(.system(size: 11))
                                Text("Tap to open Audio Guide • \(landmark.audioDuration)")
                                    .font(.system(size: 11, weight: .bold, design: .rounded))
                            }
                            .foregroundColor(primaryCyan)
                            .padding(.top, 4)
                        }
                    }
                }
                .padding(14)
                .background(cardSurface)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            !item.isRead && item.type == .geofence
                            ? primaryCyan.opacity(0.4)
                            : borderStroke,
                            lineWidth: 1
                        )
                )
                .shadow(color: Color.black.opacity(0.2), radius: 6, y: 3)
            }
            .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "bell.slash.fill")
                .font(.system(size: 40))
                .foregroundColor(slateMuted.opacity(0.4))
                .padding(.top, 40)
            
            Text("No Notifications")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text("Geofence landmark triggers and travel alerts will appear here.")
                .font(.system(size: 13, weight: .regular, design: .rounded))
                .foregroundColor(slateMuted)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
    
    // MARK: - Helpers
    private func handleTapNotification(_ item: AppNotificationItem) {
        notificationManager.markAsRead(item)
        
        if let landmark = item.landmarkData {
            dismiss()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if let onSelectLandmark = onSelectLandmark {
                    onSelectLandmark(landmark)
                } else {
                    notificationManager.openLandmarkDetail(landmark)
                }
            }
        }
    }
    
    private func iconNameForType(_ type: AppNotificationItem.NotificationType) -> String {
        switch type {
        case .geofence:
            return "location.viewfinder"
        case .weather:
            return "sun.max.fill"
        case .travelAlert:
            return "exclamationmark.triangle.fill"
        case .general:
            return "bell.fill"
        }
    }
}

#Preview {
    NotificationsInboxSheet()
}
