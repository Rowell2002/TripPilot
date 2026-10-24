import Testing
import Foundation
import SwiftUI
@testable import TripPilot

@Suite("Trip Wizard, Dashboard & Onboarding ViewModels Suite")
struct TripWizardAndDashboardViewModelsTests {
    
    @Test("Trip Wizard Destination Suggestions and Tag Toggling")
    @MainActor
    func testTripWizardInteractions() {
        let viewModel = TripWizardViewModel()
        
        // Test quick destination suggestion
        guard let suggestion = viewModel.quickSuggestions.first else { return }
        viewModel.selectSuggestion(suggestion)
        
        #expect(viewModel.selectedDestination == suggestion.name)
        #expect(viewModel.destinationSubtitle == suggestion.subtitle)
        #expect(viewModel.destinationFlag == suggestion.flag)
        #expect(viewModel.seasonText == suggestion.season)
        
        // Test tag toggle from selected to available
        guard let tagToToggle = viewModel.selectedTags.first else { return }
        let initialSelectedCount = viewModel.selectedTags.count
        let initialAvailableCount = viewModel.availableTags.count
        
        viewModel.toggleTag(tagToToggle)
        #expect(!viewModel.selectedTags.contains(tagToToggle))
        #expect(viewModel.availableTags.contains(tagToToggle))
        #expect(viewModel.selectedTags.count == initialSelectedCount - 1)
        #expect(viewModel.availableTags.count == initialAvailableCount + 1)
        
        // Toggle back
        viewModel.toggleTag(tagToToggle)
        #expect(viewModel.selectedTags.contains(tagToToggle))
        #expect(viewModel.selectedTags.count == initialSelectedCount)
        #expect(viewModel.availableTags.count == initialAvailableCount)
    }
    
    @Test("Home Dashboard Greeting and Notifications Count")
    @MainActor
    func testHomeDashboardMetrics() {
        let homeVM = HomeDashboardViewModel()
        
        // Greeting should never be empty
        #expect(!homeVM.userNameGreeting.isEmpty)
        
        // Unread notifications count matches manager
        #expect(homeVM.unreadNotificationsCount == NotificationManager.shared.unreadCount)
        
        // Active trip title is populated
        #expect(!homeVM.activeTrip.title.isEmpty)
        #expect(!homeVM.activeTrip.days.isEmpty)
    }
    
    @Test("Daily Itinerary Day Navigation and Audio State")
    @MainActor
    func testDailyItineraryNavigation() {
        let itineraryVM = DailyItineraryViewModel()
        
        let totalDays = itineraryVM.totalDaysCount
        #expect(totalDays > 0)
        
        // Select first day
        itineraryVM.selectDay(at: 0)
        #expect(itineraryVM.selectedDateIndex == 0)
        #expect(!itineraryVM.currentDay.title.isEmpty)
        
        // Out of bounds selection should be safely ignored
        itineraryVM.selectDay(at: 999)
        #expect(itineraryVM.selectedDateIndex == 0)
        
        itineraryVM.selectDay(at: -1)
        #expect(itineraryVM.selectedDateIndex == 0)
        
        // Audio playback toggle
        let audioStateBefore = itineraryVM.isAudioPlaying
        itineraryVM.toggleAudioPlayback()
        #expect(itineraryVM.isAudioPlaying != audioStateBefore)
        itineraryVM.toggleAudioPlayback()
        #expect(itineraryVM.isAudioPlaying == audioStateBefore)
    }
    
    @Test("Onboarding Navigation, Vibe Toggles and Completion")
    @MainActor
    func testOnboardingLifecycle() {
        let onboarding = OnboardingViewModel()
        
        #expect(onboarding.steps.count == 4)
        #expect(onboarding.currentStep == 0)
        #expect(!onboarding.isLastStep)
        
        // Next step
        onboarding.nextStep()
        #expect(onboarding.currentStep == 1)
        
        // Previous step
        onboarding.previousStep()
        #expect(onboarding.currentStep == 0)
        
        // Vibe toggle
        let testVibe = "🐘 Wildlife Safaris"
        let initialContains = onboarding.selectedTravelVibes.contains(testVibe)
        onboarding.toggleVibe(testVibe)
        #expect(onboarding.selectedTravelVibes.contains(testVibe) != initialContains)
        
        onboarding.toggleVibe(testVibe)
        #expect(onboarding.selectedTravelVibes.contains(testVibe) == initialContains)
        
        // Complete onboarding
        onboarding.completeOnboarding()
        #expect(onboarding.isCompleted == true)
        #expect(UserDefaults.standard.bool(forKey: "hasCompletedOnboarding") == true)
    }
}
