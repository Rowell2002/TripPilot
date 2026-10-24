//
//  TripCalendarSyncService.swift
//  TripPilot
//
//  Created for EventKit Calendar Sync & Upcoming Trips View.
//

import SwiftUI
import Combine
import EventKit
#if canImport(UIKit)
import UIKit
#endif

public struct UpcomingTripCalendarEntry: Identifiable, Hashable {
    public let id: String
    public var tripTitle: String
    public var destination: String
    public var dayNumber: Int
    public var totalDays: Int
    public var date: Date
    public var dayOfWeek: String
    public var dayOfMonth: String
    public var fullDateString: String
    public var region: String
    public var weather: String
    public var temperature: String
    public var stopsCount: Int
    public var topStops: [String]
    public var isSyncedToCalendar: Bool
}

@MainActor
public final class TripCalendarSyncService: ObservableObject {
    public static let shared = TripCalendarSyncService()
    
    private let eventStore = EKEventStore()
    
    @Published public var isAuthorized: Bool = false
    @Published public var isSyncing: Bool = false
    @Published public var lastSyncMessage: String? = nil
    @Published public var syncedTripIds: Set<String> = []
    
    private let syncedTripsKey = "TripPilot_SyncedCalendarTripIds_v1"
    
    private init() {
        if let stored = UserDefaults.standard.stringArray(forKey: syncedTripsKey) {
            self.syncedTripIds = Set(stored)
        }
        checkAuthorizationStatus()
    }
    
    public func checkAuthorizationStatus() {
        let status = EKEventStore.authorizationStatus(for: .event)
        if #available(iOS 17.0, *) {
            self.isAuthorized = (status == .fullAccess || status == .writeOnly)
        } else {
            self.isAuthorized = (status == .authorized)
        }
    }
    
    public func requestCalendarAccess() async -> Bool {
        do {
            let granted: Bool
            if #available(iOS 17.0, *) {
                granted = try await eventStore.requestFullAccessToEvents()
            } else {
                granted = try await withCheckedThrowingContinuation { continuation in
                    eventStore.requestAccess(to: .event) { allowed, error in
                        if let error = error {
                            continuation.resume(throwing: error)
                        } else {
                            continuation.resume(returning: allowed)
                        }
                    }
                }
            }
            self.isAuthorized = granted
            return granted
        } catch {
            print("⚠️ EventKit Calendar authorization error: \(error.localizedDescription)")
            self.isAuthorized = false
            return false
        }
    }
    
    /// Syncs an entire GeneratedTrip to the user's Apple Calendar using EventKit
    @discardableResult
    public func syncTripToCalendar(_ trip: GeneratedTrip) async -> (success: Bool, message: String) {
        self.isSyncing = true
        defer { self.isSyncing = false }
        
        let hasAccess = await requestCalendarAccess()
        guard hasAccess else {
            let msg = "Calendar access not authorized. Please enable Calendar in Settings."
            self.lastSyncMessage = msg
            return (false, msg)
        }
        
        guard let calendar = eventStore.defaultCalendarForNewEvents else {
            let msg = "No default Apple Calendar found on this device."
            self.lastSyncMessage = msg
            return (false, msg)
        }
        
        // Parse trip starting date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        let baseStartDate = dateFormatter.date(from: trip.startDateString) ?? Date()
        
        var addedCount = 0
        let cal = Calendar.current
        
        for (index, day) in trip.days.enumerated() {
            // Determine exact date for this day
            let dayDate = cal.date(byAdding: .day, value: index, to: baseStartDate) ?? baseStartDate
            
            // Set 9:00 AM start and 6:00 PM end
            var startComponents = cal.dateComponents([.year, .month, .day], from: dayDate)
            startComponents.hour = 9
            startComponents.minute = 0
            startComponents.second = 0
            
            var endComponents = startComponents
            endComponents.hour = 18
            endComponents.minute = 0
            endComponents.second = 0
            
            let eventStartDate = cal.date(from: startComponents) ?? dayDate
            let eventEndDate = cal.date(from: endComponents) ?? dayDate.addingTimeInterval(3600 * 9)
            
            let eventTitle = "✈️ TripPilot: \(trip.title) - Day \(day.dayNumber) (\(day.region))"
            
            // Check for existing duplicate event on that day
            let predicate = eventStore.predicateForEvents(
                withStart: cal.startOfDay(for: dayDate),
                end: cal.date(byAdding: .day, value: 1, to: cal.startOfDay(for: dayDate)) ?? dayDate,
                calendars: [calendar]
            )
            let existingEvents = eventStore.events(matching: predicate)
            let alreadyExists = existingEvents.contains { $0.title == eventTitle }
            
            let event = existingEvents.first(where: { $0.title == eventTitle }) ?? EKEvent(eventStore: eventStore)
            event.title = eventTitle
            event.startDate = eventStartDate
            event.endDate = eventEndDate
            event.calendar = calendar
            event.location = "\(day.region), Sri Lanka"
            
            // Build rich detailed itinerary notes
            var notesLines: [String] = []
            notesLines.append("🌴 TripPilot Sri Lanka Expedition: \(trip.title)")
            notesLines.append("📅 Day \(day.dayNumber) of \(trip.durationDays): \(day.title)")
            notesLines.append("📍 Region: \(day.region) • Weather: \(day.weather), \(day.temperature)")
            notesLines.append("⚡ Pace: \(trip.pace) • Budget: \(trip.budgetTier)")
            notesLines.append("")
            notesLines.append("📌 SCHEDULED STOPS:")
            for (stopIndex, stop) in day.stops.enumerated() {
                notesLines.append("\(stopIndex + 1). [\(stop.time)] \(stop.title) (\(stop.category))")
                if !stop.highlight.isEmpty {
                    notesLines.append("   • Highlight: \(stop.highlight)")
                }
                notesLines.append("   • Duration: \(stop.estimatedDuration)")
                if stop.costLKR > 0 {
                    notesLines.append("   • Fee: LKR \(stop.costLKR) (~$\(String(format: "%.1f", stop.costUSD)))")
                }
                if !stop.description.isEmpty {
                    notesLines.append("   • Notes: \(stop.description)")
                }
            }
            notesLines.append("")
            notesLines.append("📱 Planned with TripPilot • Sri Lanka AI Travel Companion")
            event.notes = notesLines.joined(separator: "\n")
            
            // Add smart alarms: 1 day before & 2 hours before
            if !alreadyExists {
                event.addAlarm(EKAlarm(relativeOffset: -86400)) // 1 day before
                event.addAlarm(EKAlarm(relativeOffset: -7200))  // 2 hours before
            }
            
            do {
                try eventStore.save(event, span: .thisEvent, commit: false)
                addedCount += 1
            } catch {
                print("⚠️ Error saving event for day \(day.dayNumber): \(error.localizedDescription)")
            }
        }
        
        do {
            try eventStore.commit()
            syncedTripIds.insert(trip.id.uuidString)
            UserDefaults.standard.set(Array(syncedTripIds), forKey: syncedTripsKey)
            
            let successMsg = "Added \(addedCount) trip days to your Apple Calendar!"
            self.lastSyncMessage = successMsg
            return (true, successMsg)
        } catch {
            let errorMsg = "Failed to commit calendar events: \(error.localizedDescription)"
            self.lastSyncMessage = errorMsg
            return (false, errorMsg)
        }
    }
    
    /// Deep-links straight into Apple's native Calendar app on the selected date
    public func openSystemCalendar(for date: Date = Date()) {
        #if canImport(UIKit)
        let interval = date.timeIntervalSinceReferenceDate
        if let url = URL(string: "calshow:\(interval)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else if let fallbackUrl = URL(string: "calshow:") {
                UIApplication.shared.open(fallbackUrl, options: [:], completionHandler: nil)
            }
        }
        #endif
    }
    
    /// Returns true if the specified trip ID is already marked as synced
    public func isTripSynced(_ tripId: String) -> Bool {
        syncedTripIds.contains(tripId)
    }
    
    public func isTripSynced(_ tripId: UUID) -> Bool {
        syncedTripIds.contains(tripId.uuidString)
    }
}
