import Testing
import Foundation
import SwiftUI
@testable import TripPilot

@Suite("Sri Lanka Domain & Hardware Services Suite")
struct SriLankaDataServiceAndDomainTests {
    
    @Test("Sri Lanka Places Database Integrity & Geocoordinates")
    func testPlacesDatabaseIntegrity() {
        let places = SriLankaDataService.shared.places
        #expect(!places.isEmpty)
        
        // Sri Lanka bounding box: Latitude 5.8 to 9.9, Longitude 79.5 to 82.0
        for place in places {
            #expect(!place.name.isEmpty)
            #expect(!place.district.isEmpty)
            #expect(!place.province.isEmpty)
            #expect(!place.description.isEmpty)
            #expect(place.rating >= 0.0 && place.rating <= 5.0)
            #expect(place.entryFeeLKR >= 0)
            #expect(place.entryFeeUSD >= 0.0)
            
            // Geographic validation
            #expect(place.latitude >= 5.8 && place.latitude <= 9.9)
            #expect(place.longitude >= 79.5 && place.longitude <= 82.0)
        }
    }
    
    @Test("Spatial Audio Guide Player Scrubbing & Skip Clamping")
    @MainActor
    func testSpatialAudioGuideSkip() {
        let player = SpatialAudioGuidePlayer.shared
        
        // Seek to 50%
        player.seek(to: 0.5)
        #expect(player.progress == 0.5)
        
        // Skip backward to start (must clamp to 0.0)
        player.skip(seconds: -500.0)
        #expect(player.progress == 0.0)
        
        // Skip forward beyond duration (must clamp to 1.0)
        player.skip(seconds: 1000.0)
        #expect(player.progress == 1.0)
        
        // Jump to first chapter
        if let firstChapter = player.chapters.first {
            player.jumpToChapter(firstChapter)
            #expect(player.currentChapterIndex == firstChapter.id)
            #expect(player.progress == 0.0)
        }
    }
    
    @Test("Step Tracker Distance, Calories, and Goal Percentage Formulas")
    @MainActor
    func testStepTrackerCalculations() {
        let tracker = TripStepTrackerService.shared
        
        // Test step goal progress
        tracker.todaySteps = 5000
        tracker.dailyGoal = 10000
        
        #expect(tracker.goalProgress == 0.5)
        #expect(tracker.goalPercentText == "50%")
        
        // Distance calculation: 5000 steps * 0.00076 km/step = 3.8 km
        let expectedKm = 5000.0 * 0.00076
        #expect(abs(tracker.distanceKm - expectedKm) < 0.0001)
        
        // Active calories: 5000 * 0.041 = 205 kcal
        #expect(tracker.activeCalories == 205)
        
        // Active minutes: 5000 / 100 = 50 min
        #expect(tracker.activeMinutes == 50)
    }
    
    @Test("Navigation Router Tab Switching and Bar Visibility")
    @MainActor
    func testNavigationRouter() {
        let router = AppNavigationRouter.shared
        
        router.switchTab(to: .itinerary)
        #expect(router.selectedTab == .itinerary)
        
        router.switchTab(to: .map)
        #expect(router.selectedTab == .map)
        
        router.switchTab(to: .budget)
        #expect(router.selectedTab == .budget)
        
        router.switchTab(to: .profile)
        #expect(router.selectedTab == .profile)
        
        router.switchTab(to: .home)
        #expect(router.selectedTab == .home)
        
        router.isBottomBarVisible = false
        #expect(router.isBottomBarVisible == false)
        
        router.isBottomBarVisible = true
        #expect(router.isBottomBarVisible == true)
    }
    
    @Test("Theme Appearance Mode Color Scheme Resolution")
    func testThemeAppearanceMode() {
        let dark = ThemeAppearanceMode.dark
        #expect(dark.colorScheme == .dark)
        
        let light = ThemeAppearanceMode.light
        #expect(light.colorScheme == .light)
        
        let auto = ThemeAppearanceMode.auto
        #expect(auto.colorScheme == nil)
    }
}
