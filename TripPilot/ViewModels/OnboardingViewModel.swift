//
//  OnboardingViewModel.swift
//  TripPilot
//
//  Created for TripPilot - Professional Onboarding Experience
//

import SwiftUI
import Combine

struct OnboardingStep: Identifiable {
    let id: Int
    let badgeText: String
    let badgeIcon: String
    let badgeColor: Color
    let title: String
    let subtitle: String
    let iconName: String
    let primaryAccent: Color
    let secondaryAccent: Color
    let previewTag: String
    let highlights: [String]
}

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published var currentStep: Int = 0
    @Published var selectedTravelVibes: Set<String> = ["🏰 UNESCO Heritage", "🚂 Scenic Highlands"]
    @Published var isCompleted: Bool = false
    
    let availableVibes: [String] = [
        "🏰 UNESCO Heritage",
        "🚂 Scenic Highlands",
        "🐘 Wildlife Safaris",
        "🌊 Coast & Surfing",
        "🍵 Ceylon Tea Estates",
        "🍛 Authentic Foodie"
    ]
    
    let steps: [OnboardingStep] = [
        OnboardingStep(
            id: 0,
            badgeText: "AI ENGINE • NEURAL CORE",
            badgeIcon: "sparkles",
            badgeColor: Color(red: 68/255, green: 226/255, blue: 205/255),
            title: "Smart Travel,\nIntelligently Guided",
            subtitle: "Autonomous multi-day itinerary generation tailored to your pace, budget, and travel companions across Sri Lanka & beyond.",
            iconName: "airplane.departure",
            primaryAccent: Color(red: 56/255, green: 189/255, blue: 248/255),
            secondaryAccent: Color(red: 68/255, green: 226/255, blue: 205/255),
            previewTag: "CORE ML RECOMMENDER",
            highlights: [
                "Tailored 1-14 day day-by-day itineraries",
                "Instant AI pace, companion & budget tuning",
                "Offline-capable trip schedules & directions"
            ]
        ),
        OnboardingStep(
            id: 1,
            badgeText: "SPATIAL AR • RADAR GEOFENCE",
            badgeIcon: "location.viewfinder",
            badgeColor: Color(red: 251/255, green: 191/255, blue: 36/255),
            title: "Audio Stories Right\nWhen You Arrive",
            subtitle: "As you approach Sigiriya, Galle Fort, or Nine Arch Bridge, spatial audio guides alert you with rich historical folklore and secrets.",
            iconName: "headphones.circle.fill",
            primaryAccent: Color(red: 251/255, green: 191/255, blue: 36/255),
            secondaryAccent: Color(red: 245/255, green: 158/255, blue: 11/255),
            previewTag: "HANDS-FREE NARRATION",
            highlights: [
                "Proximity radar radar alerts for 20+ heritage sites",
                "Natural voice audio narration with chapter scrub",
                "Spatial soundscapes recorded on location"
            ]
        ),
        OnboardingStep(
            id: 2,
            badgeText: "FINANCE • SAFE-TO-SPEND",
            badgeIcon: "chart.line.uptrend.xyaxis",
            badgeColor: Color(red: 52/255, green: 211/255, blue: 153/255),
            title: "Frictionless Budget\n& Smart Split Bills",
            subtitle: "Live Sri Lanka Central Bank exchange rate (1 USD = 305 LKR), instant camera receipt scanner, and automatic group expense settlement.",
            iconName: "creditcard.circle.fill",
            primaryAccent: Color(red: 52/255, green: 211/255, blue: 153/255),
            secondaryAccent: Color(red: 16/255, green: 185/255, blue: 129/255),
            previewTag: "CENTRAL BANK OF SRI LANKA",
            highlights: [
                "Real-time dual currency tracking (USD & LKR)",
                "Vision OCR receipt scanning in 1 tap",
                "Split costs with travel companions with Apple Pay"
            ]
        ),
        OnboardingStep(
            id: 3,
            badgeText: "PERSONALIZATION & MEMORIES",
            badgeIcon: "camera.viewfinder",
            badgeColor: Color(red: 251/255, green: 113/255, blue: 133/255),
            title: "Polaroid Memories &\nYour Travel Style",
            subtitle: "Capture photos framed in authentic polaroid templates with automatic date and GPS coordinates, keeping every landmark unforgettable.",
            iconName: "photo.stack.fill",
            primaryAccent: Color(red: 251/255, green: 113/255, blue: 133/255),
            secondaryAccent: Color(red: 168/255, green: 85/255, blue: 247/255),
            previewTag: "SECURE ENCLAVE ENCRYPTED",
            highlights: [
                "Vintage Polaroid frames with real GPS location",
                "Integrated step pedometer for daily walk tracking",
                "Select your favorite travel vibes below"
            ]
        )
    ]
    
    var isLastStep: Bool {
        currentStep >= steps.count - 1
    }
    
    func toggleVibe(_ vibe: String) {
        if selectedTravelVibes.contains(vibe) {
            selectedTravelVibes.remove(vibe)
        } else {
            selectedTravelVibes.insert(vibe)
        }
    }
    
    func nextStep() {
        if currentStep < steps.count - 1 {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
                currentStep += 1
            }
        } else {
            completeOnboarding()
        }
    }
    
    func previousStep() {
        if currentStep > 0 {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
                currentStep -= 1
            }
        }
    }
    
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        withAnimation(.easeInOut(duration: 0.4)) {
            isCompleted = true
        }
    }
}
