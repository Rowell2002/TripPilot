import Testing
import Foundation
import MapKit
import PDFKit
@testable import TripPilot

@Suite("Explore Map, Push Notifications & PDF Generation Suite")
struct ExploreMapNotificationsAndPDFTests {
    
    @Test("Explore Map Category Filter and Search Query Filtering")
    @MainActor
    func testMapFilteringAndSearch() {
        let mapVM = ExploreMapViewModel()
        
        // 1. All Pins filter
        mapVM.selectedFilter = .allPins
        #expect(!mapVM.displayPlaces.isEmpty)
        let totalCount = mapVM.displayPlaces.count
        
        // 2. UNESCO filter
        mapVM.selectedFilter = .unesco
        for place in mapVM.displayPlaces {
            #expect(place.isUNESCO == true)
        }
        
        // 3. Search query filter
        mapVM.selectedFilter = .allPins
        mapVM.searchText = "Galle"
        let searchResults = mapVM.displayPlaces
        #expect(!searchResults.isEmpty)
        for place in searchResults {
            let matches = place.name.localizedCaseInsensitiveContains("Galle") ||
                          place.district.localizedCaseInsensitiveContains("Galle") ||
                          place.province.localizedCaseInsensitiveContains("Galle")
            #expect(matches == true)
        }
        
        // Clear search
        mapVM.searchText = ""
        #expect(mapVM.displayPlaces.count == totalCount)
    }
    
    @Test("Explore Map Route Coordinates Generation")
    @MainActor
    func testMapRouteCoordinates() {
        let mapVM = ExploreMapViewModel()
        let coords = mapVM.todayRouteCoordinates
        
        // Coordinates should match stops with valid coordinates
        #expect(coords.count <= mapVM.todayStops.count)
        for coord in coords {
            #expect(coord.latitude >= 5.0 && coord.latitude <= 10.0)
            #expect(coord.longitude >= 79.0 && coord.longitude <= 82.5)
        }
    }
    
    @Test("Notification Inbox Read State and Geofence Alert Triggering")
    @MainActor
    func testNotificationLifecycle() {
        let manager = NotificationManager.shared
        
        // Ensure starting state
        #expect(!manager.notifications.isEmpty)
        
        // Trigger geofence alert for Sigiriya
        let initialCount = manager.notifications.count
        manager.triggerGeofenceAlert(for: GeofenceLandmarkData.sigiriyaSriLanka)
        
        #expect(manager.notifications.count == initialCount + 1)
        let latest = manager.notifications.first!
        #expect(latest.subtitle == "Sigiriya Lion Rock Fortress")
        #expect(latest.type == .geofence)
        #expect(latest.isRead == false)
        
        // Mark as read
        manager.markAsRead(latest)
        #expect(manager.notifications.first?.isRead == true)
        
        // Mark all as read
        manager.markAllAsRead()
        #expect(manager.unreadCount == 0)
        for notification in manager.notifications {
            #expect(notification.isRead == true)
        }
        
        // Delete notification
        manager.deleteNotification(id: latest.id)
        #expect(manager.notifications.count == initialCount)
        #expect(!manager.notifications.contains(where: { $0.id == latest.id }))
    }
    
    @Test("Passport PDF Document Generation and Binary Data Verification")
    func testPassportPDFGeneration() {
        let generator = PassportPDFGenerator.shared
        let customData = PassportPDFData(
            travelerName: "Dr. Kenji Takahashi",
            passportNumber: "LK-9824-CEYLON",
            year: "2024",
            countriesCount: 1,
            distanceKm: "5,120 km",
            itinerariesCount: 4,
            carbonOffset: "100% Certified Carbon Neutral",
            verifiedDestinations: [
                "Sigiriya Lion Rock Citadel",
                "Temple of the Sacred Tooth Relic",
                "Galle Maritime Ramparts"
            ],
            badgesUnlocked: 18
        )
        
        let pdfData = generator.generatePDF(data: customData)
        
        // Binary verification
        #expect(!pdfData.isEmpty)
        #expect(pdfData.count > 2048) // A full page PDF with drawing paths is well over 2KB
        
        // PDFKit parsing verification
        let pdfDocument = PDFDocument(data: pdfData)
        #expect(pdfDocument != nil)
        #expect(pdfDocument?.pageCount == 1)
    }
}
