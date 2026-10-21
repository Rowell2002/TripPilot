//
//  SriLankaDataService.swift
//  TripPilot
//
//  Created for Sri Lanka specialized travel planning.
//

import Foundation
import SwiftUI

public final class SriLankaDataService {
    public static let shared = SriLankaDataService()
    
    private init() {}
    
    // MARK: - Verified Sri Lankan Places Database
    public let places: [SriLankaPlace] = [
        // 1. Sigiriya Rock Fortress
        SriLankaPlace(
            name: "Sigiriya Rock Fortress",
            sinhalaName: "සීගිරිය පර්වත මාලිගය",
            district: "Matale",
            province: "Central Province",
            category: .heritage,
            rating: 4.9,
            reviewCount: "48.2k",
            description: "Ancient 5th-century palace citadel built atop a 200-meter sheer granite rock by King Kashyapa. Renowned worldwide for its iconic Lion Gate paws, celestial Sigiriya Frescoes, polished Mirror Wall with ancient graffiti, and symmetrical water gardens.",
            highlights: [
                "UNESCO World Heritage Citadel",
                "Ancient 5th-Century Frescoes & Mirror Wall",
                "Colossal Carved Lion's Paw Gate",
                "Hydraulic Water Gardens & Moats"
            ],
            entryFeeLKR: 11000,
            entryFeeUSD: 36.0,
            openingHours: "06:30 AM – 05:30 PM daily",
            visitorTips: [
                "Start climbing before 7:30 AM to beat tropical heat and crowds.",
                "Wear sturdy footwear with good grip; climb has 1,200 steps.",
                "Bring at least 1.5L of water and sun protection.",
                "Combine with Pidurangala Rock across the valley for sunset views."
            ],
            dressCode: "Comfortable breathable athletic wear, sun hat, and walking shoes.",
            latitude: 7.9570,
            longitude: 80.7603,
            imageUrls: [
                "https://images.unsplash.com/photo-1588598198321-9735fd52455b?auto=format&fit=crop&w=1200&q=80",
                "https://images.unsplash.com/photo-1586861635167-e5223aadc9fe?auto=format&fit=crop&w=1200&q=80",
                "https://images.unsplash.com/photo-1578662996442-48f60103fc96?auto=format&fit=crop&w=1200&q=80"
            ],
            audioGuideAvailable: true,
            audioGuideDuration: "45 min immersive audio tour",
            bestTimeToVisit: "Sunrise (06:30 AM) or Late Afternoon (03:30 PM)",
            badgeText: "UNESCO 8th Wonder",
            reviews: [
                PlaceReview(
                    userName: "Dr. Alistair Finch",
                    userAvatar: "A",
                    userCountry: "United Kingdom 🇬🇧",
                    rating: 5.0,
                    date: "2 days ago",
                    comment: "The sheer engineering feat of building a palace atop this monolithic column 1,500 years ago is breathtaking. The frescoes are vibrant, and the summit vista over the jungle canopy is unmatched.",
                    helpfulCount: 142
                ),
                PlaceReview(
                    userName: "Chihiro Tanaka",
                    userAvatar: "C",
                    userCountry: "Japan 🇯🇵",
                    rating: 5.0,
                    date: "Last week",
                    comment: "Climbed at 6:45 AM. The morning mist drifting over the emerald forests and surrounding lotus tanks was pure magic. Audio guide in TripPilot provided fascinating historical context.",
                    helpfulCount: 98
                ),
                PlaceReview(
                    userName: "Kasun Jayawardena",
                    userAvatar: "K",
                    userCountry: "Sri Lanka 🇱🇰",
                    rating: 5.0,
                    date: "3 weeks ago",
                    comment: "Proud pride of our heritage. Take time at the Mirror Wall to read the poems written by travelers 1,000 years ago. A must-see treasure in our country.",
                    helpfulCount: 215
                )
            ]
        ),
        
        // 2. Nine Arches Bridge, Ella
        SriLankaPlace(
            name: "Nine Arches Bridge",
            sinhalaName: "ආරුක්කු නවයේ පාලම (අහස් පාලම)",
            district: "Badulla",
            province: "Uva Province",
            category: .nature,
            rating: 4.9,
            reviewCount: "34.1k",
            description: "Known locally as the 'Bridge in the Sky', this magnificent viaduct bridge was constructed during the British colonial period entirely out of solid stone, brick, and cement without a single piece of steel. Nestled between dense tea plantations and jungle in Ella.",
            highlights: [
                "Iconic colonial stone viaduct built without steel",
                "World-famous Blue Train crossing photo spot",
                "Surrounded by emerald green Ceylon tea hills",
                "Scenic hiking trails connecting Little Adam's Peak"
            ],
            entryFeeLKR: 0,
            entryFeeUSD: 0.0,
            openingHours: "Open 24 hours (Best daylight: 06:00 AM – 06:00 PM)",
            visitorTips: [
                "Train crossing times: ~09:15 AM, 11:45 AM, 03:30 PM, and 05:30 PM.",
                "Visit the hillside cafes (Asanka Cafe or 9 Arch Cafe) for elevated viewing seats.",
                "Walk along the railway track from Ella town or take a quick 10-min tuk-tuk."
            ],
            dressCode: "Casual footwear suitable for uneven gravel paths and tea slopes.",
            latitude: 6.8767,
            longitude: 81.0608,
            imageUrls: [
                "https://images.unsplash.com/photo-1546708973-b339540b5162?auto=format&fit=crop&w=1200&q=80",
                "https://images.unsplash.com/photo-1566296517009-440dfecddc71?auto=format&fit=crop&w=1200&q=80",
                "https://images.unsplash.com/photo-1586861635167-e5223aadc9fe?auto=format&fit=crop&w=1200&q=80"
            ],
            audioGuideAvailable: true,
            audioGuideDuration: "20 min heritage story",
            bestTimeToVisit: "Morning Train Crossing at 09:15 AM or Golden Hour 05:00 PM",
            badgeText: "Viral Scenic Wonder",
            reviews: [
                PlaceReview(
                    userName: "Emma Watson-Lee",
                    userAvatar: "E",
                    userCountry: "Australia 🇦🇺",
                    rating: 5.0,
                    date: "3 days ago",
                    comment: "Standing on the tea terrace when the bright blue train whistled and curved along the arches was the highlight of our 2-week trip. Absolutely picturesque!",
                    helpfulCount: 88
                ),
                PlaceReview(
                    userName: "Matteo Rossi",
                    userAvatar: "M",
                    userCountry: "Italy 🇮🇹",
                    rating: 5.0,
                    date: "1 week ago",
                    comment: "The walk through the forest from Ella village was lovely. Grab a fresh King Coconut from the local vendors near the tunnel.",
                    helpfulCount: 64
                )
            ]
        ),
        
        // 3. Temple of the Sacred Tooth Relic (Sri Dalada Maligawa), Kandy
        SriLankaPlace(
            name: "Temple of the Sacred Tooth Relic",
            sinhalaName: "ශ්‍රී දළදා මාළිගාව (මහනුවර)",
            district: "Kandy",
            province: "Central Province",
            category: .culture,
            rating: 4.8,
            reviewCount: "41.6k",
            description: "Located in the royal palace complex of the former Kingdom of Kandy, this golden-roofed temple houses the sacred tooth relic of the Buddha. A profoundly sacred pilgrimage site with traditional drummers, fragrant jasmine offerings, and intricate Kandyan wood carvings.",
            highlights: [
                "UNESCO World Heritage Sacred Site",
                "Daily Pooja ceremonies with sacred drumming",
                "Golden Canopy chamber housing the Sacred Relic",
                "Royal Palace Museum & Audience Hall (Magul Maduwa)"
            ],
            entryFeeLKR: 2000,
            entryFeeUSD: 6.5,
            openingHours: "05:30 AM – 08:00 PM daily (Pooja: 05:30 AM, 09:30 AM, 06:30 PM)",
            visitorTips: [
                "Attend the evening Pooja ceremony at 06:30 PM for hypnotic drumming and chanting.",
                "Shoes must be deposited at the entrance counter.",
                "Purchase fresh white lotus or jasmine flowers outside the palace gates."
            ],
            dressCode: "Strict modesty: Shoulders and knees MUST be covered. White or light-colored attire recommended.",
            latitude: 7.2936,
            longitude: 80.6413,
            imageUrls: [
                "https://images.unsplash.com/photo-1589182373726-e4f658ab50f0?auto=format&fit=crop&w=1200&q=80",
                "https://images.unsplash.com/photo-1546708973-b339540b5162?auto=format&fit=crop&w=1200&q=80"
            ],
            audioGuideAvailable: true,
            audioGuideDuration: "35 min sacred pilgrimage guide",
            bestTimeToVisit: "Evening Thevava Pooja at 06:30 PM",
            badgeText: "Sacred UNESCO Landmark",
            reviews: [
                PlaceReview(
                    userName: "Priya Sharma",
                    userAvatar: "P",
                    userCountry: "India 🇮🇳",
                    rating: 5.0,
                    date: "4 days ago",
                    comment: "The spiritual ambiance during the evening drumming ceremony is otherworldly. The scent of sandalwood and jasmine fills the air. A deeply moving experience.",
                    helpfulCount: 112
                ),
                PlaceReview(
                    userName: "Laurent Mercier",
                    userAvatar: "L",
                    userCountry: "France 🇫🇷",
                    rating: 4.8,
                    date: "2 weeks ago",
                    comment: "Beautiful architecture and rich history. Make sure to stroll around the tranquil Kandy Lake right after your visit.",
                    helpfulCount: 75
                )
            ]
        ),
        
        // 4. Galle Dutch Fort & Lighthouse
        SriLankaPlace(
            name: "Galle Dutch Fort",
            sinhalaName: "ගාල්ල ලන්දේසි බලකොටුව",
            district: "Galle",
            province: "Southern Province",
            category: .heritage,
            rating: 4.9,
            reviewCount: "38.9k",
            description: "A living 16th-century fortress city founded by the Portuguese and extensively fortified by the Dutch. Today it is a charming UNESCO heritage precinct filled with cobblestone streets, Dutch colonial villas, boutique cafes, jewelry ateliers, and the iconic white Galle Lighthouse overlooking the Indian Ocean.",
            highlights: [
                "UNESCO World Heritage Living Fort",
                "Sunset strolls on the ancient sea ramparts",
                "Iconic white Galle Lighthouse & Flag Rock",
                "Dutch Hospital Shopping & Fine Dining Precinct"
            ],
            entryFeeLKR: 0,
            entryFeeUSD: 0.0,
            openingHours: "Open 24 hours",
            visitorTips: [
                "Walk the ocean ramparts at sunset (05:30 PM) for cool ocean breezes and golden light.",
                "Visit the Dutch Hospital Precinct for artisan gelato and Ceylon tea tastings.",
                "Cliff divers perform at Flag Rock during low tide."
            ],
            dressCode: "Smart coastal casual, sunglasses, and comfortable walking shoes for cobblestones.",
            latitude: 6.0268,
            longitude: 80.2170,
            imageUrls: [
                "https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?auto=format&fit=crop&w=1200&q=80",
                "https://images.unsplash.com/photo-1588598198321-9735fd52455b?auto=format&fit=crop&w=1200&q=80"
            ],
            audioGuideAvailable: true,
            audioGuideDuration: "40 min maritime history walk",
            bestTimeToVisit: "Late Afternoon (04:30 PM) through Sunset",
            badgeText: "UNESCO Living Citadel",
            reviews: [
                PlaceReview(
                    userName: "Sophia Martinez",
                    userAvatar: "S",
                    userCountry: "Spain 🇪🇸",
                    rating: 5.0,
                    date: "5 days ago",
                    comment: "Walking along the old stone bastions while the Indian Ocean crashes below is unforgettable. Wonderful artisan shops and relaxed atmosphere.",
                    helpfulCount: 94
                )
            ]
        ),
        
        // 5. Yala National Park Safari
        SriLankaPlace(
            name: "Yala National Park Safari",
            sinhalaName: "යාල ජාතික වනෝද්‍යානය",
            district: "Hambantota",
            province: "Southern & Uva",
            category: .wildlife,
            rating: 4.8,
            reviewCount: "29.4k",
            description: "Sri Lanka's premier wildlife sanctuary boasting the highest density of wild leopards in the world (Panthera pardus kotiya). Spanning coastal lagoons, dry scrub plains, and rocky outcrops, it is home to majestic Asian elephants, sloth bears, spotted deer, crocodiles, and hundreds of bird species.",
            highlights: [
                "World's highest leopard population density",
                "Close encounters with wild Asian Elephants",
                "Sloth bears, mugger crocodiles & water buffaloes",
                "Spectacular coastal lagoon landscapes"
            ],
            entryFeeLKR: 12500,
            entryFeeUSD: 40.0,
            openingHours: "06:00 AM – 06:00 PM (Morning Safari: 06:00 AM, Afternoon: 02:30 PM)",
            visitorTips: [
                "Book an experienced tracker and 4x4 open-top safari jeep.",
                "Morning game drive (06:00 AM) offers the best chance of spotting leopards on rocks.",
                "Bring telephoto lenses and binoculars."
            ],
            dressCode: "Neutral, earth-toned safari clothing (khaki, olive, tan). Dust protection/sunglasses recommended.",
            latitude: 6.3725,
            longitude: 81.5173,
            imageUrls: [
                "https://images.unsplash.com/photo-1534177616072-ef7dc120449d?auto=format&fit=crop&w=1200&q=80",
                "https://images.unsplash.com/photo-1549366021-9f761d450615?auto=format&fit=crop&w=1200&q=80"
            ],
            audioGuideAvailable: true,
            audioGuideDuration: "30 min wildlife safari field guide",
            bestTimeToVisit: "Dawn (06:00 AM) or Late Afternoon (03:00 PM)",
            badgeText: "Leopard Haven",
            reviews: [
                PlaceReview(
                    userName: "Marcus Vance",
                    userAvatar: "M",
                    userCountry: "South Africa 🇿🇦",
                    rating: 5.0,
                    date: "1 week ago",
                    comment: "We were blessed to spot a magnificent male leopard resting atop an elephant rock at Block 1 within 45 minutes of entering! Our driver was exceptional.",
                    helpfulCount: 167
                )
            ]
        ),
        
        // 6. Pedro Tea Estate & Lovers Leap, Nuwara Eliya
        SriLankaPlace(
            name: "Pedro Tea Estate & Highlands",
            sinhalaName: "පේද්‍රෝ තේ වතුයාය (නුවරඑළිය)",
            district: "Nuwara Eliya",
            province: "Central Province",
            category: .food,
            rating: 4.8,
            reviewCount: "22.3k",
            description: "Established in 1885 in the mist-shrouded hills of 'Little England' at 1,900m altitude. Witness orthodox Ceylon black tea manufacturing using original Victorian-era machinery, hand-pluck tender tea leaves with local pluckers, and savor pure single-origin Orange Pekoe.",
            highlights: [
                "Historic 1885 Victorian tea processing factory",
                "Guided factory tour & professional tea cupping tasting",
                "Panoramic rolling hills of emerald tea bushes",
                "Short trek to Lover's Leap waterfall nearby"
            ],
            entryFeeLKR: 1500,
            entryFeeUSD: 5.0,
            openingHours: "08:00 AM – 05:00 PM daily",
            visitorTips: [
                "Mornings are best to see the tea pluckers at work in the morning mist.",
                "Bring a warm jacket as Nuwara Eliya temperatures can drop to 12°C - 16°C.",
                "Sample the Lovers Leap Silver Tips at the estate teahouse."
            ],
            dressCode: "Warm light sweater or windbreaker with comfortable walking shoes.",
            latitude: 6.9708,
            longitude: 80.7951,
            imageUrls: [
                "https://images.unsplash.com/photo-1586861635167-e5223aadc9fe?auto=format&fit=crop&w=1200&q=80",
                "https://images.unsplash.com/photo-1546708973-b339540b5162?auto=format&fit=crop&w=1200&q=80"
            ],
            audioGuideAvailable: true,
            audioGuideDuration: "25 min Ceylon Tea story",
            bestTimeToVisit: "Morning (09:00 AM – 11:30 AM)",
            badgeText: "Ceylon Pure Origin",
            reviews: [
                PlaceReview(
                    userName: "Hannah Schmidt",
                    userAvatar: "H",
                    userCountry: "Germany 🇩🇪",
                    rating: 5.0,
                    date: "6 days ago",
                    comment: "The aroma of fermenting tea leaves as you enter the factory is unforgettable. The tasting session on the veranda overlooking the misty valley was serene.",
                    helpfulCount: 52
                )
            ]
        ),
        
        // 7. Mirissa Coconut Tree Hill & Whale Point
        SriLankaPlace(
            name: "Mirissa Coconut Tree Hill",
            sinhalaName: "මිරිස්ස පොල් රුක් කන්ද",
            district: "Matara",
            province: "Southern Coast",
            category: .beach,
            rating: 4.8,
            reviewCount: "27.5k",
            description: "A picturesque red-clay cliff dome jutting into the Indian Ocean, lined with a dense grove of towering palm trees. Sri Lanka's most recognizable coastal viewpoint and a gateway to world-class blue whale watching expeditions in Mirissa Bay.",
            highlights: [
                "Iconic coconut palm grove cliff over the ocean",
                "World's top location for Blue Whale & Dolphin watching",
                "Vibrant beach bars with fresh grilled seafood & King Coconuts",
                "Protected bay for turtle snorkeling and surfing"
            ],
            entryFeeLKR: 0,
            entryFeeUSD: 0.0,
            openingHours: "Open 24 hours",
            visitorTips: [
                "Visit around 06:15 AM for dawn photography without the crowds.",
                "Whale watching boats depart Mirissa Harbor at 06:30 AM daily (Nov - April).",
                "Watch for green sea turtles feeding near the reef."
            ],
            dressCode: "Beachwear, flip-flops or sandals, and sun protection.",
            latitude: 5.9450,
            longitude: 80.4614,
            imageUrls: [
                "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80",
                "https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?auto=format&fit=crop&w=1200&q=80"
            ],
            audioGuideAvailable: true,
            audioGuideDuration: "20 min marine eco-guide",
            bestTimeToVisit: "Sunrise (06:00 AM) or Sunset (05:45 PM)",
            badgeText: "Coastal Icon",
            reviews: [
                PlaceReview(
                    userName: "Alexandre Dubois",
                    userAvatar: "A",
                    userCountry: "Canada 🇨🇦",
                    rating: 5.0,
                    date: "3 days ago",
                    comment: "We saw three blue whales breaching just off the coast, and followed it up with a sunset drink at Coconut Tree Hill. Pure paradise.",
                    helpfulCount: 89
                )
            ]
        ),
        
        // 8. Colombo Lotus Tower & Galle Face Green
        SriLankaPlace(
            name: "Colombo Lotus Tower & Galle Face",
            sinhalaName: "නෙළුම් කුළුණ සහ ගාලු මුවදොර (කොළඹ)",
            district: "Colombo",
            province: "Western Province",
            category: .culture,
            rating: 4.7,
            reviewCount: "31.2k",
            description: "At 350 meters, the Lotus Tower is South Asia's tallest self-supported structure shaped like a blooming lotus bud. Paired with historic Galle Face Green, where city residents gather at sunset for spicy Isso Wade (prawn cakes), flying kites, and Indian Ocean views.",
            highlights: [
                "350m 360° Observation Deck overlooking Colombo skyline & ocean",
                "Galle Face Green seaside promenade & street food",
                "Revolving restaurant & illuminated night light show",
                "Ministry of Crab & Dutch Hospital fine dining nearby"
            ],
            entryFeeLKR: 5000,
            entryFeeUSD: 16.0,
            openingHours: "09:00 AM – 10:00 PM daily",
            visitorTips: [
                "Go up the observation deck right before sunset (05:30 PM) to see both daylight and sparkling night lights.",
                "Try fresh hot Isso Wade with spicy pickled onion from Galle Face street food stalls."
            ],
            dressCode: "Smart casual for the tower observation deck.",
            latitude: 6.9298,
            longitude: 79.8580,
            imageUrls: [
                "https://images.unsplash.com/photo-1589182373726-e4f658ab50f0?auto=format&fit=crop&w=1200&q=80",
                "https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?auto=format&fit=crop&w=1200&q=80"
            ],
            audioGuideAvailable: true,
            audioGuideDuration: "30 min Colombo modern history",
            bestTimeToVisit: "Sunset (05:30 PM – 07:30 PM)",
            badgeText: "Modern Skyline",
            reviews: [
                PlaceReview(
                    userName: "Tharindu Perera",
                    userAvatar: "T",
                    userCountry: "Sri Lanka 🇱🇰",
                    rating: 5.0,
                    date: "Yesterday",
                    comment: "The 360 view from the top is unbelievable. You can see the whole Colombo port city, Beira lake, and on clear days even Adam's Peak in the distant horizon!",
                    helpfulCount: 78
                )
            ]
        )
    ]
    
    // MARK: - Query Helper Methods
    public func getAllPlaces() -> [SriLankaPlace] {
        return places
    }
    
    public func getTrendingPlaces() -> [SriLankaPlace] {
        return Array(places.prefix(4))
    }
    
    public func getEditorPicks() -> [SriLankaPlace] {
        return Array(places.suffix(4))
    }
    
    public func getPlaces(for category: SriLankaCategory, query: String = "") -> [SriLankaPlace] {
        var filtered = places
        if category != .all {
            filtered = filtered.filter { $0.category == category }
        }
        
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if !trimmedQuery.isEmpty {
            filtered = filtered.filter {
                $0.name.lowercased().contains(trimmedQuery) ||
                $0.sinhalaName.contains(trimmedQuery) ||
                $0.district.lowercased().contains(trimmedQuery) ||
                $0.province.lowercased().contains(trimmedQuery) ||
                $0.description.lowercased().contains(trimmedQuery)
            }
        }
        return filtered
    }
    
    // MARK: - Intelligent Dynamic Trip Generation Engine
    public func generateCustomTrip(
        destination: String,
        durationDays: Int,
        companion: String,
        pace: String,
        budget: String,
        tags: [String],
        startDate: Date = Date()
    ) -> GeneratedTrip {
        let dest = destination.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Sri Lanka Highlights" : destination
        let daysCount = max(1, min(14, durationDays))
        let nightsCount = max(0, daysCount - 1)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        let startStr = dateFormatter.string(from: startDate)
        let endCalendarDate = Calendar.current.date(byAdding: .day, value: daysCount, to: startDate) ?? startDate
        let endStr = dateFormatter.string(from: endCalendarDate)
        
        // Base budget calculation based on tier
        let dailyUSD: Double = {
            switch budget.lowercased() {
            case let b where b.contains("saver"): return 65.0
            case let b where b.contains("luxury"): return 380.0
            default: return 160.0
            }
        }()
        let totalUSD = dailyUSD * Double(daysCount)
        let totalLKR = Int(totalUSD * 305.0) // 1 USD = 305 LKR
        
        // Generate Days according to destination theme
        var generatedDays: [TripDay] = []
        let dayNames = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
        
        for index in 0..<daysCount {
            let dayNum = index + 1
            let currentDate = Calendar.current.date(byAdding: .day, value: index, to: startDate) ?? startDate
            
            let weekdayIndex = Calendar.current.component(.weekday, from: currentDate) - 1
            let dayOfWeek = dayNames[max(0, min(6, weekdayIndex))]
            
            let dayOfMonthFormatter = DateFormatter()
            dayOfMonthFormatter.dateFormat = "d"
            let dayOfMonth = dayOfMonthFormatter.string(from: currentDate)
            
            let dayFullFormatter = DateFormatter()
            dayFullFormatter.dateFormat = "EEEE, MMM d"
            let dayFullDate = dayFullFormatter.string(from: currentDate)
            
            let dayData = buildDayForIndex(
                dayNumber: dayNum,
                dayOfWeek: dayOfWeek,
                dayOfMonth: dayOfMonth,
                fullDateString: dayFullDate,
                destination: dest,
                totalDays: daysCount,
                pace: pace,
                budget: budget
            )
            generatedDays.append(dayData)
        }
        
        let weatherSummary: String = {
            if dest.lowercased().contains("ella") || dest.lowercased().contains("nuwara eliya") {
                return "Misty & Crisp • 18°C"
            } else if dest.lowercased().contains("galle") || dest.lowercased().contains("mirissa") {
                return "Tropical Ocean Breeze • 28°C"
            } else {
                return "Warm Sunshine • 29°C"
            }
        }()
        
        return GeneratedTrip(
            title: "\(dest) Expedition",
            destinationRegion: dest,
            destinationFlag: "🇱🇰",
            durationDays: daysCount,
            durationNights: nightsCount,
            companion: companion,
            pace: pace,
            budgetTier: budget,
            tags: tags,
            startDateString: startStr,
            endDateString: endStr,
            weatherSummary: weatherSummary,
            totalEstimatedLKR: totalLKR,
            totalEstimatedUSD: totalUSD,
            days: generatedDays
        )
    }
    
    // MARK: - Internal Day Builder Helper
    private func buildDayForIndex(
        dayNumber: Int,
        dayOfWeek: String,
        dayOfMonth: String,
        fullDateString: String,
        destination: String,
        totalDays: Int,
        pace: String,
        budget: String
    ) -> TripDay {
        let destLower = destination.lowercased()
        
        if destLower.contains("sigiriya") || destLower.contains("cultural") || destLower.contains("triangle") {
            return buildCulturalTriangleDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString)
        } else if destLower.contains("ella") || destLower.contains("hill") || destLower.contains("tea") || destLower.contains("kandy") {
            return buildHillCountryDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString)
        } else if destLower.contains("galle") || destLower.contains("mirissa") || destLower.contains("coast") || destLower.contains("beach") {
            return buildSouthernCoastDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString)
        } else if destLower.contains("yala") || destLower.contains("safari") || destLower.contains("wildlife") {
            return buildWildlifeSafariDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString)
        } else {
            // General Sri Lanka Grand Tour rotating across iconic regions
            let modulo = (dayNumber - 1) % 4
            switch modulo {
            case 0: return buildCulturalTriangleDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString)
            case 1: return buildHillCountryDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString)
            case 2: return buildWildlifeSafariDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString)
            default: return buildSouthernCoastDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString)
            }
        }
    }
    
    private func buildCulturalTriangleDay(dayNumber: Int, dayOfWeek: String, dayOfMonth: String, fullDateString: String) -> TripDay {
        let stops = [
            TripStop(
                time: "06:30 AM",
                title: "Dawn Climb: Sigiriya Lion Rock",
                category: "Heritage",
                icon: "mountain.2.fill",
                description: "Ascend King Kashyapa's sky fortress at first light. Marvel at the 5th-century frescoes and panoramic jungle sunrise before the heat sets in.",
                locationName: "Sigiriya Citadel, Matale",
                estimatedDuration: "2h 30m",
                costLKR: 11000,
                costUSD: 36.0,
                highlight: "UNESCO 8th Wonder",
                passRequired: true,
                passName: "Sigiriya Heritage Pass",
                imageUrl: "https://images.unsplash.com/photo-1588598198321-9735fd52455b?auto=format&fit=crop&w=800&q=80"
            ),
            TripStop(
                time: "10:30 AM",
                title: "Traditional Village Lunch & Lake Catamaran",
                category: "Culture",
                icon: "fork.knife",
                description: "Traditional Bullock cart ride followed by a serene catamaran canoe across a lotus-filled lake. Savor authentic clay-pot Rice & Curry cooked over wood fire.",
                locationName: "Hiriwadunna Village, Habarana",
                estimatedDuration: "2h 00m",
                costLKR: 4500,
                costUSD: 15.0,
                highlight: "Authentic Claypot Feasting",
                imageUrl: "https://images.unsplash.com/photo-1546708973-b339540b5162?auto=format&fit=crop&w=800&q=80"
            ),
            TripStop(
                time: "02:30 PM",
                title: "Dambulla Royal Cave Temple",
                category: "Temples",
                icon: "building.columns.fill",
                description: "Explore 5 sacred cave sanctuaries filled with 150+ gilded Buddha statues and ancient Buddhist murals painted directly onto stone ceilings.",
                locationName: "Dambulla Golden Temple",
                estimatedDuration: "1h 45m",
                costLKR: 2500,
                costUSD: 8.0,
                highlight: "Ancient Cave Art",
                passRequired: true,
                passName: "Dambulla Sanctuary Pass",
                imageUrl: "https://images.unsplash.com/photo-1589182373726-e4f658ab50f0?auto=format&fit=crop&w=800&q=80"
            ),
            TripStop(
                time: "05:00 PM",
                title: "Sunset at Pidurangala Rock Summit",
                category: "Scenic",
                icon: "sun.horizon.fill",
                description: "Short adventurous climb through monastery ruins up onto the flat summit boulders for the world's most photogenic direct vista of Sigiriya Rock.",
                locationName: "Pidurangala, Sigiriya",
                estimatedDuration: "1h 30m",
                costLKR: 1000,
                costUSD: 3.5,
                highlight: "Golden Hour 360° Views",
                imageUrl: "https://images.unsplash.com/photo-1578662996442-48f60103fc96?auto=format&fit=crop&w=800&q=80"
            )
        ]
        
        return TripDay(
            dayNumber: dayNumber,
            dayOfWeek: dayOfWeek,
            dayOfMonth: dayOfMonth,
            fullDateString: fullDateString,
            title: "Royal Fortresses & Ancient Caves",
            region: "Sigiriya & Dambulla",
            weather: "Sunny & Warm",
            temperature: "29°C",
            stops: stops
        )
    }
    
    private func buildHillCountryDay(dayNumber: Int, dayOfWeek: String, dayOfMonth: String, fullDateString: String) -> TripDay {
        let stops = [
            TripStop(
                time: "08:30 AM",
                title: "Nine Arches Bridge Train Crossing",
                category: "Scenic",
                icon: "tram.fill",
                description: "Watch the famous Blue Train curve across the stone viaduct arches amidst rolling tea valleys. Sip fresh ginger tea at a hillside perch.",
                locationName: "Demodara, Ella",
                estimatedDuration: "2h 00m",
                costLKR: 0,
                costUSD: 0.0,
                highlight: "World-Famous Blue Train Spot",
                imageUrl: "https://images.unsplash.com/photo-1546708973-b339540b5162?auto=format&fit=crop&w=800&q=80"
            ),
            TripStop(
                time: "11:30 AM",
                title: "Little Adam's Peak & Zip-line",
                category: "Nature",
                icon: "figure.hiking",
                description: "Gentle panoramic hike through tea plantations to the panoramic peak overlooking Ella Gap and Ravana Falls. Optional Flying Ravana zip-line.",
                locationName: "Ella Gap Ridge",
                estimatedDuration: "2h 30m",
                costLKR: 3000,
                costUSD: 10.0,
                highlight: "Panoramic Highland Ridge",
                imageUrl: "https://images.unsplash.com/photo-1566296517009-440dfecddc71?auto=format&fit=crop&w=800&q=80"
            ),
            TripStop(
                time: "03:00 PM",
                title: "Pedro Estate Ceylon Tea Tasting",
                category: "Food & Tea",
                icon: "cup.and.saucer.fill",
                description: "Tour the 1885 Victorian tea factory, observe the drying and rolling of leaves, and taste supreme Orange Pekoe tea overlooking the mist.",
                locationName: "Nuwara Eliya Highlands",
                estimatedDuration: "1h 45m",
                costLKR: 1500,
                costUSD: 5.0,
                highlight: "Pure Ceylon Tea Plucking",
                passRequired: true,
                passName: "Highland Tea Tasting Pass",
                imageUrl: "https://images.unsplash.com/photo-1586861635167-e5223aadc9fe?auto=format&fit=crop&w=800&q=80"
            ),
            TripStop(
                time: "06:30 PM",
                title: "Cafe Chill & Kottu Feasting",
                category: "Dining",
                icon: "fork.knife",
                description: "Relax at Ella's favorite open-air lounge. Order artisanal cheese & chicken Kottu Roti, fresh passion fruit mojitos, and wood-fired flatbreads.",
                locationName: "Ella Main Street",
                estimatedDuration: "2h 00m",
                costLKR: 4500,
                costUSD: 15.0,
                highlight: "Sizzling Street Kottu",
                imageUrl: "https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?auto=format&fit=crop&w=800&q=80"
            )
        ]
        
        return TripDay(
            dayNumber: dayNumber,
            dayOfWeek: dayOfWeek,
            dayOfMonth: dayOfMonth,
            fullDateString: fullDateString,
            title: "Misty Tea Ridges & Scenic Rails",
            region: "Ella & Nuwara Eliya",
            weather: "Crisp & Misty",
            temperature: "19°C",
            stops: stops
        )
    }
    
    private func buildSouthernCoastDay(dayNumber: Int, dayOfWeek: String, dayOfMonth: String, fullDateString: String) -> TripDay {
        let stops = [
            TripStop(
                time: "06:30 AM",
                title: "Mirissa Blue Whale Watching Voyage",
                category: "Wildlife",
                icon: "water.waves",
                description: "Board a twin-engine catamaran into the deep ocean trench off Mirissa to witness majestic Blue Whales, Sperm Whales, and pods of spinner dolphins.",
                locationName: "Mirissa Fishery Harbour",
                estimatedDuration: "3h 30m",
                costLKR: 15000,
                costUSD: 50.0,
                highlight: "World's Largest Mammals",
                passRequired: true,
                passName: "Marine Safari Permit",
                imageUrl: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80"
            ),
            TripStop(
                time: "11:30 AM",
                title: "Coconut Tree Hill & Secret Beach",
                category: "Beach",
                icon: "sun.max.fill",
                description: "Stroll the red promontory shaded by tall curving coconut palms. Swim with wild green sea turtles in the sheltered reef cove.",
                locationName: "Mirissa Coast",
                estimatedDuration: "2h 00m",
                costLKR: 0,
                costUSD: 0.0,
                highlight: "Iconic Palm Promontory",
                imageUrl: "https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?auto=format&fit=crop&w=800&q=80"
            ),
            TripStop(
                time: "03:30 PM",
                title: "UNESCO Galle Dutch Fort Exploration",
                category: "Heritage",
                icon: "building.columns.fill",
                description: "Wander through the cobblestone alleys of Church Street and Pedlar's Street. Explore 350-year-old Dutch villas, gem shops, and colonial ramparts.",
                locationName: "Galle Fort, Southern Province",
                estimatedDuration: "2h 30m",
                costLKR: 0,
                costUSD: 0.0,
                highlight: "Colonial Living Citadel",
                imageUrl: "https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?auto=format&fit=crop&w=800&q=80"
            ),
            TripStop(
                time: "06:00 PM",
                title: "Sunset at Galle Lighthouse & Seafood Dining",
                category: "Dining",
                icon: "fork.knife",
                description: "Watch the sun dip into the Indian Ocean by the historic white lighthouse, followed by jumbo garlic prawns and lobster at Dutch Hospital Precinct.",
                locationName: "Galle Lighthouse Ramparts",
                estimatedDuration: "2h 00m",
                costLKR: 8500,
                costUSD: 28.0,
                highlight: "Ocean Sunset & Fresh Seafood",
                imageUrl: "https://images.unsplash.com/photo-1588598198321-9735fd52455b?auto=format&fit=crop&w=800&q=80"
            )
        ]
        
        return TripDay(
            dayNumber: dayNumber,
            dayOfWeek: dayOfWeek,
            dayOfMonth: dayOfMonth,
            fullDateString: fullDateString,
            title: "Colonial Ramparts & Marine Wonders",
            region: "Galle & Mirissa",
            weather: "Tropical Breeze",
            temperature: "28°C",
            stops: stops
        )
    }
    
    private func buildWildlifeSafariDay(dayNumber: Int, dayOfWeek: String, dayOfMonth: String, fullDateString: String) -> TripDay {
        let stops = [
            TripStop(
                time: "05:45 AM",
                title: "Dawn Yala Leopard & Sloth Bear Safari",
                category: "Wildlife",
                icon: "pawprint.fill",
                description: "Enter Block 1 as the sun rises over the coastal scrub. Track the elusive Sri Lankan Leopard, sloth bears on rocky outcrops, and herds of spotted deer.",
                locationName: "Yala National Park, Palatupana Gate",
                estimatedDuration: "4h 30m",
                costLKR: 13500,
                costUSD: 45.0,
                highlight: "Prime Leopard Encounter",
                passRequired: true,
                passName: "Yala Park Wildlife Permit",
                imageUrl: "https://images.unsplash.com/photo-1534177616072-ef7dc120449d?auto=format&fit=crop&w=800&q=80"
            ),
            TripStop(
                time: "12:00 PM",
                title: "Udawalawe Elephant Transit Home",
                category: "Conservation",
                icon: "heart.fill",
                description: "Observe rehabilitated orphaned baby elephants being bottle-fed milk by dedicated wildlife rangers before their release back into the wild.",
                locationName: "Udawalawe Sanctuary",
                estimatedDuration: "1h 30m",
                costLKR: 2000,
                costUSD: 6.5,
                highlight: "Ethical Elephant Rescue",
                imageUrl: "https://images.unsplash.com/photo-1549366021-9f761d450615?auto=format&fit=crop&w=800&q=80"
            ),
            TripStop(
                time: "04:30 PM",
                title: "Bundala Salt Pan Flamingo Wetland",
                category: "Nature",
                icon: "bird.fill",
                description: "Explore the coastal lagoons recognized by UNESCO as an international biosphere reserve. Spot thousands of migratory flamingos and sea eagles.",
                locationName: "Bundala Wetland Sanctuary",
                estimatedDuration: "2h 00m",
                costLKR: 3500,
                costUSD: 11.5,
                highlight: "UNESCO Biosphere Bird Haven",
                imageUrl: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80"
            )
        ]
        
        return TripDay(
            dayNumber: dayNumber,
            dayOfWeek: dayOfWeek,
            dayOfMonth: dayOfMonth,
            fullDateString: fullDateString,
            title: "Wild Leopards & Giant Elephant Herds",
            region: "Yala & Udawalawe",
            weather: "Sunny Savannah",
            temperature: "31°C",
            stops: stops
        )
    }
}
