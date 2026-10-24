import Testing
import Foundation
import CoreLocation
@testable import TripPilot

@Suite("Trip Manager Itinerary Engine Logic Suite")
struct TripManagerBusinessLogicTests {
    
    @Test("Dynamic Trip Generation with Custom Parameters")
    func testTripGeneration() {
        let manager = TripManager.shared
        
        manager.generateAndSetActiveTrip(
            destination: "Ella & Hill Country",
            durationDays: 5,
            companion: "Solo",
            pace: "Intense",
            budget: "Ultra Luxury",
            tags: ["🚂 Scenic Blue Train", "🍵 Ceylon Tea Trails"],
            startDate: Date()
        )
        
        let currentTrip = manager.currentTrip
        #expect(currentTrip.destination.contains("Ella") || currentTrip.destination.contains("Hill Country"))
        #expect(currentTrip.durationDays == 5)
        #expect(currentTrip.days.count == 5)
        #expect(currentTrip.companion == "Solo")
        #expect(currentTrip.pace == "Intense")
        #expect(currentTrip.budgetTier == "Ultra Luxury")
        #expect(currentTrip.totalEstimatedUSD > 0)
        
        // Ensure each day has generated stops
        for day in currentTrip.days {
            #expect(!day.stops.isEmpty)
            #expect(!day.title.isEmpty)
            #expect(!day.theme.isEmpty)
        }
    }
    
    @Test("Custom Stop Addition to Trip Day")
    func testAddCustomStop() {
        let manager = TripManager.shared
        
        let initialStopsCount = manager.currentTrip.days[0].stops.count
        
        manager.addCustomStop(
            title: "Pidurangala Rock Sunrise",
            category: "Nature",
            notes: "Panoramic sunset and sunrise view facing Sigiriya.",
            entranceFeeLKR: 1000,
            dayIndex: 0
        )
        
        #expect(manager.currentTrip.days[0].stops.count == initialStopsCount + 1)
        let addedStop = manager.currentTrip.days[0].stops.last!
        #expect(addedStop.title == "Pidurangala Rock Sunrise")
        #expect(addedStop.costLKR == 1000)
        
        // Clean up
        let lastIndex = manager.currentTrip.days[0].stops.count - 1
        manager.deleteStop(at: lastIndex, in: 0)
        #expect(manager.currentTrip.days[0].stops.count == initialStopsCount)
    }
    
    @Test("Stop Reordering and Deletion")
    func testStopReordering() {
        let manager = TripManager.shared
        guard manager.currentTrip.days[0].stops.count >= 2 else { return }
        
        var stops = manager.currentTrip.days[0].stops
        let firstTitle = stops[0].title
        let secondTitle = stops[1].title
        
        // Swap first two stops
        stops.swapAt(0, 1)
        manager.updateStopsOrder(for: 0, newStops: stops)
        
        #expect(manager.currentTrip.days[0].stops[0].title == secondTitle)
        #expect(manager.currentTrip.days[0].stops[1].title == firstTitle)
        
        // Restore order
        stops.swapAt(0, 1)
        manager.updateStopsOrder(for: 0, newStops: stops)
        #expect(manager.currentTrip.days[0].stops[0].title == firstTitle)
    }
}
