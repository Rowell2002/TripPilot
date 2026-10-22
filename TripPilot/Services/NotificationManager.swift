//
//  NotificationManager.swift
//  TripPilot
//
//  Created for TripPilot Geofenced Landmark Alerts & Audio Guide.
//

import SwiftUI
import UserNotifications
import Combine

public struct GeofenceLandmarkData: Identifiable, Hashable {
    public let id: String
    public var name: String
    public var locationName: String
    public var distanceAway: String
    public var historicBadge: String
    public var photoCount: String
    public var estYear: String
    public var ward: String
    public var audioDuration: String
    public var audioTitle: String
    public var narratorName: String
    public var narratorOrg: String
    public var quoteText: String
    public var quoteHighlight: String
    public var factTitle: String
    public var factDetail: String
    public var etiquetteTitle: String
    public var etiquetteDetail: String
    public var cachedSizeMB: String
    public var imageURLString: String
    public var isAirPodsReady: Bool
    
    public init(
        id: String = UUID().uuidString,
        name: String,
        locationName: String,
        distanceAway: String,
        historicBadge: String,
        photoCount: String,
        estYear: String,
        ward: String,
        audioDuration: String,
        audioTitle: String,
        narratorName: String,
        narratorOrg: String,
        quoteText: String,
        quoteHighlight: String,
        factTitle: String,
        factDetail: String,
        etiquetteTitle: String,
        etiquetteDetail: String,
        cachedSizeMB: String,
        imageURLString: String,
        isAirPodsReady: Bool = true
    ) {
        self.id = id
        self.name = name
        self.locationName = locationName
        self.distanceAway = distanceAway
        self.historicBadge = historicBadge
        self.photoCount = photoCount
        self.estYear = estYear
        self.ward = ward
        self.audioDuration = audioDuration
        self.audioTitle = audioTitle
        self.narratorName = narratorName
        self.narratorOrg = narratorOrg
        self.quoteText = quoteText
        self.quoteHighlight = quoteHighlight
        self.factTitle = factTitle
        self.factDetail = factDetail
        self.etiquetteTitle = etiquetteTitle
        self.etiquetteDetail = etiquetteDetail
        self.cachedSizeMB = cachedSizeMB
        self.imageURLString = imageURLString
        self.isAirPodsReady = isAirPodsReady
    }
    
    public static let defaultShibuya = GeofenceLandmarkData(
        id: "hachiko_shibuya",
        name: "Hachiko Memorial Plaza",
        locationName: "Shibuya Crossing & Hachiko Plaza",
        distanceAway: "45m away",
        historicBadge: "Tokyo Historic Monument",
        photoCount: "1 of 12",
        estYear: "Est. 1934",
        ward: "Shibuya Ward, Tokyo",
        audioDuration: "3 min 42 sec",
        audioTitle: "The Legend of Hachiko: Faithfulness Across Generations",
        narratorName: "Kenji Takahashi",
        narratorOrg: "Shibuya Folk Museum",
        quoteText: "waiting through Tokyo rain and snow for Professor Ueno's evening commute train...",
        quoteHighlight: "\"Every afternoon at precisely 3:00 PM, Hachiko would sit patiently outside Shibuya Station's ticket barrier,\"",
        factTitle: "The Original Bronze Was Melted in WWII",
        factDetail: "The original 1934 statue was recycled for locomotive parts during the Pacific War. The current beloved memorial was sculpted in 1948 by Takeshi Ando—the son of the original artist.",
        etiquetteTitle: "Queueing for Landmark Photographs",
        etiquetteDetail: "Visitors form a single respectful queue along the tree line to photograph the statue. Stepping directly onto the bronze plinth or leaving food offerings is kindly discouraged.",
        cachedSizeMB: "18 MB HD Audio & AR Cached",
        imageURLString: "https://images.unsplash.com/photo-1542051841857-5f90071e7989?q=80&w=1200&auto=format&fit=crop",
        isAirPodsReady: true
    )
    
    public static let sigiriyaSriLanka = GeofenceLandmarkData(
        id: "sigiriya_rock",
        name: "Sigiriya Lion Rock Fortress",
        locationName: "Sigiriya Ancient Citadel Perimeter",
        distanceAway: "30m away",
        historicBadge: "UNESCO World Heritage Site",
        photoCount: "1 of 16",
        estYear: "Est. 5th Century AD",
        ward: "Matale District, Central Province",
        audioDuration: "4 min 15 sec",
        audioTitle: "King Kashyapa's Sky Palace & The Mirror Wall",
        narratorName: "Dr. Anura Senanayake",
        narratorOrg: "Central Cultural Fund",
        quoteText: "rising 200 meters above the emerald jungle canopy, adorned with vibrant celestial frescoes...",
        quoteHighlight: "\"Carved into a massive sheer granite monolith, the lion's paw gateway once guarded the royal path to the celestial gardens,\"",
        factTitle: "The Ancient Hydraulic Wonder",
        factDetail: "The subterranean water gardens at Sigiriya still operate today using ingenious gravity-fed fountains that activate during monsoon season.",
        etiquetteTitle: "Preserving the Ancient Frescoes",
        etiquetteDetail: "Flash photography and touching the plaster surfaces along the Spiral Staircase is strictly prohibited to preserve the natural mineral pigments.",
        cachedSizeMB: "24 MB HD Audio & AR Cached",
        imageURLString: "https://images.unsplash.com/photo-1586861635167-e5223aadc9fe?q=80&w=1200&auto=format&fit=crop",
        isAirPodsReady: true
    )
}

public struct AppNotificationItem: Identifiable, Hashable {
    public let id: String
    public var title: String
    public var subtitle: String
    public var body: String
    public var timestamp: Date
    public var isRead: Bool
    public var type: NotificationType
    public var landmarkData: GeofenceLandmarkData?
    
    public enum NotificationType: String, Hashable {
        case geofence
        case weather
        case travelAlert
        case general
    }
    
    public init(
        id: String = UUID().uuidString,
        title: String,
        subtitle: String,
        body: String,
        timestamp: Date = Date(),
        isRead: Bool = false,
        type: NotificationType = .geofence,
        landmarkData: GeofenceLandmarkData? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.body = body
        self.timestamp = timestamp
        self.isRead = isRead
        self.type = type
        self.landmarkData = landmarkData
    }
}

@MainActor
public final class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    public static let shared = NotificationManager()
    
    @Published public var notifications: [AppNotificationItem] = []
    @Published public var activeGeofenceAlert: GeofenceLandmarkData? = nil
    @Published public var isNotificationsInboxPresented: Bool = false
    @Published public var isPermissionGranted: Bool = false
    
    public var unreadCount: Int {
        notifications.filter { !$0.isRead }.count
    }
    
    override private init() {
        super.init()
        // Pre-populate with initial geofence notification as requested
        let initialAlert = AppNotificationItem(
            id: "initial_hachiko_geofence",
            title: "Geofence Triggered • 45m away",
            subtitle: "Hachiko Memorial Plaza",
            body: "You entered the landmark boundary. Tap to listen to the exclusive spatial audio guide.",
            timestamp: Date(),
            isRead: false,
            type: .geofence,
            landmarkData: .defaultShibuya
        )
        
        let weatherAlert = AppNotificationItem(
            id: "weather_update",
            title: "Tropical Weather Window",
            subtitle: "Golden Hour Forecast",
            body: "Optimal lighting conditions detected around Shibuya & Yoyogi Park for the next 2 hours.",
            timestamp: Date().addingTimeInterval(-3600),
            isRead: true,
            type: .weather,
            landmarkData: nil
        )
        
        self.notifications = [initialAlert, weatherAlert]
        setupNotificationCenter()
    }
    
    public func setupNotificationCenter() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        center.getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                self?.isPermissionGranted = (settings.authorizationStatus == .authorized)
            }
        }
    }
    
    public func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            DispatchQueue.main.async {
                self?.isPermissionGranted = granted
                if let error = error {
                    print("⚠️ Notification authorization error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    /// Trigger a push notification for a geofenced landmark and add it to the inbox
    public func triggerGeofenceAlert(for landmark: GeofenceLandmarkData = .defaultShibuya) {
        // 1. Add to In-App Notifications
        let notificationItem = AppNotificationItem(
            id: UUID().uuidString,
            title: "Geofence Triggered • \(landmark.distanceAway)",
            subtitle: landmark.name,
            body: "You entered the landmark boundary. Tap to listen to the exclusive spatial audio guide.",
            timestamp: Date(),
            isRead: false,
            type: .geofence,
            landmarkData: landmark
        )
        
        // Insert at beginning
        notifications.insert(notificationItem, at: 0)
        
        // 2. Schedule Local Push Notification
        let content = UNMutableNotificationContent()
        content.title = "📍 Geofence Alert • \(landmark.distanceAway)"
        content.subtitle = landmark.name
        content.body = "You are near \(landmark.locationName). Tap to listen to '\(landmark.audioTitle)'."
        content.sound = .default
        content.badge = NSNumber(value: unreadCount)
        content.userInfo = [
            "landmarkId": landmark.id,
            "type": "geofence"
        ]
        
        // Fire after 1 second
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(
            identifier: "geofence_\(landmark.id)_\(Date().timeIntervalSince1970)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("⚠️ Error scheduling push notification: \(error.localizedDescription)")
            }
        }
    }
    
    public func markAsRead(_ item: AppNotificationItem) {
        if let index = notifications.firstIndex(where: { $0.id == item.id }) {
            notifications[index].isRead = true
        }
    }
    
    public func markAllAsRead() {
        for index in notifications.indices {
            notifications[index].isRead = true
        }
    }
    
    public func deleteNotification(id: String) {
        notifications.removeAll(where: { $0.id == id })
    }
    
    public func openLandmarkDetail(_ landmark: GeofenceLandmarkData) {
        self.activeGeofenceAlert = landmark
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    
    // Allow notifications to appear while app is in foreground
    nonisolated public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }
    
    // User tapped the system push notification
    nonisolated public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        let landmarkId = userInfo["landmarkId"] as? String
        
        Task { @MainActor in
            if landmarkId == GeofenceLandmarkData.sigiriyaSriLanka.id {
                self.openLandmarkDetail(GeofenceLandmarkData.sigiriyaSriLanka)
            } else {
                self.openLandmarkDetail(GeofenceLandmarkData.defaultShibuya)
            }
        }
        
        completionHandler()
    }
}
