import Foundation
import SwiftUI

// MARK: - Polaroid Memory Model
struct PolaroidMoment: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var localImageFilename: String?
    var remoteImageUrl: String?
    var caption: String            // Primary handwritten text (e.g., "Weston + Elise", "Sigiriya Lion Rock")
    var locationName: String       // e.g. "Central Province, Sri Lanka"
    var date: Date
    var rotationDegrees: Double    // Subtle organic tilt (-2.5° to +2.5°)
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yyyy"
        return formatter.string(from: date)
    }
    
    init(
        id: UUID = UUID(),
        localImageFilename: String? = nil,
        remoteImageUrl: String? = nil,
        caption: String,
        locationName: String,
        date: Date = Date(),
        rotationDegrees: Double? = nil
    ) {
        self.id = id
        self.localImageFilename = localImageFilename
        self.remoteImageUrl = remoteImageUrl
        self.caption = caption
        self.locationName = locationName
        self.date = date
        self.rotationDegrees = rotationDegrees ?? Double.random(in: -2.5...2.5)
    }
}
