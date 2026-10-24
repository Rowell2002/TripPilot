//
//  TripCalendarSyncTests.swift
//  TripPilotTests
//
//  Created for EventKit Calendar Sync & Upcoming Trips Verification.
//

import Testing
import Foundation
@testable import TripPilot

@Suite("Trip Calendar Sync & EventKit Integration Suite")
struct TripCalendarSyncTests {
    
    @Test("Calendar Sync Service State and Sync Tracking")
    @MainActor
    func testCalendarSyncServiceState() {
        let service = TripCalendarSyncService.shared
        
        // Initial state check
        service.checkAuthorizationStatus()
        
        let testTripId = "test_future_trip_\(UUID().uuidString)"
        #expect(!service.isTripSynced(testTripId))
        
        // Mark as synced
        service.syncedTripIds.insert(testTripId)
        #expect(service.isTripSynced(testTripId))
    }
    
    @Test("Future Trip Itinerary Date Parsing and Range")
    func testFutureTripDateCalculation() {
        let calendar = Calendar.current
        guard let futureDate = calendar.date(byAdding: .day, value: 20, to: Date()) else { return }
        
        let trip = SriLankaDataService.shared.generateCustomTrip(
            destination: "Sigiriya & Ella Highlands",
            durationDays: 6,
            companion: "Solo",
            pace: "Balanced",
            budget: "Comfort",
            tags: ["🏰 UNESCO Heritage", "🚂 Scenic Blue Train"],
            startDate: futureDate
        )
        
        #expect(trip.durationDays == 6)
        #expect(trip.days.count == 6)
        
        let df = DateFormatter()
        df.dateFormat = "MMM d, yyyy"
        #expect(trip.startDateString == df.string(from: futureDate))
        
        // Day 1 stops verification
        let day1 = trip.days[0]
        #expect(!day1.stops.isEmpty)
        #expect(day1.dayNumber == 1)
        
        // End date should be start + 6 days
        let endCalendarDate = calendar.date(byAdding: .day, value: 6, to: futureDate) ?? futureDate
        #expect(trip.endDateString == df.string(from: endCalendarDate))
    }
    
    @Test("Upcoming Trip Calendar Entry Data Integrity")
    func testUpcomingTripCalendarEntry() {
        let now = Date()
        let entry = UpcomingTripCalendarEntry(
            id: "entry_1",
            tripTitle: "Ella Highlands Expedition",
            destination: "Ella",
            dayNumber: 2,
            totalDays: 5,
            date: now,
            dayOfWeek: "MON",
            dayOfMonth: "15",
            fullDateString: "Monday, Nov 15",
            region: "Central Highlands",
            weather: "Misty & Crisp",
            temperature: "19°C",
            stopsCount: 4,
            topStops: ["Nine Arches Bridge", "Little Adam's Peak"],
            isSyncedToCalendar: true
        )
        
        #expect(entry.tripTitle == "Ella Highlands Expedition")
        #expect(entry.dayNumber == 2)
        #expect(entry.stopsCount == 4)
        #expect(entry.isSyncedToCalendar == true)
        #expect(entry.topStops.count == 2)
    }
}
