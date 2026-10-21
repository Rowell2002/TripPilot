//
//  TripManager.swift
//  TripPilot
//
//  Shared state manager for active Sri Lanka journeys.
//

import SwiftUI
import Combine

public final class TripManager: ObservableObject {
    public static let shared = TripManager()
    
    @Published public var currentTrip: GeneratedTrip
    @Published public var savedTrips: [GeneratedTrip] = []
    
    private init() {
        // Initial flagship Sri Lanka journey
        let defaultTrip = SriLankaDataService.shared.generateCustomTrip(
            destination: "Sigiriya, Ella & Galle",
            durationDays: 7,
            companion: "Couple (2)",
            pace: "Balanced",
            budget: "Comfort Premium",
            tags: [
                "🏰 UNESCO Heritage",
                "🚂 Scenic Blue Train",
                "🐘 Wildlife Safari",
                "🍵 Ceylon Tea Trails",
                "🍛 Spicy Kottu & Seafood"
            ],
            startDate: Date()
        )
        self.currentTrip = defaultTrip
        self.savedTrips = [defaultTrip]
    }
    
    @discardableResult
    public func generateAndSetActiveTrip(
        destination: String,
        durationDays: Int,
        companion: String,
        pace: String,
        budget: String,
        tags: [String],
        startDate: Date = Date()
    ) -> GeneratedTrip {
        let newTrip = SriLankaDataService.shared.generateCustomTrip(
            destination: destination,
            durationDays: durationDays,
            companion: companion,
            pace: pace,
            budget: budget,
            tags: tags,
            startDate: startDate
        )
        self.currentTrip = newTrip
        if !self.savedTrips.contains(where: { $0.id == newTrip.id }) {
            self.savedTrips.insert(newTrip, at: 0)
        }
        return newTrip
    }
    
    public func setActiveTrip(_ trip: GeneratedTrip) {
        self.currentTrip = trip
    }
    
    public func addCustomStop(
        title: String,
        category: String,
        notes: String,
        entranceFeeLKR: Int,
        dayIndex: Int = 0
    ) {
        guard !currentTrip.days.isEmpty else { return }
        let targetIndex = min(max(dayIndex, 0), currentTrip.days.count - 1)
        var updatedDays = currentTrip.days
        let newStop = TripStop(
            time: "11:00 AM",
            title: title,
            category: category,
            icon: "mappin.circle.fill",
            description: notes,
            locationName: title,
            estimatedDuration: "2h 30m",
            costLKR: entranceFeeLKR,
            costUSD: Double(entranceFeeLKR) / 305.0,
            highlight: "Added from Interactive Map",
            passRequired: entranceFeeLKR > 0,
            passName: entranceFeeLKR > 0 ? "Entry Pass" : nil,
            imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuCrQTcPiDbYUvAVVwmrM19ubJHwtODGFMAL9b0YlRpZmxh75ZIY9eYHnn6MulTbcu7wFHCLX3zgKUoOqDywdFsKdGll8eIOGxk3ONR3XmK1uhNNkHq2P4w_Yya4GUw7czqkdDJLfMHa03vqpx1Psngp8Bx_Qj8EKtvHC3kUBhWfnqMtjry7aKsidJIvN4oe2_7XM0IjIxPmOBvJCTDohM8EOj5C5SxVWlSnVld9sul4SNq0GJvz7TuWsQ"
        )
        var targetStops = updatedDays[targetIndex].stops
        targetStops.append(newStop)
        
        let oldDay = updatedDays[targetIndex]
        let updatedDay = TripDay(
            id: oldDay.id,
            dayNumber: oldDay.dayNumber,
            dayOfWeek: oldDay.dayOfWeek,
            dayOfMonth: oldDay.dayOfMonth,
            fullDateString: oldDay.fullDateString,
            title: oldDay.title,
            region: oldDay.region,
            weather: oldDay.weather,
            temperature: oldDay.temperature,
            stops: targetStops
        )
        updatedDays[targetIndex] = updatedDay
        
        self.currentTrip = GeneratedTrip(
            id: currentTrip.id,
            title: currentTrip.title,
            destinationRegion: currentTrip.destinationRegion,
            destinationFlag: currentTrip.destinationFlag,
            durationDays: currentTrip.durationDays,
            durationNights: currentTrip.durationNights,
            companion: currentTrip.companion,
            pace: currentTrip.pace,
            budgetTier: currentTrip.budgetTier,
            tags: currentTrip.tags,
            startDateString: currentTrip.startDateString,
            endDateString: currentTrip.endDateString,
            weatherSummary: currentTrip.weatherSummary,
            totalEstimatedLKR: currentTrip.totalEstimatedLKR + entranceFeeLKR,
            totalEstimatedUSD: currentTrip.totalEstimatedUSD + (Double(entranceFeeLKR) / 305.0),
            days: updatedDays
        )
    }
}
