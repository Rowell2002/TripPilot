//
//  UpcomingTripsCalendarView.swift
//  TripPilot
//
//  Created for Visual Calendar & EventKit Upcoming Trips Viewer.
//

import SwiftUI
import EventKit

public struct UpcomingTripsCalendarView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var tripManager = TripManager.shared
    @ObservedObject private var calendarSync = TripCalendarSyncService.shared
    
    // Calendar Navigation State
    @State private var currentMonthDate: Date = Date()
    @State private var selectedDayDate: Date = Date()
    @State private var syncToastMessage: String? = nil
    
    // Theme Colors
    private let bgCanvas = Color(red: 15/255, green: 19/255, blue: 28/255)       // #0f131c
    private let surfaceContainerLow = Color(red: 24/255, green: 28/255, blue: 36/255) // #181c24
    private let surfaceContainer = Color(red: 28/255, green: 32/255, blue: 40/255)    // #1c2028
    private let surfaceContainerHigh = Color(red: 38/255, green: 42/255, blue: 51/255)// #262a33
    private let primaryCyan = Color(red: 56/255, green: 189/255, blue: 248/255)  // #38bdf8
    private let secondaryMint = Color(red: 68/255, green: 226/255, blue: 205/255)// #44e2cd
    private let skyBlue = Color(red: 142/255, green: 213/255, blue: 255/255)    // #8ed5ff
    private let outlineVariant = Color.white.opacity(0.1)
    private let slateMuted = Color(red: 148/255, green: 163/255, blue: 184/255)  // #94a3b8
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ZStack {
                bgCanvas.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerSection
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 18) {
                            // 1. Apple Calendar EventKit Sync Banner
                            eventKitSyncBanner
                            
                            // 2. Interactive Monthly Calendar Widget
                            monthlyCalendarCard
                            
                            // 3. Selected Day Schedule Snapshot
                            selectedDayScheduleCard
                            
                            // 4. All Upcoming Trips Countdown List
                            upcomingTripsListSection
                            
                            Spacer(minLength: 40)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 14)
                    }
                }
                
                // Toast Alert
                if let toast = syncToastMessage {
                    VStack {
                        Spacer()
                        HStack(spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(secondaryMint)
                            Text(toast)
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 18)
                        .padding(.vertical, 12)
                        .background(surfaceContainerHigh)
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(secondaryMint.opacity(0.4), lineWidth: 1))
                        .shadow(color: Color.black.opacity(0.6), radius: 10, y: 5)
                        .padding(.bottom, 24)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            calendarSync.checkAuthorizationStatus()
            // Set default selected date to active trip start date if upcoming
            let df = DateFormatter()
            df.dateFormat = "MMM d, yyyy"
            if let tripStart = df.date(from: tripManager.currentTrip.startDateString) {
                selectedDayDate = tripStart
                currentMonthDate = tripStart
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 8) {
                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(primaryCyan)
                    Text("Trip Calendar")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                Text("Upcoming expeditions synced with Apple Calendar")
                    .font(.system(size: 12.5, weight: .medium))
                    .foregroundColor(slateMuted)
            }
            
            Spacer()
            
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(surfaceContainerLow)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(outlineVariant, lineWidth: 1))
            }
        }
        .padding(.horizontal, 18)
        .padding(.top, 14)
        .padding(.bottom, 10)
    }
    
    // MARK: - 1. EventKit Sync Banner
    private var eventKitSyncBanner: some View {
        let isSynced = calendarSync.isTripSynced(tripManager.currentTrip.id)
        
        return VStack(spacing: 12) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(primaryCyan.opacity(0.15))
                        .frame(width: 44, height: 44)
                        .overlay(Circle().stroke(primaryCyan.opacity(0.3), lineWidth: 1))
                    
                    Image(systemName: isSynced ? "calendar.badge.checkmark" : "calendar.badge.plus")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(isSynced ? secondaryMint : primaryCyan)
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text(isSynced ? "SYNCED TO APPLE CALENDAR" : "APPLE CALENDAR SYNC")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(isSynced ? secondaryMint : primaryCyan)
                            .tracking(0.6)
                        
                        if isSynced {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 11))
                                .foregroundColor(secondaryMint)
                        }
                    }
                    
                    Text(tripManager.currentTrip.title)
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Text("\(tripManager.currentTrip.durationDays) Days • \(tripManager.currentTrip.startDateString) to \(tripManager.currentTrip.endDateString)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(slateMuted)
                }
                
                Spacer()
            }
            
            HStack(spacing: 10) {
                Button(action: {
                    Task {
                        let res = await calendarSync.syncTripToCalendar(tripManager.currentTrip)
                        withAnimation {
                            syncToastMessage = res.message
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            withAnimation { syncToastMessage = nil }
                        }
                    }
                }) {
                    HStack(spacing: 6) {
                        if calendarSync.isSyncing {
                            ProgressView()
                                .tint(.black)
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: isSynced ? "arrow.triangle.2.circlepath" : "plus.circle.fill")
                                .font(.system(size: 13, weight: .bold))
                        }
                        Text(isSynced ? "Re-sync Trip" : "Add to Apple Calendar")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        LinearGradient(
                            colors: [primaryCyan, secondaryMint],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
                }
                .disabled(calendarSync.isSyncing)
                
                Button(action: {
                    calendarSync.openSystemCalendar(for: selectedDayDate)
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.up.right.square")
                            .font(.system(size: 13, weight: .semibold))
                        Text("Open Calendar")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(surfaceContainerHigh)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(outlineVariant, lineWidth: 1))
                }
            }
        }
        .padding(16)
        .background(surfaceContainerLow)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(outlineVariant, lineWidth: 1))
    }
    
    // MARK: - 2. Monthly Calendar Card
    private var monthlyCalendarCard: some View {
        VStack(spacing: 14) {
            // Month navigation header
            HStack {
                Button(action: {
                    if let prevMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonthDate) {
                        currentMonthDate = prevMonth
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(surfaceContainer)
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Text(monthYearString(from: currentMonthDate))
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    if let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonthDate) {
                        currentMonthDate = nextMonth
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(surfaceContainer)
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 4)
            
            // Weekday symbols
            let weekdaySymbols = ["S", "M", "T", "W", "T", "F", "S"]
            HStack(spacing: 0) {
                ForEach(weekdaySymbols.indices, id: \.self) { i in
                    Text(weekdaySymbols[i])
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundColor(slateMuted)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Days grid
            let daysInMonth = calendarDaysForMonth(currentMonthDate)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(daysInMonth, id: \.self) { date in
                    if let date = date {
                        let isSelected = Calendar.current.isDate(date, inSameDayAs: selectedDayDate)
                        let hasTrip = hasTripOnDate(date)
                        let isToday = Calendar.current.isDateInToday(date)
                        
                        Button(action: {
                            selectedDayDate = date
                        }) {
                            VStack(spacing: 3) {
                                Text("\(Calendar.current.component(.day, from: date))")
                                    .font(.system(size: 14, weight: isSelected ? .heavy : (hasTrip ? .bold : .medium), design: .rounded))
                                    .foregroundColor(isSelected ? .black : (hasTrip ? .white : (isToday ? primaryCyan : slateMuted)))
                                
                                Circle()
                                    .fill(isSelected ? Color.black : (hasTrip ? secondaryMint : Color.clear))
                                    .frame(width: 5, height: 5)
                            }
                            .frame(height: 38)
                            .frame(maxWidth: .infinity)
                            .background(
                                isSelected ? (hasTrip ? secondaryMint : primaryCyan) : (isToday ? surfaceContainerHigh : Color.clear)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(hasTrip && !isSelected ? secondaryMint.opacity(0.4) : Color.clear, lineWidth: 1)
                            )
                        }
                    } else {
                        Color.clear.frame(height: 38)
                    }
                }
            }
        }
        .padding(16)
        .background(surfaceContainerLow)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(outlineVariant, lineWidth: 1))
    }
    
    // MARK: - 3. Selected Day Schedule Card
    private var selectedDayScheduleCard: some View {
        let matchingDays = matchingDaysForDate(selectedDayDate)
        
        let formatter = DateFormatter()
        let _ = formatter.dateFormat = "EEEE, MMMM d, yyyy"
        let dateTitle = formatter.string(from: selectedDayDate)
        
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(dateTitle, systemImage: "clock.badge")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(primaryCyan)
                Spacer()
                if !matchingDays.isEmpty {
                    Text("\(matchingDays.count) \(matchingDays.count == 1 ? "Trip Day" : "Trip Days")")
                        .font(.system(size: 11.5, weight: .bold, design: .rounded))
                        .foregroundColor(secondaryMint)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(secondaryMint.opacity(0.12))
                        .clipShape(Capsule())
                }
            }
            
            if matchingDays.isEmpty {
                HStack(spacing: 12) {
                    Image(systemName: "calendar.badge.minus")
                        .font(.system(size: 20))
                        .foregroundColor(slateMuted)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("No trips scheduled on this day")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                        Text("Tap any date with a mint dot above to see scheduled activities.")
                            .font(.system(size: 12))
                            .foregroundColor(slateMuted)
                    }
                }
                .padding(.vertical, 8)
            } else {
                ForEach(matchingDays) { item in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("DAY \(item.day.dayNumber) • \(item.trip.destinationRegion)")
                                .font(.system(size: 11, weight: .heavy, design: .rounded))
                                .foregroundColor(secondaryMint)
                                .tracking(0.6)
                            Spacer()
                            Text(item.day.weather + " • " + item.day.temperature)
                                .font(.system(size: 11.5, weight: .semibold, design: .rounded))
                                .foregroundColor(slateMuted)
                        }
                        
                        Text(item.day.title)
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        // Stops list
                        VStack(alignment: .leading, spacing: 6) {
                            ForEach(item.day.stops) { stop in
                                HStack(spacing: 8) {
                                    Text(stop.time)
                                        .font(.system(size: 11.5, weight: .bold, design: .rounded))
                                        .foregroundColor(primaryCyan)
                                        .frame(width: 65, alignment: .leading)
                                    
                                    Image(systemName: stop.icon)
                                        .font(.system(size: 12))
                                        .foregroundColor(secondaryMint)
                                    
                                    Text(stop.title)
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(Color(red: 226/255, green: 232/255, blue: 240/255))
                                        .lineLimit(1)
                                    
                                    Spacer()
                                }
                            }
                        }
                        .padding(10)
                        .background(surfaceContainer)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(12)
                    .background(surfaceContainerHigh.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
            }
        }
        .padding(16)
        .background(surfaceContainerLow)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(outlineVariant, lineWidth: 1))
    }
    
    // MARK: - 4. Upcoming Trips Countdown List
    private var upcomingTripsListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("ALL UPCOMING & SAVED TRIPS")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(slateMuted)
                    .tracking(0.8)
                Spacer()
                Text("\(tripManager.savedTrips.count) Total")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundColor(primaryCyan)
            }
            .padding(.horizontal, 4)
            
            ForEach(tripManager.savedTrips) { trip in
                let countdown = calculateCountdown(for: trip)
                let isSynced = calendarSync.isTripSynced(trip.id)
                
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(surfaceContainer)
                            .frame(width: 48, height: 48)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(outlineVariant, lineWidth: 1))
                        
                        Text(trip.destinationFlag)
                            .font(.system(size: 24))
                    }
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text(trip.title)
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .lineLimit(1)
                        
                        HStack(spacing: 6) {
                            Text(trip.startDateString)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(slateMuted)
                            Text("•")
                                .foregroundColor(slateMuted)
                            Text("\(trip.durationDays) Days")
                                .font(.system(size: 12, weight: .semibold, design: .rounded))
                                .foregroundColor(primaryCyan)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 3) {
                        Text(countdown)
                            .font(.system(size: 12, weight: .heavy, design: .rounded))
                            .foregroundColor(countdown.contains("Active") ? secondaryMint : skyBlue)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(
                                (countdown.contains("Active") ? secondaryMint : skyBlue).opacity(0.14)
                            )
                            .clipShape(Capsule())
                        
                        if isSynced {
                            HStack(spacing: 3) {
                                Image(systemName: "calendar.badge.checkmark")
                                    .font(.system(size: 9))
                                Text("Synced")
                                    .font(.system(size: 10, weight: .bold, design: .rounded))
                            }
                            .foregroundColor(secondaryMint)
                        }
                    }
                }
                .padding(14)
                .background(surfaceContainerLow)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(outlineVariant, lineWidth: 1))
                .onTapGesture {
                    // Set active and navigate
                    tripManager.setActiveTrip(trip)
                    let df = DateFormatter()
                    df.dateFormat = "MMM d, yyyy"
                    if let start = df.date(from: trip.startDateString) {
                        selectedDayDate = start
                        currentMonthDate = start
                    }
                }
            }
        }
    }
    
    // MARK: - Calendar Helpers
    private func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    private func calendarDaysForMonth(_ monthDate: Date) -> [Date?] {
        let cal = Calendar.current
        guard let monthInterval = cal.dateInterval(of: .month, for: monthDate) else { return [] }
        
        let startOfMonth = monthInterval.start
        let firstWeekday = cal.component(.weekday, from: startOfMonth) // 1 = Sunday
        let numberOfDaysInMonth = cal.range(of: .day, in: .month, for: monthDate)?.count ?? 30
        
        var result: [Date?] = []
        // Leading empty slots
        for _ in 1..<firstWeekday {
            result.append(nil)
        }
        // Month days
        for day in 1...numberOfDaysInMonth {
            if let date = cal.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                result.append(date)
            }
        }
        return result
    }
    
    private func hasTripOnDate(_ date: Date) -> Bool {
        !matchingDaysForDate(date).isEmpty
    }
    
    struct MatchingDayItem: Identifiable {
        let id: String
        let trip: GeneratedTrip
        let day: TripDay
    }
    
    private func matchingDaysForDate(_ targetDate: Date) -> [MatchingDayItem] {
        let cal = Calendar.current
        let df = DateFormatter()
        df.dateFormat = "MMM d, yyyy"
        
        var results: [MatchingDayItem] = []
        for trip in tripManager.savedTrips {
            guard let tripStartDate = df.date(from: trip.startDateString) else { continue }
            for (index, day) in trip.days.enumerated() {
                if let dayDate = cal.date(byAdding: .day, value: index, to: tripStartDate) {
                    if cal.isDate(dayDate, inSameDayAs: targetDate) {
                        results.append(MatchingDayItem(id: "\(trip.id)_\(day.id)", trip: trip, day: day))
                    }
                }
            }
        }
        return results
    }
    
    private func calculateCountdown(for trip: GeneratedTrip) -> String {
        let cal = Calendar.current
        let df = DateFormatter()
        df.dateFormat = "MMM d, yyyy"
        guard let start = df.date(from: trip.startDateString) else { return "Upcoming" }
        
        let startOfDayTarget = cal.startOfDay(for: start)
        let startOfDayToday = cal.startOfDay(for: Date())
        
        let daysDiff = cal.dateComponents([.day], from: startOfDayToday, to: startOfDayTarget).day ?? 0
        if daysDiff == 0 {
            return "Active Today"
        } else if daysDiff > 0 {
            return "In \(daysDiff) \(daysDiff == 1 ? "day" : "days")"
        } else {
            let passed = abs(daysDiff)
            if passed < trip.durationDays {
                return "Day \(passed + 1) Active"
            } else {
                return "Completed"
            }
        }
    }
}
