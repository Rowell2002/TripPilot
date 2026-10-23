import Foundation

public struct TripWidgetSharedData: Codable {
    public var steps: Int
    public var goal: Int
    public var distanceKm: Double
    public var calories: Int
    public var milestoneTitle: String
    public var milestoneBadge: String
    public var milestoneIcon: String
    public var lastUpdated: Date
    
    public var progress: Double {
        guard goal > 0 else { return 0 }
        return min(max(Double(steps) / Double(goal), 0.0), 1.0)
    }
    
    public static let appGroupSuite = "group.NIBM.TripPilot"
    public static let storageKey = "tripPilot_widget_shared_steps"
    
    public static var defaults: UserDefaults {
        UserDefaults(suiteName: appGroupSuite) ?? UserDefaults.standard
    }
    
    public static func load() -> TripWidgetSharedData {
        if let data = defaults.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode(TripWidgetSharedData.self, from: data) {
            return decoded
        }
        return TripWidgetSharedData(
            steps: 4250,
            goal: 10000,
            distanceKm: 3.2,
            calories: 174,
            milestoneTitle: "Sigiriya Rock Conqueror",
            milestoneBadge: "3x Sigiriya",
            milestoneIcon: "mountain.2.fill",
            lastUpdated: Date()
        )
    }
    
    public func save() {
        if let encoded = try? JSONEncoder().encode(self) {
            TripWidgetSharedData.defaults.set(encoded, forKey: TripWidgetSharedData.storageKey)
        }
    }
}
