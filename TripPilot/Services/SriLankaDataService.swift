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
        ),
        SriLankaPlace(
            name: "Ministry of Crab",
            sinhalaName: "මිනිස්ට්‍රි ඔෆ් ක්‍රැබ්",
            district: "Colombo",
            province: "Western Province",
            category: .dining,
            rating: 4.9,
            reviewCount: "5.8k",
            description: "World-renowned seafood temple founded by Chef Dharshan Munidasa and cricket legends Kumar Sangakkara & Mahela Jayawardene in a 400-year-old Dutch Hospital.",
            highlights: [
                "Lagoon Crab in Black Pepper Sauce",
                "Garlic Chilli Prawns with Kade Bread",
                "Claypot Crab Curry & Coconut Sambol"
            ],
            entryFeeLKR: 0,
            entryFeeUSD: 0.0,
            openingHours: "12:00 PM – 11:00 PM daily",
            visitorTips: [
                "Reserve at least 2–3 days in advance during high season.",
                "Order the traditional Sri Lankan 'Kade Bread' to dip into the rich garlic pepper crab broth."
            ],
            dressCode: "Smart casual. No beachwear.",
            latitude: 6.9332,
            longitude: 79.8436,
            imageUrls: [
                "https://images.unsplash.com/photo-1546708973-b339540b5162?auto=format&fit=crop&w=1200&q=80",
                "https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?auto=format&fit=crop&w=1200&q=80"
            ],
            audioGuideAvailable: false,
            audioGuideDuration: nil,
            bestTimeToVisit: "Evening Dinner (07:30 PM)",
            badgeText: "Asia's 50 Best",
            reviews: [
                PlaceReview(
                    userName: "Marcus Vance",
                    userAvatar: "M",
                    userCountry: "United Kingdom 🇬🇧",
                    rating: 5.0,
                    date: "3 days ago",
                    comment: "The pepper crab was nothing short of life changing. The sweet lagoon crab meat with peppery heat and warm wood-fired bread is perfection.",
                    helpfulCount: 64
                )
            ]
        ),
        SriLankaPlace(
            name: "Upali's by Nawaloka",
            sinhalaName: "උපාලිස් කැෆේ",
            district: "Colombo",
            province: "Western Province",
            category: .cafe,
            rating: 4.8,
            reviewCount: "3.2k",
            description: "Colombo's premier destination for authentic Sri Lankan breakfast and home-cooked heirloom curries opposite Viharamahadevi Park.",
            highlights: [
                "Steaming Egg Hoppers with Katta Sambol",
                "Red Rice String Hoppers with Fish Ambul Thiyal",
                "Kiribath (Milk Rice) with Lunu Miris & Jaggery"
            ],
            entryFeeLKR: 0,
            entryFeeUSD: 0.0,
            openingHours: "06:30 AM – 10:30 PM daily",
            visitorTips: [
                "Arrive around 07:30 AM for the freshest batch of crispy egg hoppers straight off the wok.",
                "Pair your meal with a glass of fresh woodapple juice or hot ginger tea."
            ],
            dressCode: "Casual comfortable.",
            latitude: 6.9147,
            longitude: 79.8606,
            imageUrls: [
                "https://images.unsplash.com/photo-1589182373726-e4f658ab50f0?auto=format&fit=crop&w=1200&q=80"
            ],
            audioGuideAvailable: false,
            audioGuideDuration: nil,
            bestTimeToVisit: "Ceylon Breakfast (07:00 AM – 09:30 AM)",
            badgeText: "Authentic Breakfast",
            reviews: [
                PlaceReview(
                    userName: "Sanduni Fernando",
                    userAvatar: "S",
                    userCountry: "Sri Lanka 🇱🇰",
                    rating: 5.0,
                    date: "1 week ago",
                    comment: "The most authentic Sri Lankan breakfast in the city. The egg hoppers are perfectly runny in the center and feather-crisp at the edges!",
                    helpfulCount: 42
                )
            ]
        ),
        SriLankaPlace(
            name: "Cafe Chill & Lounge",
            sinhalaName: "කැෆේ චිල් ඇල්ල",
            district: "Badulla",
            province: "Uva Province",
            category: .dining,
            rating: 4.8,
            reviewCount: "4.4k",
            description: "Ella's iconic open-air bamboo lounge with vibrant backpacker energy, artisanal curries, wood-fired pizzas, and fresh tropical passionfruit mojitos.",
            highlights: [
                "Cheesy Chicken & Vegetable Kottu",
                "Traditional Banana Leaf Lamprais",
                "Fresh Passionfruit & Mint Smoothie Bowls"
            ],
            entryFeeLKR: 0,
            entryFeeUSD: 0.0,
            openingHours: "07:30 AM – Midnight daily",
            visitorTips: [
                "Head to the upper bamboo floor for mountain breeze and fairy-lit evening vibes.",
                "Great spot for both hearty morning avocado toast and late-night music."
            ],
            dressCode: "Relaxed travel casual.",
            latitude: 6.8687,
            longitude: 81.0465,
            imageUrls: [
                "https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?auto=format&fit=crop&w=1200&q=80"
            ],
            audioGuideAvailable: false,
            audioGuideDuration: nil,
            bestTimeToVisit: "Evening Vibes (06:30 PM – 10:00 PM)",
            badgeText: "Highland Hangout",
            reviews: [
                PlaceReview(
                    userName: "Liam O'Connor",
                    userAvatar: "L",
                    userCountry: "Ireland 🇮🇪",
                    rating: 5.0,
                    date: "4 days ago",
                    comment: "Best vibe in Ella! The chicken kottu was heavenly after hiking Little Adam's Peak.",
                    helpfulCount: 39
                )
            ]
        ),
        SriLankaPlace(
            name: "Grand Hotel 1891 High Tea Room",
            sinhalaName: "ග්‍රෑන්ඩ් හෝටලය හයි ටී",
            district: "Nuwara Eliya",
            province: "Central Province",
            category: .cafe,
            rating: 4.9,
            reviewCount: "2.9k",
            description: "Victorian colonial elegance offering the most celebrated High Tea experience in Little England amidst manicured rose gardens and Ceylon single-estate teas.",
            highlights: [
                "Three-tiered silver stand with warm Devon cream scones",
                "Smoked salmon blinis & cucumber sandwiches",
                "Single-Estate Nuwara Eliya Flowery Pekoe tasting"
            ],
            entryFeeLKR: 4500,
            entryFeeUSD: 15.0,
            openingHours: "03:00 PM – 06:00 PM daily",
            visitorTips: [
                "Book tea service between 03:30 PM and 04:30 PM to sit in the glass conservatory overlooking the mist.",
                "Sample the rare Silver Tips white tea harvested only at dawn."
            ],
            dressCode: "Smart casual. Collared shirts recommended.",
            latitude: 6.9697,
            longitude: 80.7678,
            imageUrls: [
                "https://images.unsplash.com/photo-1586861635167-e5223aadc9fe?auto=format&fit=crop&w=1200&q=80"
            ],
            audioGuideAvailable: false,
            audioGuideDuration: nil,
            bestTimeToVisit: "Afternoon High Tea (03:30 PM – 05:30 PM)",
            badgeText: "Heritage High Tea",
            reviews: [
                PlaceReview(
                    userName: "Charlotte Bennett",
                    userAvatar: "C",
                    userCountry: "Australia 🇦🇺",
                    rating: 5.0,
                    date: "2 weeks ago",
                    comment: "Stepping back in time. The warm scones with homemade strawberry jam and fresh cream in the cool mountain air is unforgettable.",
                    helpfulCount: 51
                )
            ]
        ),
        SriLankaPlace(
            name: "Poonie's Kitchen",
            sinhalaName: "පූනීස් කිචන් ගාල්ල",
            district: "Galle",
            province: "Southern Province",
            category: .cafe,
            rating: 4.8,
            reviewCount: "2.1k",
            description: "Enchanting open-air courtyard garden oasis hidden on Pedlar's Street inside Galle Fort. Famous for organic Sri Lankan farmer ingredients and vibrant salad thali bowls.",
            highlights: [
                "Signature Thali Salad with Turmeric & Lemongrass Dressing",
                "Chilled Golden Thambili (King Coconut) Coolers",
                "Fresh Passionfruit and Mango Pavlova"
            ],
            entryFeeLKR: 0,
            entryFeeUSD: 0.0,
            openingHours: "10:00 AM – 05:00 PM (Closed Sundays)",
            visitorTips: [
                "Sit by the tranquil central goldfish pond under tropical banana trees.",
                "Ideal sanctuary to cool down after walking Galle Fort's sunlit ramparts."
            ],
            dressCode: "Casual summer wear.",
            latitude: 6.0270,
            longitude: 80.2178,
            imageUrls: [
                "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80"
            ],
            audioGuideAvailable: false,
            audioGuideDuration: nil,
            bestTimeToVisit: "Fort Lunch & Coffee (12:00 PM – 02:30 PM)",
            badgeText: "Organic Courtyard",
            reviews: [
                PlaceReview(
                    userName: "Emma Watson-Smith",
                    userAvatar: "E",
                    userCountry: "New Zealand 🇳🇿",
                    rating: 5.0,
                    date: "5 days ago",
                    comment: "A hidden secret in the Fort! The salad thali was so fresh and colorful, and the king coconut cooler was so revitalizing.",
                    helpfulCount: 36
                )
            ]
        ),
        
        // 14. Pedlar's Inn Cafe, Galle Fort
        SriLankaPlace(
            name: "Pedlar's Inn Cafe & Gelato",
            sinhalaName: "පෙඩ්ලර්ස් ඉන් කැෆේ (ගාල්ල)",
            district: "Galle",
            province: "Southern Province",
            category: .cafe,
            rating: 4.8,
            reviewCount: "4.7k",
            description: "The historical pioneer cafe of Galle Fort housed inside an 18th-century British colonial post office. Celebrated for artisanal Italian gelato, wood-fired seafood pizzas, iced Ceylon ginger teas, and fresh passionfruit spritzers.",
            highlights: [
                "Oldest & most iconic heritage cafe in Galle Fort",
                "Homemade passionfruit & mango gelato",
                "Spiced Ceylon cold brew coffee"
            ],
            entryFeeLKR: 0,
            entryFeeUSD: 0.0,
            openingHours: "08:30 AM – 10:00 PM daily",
            visitorTips: [
                "Perfect afternoon respite after walking the Fort ramparts.",
                "Try their fresh lime and ginger soda with mint leaves."
            ],
            dressCode: "Smart casual / summer resort wear.",
            latitude: 6.0268,
            longitude: 80.2181,
            imageUrls: [
                "https://images.unsplash.com/photo-1554118811-1e0d58224f24?auto=format&fit=crop&w=1200&q=80"
            ],
            audioGuideAvailable: false,
            audioGuideDuration: nil,
            bestTimeToVisit: "Morning Coffee (09:00 AM) or Sunset Gelato (05:00 PM)",
            badgeText: "Historic Post Office Cafe",
            reviews: [
                PlaceReview(
                    userName: "Jessica Alba-Davies",
                    userAvatar: "J",
                    userCountry: "Australia 🇦🇺",
                    rating: 5.0,
                    date: "3 days ago",
                    comment: "The atmosphere inside this colonial post office is unmatched. The homemade coconut gelato and cold brew coffee gave us the perfect midday energy boost.",
                    helpfulCount: 42
                )
            ]
        ),
        
        // 15. Salty Swamis Cafe & Surf, Weligama / Mirissa
        SriLankaPlace(
            name: "Salty Swamis Cafe & Surf",
            sinhalaName: "සෝල්ටි ස්වාමිස් වෙරළ කැෆේ",
            district: "Matara",
            province: "Southern Province",
            category: .cafe,
            rating: 4.9,
            reviewCount: "3.2k",
            description: "Chic beachfront surf haven and specialty espresso bar overlooking Weligama Bay. Famed for Sri Lanka's best specialty flat whites, pink dragonfruit smoothie bowls, and sourdough avocado toasts.",
            highlights: [
                "Specialty single-origin Ceylon espresso & nitro cold brews",
                "Organic oceanfront breakfast & sourdough tartines",
                "Direct beach access with surf board rentals"
            ],
            entryFeeLKR: 0,
            entryFeeUSD: 0.0,
            openingHours: "07:30 AM – 04:30 PM daily",
            visitorTips: [
                "Arrive early before 9:00 AM for fresh sourdough loaves.",
                "Grab a seat on the ocean-facing deck to watch morning surfers."
            ],
            dressCode: "Beach casual & sunglasses.",
            latitude: 5.9698,
            longitude: 80.4285,
            imageUrls: [
                "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80"
            ],
            audioGuideAvailable: false,
            audioGuideDuration: nil,
            bestTimeToVisit: "Sunrise Breakfast & Surf (07:30 AM – 10:00 AM)",
            badgeText: "Specialty Surf Cafe",
            reviews: [
                PlaceReview(
                    userName: "Finnigan Meyer",
                    userAvatar: "F",
                    userCountry: "Germany 🇩🇪",
                    rating: 5.0,
                    date: "1 week ago",
                    comment: "Best coffee on the southern coast of Sri Lanka! The smoothie bowl was fresh, beautifully arranged, and the surf vibe is 10/10.",
                    helpfulCount: 51
                )
            ]
        ),
        
        // 16. The Empire Cafe, Kandy
        SriLankaPlace(
            name: "The Empire Cafe",
            sinhalaName: "එම්පයර් කැෆේ (මහනුවර)",
            district: "Kandy",
            province: "Central Province",
            category: .cafe,
            rating: 4.8,
            reviewCount: "3.9k",
            description: "Housed in a grand colonial arcade steps away from the sacred Temple of the Tooth. Offers a delightful fusion of Ceylon spices, vegan jackfruit curries, lemongrass tea, and house-made passionfruit cheesecakes.",
            highlights: [
                "Prime location directly across from Temple of the Tooth",
                "Signature Jackfruit Curry & Coconut Roti",
                "Spiced Ceylon chai and organic lemonades"
            ],
            entryFeeLKR: 0,
            entryFeeUSD: 0.0,
            openingHours: "08:30 AM – 08:30 PM daily",
            visitorTips: [
                "Take an outdoor arcade table to soak in the Kandy temple atmosphere.",
                "Pair their spicy curries with freshly squeezed ginger lime juice."
            ],
            dressCode: "Modest casual (near sacred temple premises).",
            latitude: 7.2936,
            longitude: 80.6415,
            imageUrls: [
                "https://images.unsplash.com/photo-1554118811-1e0d58224f24?auto=format&fit=crop&w=1200&q=80"
            ],
            audioGuideAvailable: false,
            audioGuideDuration: nil,
            bestTimeToVisit: "Post-Temple Breakfast or Afternoon Tea (11:00 AM – 04:00 PM)",
            badgeText: "Heritage Temple Cafe",
            reviews: [
                PlaceReview(
                    userName: "Aarti Sengupta",
                    userAvatar: "A",
                    userCountry: "India 🇮🇳",
                    rating: 5.0,
                    date: "4 days ago",
                    comment: "Visited right after the morning pooja at the Temple of the Tooth. The iced spiced chai and pumpkin curry were comforting and delicious.",
                    helpfulCount: 68
                )
            ]
        ),
        
        // 17. Barefoot Garden Cafe, Colombo
        SriLankaPlace(
            name: "Barefoot Garden Cafe & Gallery",
            sinhalaName: "බෙයාර්ෆූට් උද්‍යාන කැෆේ",
            district: "Colombo",
            province: "Western Province",
            category: .dining,
            rating: 4.8,
            reviewCount: "6.1k",
            description: "A cultural institution in Colombo designed around an open-air frangipani courtyard by architect Barbara Sansoni. Renowned for its legendary Black Pork Curry, fresh lime granitas, handloom textiles, and Sunday jazz concerts.",
            highlights: [
                "Lush open-air frangipani and gravel courtyard",
                "Famous Colombo Black Pork Curry with Yellow Rice",
                "Artisan handloom textile boutique and art gallery"
            ],
            entryFeeLKR: 0,
            entryFeeUSD: 0.0,
            openingHours: "10:00 AM – 07:00 PM (Sundays 11:00 AM – 05:00 PM)",
            visitorTips: [
                "Visit on Sunday midday for live jazz in the courtyard.",
                "Order the lime granita to cool off from Colombo heat."
            ],
            dressCode: "Casual chic.",
            latitude: 6.8920,
            longitude: 79.8563,
            imageUrls: [
                "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=1200&q=80"
            ],
            audioGuideAvailable: false,
            audioGuideDuration: nil,
            bestTimeToVisit: "Lunch & Art Browsing (12:00 PM – 03:00 PM)",
            badgeText: "Frangipani Courtyard",
            reviews: [
                PlaceReview(
                    userName: "Oliver Trench",
                    userAvatar: "O",
                    userCountry: "United Kingdom 🇬🇧",
                    rating: 5.0,
                    date: "2 weeks ago",
                    comment: "The black pork curry here is sensational, perfectly spiced with roasted Ceylon curry powder. The courtyard is a tranquil haven inside busy Colombo.",
                    helpfulCount: 77
                )
            ]
        ),
        
        // 18. Matey Hut, Ella
        SriLankaPlace(
            name: "Matey Hut Artisan Cooking",
            sinhalaName: "මේටි හට් ඇල්ල",
            district: "Badulla",
            province: "Uva Province",
            category: .food,
            rating: 4.9,
            reviewCount: "5.8k",
            description: "A tiny wooden hut on the hillside of Ella celebrated across the island for authentic claypot cooking. Every claypot curry is cooked fresh to order with hand-scraped coconut milk, fragrant lemongrass, and heirloom spices.",
            highlights: [
                "Ranked Ella's #1 traditional Sri Lankan dining spot",
                "Claypot pumpkin, cashew, and banana blossom curries",
                "Crispy hot coconut rottis with fiery katta sambol"
            ],
            entryFeeLKR: 0,
            entryFeeUSD: 0.0,
            openingHours: "11:00 AM – 09:30 PM daily",
            visitorTips: [
                "Popular spot with limited tables; arrive at 11:45 AM or 6:30 PM.",
                "Ask for the 5-curry sampler to taste seasonal vegetables."
            ],
            dressCode: "Mountain casual.",
            latitude: 6.8715,
            longitude: 81.0490,
            imageUrls: [
                "https://images.unsplash.com/photo-1546708973-b339540b5162?auto=format&fit=crop&w=1200&q=80"
            ],
            audioGuideAvailable: false,
            audioGuideDuration: nil,
            bestTimeToVisit: "Lunch (12:00 PM) or Early Dinner (06:30 PM)",
            badgeText: "Artisan Claypot Legend",
            reviews: [
                PlaceReview(
                    userName: "Elena Rostova",
                    userAvatar: "E",
                    userCountry: "Canada 🇨🇦",
                    rating: 5.0,
                    date: "3 days ago",
                    comment: "The coconut pumpkin curry and beetroot curry were the best meals I had in my entire 2 weeks in Sri Lanka! Unbelievably fresh and flavorful.",
                    helpfulCount: 89
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
                budget: budget,
                tags: tags
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
        budget: String,
        tags: [String]
    ) -> TripDay {
        let destLower = destination.lowercased()
        let tagsJoined = tags.joined(separator: " ").lowercased()
        let isFoodie = tagsJoined.contains("food") || tagsJoined.contains("kottu") || tagsJoined.contains("seafood") || tagsJoined.contains("cafe") || tagsJoined.contains("dining") || tagsJoined.contains("tea")
        let isBeach = tagsJoined.contains("surf") || tagsJoined.contains("coast") || tagsJoined.contains("beach")
        let isWildlife = tagsJoined.contains("safari") || tagsJoined.contains("wildlife") || tagsJoined.contains("leopard")
        let isCultural = tagsJoined.contains("unesco") || tagsJoined.contains("heritage") || tagsJoined.contains("temple")
        
        if destLower.contains("colombo") || destLower.contains("capital") {
            return buildColomboWesternCoastDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
        } else if destLower.contains("kandy") {
            return buildKandyHeritageDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
        } else if destLower.contains("sigiriya") || destLower.contains("cultural") || destLower.contains("triangle") || destLower.contains("dambulla") {
            return buildCulturalTriangleDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
        } else if destLower.contains("ella") || destLower.contains("hill") || destLower.contains("tea") || destLower.contains("nuwara eliya") {
            return buildHillCountryDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
        } else if destLower.contains("galle") || destLower.contains("mirissa") || destLower.contains("coast") || destLower.contains("beach") || destLower.contains("weligama") {
            return buildSouthernCoastDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
        } else if destLower.contains("yala") || destLower.contains("safari") || destLower.contains("wildlife") {
            return buildWildlifeSafariDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
        } else {
            // Intelligent Grand Tour routing tailored to user purpose tags
            if isFoodie {
                // Focus on gastronomy hubs: Colombo crab/curries, Southern seafood/cafes, Hill country high tea/kottu, Sigiriya claypot feast
                let rotation = (dayNumber - 1) % 4
                switch rotation {
                case 0: return buildSouthernCoastDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                case 1: return buildHillCountryDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                case 2: return buildColomboWesternCoastDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                default: return buildCulturalTriangleDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                }
            } else if isBeach {
                // Focus on coast, surf, and marine life
                let rotation = (dayNumber - 1) % 3
                switch rotation {
                case 0: return buildSouthernCoastDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                case 1: return buildWildlifeSafariDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                default: return buildHillCountryDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                }
            } else if isCultural {
                // Focus on UNESCO citadels, temples, and hill heritage
                let rotation = (dayNumber - 1) % 4
                switch rotation {
                case 0: return buildCulturalTriangleDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                case 1: return buildKandyHeritageDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                case 2: return buildSouthernCoastDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                default: return buildHillCountryDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                }
            } else {
                // Normal exploration trip: smoothly cycles all iconic Sri Lankan regions
                let modulo = (dayNumber - 1) % 6
                switch modulo {
                case 0: return buildCulturalTriangleDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                case 1: return buildKandyHeritageDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                case 2: return buildHillCountryDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                case 3: return buildWildlifeSafariDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                case 4: return buildSouthernCoastDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                default: return buildColomboWesternCoastDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                }
            }
        }
    }
    
    private func buildCulturalTriangleDay(dayNumber: Int, dayOfWeek: String, dayOfMonth: String, fullDateString: String, tags: [String] = []) -> TripDay {
        let stops = [
            TripStop(
                time: "07:30 AM",
                title: "Ceylon Sunrise Breakfast & Fresh Coconut Roti",
                category: "Breakfast & Cafe",
                icon: "cup.and.saucer.fill",
                description: "Start the morning with steaming pol roti, lunu miris, tropical papaya, and fresh Ceylon ginger tea with dramatic views of Lion Rock.",
                locationName: "Rithu Rock View Cafe, Sigiriya",
                estimatedDuration: "1h 00m",
                costLKR: 1800,
                costUSD: 6.0,
                highlight: "Sunrise over Lion Rock",
                imageUrl: "https://images.unsplash.com/photo-1589182373726-e4f658ab50f0?auto=format&fit=crop&w=800&q=80",
                latitude: 7.9540,
                longitude: 80.7550
            ),
            TripStop(
                time: "08:45 AM",
                title: "Sigiriya Lion Rock Sky Citadel Summit",
                category: "Heritage",
                icon: "mountain.2.fill",
                description: "Ascend King Kashyapa's 5th-century palace in the clouds. Walk past the Mirror Wall, marvel at celestial maiden frescoes, and climb through the giant Lion Paws.",
                locationName: "Sigiriya Citadel, Matale",
                estimatedDuration: "2h 30m",
                costLKR: 11000,
                costUSD: 36.0,
                highlight: "UNESCO 8th Wonder",
                passRequired: true,
                passName: "Sigiriya Heritage Pass",
                imageUrl: "https://images.unsplash.com/photo-1588598198321-9735fd52455b?auto=format&fit=crop&w=800&q=80",
                latitude: 7.9570,
                longitude: 80.7603
            ),
            TripStop(
                time: "12:30 PM",
                title: "Wood-Fired Claypot Rice & 5-Curry Feast",
                category: "Lunch & Dining",
                icon: "fork.knife",
                description: "Savor an heirloom lunch served on lotus leaves: fragrant red samba rice, jackfruit polus curry, devilled cashew, fresh dhal, and crispy poppadoms.",
                locationName: "Pradeep Village Kitchen, Sigiriya",
                estimatedDuration: "1h 30m",
                costLKR: 3200,
                costUSD: 10.5,
                highlight: "Wood-Fired Claypot Feast",
                imageUrl: "https://images.unsplash.com/photo-1546708973-b339540b5162?auto=format&fit=crop&w=800&q=80",
                latitude: 7.9535,
                longitude: 80.7580
            ),
            TripStop(
                time: "02:45 PM",
                title: "Dambulla Royal Cave Monasteries",
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
                imageUrl: "https://images.unsplash.com/photo-1589182373726-e4f658ab50f0?auto=format&fit=crop&w=800&q=80",
                latitude: 7.8567,
                longitude: 80.6483
            ),
            TripStop(
                time: "05:15 PM",
                title: "Golden Hour Sunset at Pidurangala Summit",
                category: "Scenic",
                icon: "sun.horizon.fill",
                description: "Climb through ancient monastery boulders for the island's most iconic sunset view, with the golden evening glow illuminating Sigiriya Citadel.",
                locationName: "Pidurangala Rock, Sigiriya",
                estimatedDuration: "1h 30m",
                costLKR: 1000,
                costUSD: 3.5,
                highlight: "Golden Hour 360° Panorama",
                imageUrl: "https://images.unsplash.com/photo-1578662996442-48f60103fc96?auto=format&fit=crop&w=800&q=80",
                latitude: 7.9655,
                longitude: 80.7620
            ),
            TripStop(
                time: "07:30 PM",
                title: "Traditional Ceylon Dinner & Kithul Treacle Dessert",
                category: "Dinner & Drinks",
                icon: "fork.knife",
                description: "Dine under lantern-lit bamboo canopies with spicy devilled prawns, fresh paratha roti, and creamy buffalo curd drizzled with organic kithul palm treacle.",
                locationName: "Sigiriya Heritage Garden Dining",
                estimatedDuration: "2h 00m",
                costLKR: 5500,
                costUSD: 18.0,
                highlight: "Lantern-lit Garden Dining",
                imageUrl: "https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?auto=format&fit=crop&w=800&q=80",
                latitude: 7.9520,
                longitude: 80.7530
            )
        ]
        
        return TripDay(
            dayNumber: dayNumber,
            dayOfWeek: dayOfWeek,
            dayOfMonth: dayOfMonth,
            fullDateString: fullDateString,
            title: "Royal Fortresses & Village Feasting",
            region: "Sigiriya & Dambulla",
            weather: "Sunny & Warm",
            temperature: "29°C",
            stops: stops
        )
    }
    
    private func buildHillCountryDay(dayNumber: Int, dayOfWeek: String, dayOfMonth: String, fullDateString: String, tags: [String] = []) -> TripDay {
        let stops = [
            TripStop(
                time: "07:30 AM",
                title: "Ella Morning Mist Bakery & Tropical Fruit Smoothie",
                category: "Breakfast & Cafe",
                icon: "cup.and.saucer.fill",
                description: "Crispy freshly baked butter croissants, local woodapple jam, avocado toast with poached eggs, and fresh highland Arabica coffee.",
                locationName: "Ella Morning Ridge Cafe",
                estimatedDuration: "1h 00m",
                costLKR: 2200,
                costUSD: 7.0,
                highlight: "Misty Mountain Valley View",
                imageUrl: "https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?auto=format&fit=crop&w=800&q=80",
                latitude: 6.8670,
                longitude: 81.0450
            ),
            TripStop(
                time: "08:45 AM",
                title: "Nine Arches Bridge Morning Blue Train Crossing",
                category: "Scenic",
                icon: "tram.fill",
                description: "Watch the legendary vibrant Blue Train curve gracefully across the 1921 British stone arches amidst rolling tea valleys and morning mist.",
                locationName: "Demodara, Ella",
                estimatedDuration: "2h 00m",
                costLKR: 0,
                costUSD: 0.0,
                highlight: "World-Famous Blue Train Spot",
                imageUrl: "https://images.unsplash.com/photo-1546708973-b339540b5162?auto=format&fit=crop&w=800&q=80",
                latitude: 6.8768,
                longitude: 81.0608
            ),
            TripStop(
                time: "12:15 PM",
                title: "Matey Hut Artisan Rice & 5-Curry Lunch",
                category: "Lunch & Dining",
                icon: "fork.knife",
                description: "Ella's most beloved local eatery. Enjoy pumpkin coconut curry, sweet caramelized brinjal moju, fresh winged beans, and pol sambol.",
                locationName: "Matey Hut, Ella",
                estimatedDuration: "1h 30m",
                costLKR: 2800,
                costUSD: 9.0,
                highlight: "Famous Artisan Claypot Curries",
                imageUrl: "https://images.unsplash.com/photo-1546708973-b339540b5162?auto=format&fit=crop&w=800&q=80",
                latitude: 6.8715,
                longitude: 81.0490
            ),
            TripStop(
                time: "02:30 PM",
                title: "Little Adam's Peak Ridge Hike",
                category: "Nature",
                icon: "figure.hiking",
                description: "Gentle panoramic walk through vibrant green tea estates to the summit overlooking Ella Rock, Ravana Falls, and southern plains.",
                locationName: "Little Adam's Peak, Ella",
                estimatedDuration: "2h 00m",
                costLKR: 0,
                costUSD: 0.0,
                highlight: "360° Ella Gap Vista",
                imageUrl: "https://images.unsplash.com/photo-1566296517009-440dfecddc71?auto=format&fit=crop&w=800&q=80",
                latitude: 6.8625,
                longitude: 81.0540
            ),
            TripStop(
                time: "04:45 PM",
                title: "Grand Hotel 1891 Victorian High Tea",
                category: "High Tea & Cafe",
                icon: "cup.and.saucer.fill",
                description: "Step into colonial splendor for afternoon high tea with warm scones, Devon cream, homemade strawberry jam, and single-estate Orange Pekoe.",
                locationName: "Grand Hotel, Nuwara Eliya",
                estimatedDuration: "1h 45m",
                costLKR: 4500,
                costUSD: 15.0,
                highlight: "Heritage High Tea in Rose Garden",
                passRequired: true,
                passName: "Grand Hotel Tea Reservation",
                imageUrl: "https://images.unsplash.com/photo-1586861635167-e5223aadc9fe?auto=format&fit=crop&w=800&q=80",
                latitude: 6.9697,
                longitude: 80.7678
            ),
            TripStop(
                time: "07:30 PM",
                title: "Cafe Chill: Sizzling Cheese Kottu & Cocktails",
                category: "Dinner & Drinks",
                icon: "fork.knife",
                description: "Unwind on the upper bamboo deck with Ella's best sizzling chicken cheese kottu, banana leaf lamprais, and passionfruit mojitos.",
                locationName: "Cafe Chill, Ella Main Street",
                estimatedDuration: "2h 30m",
                costLKR: 5500,
                costUSD: 18.0,
                highlight: "Highland Night Vibes",
                imageUrl: "https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?auto=format&fit=crop&w=800&q=80",
                latitude: 6.8687,
                longitude: 81.0465
            )
        ]
        
        return TripDay(
            dayNumber: dayNumber,
            dayOfWeek: dayOfWeek,
            dayOfMonth: dayOfMonth,
            fullDateString: fullDateString,
            title: "Misty Rails, High Tea & Kottu",
            region: "Ella & Nuwara Eliya",
            weather: "Crisp & Misty",
            temperature: "19°C",
            stops: stops
        )
    }
    
    private func buildSouthernCoastDay(dayNumber: Int, dayOfWeek: String, dayOfMonth: String, fullDateString: String, tags: [String] = []) -> TripDay {
        let stops = [
            TripStop(
                time: "07:30 AM",
                title: "Salty Swamis Cafe: Dragonfruit Bowl & Cold Brew",
                category: "Breakfast & Cafe",
                icon: "cup.and.saucer.fill",
                description: "Watch morning surfers while enjoying pink dragonfruit smoothie bowls, organic sourdough avocado toast, and specialty Ceylon espresso.",
                locationName: "Salty Swamis Cafe, Weligama Bay",
                estimatedDuration: "1h 00m",
                costLKR: 2400,
                costUSD: 8.0,
                highlight: "Beachfront Ocean View Breakfast",
                imageUrl: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80",
                latitude: 5.9698,
                longitude: 80.4285
            ),
            TripStop(
                time: "09:00 AM",
                title: "Mirissa Blue Whale & Dolphin Catamaran Voyage",
                category: "Wildlife",
                icon: "water.waves",
                description: "Board a modern catamaran into the Indian Ocean canyon to witness majestic Blue Whales and playful spinner dolphins in their natural sanctuary.",
                locationName: "Mirissa Fishery Harbour",
                estimatedDuration: "3h 30m",
                costLKR: 15000,
                costUSD: 50.0,
                highlight: "World's Largest Ocean Giants",
                passRequired: true,
                passName: "Marine Safari Permit",
                imageUrl: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80",
                latitude: 5.9482,
                longitude: 80.4589
            ),
            TripStop(
                time: "01:00 PM",
                title: "Organic Courtyard Garden Lunch at Poonie's",
                category: "Lunch & Cafe",
                icon: "fork.knife",
                description: "Escape the midday sun inside a tranquil courtyard garden. Order the signature thali salad bowl with turmeric dressing and iced lemongrass tea.",
                locationName: "Poonie's Kitchen, Galle Fort",
                estimatedDuration: "1h 30m",
                costLKR: 3800,
                costUSD: 12.5,
                highlight: "Organic Oasis in Old Fort",
                imageUrl: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80",
                latitude: 6.0270,
                longitude: 80.2178
            ),
            TripStop(
                time: "03:00 PM",
                title: "UNESCO Galle Dutch Fort Historical Walk & Pedlar's Gelato",
                category: "Heritage",
                icon: "building.columns.fill",
                description: "Stroll down Church Street, Pedlar's Street, and Old Dutch hospital. Grab an artisan passionfruit gelato at Pedlar's Inn Cafe and explore 17th-century rampart cannons.",
                locationName: "Galle Dutch Fort",
                estimatedDuration: "2h 00m",
                costLKR: 1200,
                costUSD: 4.0,
                highlight: "Living UNESCO Citadel & Gelato",
                imageUrl: "https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?auto=format&fit=crop&w=800&q=80",
                latitude: 6.0300,
                longitude: 80.2170
            ),
            TripStop(
                time: "05:30 PM",
                title: "Sunset at Galle Fort White Lighthouse",
                category: "Scenic",
                icon: "sun.horizon.fill",
                description: "Join locals and travelers sitting along the ancient granite ramparts watching the crimson sunset dip into the Indian Ocean by the iconic lighthouse.",
                locationName: "Galle Lighthouse Point",
                estimatedDuration: "1h 15m",
                costLKR: 0,
                costUSD: 0.0,
                highlight: "Ocean Sunset from Ramparts",
                imageUrl: "https://images.unsplash.com/photo-1588598198321-9735fd52455b?auto=format&fit=crop&w=800&q=80",
                latitude: 6.0250,
                longitude: 80.2185
            ),
            TripStop(
                time: "07:30 PM",
                title: "Oceanfront Seafood Feast & Jumbo Lagoon Crab",
                category: "Dinner & Drinks",
                icon: "fork.knife",
                description: "Waterfront candle-lit dinner featuring freshly caught jumbo garlic prawns, grilled yellowfin tuna steaks, coconut sambol, and chilled Lion Lager.",
                locationName: "A Minute by Tuk Tuk, Dutch Hospital Galle",
                estimatedDuration: "2h 15m",
                costLKR: 8500,
                costUSD: 28.0,
                highlight: "Ocean Breeze Seafood Feast",
                imageUrl: "https://images.unsplash.com/photo-1546708973-b339540b5162?auto=format&fit=crop&w=800&q=80",
                latitude: 6.0290,
                longitude: 80.2165
            )
        ]
        
        return TripDay(
            dayNumber: dayNumber,
            dayOfWeek: dayOfWeek,
            dayOfMonth: dayOfMonth,
            fullDateString: fullDateString,
            title: "Ocean Catamarans, Courtyards & Galle Fort",
            region: "Galle & Mirissa",
            weather: "Tropical Ocean Breeze",
            temperature: "28°C",
            stops: stops
        )
    }
    
    private func buildWildlifeSafariDay(dayNumber: Int, dayOfWeek: String, dayOfMonth: String, fullDateString: String, tags: [String] = []) -> TripDay {
        let stops = [
            TripStop(
                time: "05:45 AM",
                title: "Dawn Yala Leopard & Sloth Bear Safari",
                category: "Wildlife",
                icon: "pawprint.fill",
                description: "Enter Block 1 as the sun rises over the coastal scrub. Track the elusive Sri Lankan Leopard, sloth bears on rocky outcrops, and herds of spotted deer.",
                locationName: "Yala National Park, Palatupana Gate",
                estimatedDuration: "4h 00m",
                costLKR: 13500,
                costUSD: 45.0,
                highlight: "Prime Leopard Encounter",
                passRequired: true,
                passName: "Yala Park Wildlife Permit",
                imageUrl: "https://images.unsplash.com/photo-1534177616072-ef7dc120449d?auto=format&fit=crop&w=800&q=80",
                latitude: 6.3687,
                longitude: 81.5200
            ),
            TripStop(
                time: "10:30 AM",
                title: "Jungle Bush Breakfast & Fresh Ceylon Tea",
                category: "Breakfast & Dining",
                icon: "cup.and.saucer.fill",
                description: "Picnic breakfast set up beside the Manik Ganga river: warm egg roti, pol sambol, fresh seasonal mangoes, bananas, and hot Ceylon tea.",
                locationName: "Manik Ganga River Bank, Yala",
                estimatedDuration: "1h 15m",
                costLKR: 2500,
                costUSD: 8.0,
                highlight: "Riverside Jungle Breakfast",
                imageUrl: "https://images.unsplash.com/photo-1546708973-b339540b5162?auto=format&fit=crop&w=800&q=80",
                latitude: 6.3550,
                longitude: 81.5120
            ),
            TripStop(
                time: "01:00 PM",
                title: "Udawalawe Elephant Transit Home Milk Feeding",
                category: "Conservation",
                icon: "heart.fill",
                description: "Witness dozens of rescued orphaned baby elephants joyfully running in for their afternoon milk feeding before resting in the sanctuary.",
                locationName: "Udawalawe Sanctuary",
                estimatedDuration: "1h 30m",
                costLKR: 2000,
                costUSD: 6.5,
                highlight: "Ethical Elephant Rescue",
                imageUrl: "https://images.unsplash.com/photo-1549366021-9f761d450615?auto=format&fit=crop&w=800&q=80",
                latitude: 6.4740,
                longitude: 80.8870
            ),
            TripStop(
                time: "03:15 PM",
                title: "Southern Buffalo Curd & Kithul Treacle Tasting",
                category: "Cafe & Snack",
                icon: "cup.and.saucer.fill",
                description: "Stop by an artisan claypot stall in Tissamaharama for thick, creamy fresh water buffalo curd topped with sweet wild kithul palm nectar.",
                locationName: "Tissamaharama Village Road",
                estimatedDuration: "1h 00m",
                costLKR: 1200,
                costUSD: 4.0,
                highlight: "Artisanal Claypot Buffalo Curd",
                imageUrl: "https://images.unsplash.com/photo-1589182373726-e4f658ab50f0?auto=format&fit=crop&w=800&q=80",
                latitude: 6.2810,
                longitude: 81.2870
            ),
            TripStop(
                time: "05:00 PM",
                title: "Bundala UNESCO Salt Pan Flamingo Sunset",
                category: "Nature",
                icon: "bird.fill",
                description: "Explore the international biosphere reserve coastal lagoons at twilight. Spot thousands of greater flamingos, pelicans, and sea eagles.",
                locationName: "Bundala Wetland Sanctuary",
                estimatedDuration: "1h 45m",
                costLKR: 3500,
                costUSD: 11.5,
                highlight: "UNESCO Biosphere Bird Sanctuary",
                imageUrl: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80",
                latitude: 6.1950,
                longitude: 81.2180
            ),
            TripStop(
                time: "07:30 PM",
                title: "Campfire Coastal Safari BBQ & Fresh Catch",
                category: "Dinner & Drinks",
                icon: "fork.knife",
                description: "Gather around crackling beach logs under southern stars for charcoal-grilled reef fish, spicy devilled chicken skewers, and wood-fired flatbreads.",
                locationName: "Palatupana Coastal Camp",
                estimatedDuration: "2h 30m",
                costLKR: 6500,
                costUSD: 21.0,
                highlight: "Campfire BBQ Under the Stars",
                imageUrl: "https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?auto=format&fit=crop&w=800&q=80",
                latitude: 6.3320,
                longitude: 81.4280
            )
        ]
        
        return TripDay(
            dayNumber: dayNumber,
            dayOfWeek: dayOfWeek,
            dayOfMonth: dayOfMonth,
            fullDateString: fullDateString,
            title: "Wild Leopards, River Breakfast & Campfire BBQ",
            region: "Yala & Udawalawe",
            weather: "Sunny Savannah",
            temperature: "31°C",
            stops: stops
        )
    }

    private func buildColomboWesternCoastDay(dayNumber: Int, dayOfWeek: String, dayOfMonth: String, fullDateString: String, tags: [String] = []) -> TripDay {
        let stops = [
            TripStop(
                time: "08:00 AM",
                title: "Barefoot Garden Cafe & Ceylon Spiced Coffee",
                category: "Breakfast & Cafe",
                icon: "cup.and.saucer.fill",
                description: "Start under shaded frangipani trees with steaming egg hoppers, spicy katta sambol, and fresh Ceylon highland coffee.",
                locationName: "Barefoot Garden Cafe, Colombo 03",
                estimatedDuration: "1h 15m",
                costLKR: 2400,
                costUSD: 8.0,
                highlight: "Frangipani Courtyard Hoppers",
                imageUrl: "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=800&q=80",
                latitude: 6.8920,
                longitude: 79.8563
            ),
            TripStop(
                time: "09:30 AM",
                title: "Gangaramaya Temple & Seema Malaka on Beira Lake",
                category: "Culture",
                icon: "building.columns.fill",
                description: "Explore Colombo's most iconic Buddhist sanctuary featuring an eclectic museum, sacred Bodhi tree, and Geoffrey Bawa's floating temple on Beira Lake.",
                locationName: "Gangaramaya Temple, Colombo 02",
                estimatedDuration: "2h 00m",
                costLKR: 1000,
                costUSD: 3.5,
                highlight: "Floating Island Temple Pavilion",
                imageUrl: "https://images.unsplash.com/photo-1578662996442-48f60103fc96?auto=format&fit=crop&w=800&q=80",
                latitude: 6.9167,
                longitude: 79.8597
            ),
            TripStop(
                time: "12:30 PM",
                title: "Upali's by Nawaloka: Traditional Yellow Rice & Curries",
                category: "Lunch & Dining",
                icon: "fork.knife",
                description: "Enjoy an authentic Colombo midday feast: fragrant ghee yellow rice, spicy devilled prawn theldala, tender black pepper beef curry, and pol sambol.",
                locationName: "Upali's, Opposite Viharamahadevi Park",
                estimatedDuration: "1h 30m",
                costLKR: 4200,
                costUSD: 14.0,
                highlight: "Legendary Colombo Rice & Curry",
                imageUrl: "https://images.unsplash.com/photo-1546708973-b339540b5162?auto=format&fit=crop&w=800&q=80",
                latitude: 6.9112,
                longitude: 79.8601
            ),
            TripStop(
                time: "02:30 PM",
                title: "Colombo Lotus Tower Observation Deck",
                category: "Scenic",
                icon: "tower.control.fill",
                description: "Take the high-speed elevator 350 meters above the capital for 360-degree panoramic views across Colombo harbor, Beira Lake, and the Indian Ocean coastline.",
                locationName: "Lotus Tower, Colombo",
                estimatedDuration: "1h 30m",
                costLKR: 4500,
                costUSD: 15.0,
                highlight: "350m Sky Deck Panorama",
                passRequired: true,
                passName: "Lotus Tower Observation Pass",
                imageUrl: "https://images.unsplash.com/photo-1588598198321-9735fd52455b?auto=format&fit=crop&w=800&q=80",
                latitude: 6.9271,
                longitude: 79.8578
            ),
            TripStop(
                time: "05:15 PM",
                title: "Galle Face Green Ocean Breeze & Isso Vadai",
                category: "Sunset & Street Food",
                icon: "sun.horizon.fill",
                description: "Walk the historic colonial ocean promenade at twilight. Savor crispy warm prawn isso vadai, fresh king coconut water, and kites flying in the sunset.",
                locationName: "Galle Face Green Promenade",
                estimatedDuration: "1h 45m",
                costLKR: 1200,
                costUSD: 4.0,
                highlight: "Sunset Prawn Vadai by the Waves",
                imageUrl: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80",
                latitude: 6.9234,
                longitude: 79.8458
            ),
            TripStop(
                time: "07:45 PM",
                title: "Ministry of Crab: World-Famous Black Pepper Crab",
                category: "Dinner & Fine Dining",
                icon: "fork.knife",
                description: "Dine at Sri Lanka's globally acclaimed flagship restaurant inside the 400-year-old Dutch Hospital. Feast on succulent wild Sri Lankan lagoon crab in crushed peppercorn sauce.",
                locationName: "Ministry of Crab, Dutch Hospital Fort",
                estimatedDuration: "2h 30m",
                costLKR: 18500,
                costUSD: 60.0,
                highlight: "Asia's 50 Best Crab Experience",
                imageUrl: "https://images.unsplash.com/photo-1546708973-b339540b5162?auto=format&fit=crop&w=800&q=80",
                latitude: 6.9344,
                longitude: 79.8436
            )
        ]
        
        return TripDay(
            dayNumber: dayNumber,
            dayOfWeek: dayOfWeek,
            dayOfMonth: dayOfMonth,
            fullDateString: fullDateString,
            title: "Capital Sky Towers, Street Bites & Lagoon Crab",
            region: "Colombo & Western Coast",
            weather: "Tropical Warm Sunshine",
            temperature: "30°C",
            stops: stops
        )
    }

    private func buildKandyHeritageDay(dayNumber: Int, dayOfWeek: String, dayOfMonth: String, fullDateString: String, tags: [String] = []) -> TripDay {
        let stops = [
            TripStop(
                time: "07:30 AM",
                title: "The Empire Cafe: Jackfruit Curry & Spiced Tea",
                category: "Breakfast & Cafe",
                icon: "cup.and.saucer.fill",
                description: "Dine on the colonial terrace overlooking Kandy Lake and temple grounds with vegan jackfruit curry, warm coconut roti, and iced cinnamon tea.",
                locationName: "The Empire Cafe, Kandy Temple Arcade",
                estimatedDuration: "1h 15m",
                costLKR: 2500,
                costUSD: 8.0,
                highlight: "Colonial Arcade Terrace Breakfast",
                imageUrl: "https://images.unsplash.com/photo-1554118811-1e0d58224f24?auto=format&fit=crop&w=800&q=80",
                latitude: 7.2936,
                longitude: 80.6415
            ),
            TripStop(
                time: "09:00 AM",
                title: "Temple of the Sacred Tooth Relic (Sri Dalada Maligawa)",
                category: "Heritage",
                icon: "building.columns.fill",
                description: "Witness the sacred morning Thevava ritual with resonant drumming and fragrant jasmine lotus offerings at Sri Lanka's spiritual heart.",
                locationName: "Sri Dalada Maligawa, Kandy",
                estimatedDuration: "2h 00m",
                costLKR: 2000,
                costUSD: 6.5,
                highlight: "Sacred Tooth Golden Reliquary",
                passRequired: true,
                passName: "Temple of the Tooth Entry",
                imageUrl: "https://images.unsplash.com/photo-1578662996442-48f60103fc96?auto=format&fit=crop&w=800&q=80",
                latitude: 7.2936,
                longitude: 80.6413
            ),
            TripStop(
                time: "12:15 PM",
                title: "Balaji Dosai: Crisp Ghee Paper Roast & Sambar",
                category: "Lunch & Dining",
                icon: "fork.knife",
                description: "Kandy's most loved South Indian & Ceylon Tamil dining stop. Savor huge crispy ghee paper dosais, spiced potato masala, and rich coconut sambar.",
                locationName: "Balaji Dosai, Colombo Street Kandy",
                estimatedDuration: "1h 15m",
                costLKR: 1800,
                costUSD: 6.0,
                highlight: "Giant Crispy Paper Dosai",
                imageUrl: "https://images.unsplash.com/photo-1546708973-b339540b5162?auto=format&fit=crop&w=800&q=80",
                latitude: 7.2925,
                longitude: 80.6358
            ),
            TripStop(
                time: "02:00 PM",
                title: "Royal Botanical Gardens Peradeniya Walk",
                category: "Nature",
                icon: "leaf.fill",
                description: "Stroll beneath towering royal palm avenues, giant Javanese fig trees with sprawling buttress roots, and the national Orchid greenhouse.",
                locationName: "Peradeniya Botanical Gardens",
                estimatedDuration: "2h 15m",
                costLKR: 3000,
                costUSD: 10.0,
                highlight: "Spectacular Orchid Sanctuary",
                passRequired: true,
                passName: "Botanical Garden Ticket",
                imageUrl: "https://images.unsplash.com/photo-1588598198321-9735fd52455b?auto=format&fit=crop&w=800&q=80",
                latitude: 7.2683,
                longitude: 80.5966
            ),
            TripStop(
                time: "05:00 PM",
                title: "Arthur's Seat Kandy Lake Viewpoint Cafe",
                category: "Sunset & Cafe",
                icon: "sun.horizon.fill",
                description: "Watch the golden evening reflection over Kandy Lake while sipping freshly brewed Ceylon Nuwara Eliya tea with warm ginger biscuits.",
                locationName: "Arthur's Seat, Rajapihilla Mawatha",
                estimatedDuration: "1h 15m",
                costLKR: 1400,
                costUSD: 4.5,
                highlight: "Panoramic Lake Sunset View",
                imageUrl: "https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?auto=format&fit=crop&w=800&q=80",
                latitude: 7.2882,
                longitude: 80.6450
            ),
            TripStop(
                time: "07:30 PM",
                title: "Royal Bar & Hotel: Heritage Spiced Lamprais",
                category: "Dinner & Drinks",
                icon: "fork.knife",
                description: "Historic 19th-century colonial courtyard restaurant. Savor authentic Dutch-Burgher lamprais baked in banana leaf with frikkadels and prawn blachan.",
                locationName: "Royal Bar, Raja Veediya, Kandy",
                estimatedDuration: "2h 00m",
                costLKR: 5800,
                costUSD: 19.0,
                highlight: "Colonial Courtyard Lamprais",
                imageUrl: "https://images.unsplash.com/photo-1546708973-b339540b5162?auto=format&fit=crop&w=800&q=80",
                latitude: 7.2940,
                longitude: 80.6385
            )
        ]
        
        return TripDay(
            dayNumber: dayNumber,
            dayOfWeek: dayOfWeek,
            dayOfMonth: dayOfMonth,
            fullDateString: fullDateString,
            title: "Sacred Tooth Relics, Royal Gardens & Lamprais",
            region: "Kandy & Hill Heritage",
            weather: "Pleasant & Breezy",
            temperature: "24°C",
            stops: stops
        )
    }
}
