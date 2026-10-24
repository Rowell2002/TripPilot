//
//  TripWizardViewModel.swift
//  TripPilot
//
//  Created for TripPilot - MVVM Architecture
//

import SwiftUI
import Combine

@MainActor
final class TripWizardViewModel: ObservableObject {
    // MARK: - Published Destination & Travel Window
    @Published var selectedDestination: String = "Sigiriya & Ella Highlands"
    @Published var destinationSubtitle: String = "Sri Lanka • Cultural Triangle to Hill Country"
    @Published var destinationFlag: String = "🇱🇰"
    @Published var seasonText: String = "Tropical Sunshine & Mountain Mist"
    @Published var seasonBadge: String = "Year-Round Prime"
    
    @Published var selectedStartDate: Date = Date()
    @Published var travelDatesText: String = "Upcoming 7 Days"
    @Published var travelDaysCount: Int = 7
    @Published var travelDurationText: String = "7 Days • 6 Nights"
    @Published var weatherSummary: String = "Tropical Sunshine • 28°C"
    
    // MARK: - Published Persona & Preferences
    @Published var selectedCompanion: CompanionType = .couple
    @Published var selectedPace: RhythmPace = .balanced
    @Published var selectedBudget: BudgetTier = .comfort
    
    @Published var selectedTags: [String] = [
        "🏰 UNESCO Heritage",
        "🚂 Scenic Blue Train",
        "🐘 Wildlife Safari",
        "🍵 Ceylon Tea Trails",
        "🍛 Spicy Kottu & Seafood"
    ]
    @Published var availableTags: [String] = [
        "☕ Ceylon Cafes & Breakfast",
        "🍽️ Foodie & Fine Dining",
        "🦀 Fresh Lagoon Seafood",
        "🏄 Surfing & Coast",
        "📸 Epic Viewpoints",
        "🌿 Ayurveda & Spas",
        "🛕 Ancient Temples",
        "🛺 Tuk-Tuk Adventures"
    ]
    
    @Published var customDestinationInput: String = ""
    @Published var showEditDatesSheet: Bool = false
    @Published var showTuneSheet: Bool = false
    @Published var isGenerating: Bool = false
    @Published var generationProgress: Double = 0.0
    @Published var generationStage: String = "Analyzing Sri Lanka destinations..."
    @Published var navigateToDailyItinerary: Bool = false
    @Published var activeToast: String? = nil
    @Published var isAiPulsing: Bool = false
    
    // Quick suggestion destinations in Sri Lanka
    let quickSuggestions: [QuickDestination] = [
        QuickDestination(name: "Sigiriya & Cultural Triangle", flag: "🇱🇰", subtitle: "UNESCO Ancient Citadel & Rock Caves", season: "Tropical Dry Season", seasonTag: "Best Clear Skies"),
        QuickDestination(name: "Ella & Hill Country", flag: "🇱🇰", subtitle: "Scenic Blue Train & Ceylon Tea Trails", season: "Cool Mountain Mist", seasonTag: "Year-Round Cool"),
        QuickDestination(name: "Galle Fort & Southern Coast", flag: "🇱🇰", subtitle: "Living Dutch Fort & Ocean Ramparts", season: "Coastal Sunshine & Surfing", seasonTag: "Nov-Apr Peak"),
        QuickDestination(name: "Yala Wildlife & Leopards", flag: "🇱🇰", subtitle: "Leopards, Elephants & Lagoon Safari", season: "Prime Wildlife Viewing", seasonTag: "Dry Season Best")
    ]
    
    let tripManager: TripManager
    
    init(tripManager: TripManager = .shared) {
        self.tripManager = tripManager
    }
    
    // MARK: - Actions
    func selectSuggestion(_ suggestion: QuickDestination) {
        selectedDestination = suggestion.name
        destinationSubtitle = suggestion.subtitle
        destinationFlag = suggestion.flag
        seasonText = suggestion.season
        seasonBadge = suggestion.seasonTag
        triggerToast("Destination selected: \(suggestion.name)")
    }
    
    func toggleTag(_ tag: String) {
        if let idx = selectedTags.firstIndex(of: tag) {
            selectedTags.remove(at: idx)
            availableTags.append(tag)
        } else if let idx = availableTags.firstIndex(of: tag) {
            availableTags.remove(at: idx)
            selectedTags.append(tag)
        }
    }
    
    func triggerToast(_ message: String) {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            activeToast = message
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
            withAnimation(.easeOut(duration: 0.25)) {
                if self?.activeToast == message {
                    self?.activeToast = nil
                }
            }
        }
    }
    
    func startAiGenerationSequence() {
        withAnimation {
            isGenerating = true
            generationProgress = 0.0
            generationStage = "Analyzing travel companions & vibe DNA in Sri Lanka..."
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.35, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            if self.generationProgress < 0.3 {
                self.generationProgress += 0.1
                self.generationStage = "Running Core ML Recommender on Apple Neural Engine..."
            } else if self.generationProgress < 0.6 {
                self.generationProgress += 0.15
                self.generationStage = "Predicting destination affinity & visit pacing..."
            } else if self.generationProgress < 0.9 {
                self.generationProgress += 0.15
                self.generationStage = "Personalizing Ceylon scenic routes & dining stops..."
            } else {
                timer.invalidate()
                self.generationProgress = 1.0
                self.generationStage = "Core ML Itinerary Ready! Opening your Sri Lanka plan..."
                
                // GENERATE REAL DYNAMIC TRIP ACCORDING TO USER INPUT
                self.tripManager.generateAndSetActiveTrip(
                    destination: self.selectedDestination,
                    durationDays: self.travelDaysCount,
                    companion: self.selectedCompanion.rawValue,
                    pace: self.selectedPace.rawValue,
                    budget: self.selectedBudget.rawValue,
                    tags: self.selectedTags,
                    startDate: self.selectedStartDate
                )
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation {
                        self.isGenerating = false
                        self.navigateToDailyItinerary = true
                    }
                }
            }
        }
    }
}
