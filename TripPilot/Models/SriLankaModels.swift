//
//  SriLankaModels.swift
//  TripPilot
//
//  Created for Sri Lanka specialized travel planning.
//

import SwiftUI
import CoreLocation

// MARK: - Place Category
public enum SriLankaCategory: String, CaseIterable, Identifiable {
    case all = "All"
    case heritage = "Heritage & UNESCO"
    case nature = "Hill Country & Nature"
    case wildlife = "Wildlife & Safari"
    case beach = "Beaches & Coast"
    case food = "Ceylon Food & Tea"
    case culture = "Culture & Temples"
    
    public var id: String { rawValue }
    
    public var iconName: String {
        switch self {
        case .all: return "sparkles"
        case .heritage: return "building.columns.fill"
        case .nature: return "leaf.fill"
        case .wildlife: return "pawprint.fill"
        case .beach: return "water.waves"
        case .food: return "cup.and.saucer.fill"
        case .culture: return "sun.horizon.fill"
        }
    }
    
    public static var highlands: SriLankaCategory { .nature }
    public static var urban: SriLankaCategory { .food }
}

// MARK: - User Review Model
public struct PlaceReview: Identifiable, Hashable {
    public let id: UUID
    public let userName: String
    public let userAvatar: String
    public let userCountry: String
    public let rating: Double
    public let date: String
    public let comment: String
    public let helpfulCount: Int
    
    public init(
        id: UUID = UUID(),
        userName: String,
        userAvatar: String,
        userCountry: String,
        rating: Double,
        date: String,
        comment: String,
        helpfulCount: Int
    ) {
        self.id = id
        self.userName = userName
        self.userAvatar = userAvatar
        self.userCountry = userCountry
        self.rating = rating
        self.date = date
        self.comment = comment
        self.helpfulCount = helpfulCount
    }
}

// MARK: - Sri Lanka Place Model
public struct SriLankaPlace: Identifiable, Hashable {
    public let id: UUID
    public let name: String
    public let sinhalaName: String
    public let district: String
    public let province: String
    public let category: SriLankaCategory
    public let rating: Double
    public let reviewCount: String
    public let description: String
    public let highlights: [String]
    public let entryFeeLKR: Int
    public let entryFeeUSD: Double
    public let openingHours: String
    public let visitorTips: [String]
    public let dressCode: String?
    public let latitude: Double
    public let longitude: Double
    public let imageUrls: [String]
    public let audioGuideAvailable: Bool
    public let audioGuideDuration: String?
    public let bestTimeToVisit: String
    public let badgeText: String?
    public let reviews: [PlaceReview]
    
    public init(
        id: UUID = UUID(),
        name: String,
        sinhalaName: String,
        district: String,
        province: String,
        category: SriLankaCategory,
        rating: Double,
        reviewCount: String,
        description: String,
        highlights: [String],
        entryFeeLKR: Int,
        entryFeeUSD: Double,
        openingHours: String,
        visitorTips: [String],
        dressCode: String? = nil,
        latitude: Double,
        longitude: Double,
        imageUrls: [String],
        audioGuideAvailable: Bool = true,
        audioGuideDuration: String? = nil,
        bestTimeToVisit: String,
        badgeText: String? = nil,
        reviews: [PlaceReview] = []
    ) {
        self.id = id
        self.name = name
        self.sinhalaName = sinhalaName
        self.district = district
        self.province = province
        self.category = category
        self.rating = rating
        self.reviewCount = reviewCount
        self.description = description
        self.highlights = highlights
        self.entryFeeLKR = entryFeeLKR
        self.entryFeeUSD = entryFeeUSD
        self.openingHours = openingHours
        self.visitorTips = visitorTips
        self.dressCode = dressCode
        self.latitude = latitude
        self.longitude = longitude
        self.imageUrls = imageUrls
        self.audioGuideAvailable = audioGuideAvailable
        self.audioGuideDuration = audioGuideDuration
        self.bestTimeToVisit = bestTimeToVisit
        self.badgeText = badgeText
        self.reviews = reviews
    }
    
    public var region: String { "\(district), \(province)" }
    public var entranceFeeUSD: Int { Int(entryFeeUSD) }
    public var entranceFeeLKR: Int { entryFeeLKR }
    public var recommendedDuration: String { audioGuideDuration ?? "2 - 3 hours" }
    public var isUNESCO: Bool {
        badgeText?.contains("UNESCO") == true || category == .heritage || highlights.contains { $0.localizedCaseInsensitiveContains("UNESCO") }
    }
}

// MARK: - Trip Stop Model
public struct TripStop: Identifiable, Hashable {
    public let id: UUID
    public let time: String
    public let title: String
    public let category: String
    public let icon: String
    public let description: String
    public let locationName: String
    public let estimatedDuration: String
    public let costLKR: Int
    public let costUSD: Double
    public let highlight: String
    public let passRequired: Bool
    public let passName: String?
    public let imageUrl: String
    
    public init(
        id: UUID = UUID(),
        time: String,
        title: String,
        category: String,
        icon: String,
        description: String,
        locationName: String,
        estimatedDuration: String,
        costLKR: Int,
        costUSD: Double,
        highlight: String,
        passRequired: Bool = false,
        passName: String? = nil,
        imageUrl: String
    ) {
        self.id = id
        self.time = time
        self.title = title
        self.category = category
        self.icon = icon
        self.description = description
        self.locationName = locationName
        self.estimatedDuration = estimatedDuration
        self.costLKR = costLKR
        self.costUSD = costUSD
        self.highlight = highlight
        self.passRequired = passRequired
        self.passName = passName
        self.imageUrl = imageUrl
    }
    
    public var tag: String { category }
    public var categoryIcon: String { icon }
    public var isHighlight: Bool { !highlight.isEmpty }
}

// MARK: - Trip Day Model
public struct TripDay: Identifiable, Hashable {
    public let id: UUID
    public let dayNumber: Int
    public let dayOfWeek: String
    public let dayOfMonth: String
    public let fullDateString: String
    public let title: String
    public let region: String
    public let weather: String
    public let temperature: String
    public let stops: [TripStop]
    
    public var theme: String { title }
    
    public init(
        id: UUID = UUID(),
        dayNumber: Int,
        dayOfWeek: String,
        dayOfMonth: String,
        fullDateString: String,
        title: String,
        region: String,
        weather: String,
        temperature: String,
        stops: [TripStop]
    ) {
        self.id = id
        self.dayNumber = dayNumber
        self.dayOfWeek = dayOfWeek
        self.dayOfMonth = dayOfMonth
        self.fullDateString = fullDateString
        self.title = title
        self.region = region
        self.weather = weather
        self.temperature = temperature
        self.stops = stops
    }
}

// MARK: - Generated Trip Model
public struct GeneratedTrip: Identifiable, Hashable {
    public let id: UUID
    public let title: String
    public let destinationRegion: String
    public let destinationFlag: String
    public let durationDays: Int
    public let durationNights: Int
    public let companion: String
    public let pace: String
    public let budgetTier: String
    public let tags: [String]
    public let startDateString: String
    public let endDateString: String
    public let weatherSummary: String
    public let totalEstimatedLKR: Int
    public let totalEstimatedUSD: Double
    public let days: [TripDay]
    
    public var destination: String { destinationRegion }
    
    public init(
        id: UUID = UUID(),
        title: String,
        destinationRegion: String,
        destinationFlag: String = "🇱🇰",
        durationDays: Int,
        durationNights: Int,
        companion: String,
        pace: String,
        budgetTier: String,
        tags: [String],
        startDateString: String,
        endDateString: String,
        weatherSummary: String,
        totalEstimatedLKR: Int,
        totalEstimatedUSD: Double,
        days: [TripDay]
    ) {
        self.id = id
        self.title = title
        self.destinationRegion = destinationRegion
        self.destinationFlag = destinationFlag
        self.durationDays = durationDays
        self.durationNights = durationNights
        self.companion = companion
        self.pace = pace
        self.budgetTier = budgetTier
        self.tags = tags
        self.startDateString = startDateString
        self.endDateString = endDateString
        self.weatherSummary = weatherSummary
        self.totalEstimatedLKR = totalEstimatedLKR
        self.totalEstimatedUSD = totalEstimatedUSD
        self.days = days
    }
}
