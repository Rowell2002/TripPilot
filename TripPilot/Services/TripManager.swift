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
    
    private var currentUserId: String {
        AuthViewModel.shared.currentUserId
    }
    
    private var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private var tripsDirectory: URL {
        documentsDirectory.appendingPathComponent("TripPilotTrips", isDirectory: true)
    }
    
    private var tripsFileURL: URL {
        tripsDirectory.appendingPathComponent("trips_\(currentUserId).json")
    }
    
    private struct UserTripsPayload: Codable {
        let currentTripId: UUID
        let trips: [GeneratedTrip]
    }
    
    private static func makeStaticDefaultTrip() -> GeneratedTrip {
        SriLankaDataService.shared.generateCustomTrip(
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
    }
    
    private init() {
        let initialTrip = Self.makeStaticDefaultTrip()
        self.currentTrip = initialTrip
        self.savedTrips = [initialTrip]
        
        loadUserTrips()
        
        NotificationCenter.default.addObserver(
            forName: AuthViewModel.userDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.loadUserTrips()
        }
    }
    
    private func createFolderIfNeeded() {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: tripsDirectory.path) {
            try? fileManager.createDirectory(at: tripsDirectory, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    public func loadUserTrips() {
        createFolderIfNeeded()
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: tripsFileURL.path),
           let data = try? Data(contentsOf: tripsFileURL),
           let payload = try? JSONDecoder().decode(UserTripsPayload.self, from: data),
           !payload.trips.isEmpty {
            self.savedTrips = payload.trips
            self.currentTrip = payload.trips.first(where: { $0.id == payload.currentTripId }) ?? payload.trips[0]
        } else {
            let defaultTrip = Self.makeStaticDefaultTrip()
            self.currentTrip = defaultTrip
            self.savedTrips = [defaultTrip]
            persistUserTrips()
        }
    }
    
    public func persistUserTrips() {
        createFolderIfNeeded()
        let payload = UserTripsPayload(currentTripId: currentTrip.id, trips: savedTrips)
        do {
            let data = try JSONEncoder().encode(payload)
            try data.write(to: tripsFileURL, options: .atomic)
        } catch {
            print("Failed to persist user trips: \(error)")
        }
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
        persistUserTrips()
        return newTrip
    }
    
    public func setActiveTrip(_ trip: GeneratedTrip) {
        self.currentTrip = trip
        persistUserTrips()
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
        persistUserTrips()
    }
    
    public func updateStopsOrder(for dayIndex: Int, newStops: [TripStop]) {
        guard !currentTrip.days.isEmpty else { return }
        let targetIndex = min(max(dayIndex, 0), currentTrip.days.count - 1)
        var updatedDays = currentTrip.days
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
            stops: newStops
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
            totalEstimatedLKR: currentTrip.totalEstimatedLKR,
            totalEstimatedUSD: currentTrip.totalEstimatedUSD,
            days: updatedDays
        )
        persistUserTrips()
    }
    
    public func deleteStop(at index: Int, in dayIndex: Int) {
        guard !currentTrip.days.isEmpty else { return }
        let targetIndex = min(max(dayIndex, 0), currentTrip.days.count - 1)
        var targetStops = currentTrip.days[targetIndex].stops
        guard targetStops.indices.contains(index) else { return }
        targetStops.remove(at: index)
        updateStopsOrder(for: targetIndex, newStops: targetStops)
    }
}
