import Foundation
import SwiftUI
import Combine
#if canImport(WidgetKit)
import WidgetKit
#endif
#if canImport(CoreMotion)
import CoreMotion
#endif

// MARK: - Travel Activity Idea Model
struct TravelStepIdea {
    let title: String
    let description: String
    let icon: String
    let badge: String
    let accentColor: Color
}

// MARK: - Trip Step Tracker Service
final class TripStepTrackerService: ObservableObject {
    static let shared = TripStepTrackerService()
    
    // MARK: - Published Properties (Real Sensor Values Only)
    @Published var todaySteps: Int = 0
    @Published var tripTotalSteps: Int = 0
    @Published var dailyGoal: Int = 10000
    @Published var isPedometerAvailable: Bool = false
    @Published var isLiveTracking: Bool = false
    @Published var lastSyncTime: Date = Date()
    @Published var statusMessage: String = "Initializing Motion Sensor..."
    
    // Real distance if measured by hardware pedometer
    private var realTodayDistanceMeters: Double? = nil
    
    // Prior days of the ongoing trip
    private var priorDaysSteps: Int = 0
    
    // Calculated Metric Estimates from real steps
    var distanceKm: Double {
        if let meters = realTodayDistanceMeters, meters > 0 {
            return meters / 1000.0
        }
        // Average walking stride: ~0.76 meters per step
        return Double(todaySteps) * 0.00076
    }
    
    var tripDistanceKm: Double {
        Double(tripTotalSteps) * 0.00076
    }
    
    var activeCalories: Int {
        // Average ~0.041 calories burned per walking step
        Int(Double(todaySteps) * 0.041)
    }
    
    var activeMinutes: Int {
        // Average ~100 steps per minute walking pace
        todaySteps / 100
    }
    
    var goalProgress: Double {
        guard dailyGoal > 0 else { return 0 }
        return min(max(Double(todaySteps) / Double(dailyGoal), 0.0), 1.0)
    }
    
    var goalPercentText: String {
        "\(Int(goalProgress * 100))%"
    }
    
    // MARK: - Dynamic Travel Idea & Comparisons
    var currentTravelIdea: TravelStepIdea {
        if todaySteps == 0 {
            return TravelStepIdea(
                title: "Ready to Explore Ceylon",
                description: "Take your iPhone with you while exploring Sri Lanka. Real steps from Apple Motion will automatically map to iconic Ceylon milestones.",
                icon: "figure.walk",
                badge: "Trip Awaiting",
                accentColor: Color(red: 68/255, green: 226/255, blue: 205/255)
            )
        } else if todaySteps < 2000 {
            return TravelStepIdea(
                title: "Morning Ceylon Stroll",
                description: "Warming up! Climbing the ancient Sigiriya Lion Rock summit staircase is around 1,200 steps.",
                icon: "figure.walk",
                badge: "Starting Out",
                accentColor: Color(red: 68/255, green: 226/255, blue: 205/255)
            )
        } else if todaySteps < 5500 {
            let sigiriyaTimes = max(1, todaySteps / 1200)
            return TravelStepIdea(
                title: "Sigiriya Rock Conqueror",
                description: "You've walked equivalent to climbing the vertical Sigiriya Rock staircase (~1,200 steps) \(sigiriyaTimes) times today!",
                icon: "mountain.2.fill",
                badge: "\(sigiriyaTimes)x Sigiriya",
                accentColor: Color(red: 251/255, green: 191/255, blue: 36/255)
            )
        } else if todaySteps < 8500 {
            return TravelStepIdea(
                title: "Ella Nine Arch Trail Trekker",
                description: "You've walked ~\(String(format: "%.1f", distanceKm)) km — equal to the full Demodara Nine Arch Bridge scenic mountain trek!",
                icon: "leaf.fill",
                badge: "Ella Mountain Pass",
                accentColor: Color(red: 68/255, green: 226/255, blue: 205/255)
            )
        } else if todaySteps < 12000 {
            return TravelStepIdea(
                title: "Galle Fort Rampart Patrol",
                description: "Superb exploration! You've walked the equivalent of 4 full seaside circuits around the UNESCO Galle Fort ramparts.",
                icon: "shield.lefthalf.filled",
                badge: "Galle Fort Explorer",
                accentColor: Color(red: 56/255, green: 189/255, blue: 248/255)
            )
        } else {
            return TravelStepIdea(
                title: "Adam's Peak Pilgrim Legend",
                description: "Heroic milestone! You've matched the sacred Sri Pada (Adam's Peak) pilgrim ascent of 5,500 stone stairs twice!",
                icon: "trophy.fill",
                badge: "Ceylon Ultra Traveler",
                accentColor: Color(red: 251/255, green: 191/255, blue: 36/255)
            )
        }
    }
    
    // MARK: - CoreMotion Pedometer
    #if canImport(CoreMotion)
    private let pedometer = CMPedometer()
    #endif
    
    private let defaults = UserDefaults.standard
    
    private var currentUserId: String {
        AuthViewModel.shared.currentUserId
    }
    
    private var stepsKey: String { "tripPilot_\(currentUserId)_todayRealSteps" }
    private var priorDaysKey: String { "tripPilot_\(currentUserId)_priorDaysSteps" }
    private var lastDateKey: String { "tripPilot_\(currentUserId)_lastStepDate" }
    private var goalKey: String { "tripPilot_\(currentUserId)_dailyGoal" }
    
    private init() {
        cleanLegacyMockData()
        loadPersistedData()
        checkPedometerSupport()
        startTracking()
        
        NotificationCenter.default.addObserver(
            forName: AuthViewModel.userDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.loadPersistedData()
        }
    }
    
    // MARK: - Remove any older mock/fallback numbers
    private func cleanLegacyMockData() {
        // Clear previous fallback keys if any existed
        defaults.removeObject(forKey: "tripPilot_todaySteps")
        defaults.removeObject(forKey: "tripPilot_tripTotalSteps")
    }
    
    // MARK: - Persistence
    private func loadPersistedData() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        let savedPrior = defaults.integer(forKey: priorDaysKey)
        self.priorDaysSteps = max(0, savedPrior)
        
        if let savedDate = defaults.object(forKey: lastDateKey) as? Date {
            if calendar.isDate(savedDate, inSameDayAs: today) {
                self.todaySteps = defaults.integer(forKey: stepsKey)
            } else {
                // Day rollover: add yesterday's measured steps to prior days accumulator
                let yesterdaySteps = defaults.integer(forKey: stepsKey)
                self.priorDaysSteps += yesterdaySteps
                defaults.set(self.priorDaysSteps, forKey: priorDaysKey)
                
                self.todaySteps = 0
                defaults.set(0, forKey: stepsKey)
                defaults.set(today, forKey: lastDateKey)
            }
        } else {
            defaults.set(today, forKey: lastDateKey)
            self.todaySteps = 0
            defaults.set(0, forKey: stepsKey)
        }
        
        self.tripTotalSteps = self.priorDaysSteps + self.todaySteps
        
        let savedGoal = defaults.integer(forKey: goalKey)
        if savedGoal > 0 {
            self.dailyGoal = savedGoal
        }
        
        syncToWidget()
    }
    
    private func persist() {
        defaults.set(todaySteps, forKey: stepsKey)
        defaults.set(priorDaysSteps, forKey: priorDaysKey)
        defaults.set(Date(), forKey: lastDateKey)
        defaults.set(dailyGoal, forKey: goalKey)
        
        syncToWidget()
    }
    
    private func syncToWidget() {
        let idea = currentTravelIdea
        let widgetData = TripWidgetSharedData(
            steps: todaySteps,
            goal: dailyGoal,
            distanceKm: distanceKm,
            calories: activeCalories,
            milestoneTitle: idea.title,
            milestoneBadge: idea.badge,
            milestoneIcon: idea.icon,
            lastUpdated: Date()
        )
        widgetData.save()
        
        #if canImport(WidgetKit)
        WidgetCenter.shared.reloadAllTimelines()
        #endif
    }
    
    // MARK: - Pedometer Lifecycle
    private func checkPedometerSupport() {
        #if canImport(CoreMotion)
        if CMPedometer.isStepCountingAvailable() {
            self.isPedometerAvailable = true
            self.statusMessage = "Apple Motion Sensor Ready"
        } else {
            self.isPedometerAvailable = false
            self.statusMessage = "Motion Sensor Unavailable"
        }
        #else
        self.isPedometerAvailable = false
        self.statusMessage = "Motion Sensor Unavailable"
        #endif
    }
    
    func startTracking() {
        #if canImport(CoreMotion)
        guard CMPedometer.isStepCountingAvailable() else {
            self.isPedometerAvailable = false
            self.isLiveTracking = false
            self.statusMessage = "Motion Sensor Unavailable"
            return
        }
        
        self.isPedometerAvailable = true
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        
        // 1. Query original steps since start of day
        pedometer.queryPedometerData(from: startOfDay, to: Date()) { [weak self] data, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if let data = data, error == nil {
                    let actualSteps = data.numberOfSteps.intValue
                    self.todaySteps = actualSteps
                    if let dist = data.distance?.doubleValue {
                        self.realTodayDistanceMeters = dist
                    }
                    self.tripTotalSteps = self.priorDaysSteps + self.todaySteps
                    self.lastSyncTime = Date()
                    self.statusMessage = "Apple Motion Synced"
                    self.isLiveTracking = true
                    self.persist()
                } else if let error = error {
                    let nsError = error as NSError
                    if nsError.domain == CMErrorDomain && nsError.code == Int(CMErrorMotionActivityNotAuthorized.rawValue) {
                        self.statusMessage = "Motion Permission Required"
                    } else {
                        self.statusMessage = "Sync Failed"
                    }
                }
            }
        }
        
        // 2. Start continuous live updates from start of day
        // CMPedometerData provides cumulative steps accumulated since startOfDay
        pedometer.startUpdates(from: startOfDay) { [weak self] data, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if let data = data, error == nil {
                    let actualSteps = data.numberOfSteps.intValue
                    self.todaySteps = actualSteps
                    if let dist = data.distance?.doubleValue {
                        self.realTodayDistanceMeters = dist
                    }
                    self.tripTotalSteps = self.priorDaysSteps + self.todaySteps
                    self.lastSyncTime = Date()
                    self.statusMessage = "Tracking Live Motion"
                    self.isLiveTracking = true
                    self.persist()
                }
            }
        }
        #else
        self.isPedometerAvailable = false
        self.isLiveTracking = false
        self.statusMessage = "Motion Sensor Unavailable"
        #endif
    }
    
    func resetToday() {
        withAnimation {
            todaySteps = 0
            realTodayDistanceMeters = 0
            tripTotalSteps = priorDaysSteps
            lastSyncTime = Date()
            persist()
        }
    }
}
