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
        let daysCount = max(1, min(30, durationDays))
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
            
            // Enrich stops using Core ML Recommender Engine
            let mlEnrichedStops = dayData.stops.map { stop in
                let mlPrediction = TripMLRecommenderService.shared.predict(
                    for: stop.title,
                    category: stop.category,
                    purpose: tags.joined(separator: " "),
                    pace: pace,
                    budget: budget,
                    durationDays: daysCount,
                    travelerType: companion
                )
                return TripStop(
                    id: stop.id,
                    time: stop.time,
                    title: stop.title,
                    category: stop.category,
                    icon: stop.icon,
                    description: stop.description,
                    locationName: stop.locationName,
                    estimatedDuration: stop.estimatedDuration,
                    costLKR: stop.costLKR,
                    costUSD: stop.costUSD,
                    highlight: stop.highlight,
                    passRequired: stop.passRequired,
                    passName: stop.passName,
                    imageUrl: stop.imageUrl,
                    latitude: stop.latitude,
                    longitude: stop.longitude,
                    matchPercentage: mlPrediction.matchPercentage
                )
            }
            
            let enrichedDay = TripDay(
                id: dayData.id,
                dayNumber: dayData.dayNumber,
                dayOfWeek: dayData.dayOfWeek,
                dayOfMonth: dayData.dayOfMonth,
                fullDateString: dayData.fullDateString,
                title: dayData.title,
                region: dayData.region,
                weather: dayData.weather,
                temperature: dayData.temperature,
                stops: mlEnrichedStops
            )
            generatedDays.append(enrichedDay)
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
        
        // Multi-day regional itinerary routing: every single day within a region is completely unique!
        if destLower.contains("sigiriya") || destLower.contains("cultural") || destLower.contains("triangle") || destLower.contains("dambulla") {
            let dayIndex = (dayNumber - 1) % 3
            switch dayIndex {
            case 0: return buildCulturalTriangleDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
            case 1: return buildCulturalTriangleDay2(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
            default: return buildCulturalTriangleDay3(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
            }
        } else if destLower.contains("ella") || destLower.contains("hill") || destLower.contains("nuwara eliya") {
            let dayIndex = (dayNumber - 1) % 3
            switch dayIndex {
            case 0: return buildHillCountryDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
            case 1: return buildHillCountryDay2(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
            default: return buildHillCountryDay3(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
            }
        } else if destLower.contains("galle") || destLower.contains("mirissa") || destLower.contains("coast") || destLower.contains("beach") || destLower.contains("weligama") {
            let dayIndex = (dayNumber - 1) % 3
            switch dayIndex {
            case 0: return buildSouthernCoastDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
            case 1: return buildSouthernCoastDay2(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
            default: return buildSouthernCoastDay3(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
            }
        } else if destLower.contains("yala") || destLower.contains("safari") || destLower.contains("wildlife") {
            let dayIndex = (dayNumber - 1) % 3
            switch dayIndex {
            case 0: return buildWildlifeSafariDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
            case 1: return buildWildlifeSafariDay2(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
            default: return buildWildlifeSafariDay3(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
            }
        } else if destLower.contains("colombo") || destLower.contains("capital") {
            let dayIndex = (dayNumber - 1) % 3
            switch dayIndex {
            case 0: return buildColomboWesternCoastDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
            case 1: return buildSouthernCoastDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
            default: return buildSouthernCoastDay2(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
            }
        } else if destLower.contains("kandy") {
            let dayIndex = (dayNumber - 1) % 3
            switch dayIndex {
            case 0: return buildKandyHeritageDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
            case 1: return buildHillCountryDay2(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
            default: return buildCulturalTriangleDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
            }
        } else {
            // Intelligent Island-wide Tour routing tailored to user purpose tags
            if isFoodie {
                let rotation = (dayNumber - 1) % 6
                switch rotation {
                case 0: return buildSouthernCoastDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                case 1: return buildHillCountryDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                case 2: return buildColomboWesternCoastDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                case 3: return buildCulturalTriangleDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                case 4: return buildSouthernCoastDay2(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                default: return buildHillCountryDay2(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                }
            } else if isBeach {
                let rotation = (dayNumber - 1) % 4
                switch rotation {
                case 0: return buildSouthernCoastDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                case 1: return buildSouthernCoastDay2(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                case 2: return buildSouthernCoastDay3(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                default: return buildWildlifeSafariDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                }
            } else if isCultural {
                let rotation = (dayNumber - 1) % 4
                switch rotation {
                case 0: return buildCulturalTriangleDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                case 1: return buildKandyHeritageDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                case 2: return buildCulturalTriangleDay2(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                default: return buildCulturalTriangleDay3(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                }
            } else if isWildlife {
                let rotation = (dayNumber - 1) % 4
                switch rotation {
                case 0: return buildWildlifeSafariDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                case 1: return buildWildlifeSafariDay2(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                case 2: return buildWildlifeSafariDay3(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                default: return buildSouthernCoastDay3(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                }
            } else {
                // Normal exploration trip: smoothly cycles all 8 iconic Sri Lankan highlights without repetition
                let modulo = (dayNumber - 1) % 8
                switch modulo {
                case 0: return buildCulturalTriangleDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                case 1: return buildKandyHeritageDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                case 2: return buildHillCountryDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                case 3: return buildWildlifeSafariDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                case 4: return buildSouthernCoastDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                case 5: return buildColomboWesternCoastDay(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                case 6: return buildCulturalTriangleDay2(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
                default: return buildSouthernCoastDay2(dayNumber: dayNumber, dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, fullDateString: fullDateString, tags: tags)
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

    // MARK: - Cultural Triangle Day 2: Caves & Minneriya Wild Elephants
    private func buildCulturalTriangleDay2(dayNumber: Int, dayOfWeek: String, dayOfMonth: String, fullDateString: String, tags: [String] = []) -> TripDay {
        let stops = [
            TripStop(
                time: "07:30 AM",
                title: "Mango Tree Garden Cafe: Traditional String Hoppers",
                category: "Breakfast & Cafe",
                icon: "cup.and.saucer.fill",
                description: "Steaming hot idiappa (string hoppers), spicy kithul treacle tea, fresh fish ambul thiyal, and fresh passionfruit juice in an open garden.",
                locationName: "Mango Tree Cafe, Dambulla",
                estimatedDuration: "1h 00m",
                costLKR: 1900,
                costUSD: 6.0,
                highlight: "Fresh Garden String Hoppers",
                imageUrl: "https://images.unsplash.com/photo-1546708973-b339540b5162?auto=format&fit=crop&w=800&q=80",
                latitude: 7.8720,
                longitude: 80.6510
            ),
            TripStop(
                time: "08:45 AM",
                title: "Dambulla Royal Rock Cave Monasteries",
                category: "Heritage",
                icon: "building.columns.fill",
                description: "Ascend the sacred granite rock to five magnificent cave sanctuaries adorned with 153 gilded Buddha statues and 2,100 square meters of ceiling murals.",
                locationName: "Dambulla Rock Sanctuary",
                estimatedDuration: "2h 00m",
                costLKR: 2500,
                costUSD: 8.0,
                highlight: "Ancient Ceiling Frescoes & Golden Statues",
                passRequired: true,
                passName: "Dambulla Sanctuary Pass",
                imageUrl: "https://images.unsplash.com/photo-1589182373726-e4f658ab50f0?auto=format&fit=crop&w=800&q=80",
                latitude: 7.8567,
                longitude: 80.6483
            ),
            TripStop(
                time: "12:15 PM",
                title: "Gamgedara Waterlily Lakeside Fish Curry Lunch",
                category: "Lunch & Dining",
                icon: "fork.knife",
                description: "Overlooking blooming purple waterlilies, feast on fresh lake fish curry, fried sprats, pumpkin in coconut milk, and wood-fired papadums.",
                locationName: "Gamgedara Lakeside Kitchen, Habarana",
                estimatedDuration: "1h 30m",
                costLKR: 3200,
                costUSD: 10.5,
                highlight: "Waterlily Pond Dining",
                imageUrl: "https://images.unsplash.com/photo-1546708973-b339540b5162?auto=format&fit=crop&w=800&q=80",
                latitude: 8.0340,
                longitude: 80.7510
            ),
            TripStop(
                time: "02:30 PM",
                title: "Minneriya National Park 'The Gathering' Elephant Safari",
                category: "Wildlife",
                icon: "pawprint.fill",
                description: "Board a 4x4 open safari jeep to witness the world-famous Elephant Gathering: up to 300 wild Asian elephants socializing on the lush reservoir grasses.",
                locationName: "Minneriya National Park Gate",
                estimatedDuration: "3h 00m",
                costLKR: 13000,
                costUSD: 42.0,
                highlight: "World's Largest Elephant Gathering",
                passRequired: true,
                passName: "Minneriya Wildlife Permit",
                imageUrl: "https://images.unsplash.com/photo-1549366021-9f761d450615?auto=format&fit=crop&w=800&q=80",
                latitude: 8.0380,
                longitude: 80.8250
            ),
            TripStop(
                time: "05:45 PM",
                title: "Habarana Lake Twilight Stroll & Fresh King Coconut",
                category: "Scenic",
                icon: "sun.horizon.fill",
                description: "Peaceful lakeside walk as white egrets and cormorants return to their nests against the crimson reflection across Habarana ancient lake.",
                locationName: "Habarana Lake Viewpoint",
                estimatedDuration: "1h 15m",
                costLKR: 600,
                costUSD: 2.0,
                highlight: "Tranquil Ancient Lake Sunset",
                imageUrl: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80",
                latitude: 8.0360,
                longitude: 80.7580
            ),
            TripStop(
                time: "07:30 PM",
                title: "Aliya Open-Air Hearth Dinner & Live Kottu",
                category: "Dinner & Drinks",
                icon: "fork.knife",
                description: "Dine under glowing lanterns with rhythmically chopped vegetable cheese kottu, devilled cashew curry, and fresh buffalo curd with wild kithul syrup.",
                locationName: "Aliya Heritage Garden Dining",
                estimatedDuration: "2h 00m",
                costLKR: 5600,
                costUSD: 18.0,
                highlight: "Live Rhythmic Kottu Roti Show",
                imageUrl: "https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?auto=format&fit=crop&w=800&q=80",
                latitude: 7.9620,
                longitude: 80.7490
            )
        ]
        
        return TripDay(
            dayNumber: dayNumber,
            dayOfWeek: dayOfWeek,
            dayOfMonth: dayOfMonth,
            fullDateString: fullDateString,
            title: "Rock Sanctuaries & Minneriya Wild Elephants",
            region: "Dambulla & Minneriya",
            weather: "Warm & Breezy",
            temperature: "30°C",
            stops: stops
        )
    }

    // MARK: - Cultural Triangle Day 3: Polonnaruwa & Artisan Crafts
    private func buildCulturalTriangleDay3(dayNumber: Int, dayOfWeek: String, dayOfMonth: String, fullDateString: String, tags: [String] = []) -> TripDay {
        let stops = [
            TripStop(
                time: "07:30 AM",
                title: "Ancient City Bakery: Coconut Roti & Ginger Chai",
                category: "Breakfast & Cafe",
                icon: "cup.and.saucer.fill",
                description: "Crispy freshly griddled pol roti with spicy caramelized onion lunu miris, fresh tropical fruits, and aromatic hot ginger tea.",
                locationName: "Ancient City Cafe, Polonnaruwa",
                estimatedDuration: "1h 00m",
                costLKR: 1800,
                costUSD: 6.0,
                highlight: "Sunrise Breakfast by the Ruins",
                imageUrl: "https://images.unsplash.com/photo-1554118811-1e0d58224f24?auto=format&fit=crop&w=800&q=80",
                latitude: 7.9390,
                longitude: 81.0020
            ),
            TripStop(
                time: "08:45 AM",
                title: "Polonnaruwa UNESCO Royal Palace & Gal Vihara by Bicycle",
                category: "Heritage",
                icon: "building.columns.fill",
                description: "Cycle through the 12th-century medieval capital: King Parakramabahu's seven-story palace, the circular Vatadage relic house, and the awe-inspiring Gal Vihara granite Buddha statues.",
                locationName: "Polonnaruwa Ancient City",
                estimatedDuration: "3h 00m",
                costLKR: 9500,
                costUSD: 31.0,
                highlight: "Gal Vihara Masterpiece Rock Carvings",
                passRequired: true,
                passName: "Polonnaruwa Heritage Pass",
                imageUrl: "https://images.unsplash.com/photo-1588598198321-9735fd52455b?auto=format&fit=crop&w=800&q=80",
                latitude: 7.9403,
                longitude: 81.0003
            ),
            TripStop(
                time: "12:30 PM",
                title: "Priyamali Gedara: 10-Curry Organic Lotus Leaf Feast",
                category: "Lunch & Dining",
                icon: "fork.knife",
                description: "Sri Lanka's most celebrated rural dining experience: unpolished red heirloom rice served on fresh green lotus leaves with 10 traditional organic curries and fried tank fish.",
                locationName: "Priyamali Gedara, Polonnaruwa",
                estimatedDuration: "1h 30m",
                costLKR: 2800,
                costUSD: 9.0,
                highlight: "Heirloom Lotus Leaf Banquet",
                imageUrl: "https://images.unsplash.com/photo-1546708973-b339540b5162?auto=format&fit=crop&w=800&q=80",
                latitude: 7.9450,
                longitude: 81.0120
            ),
            TripStop(
                time: "02:30 PM",
                title: "Traditional Woodcarving & Brass Artisan Guild",
                category: "Culture",
                icon: "paintbrush.fill",
                description: "Discover ancient Ceylon woodcraft masteries: watch artisans hand-carve ebony elephants, devil dance masks, and cast polished brass oil lamps.",
                locationName: "Polonnaruwa Artisan Guild",
                estimatedDuration: "1h 45m",
                costLKR: 1200,
                costUSD: 4.0,
                highlight: "Hand-Carved Mask & Brass Guild",
                imageUrl: "https://images.unsplash.com/photo-1578662996442-48f60103fc96?auto=format&fit=crop&w=800&q=80",
                latitude: 7.9370,
                longitude: 81.0050
            ),
            TripStop(
                time: "05:15 PM",
                title: "Parakrama Samudra 'Sea of King Parakrama' Sunset",
                category: "Scenic",
                icon: "sun.horizon.fill",
                description: "Watch the sun sink into Sri Lanka's largest ancient man-made inland sea, so vast that the opposite bank vanishes over the water horizon like the ocean.",
                locationName: "Parakrama Samudra Bund",
                estimatedDuration: "1h 30m",
                costLKR: 0,
                costUSD: 0.0,
                highlight: "Inland Sea Ocean Horizon Sunset",
                imageUrl: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80",
                latitude: 7.9310,
                longitude: 80.9950
            ),
            TripStop(
                time: "07:30 PM",
                title: "Lakeside Claypot Dinner & Ceylon Spiced Punch",
                category: "Dinner & Drinks",
                icon: "fork.knife",
                description: "Dine on the veranda beside the reservoir with sweet tamarind glazed freshwater prawns, flaky godamba roti, dhal, and refreshing tropical fruit punch.",
                locationName: "Lake View Heritage Veranda",
                estimatedDuration: "2h 00m",
                costLKR: 5200,
                costUSD: 17.0,
                highlight: "Lakeside Veranda Dining",
                imageUrl: "https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?auto=format&fit=crop&w=800&q=80",
                latitude: 7.9350,
                longitude: 80.9980
            )
        ]
        
        return TripDay(
            dayNumber: dayNumber,
            dayOfWeek: dayOfWeek,
            dayOfMonth: dayOfMonth,
            fullDateString: fullDateString,
            title: "Medieval Citadel Ruins, Artisan Guilds & Inland Seas",
            region: "Polonnaruwa Ancient Kingdom",
            weather: "Tropical Sunny",
            temperature: "31°C",
            stops: stops
        )
    }

    // MARK: - Hill Country Day 2: Nuwara Eliya & Tea Masterclass
    private func buildHillCountryDay2(dayNumber: Int, dayOfWeek: String, dayOfMonth: String, fullDateString: String, tags: [String] = []) -> TripDay {
        let stops = [
            TripStop(
                time: "07:30 AM",
                title: "Damro Tea Lounge: Highland Breakfast & Strawberry Crepes",
                category: "Breakfast & Cafe",
                icon: "cup.and.saucer.fill",
                description: "Overlooking dramatic emerald tea valleys, enjoy freshly picked Nuwara Eliya strawberries, fluffy warm pancakes, and single-estate BOP tea.",
                locationName: "Damro Labookellie Lounge",
                estimatedDuration: "1h 15m",
                costLKR: 2400,
                costUSD: 8.0,
                highlight: "Valley Vista Tea Lounge",
                imageUrl: "https://images.unsplash.com/photo-1554118811-1e0d58224f24?auto=format&fit=crop&w=800&q=80",
                latitude: 7.0210,
                longitude: 80.7250
            ),
            TripStop(
                time: "09:15 AM",
                title: "Pedro Tea Estate Guided Plucking & 1885 Factory Tour",
                category: "Culture",
                icon: "leaf.fill",
                description: "Strap on a wicker tea-basket, walk with estate pluckers on misty slopes, and learn the orthodox Ceylon tea manufacturing process inside the historic 1885 factory.",
                locationName: "Pedro Tea Estate, Nuwara Eliya",
                estimatedDuration: "2h 15m",
                costLKR: 2000,
                costUSD: 6.5,
                highlight: "Hands-on Ceylon Tea Plucking",
                passRequired: true,
                passName: "Pedro Estate Tour Ticket",
                imageUrl: "https://images.unsplash.com/photo-1586861635167-e5223aadc9fe?auto=format&fit=crop&w=800&q=80",
                latitude: 6.9630,
                longitude: 80.8030
            ),
            TripStop(
                time: "12:15 PM",
                title: "Grand Indian: Rich Butter Naan & Saffron Biryani",
                category: "Lunch & Dining",
                icon: "fork.knife",
                description: "Nuwara Eliya's premier culinary staple. Indulge in steaming tandoori garlic naans, creamy black lentil dal makhani, and aromatic chicken dum biryani.",
                locationName: "Grand Indian, Nuwara Eliya",
                estimatedDuration: "1h 30m",
                costLKR: 4200,
                costUSD: 14.0,
                highlight: "Highland Tandoor Gourmet",
                imageUrl: "https://images.unsplash.com/photo-1546708973-b339540b5162?auto=format&fit=crop&w=800&q=80",
                latitude: 6.9680,
                longitude: 80.7670
            ),
            TripStop(
                time: "02:15 PM",
                title: "Gregory Lake Alpine Promenade & Swan Pedal Boats",
                category: "Scenic",
                icon: "water.waves",
                description: "Stroll along pine-fringed alpine lake paths in the cool mountain climate, pedal across calm waters, and admire Tudor-style colonial bungalows.",
                locationName: "Lake Gregory, Nuwara Eliya",
                estimatedDuration: "1h 45m",
                costLKR: 1500,
                costUSD: 5.0,
                highlight: "Alpine Lake Mist & Pine Trees",
                imageUrl: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80",
                latitude: 6.9535,
                longitude: 80.7818
            ),
            TripStop(
                time: "04:30 PM",
                title: "Grand Hotel 1891 Victorian High Tea",
                category: "High Tea & Cafe",
                icon: "cup.and.saucer.fill",
                description: "Step into colonial splendor for afternoon high tea with warm scones, Devon cream, homemade strawberry jam, and single-estate Orange Pekoe.",
                locationName: "Grand Hotel Rose Garden",
                estimatedDuration: "1h 45m",
                costLKR: 4500,
                costUSD: 15.0,
                highlight: "Victorian High Tea in Rose Gardens",
                passRequired: true,
                passName: "Grand Hotel Tea Reservation",
                imageUrl: "https://images.unsplash.com/photo-1586861635167-e5223aadc9fe?auto=format&fit=crop&w=800&q=80",
                latitude: 6.9697,
                longitude: 80.7678
            ),
            TripStop(
                time: "07:30 PM",
                title: "The Barn Hall: Stone Fireplace Dinner & Highland Roast",
                category: "Dinner & Drinks",
                icon: "fork.knife",
                description: "Cozy up beside the roaring log fireplace in the crisp 16°C mountain air. Savor roasted pumpkin soup, rosemary highland lamb cutlets, and warm spiced bread pudding.",
                locationName: "The Barn Hall, Nuwara Eliya",
                estimatedDuration: "2h 15m",
                costLKR: 6800,
                costUSD: 22.0,
                highlight: "Blazing Fireplace Highland Dinner",
                imageUrl: "https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?auto=format&fit=crop&w=800&q=80",
                latitude: 6.9660,
                longitude: 80.7690
            )
        ]
        
        return TripDay(
            dayNumber: dayNumber,
            dayOfWeek: dayOfWeek,
            dayOfMonth: dayOfMonth,
            fullDateString: fullDateString,
            title: "Colonial High Tea, Tea Estates & Alpine Lakes",
            region: "Nuwara Eliya (Little England)",
            weather: "Crisp Mountain Mist",
            temperature: "17°C",
            stops: stops
        )
    }

    // MARK: - Hill Country Day 3: Lipton's Seat & Diyaluma Cascades
    private func buildHillCountryDay3(dayNumber: Int, dayOfWeek: String, dayOfMonth: String, fullDateString: String, tags: [String] = []) -> TripDay {
        let stops = [
            TripStop(
                time: "07:00 AM",
                title: "Haputale Mountain Mist Bakery & Pour-over Coffee",
                category: "Breakfast & Cafe",
                icon: "cup.and.saucer.fill",
                description: "Crispy freshly baked cinnamon swirls, toasted sourdough with mountain honey, and rich pour-over highland Arabica coffee overlooking southern mountain valleys.",
                locationName: "Haputale Ridge Cafe",
                estimatedDuration: "1h 00m",
                costLKR: 2000,
                costUSD: 6.5,
                highlight: "Southern Ridge Mountain Sunrise",
                imageUrl: "https://images.unsplash.com/photo-1554118811-1e0d58224f24?auto=format&fit=crop&w=800&q=80",
                latitude: 6.7680,
                longitude: 80.9520
            ),
            TripStop(
                time: "08:30 AM",
                title: "Lipton's Seat 360° Cloud Ridge Lookout",
                category: "Scenic",
                icon: "mountain.2.fill",
                description: "Climb to Sir Thomas Lipton's historic lookout perched 1,970m high. On clear mornings, you can gaze across seven Sri Lankan provinces all the way to the southern coastline.",
                locationName: "Lipton's Seat, Dambatenne",
                estimatedDuration: "2h 30m",
                costLKR: 1500,
                costUSD: 5.0,
                highlight: "360° Panoramic Viewpoint Across 7 Provinces",
                imageUrl: "https://images.unsplash.com/photo-1566296517009-440dfecddc71?auto=format&fit=crop&w=800&q=80",
                latitude: 6.7820,
                longitude: 81.0150
            ),
            TripStop(
                time: "12:15 PM",
                title: "Dambatenne Planter's Veranda Curry Lunch",
                category: "Lunch & Dining",
                icon: "fork.knife",
                description: "Authentic estate meal: fragrant red samba rice, village country chicken curry, jackfruit seeds in coconut cream, and crisp vegetable mallum.",
                locationName: "Dambatenne Veranda, Haputale",
                estimatedDuration: "1h 30m",
                costLKR: 3000,
                costUSD: 10.0,
                highlight: "Estate Planter's Veranda Lunch",
                imageUrl: "https://images.unsplash.com/photo-1546708973-b339540b5162?auto=format&fit=crop&w=800&q=80",
                latitude: 6.7740,
                longitude: 81.0020
            ),
            TripStop(
                time: "02:15 PM",
                title: "Diyaluma Falls Upper Rock Infinity Pools",
                category: "Nature",
                icon: "water.waves",
                description: "Hike through scenic lemongrass hills to the upper tiers of Sri Lanka's second-highest waterfall (220m). Swim in natural stone infinity rock pools carved into the cliff edge.",
                locationName: "Diyaluma Falls, Koslanda",
                estimatedDuration: "2h 45m",
                costLKR: 1000,
                costUSD: 3.5,
                highlight: "Natural Clifftop Infinity Pool Swim",
                imageUrl: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80",
                latitude: 6.7320,
                longitude: 81.0310
            ),
            TripStop(
                time: "05:30 PM",
                title: "Ella Gap Twilight Terrace & Passionfruit Cooler",
                category: "Sunset & Cafe",
                icon: "sun.horizon.fill",
                description: "Watch dusk sweep across the grand Ella Gap as cool mountain breezes rustle through the tea trees and twilight lanterns light up Ella town.",
                locationName: "Ella Gap Terrace Cafe",
                estimatedDuration: "1h 15m",
                costLKR: 1400,
                costUSD: 4.5,
                highlight: "Twilight Gap Viewpoint",
                imageUrl: "https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?auto=format&fit=crop&w=800&q=80",
                latitude: 6.8650,
                longitude: 81.0420
            ),
            TripStop(
                time: "07:30 PM",
                title: "Cafe One: Wood-Fired Roti & Live Acoustic Evening",
                category: "Dinner & Drinks",
                icon: "fork.knife",
                description: "Relaxed highland vibes with wood-fired cheese and spicy chicken roties, grilled corn on the cob, craft ginger beer, and live acoustic music.",
                locationName: "Cafe One, Ella Main Street",
                estimatedDuration: "2h 15m",
                costLKR: 4800,
                costUSD: 16.0,
                highlight: "Live Mountain Music & Artisan Roti",
                imageUrl: "https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?auto=format&fit=crop&w=800&q=80",
                latitude: 6.8690,
                longitude: 81.0460
            )
        ]
        
        return TripDay(
            dayNumber: dayNumber,
            dayOfWeek: dayOfWeek,
            dayOfMonth: dayOfMonth,
            fullDateString: fullDateString,
            title: "Lipton's Cloud Peak, Waterfall Infinity Pools & Acoustic Nights",
            region: "Haputale & Diyaluma",
            weather: "Sunny & Mountain Breeze",
            temperature: "21°C",
            stops: stops
        )
    }

    // MARK: - Southern Coast Day 2: Weligama Surfing & Mirissa Sunset
    private func buildSouthernCoastDay2(dayNumber: Int, dayOfWeek: String, dayOfMonth: String, fullDateString: String, tags: [String] = []) -> TripDay {
        let stops = [
            TripStop(
                time: "07:30 AM",
                title: "Salty Swamis Cafe: Pink Pitaya Bowl & Cold Brew",
                category: "Breakfast & Cafe",
                icon: "cup.and.saucer.fill",
                description: "Vibrant pink dragonfruit smoothie bowl topped with toasted chia seeds, shaved coconut, organic sourdough avocado toast, and single-origin cold brew.",
                locationName: "Salty Swamis Cafe, Weligama Bay",
                estimatedDuration: "1h 00m",
                costLKR: 2400,
                costUSD: 8.0,
                highlight: "Surf Watchers Healthy Breakfast",
                imageUrl: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80",
                latitude: 5.9698,
                longitude: 80.4285
            ),
            TripStop(
                time: "09:00 AM",
                title: "Weligama Bay Gentle Waves Surf Clinic",
                category: "Adventure",
                icon: "figure.surfing",
                description: "Two-hour guided beginner surf lesson in Weligama's sheltered sandy bay. Catch peeling warm waves with an ISA certified instructor.",
                locationName: "Weligama Surf Point",
                estimatedDuration: "2h 15m",
                costLKR: 5500,
                costUSD: 18.0,
                highlight: "Ride Your First Sri Lankan Wave",
                imageUrl: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80",
                latitude: 5.9720,
                longitude: 80.4310
            ),
            TripStop(
                time: "12:30 PM",
                title: "Ceylon Sliders Rooftop Coastal Lunch",
                category: "Lunch & Dining",
                icon: "fork.knife",
                description: "Breezy coastal rooftop dining: fresh yellowfin tuna poke bowl, spicy fish tacos, lime coriander salsa, and iced watermelon mint juice.",
                locationName: "Ceylon Sliders, Weligama",
                estimatedDuration: "1h 30m",
                costLKR: 3900,
                costUSD: 13.0,
                highlight: "Ocean Breeze Rooftop Poke & Tacos",
                imageUrl: "https://images.unsplash.com/photo-1546708973-b339540b5162?auto=format&fit=crop&w=800&q=80",
                latitude: 5.9735,
                longitude: 80.4340
            ),
            TripStop(
                time: "02:45 PM",
                title: "Koggala Traditional Stilt Fishermen Cultural Heritage",
                category: "Culture",
                icon: "camera.fill",
                description: "Meet iconic Southern fishermen balancing gracefully on slender wooden stilts (ritipanna) above crashing shallow coral reefs.",
                locationName: "Koggala Stilt Fishermen Point",
                estimatedDuration: "1h 30m",
                costLKR: 1500,
                costUSD: 5.0,
                highlight: "Living Ceylon Maritime Heritage",
                imageUrl: "https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?auto=format&fit=crop&w=800&q=80",
                latitude: 5.9920,
                longitude: 80.3240
            ),
            TripStop(
                time: "05:15 PM",
                title: "Mirissa Coconut Tree Hill Golden Hour Sunset",
                category: "Scenic",
                icon: "sun.horizon.fill",
                description: "Walk up the famous reddish clay mound crowned with leaning coconut palms overlooking the endless blue expanse of the Indian Ocean at sunset.",
                locationName: "Coconut Tree Hill, Mirissa",
                estimatedDuration: "1h 30m",
                costLKR: 0,
                costUSD: 0.0,
                highlight: "Iconic Leaning Palm Sunset Promontory",
                imageUrl: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80",
                latitude: 5.9442,
                longitude: 80.4619
            ),
            TripStop(
                time: "07:30 PM",
                title: "Zephyr Beachfront Seafood BBQ & Torchlight Dinner",
                category: "Dinner & Drinks",
                icon: "fork.knife",
                description: "Dine with your feet in the sand illuminated by tiki torches. Choose fresh red snapper, jumbo garlic butter prawns, and passionfruit mojitos.",
                locationName: "Zephyr Beach Restaurant, Mirissa",
                estimatedDuration: "2h 30m",
                costLKR: 7800,
                costUSD: 25.0,
                highlight: "Feet-in-the-Sand Torchlit Feast",
                imageUrl: "https://images.unsplash.com/photo-1546708973-b339540b5162?auto=format&fit=crop&w=800&q=80",
                latitude: 5.9465,
                longitude: 80.4570
            )
        ]
        
        return TripDay(
            dayNumber: dayNumber,
            dayOfWeek: dayOfWeek,
            dayOfMonth: dayOfMonth,
            fullDateString: fullDateString,
            title: "Weligama Waves, Stilt Fishermen & Coconut Hill",
            region: "Weligama & Mirissa Coast",
            weather: "Sunny Coastal Breeze",
            temperature: "29°C",
            stops: stops
        )
    }

    // MARK: - Southern Coast Day 3: Whales, Secret Coves & Unawatuna
    private func buildSouthernCoastDay3(dayNumber: Int, dayOfWeek: String, dayOfMonth: String, fullDateString: String, tags: [String] = []) -> TripDay {
        let stops = [
            TripStop(
                time: "06:30 AM",
                title: "Mirissa Harbour Sunrise & Tropical King Coconut",
                category: "Breakfast & Cafe",
                icon: "cup.and.saucer.fill",
                description: "Watch multi-colored wooden fishing trawlers unload night catches while enjoying fresh king coconut water, sweet mini bananas, and warm roti.",
                locationName: "Mirissa Fishery Harbour",
                estimatedDuration: "0h 45m",
                costLKR: 1200,
                costUSD: 4.0,
                highlight: "Harbour Sunrise Departure",
                imageUrl: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80",
                latitude: 5.9482,
                longitude: 80.4589
            ),
            TripStop(
                time: "07:30 AM",
                title: "Ethical Blue Whale & Spinner Dolphin Sailing Catamaran",
                category: "Wildlife",
                icon: "water.waves",
                description: "Cruise into the deep Indian Ocean canyon aboard an eco-friendly sailing catamaran to witness migrating Blue Whales and super-pods of acrobatic spinner dolphins.",
                locationName: "Mirissa Marine Sanctuary",
                estimatedDuration: "3h 45m",
                costLKR: 15000,
                costUSD: 50.0,
                highlight: "Majestic Blue Whales in the Wild",
                passRequired: true,
                passName: "Marine Sanctuary Pass",
                imageUrl: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80",
                latitude: 5.9200,
                longitude: 80.4600
            ),
            TripStop(
                time: "12:30 PM",
                title: "Secret Beach Secluded Cove Lunch & Fresh Calamari",
                category: "Lunch & Dining",
                icon: "fork.knife",
                description: "Tucked behind a lush jungle hill, this hidden cove boasts turquoise natural tidal pools. Enjoy grilled calamari with lime chili dip and iced coconut smoothies.",
                locationName: "Secret Beach, Mirissa",
                estimatedDuration: "2h 00m",
                costLKR: 3800,
                costUSD: 12.5,
                highlight: "Hidden Cove & Natural Rock Pools",
                imageUrl: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80",
                latitude: 5.9450,
                longitude: 80.4510
            ),
            TripStop(
                time: "03:15 PM",
                title: "Sea Turtle Rescue & Rehabilitation Sanctuary",
                category: "Conservation",
                icon: "heart.fill",
                description: "Support ethical conservation efforts for rescued Green, Hawksbill, and Olive Ridley sea turtles, and learn about coastal nest protection programs.",
                locationName: "Habaraduwa Turtle Sanctuary",
                estimatedDuration: "1h 30m",
                costLKR: 1500,
                costUSD: 5.0,
                highlight: "Rescued Sea Turtle Rehabilitation",
                imageUrl: "https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?auto=format&fit=crop&w=800&q=80",
                latitude: 6.0020,
                longitude: 80.3010
            ),
            TripStop(
                time: "05:15 PM",
                title: "Japanese Peace Pagoda & Rumassala Sunset Panorama",
                category: "Scenic",
                icon: "sun.horizon.fill",
                description: "Stand atop Rumassala headland by the pristine white pagoda, looking out across the entire crescent of Galle Bay and the historic fort ramparts in the sunset.",
                locationName: "Japanese Peace Pagoda, Rumassala",
                estimatedDuration: "1h 30m",
                costLKR: 0,
                costUSD: 0.0,
                highlight: "Sunset Panorama Over Galle Bay",
                imageUrl: "https://images.unsplash.com/photo-1588598198321-9735fd52455b?auto=format&fit=crop&w=800&q=80",
                latitude: 6.0140,
                longitude: 80.2450
            ),
            TripStop(
                time: "07:30 PM",
                title: "Kingfisher Beachfront Restaurant: Lemongrass Crab Curry",
                category: "Dinner & Fine Dining",
                icon: "fork.knife",
                description: "Beachfront dining on Unawatuna sands. Feast on rich coconut lemongrass crab curry, garlic naan, grilled jumbo prawns, and chilled Sauvignon Blanc.",
                locationName: "Kingfisher, Unawatuna Beach",
                estimatedDuration: "2h 30m",
                costLKR: 8900,
                costUSD: 29.0,
                highlight: "Signature Lemongrass Lagoon Crab",
                imageUrl: "https://images.unsplash.com/photo-1546708973-b339540b5162?auto=format&fit=crop&w=800&q=80",
                latitude: 6.0090,
                longitude: 80.2480
            )
        ]
        
        return TripDay(
            dayNumber: dayNumber,
            dayOfWeek: dayOfWeek,
            dayOfMonth: dayOfMonth,
            fullDateString: fullDateString,
            title: "Blue Whale Ocean Catamarans, Secret Coves & Unawatuna",
            region: "Mirissa & Unawatuna",
            weather: "Warm Ocean Breeze",
            temperature: "28°C",
            stops: stops
        )
    }

    // MARK: - Wildlife Safari Day 2: Bundala Wetland Sanctuary
    private func buildWildlifeSafariDay2(dayNumber: Int, dayOfWeek: String, dayOfMonth: String, fullDateString: String, tags: [String] = []) -> TripDay {
        let stops = [
            TripStop(
                time: "07:00 AM",
                title: "Southern Village Hoppers & Katta Sambol",
                category: "Breakfast & Cafe",
                icon: "cup.and.saucer.fill",
                description: "Freshly made crispy egg hoppers, sweet coconut milk hoppers, spicy crushed chili katta sambol, and hot ginger milk tea.",
                locationName: "Tissa Village Kitchen",
                estimatedDuration: "1h 00m",
                costLKR: 1800,
                costUSD: 6.0,
                highlight: "Authentic Southern Village Hoppers",
                imageUrl: "https://images.unsplash.com/photo-1554118811-1e0d58224f24?auto=format&fit=crop&w=800&q=80",
                latitude: 6.2800,
                longitude: 81.2850
            ),
            TripStop(
                time: "08:30 AM",
                title: "Bundala UNESCO Biosphere Flamingo & Wetland Safari",
                category: "Wildlife",
                icon: "bird.fill",
                description: "4x4 safari through Ramsar coastal wetlands. Spot thousands of greater flamingos feeding in salt pans, giant pelicans, sea eagles, and mugger crocodiles.",
                locationName: "Bundala National Park Gate",
                estimatedDuration: "3h 30m",
                costLKR: 9500,
                costUSD: 31.0,
                highlight: "Greater Flamingos & Coastal Biosphere",
                passRequired: true,
                passName: "Bundala Wildlife Permit",
                imageUrl: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80",
                latitude: 6.1950,
                longitude: 81.2180
            ),
            TripStop(
                time: "12:30 PM",
                title: "Kirinda Lagoon Fresh Tiger Prawns & Red Rice",
                category: "Lunch & Dining",
                icon: "fork.knife",
                description: "Savor sweet wild tiger prawns sautéed in garlic, spicy tomato devilled sauce, dhal, and fresh coconut sambol with unpolished red country rice.",
                locationName: "Kirinda Lagoon Rest, Kirinda",
                estimatedDuration: "1h 30m",
                costLKR: 3800,
                costUSD: 12.5,
                highlight: "Wild Lagoon Tiger Prawns",
                imageUrl: "https://images.unsplash.com/photo-1546708973-b339540b5162?auto=format&fit=crop&w=800&q=80",
                latitude: 6.2150,
                longitude: 81.3320
            ),
            TripStop(
                time: "02:30 PM",
                title: "Ancient Kirinda Ocean Clifftop Temple",
                category: "Heritage",
                icon: "building.columns.fill",
                description: "Perched on dramatic black boulders battered by roaring southern waves, this ancient 2nd century BC shrine commemorates legendary Queen Viharamahadevi.",
                locationName: "Kirinda Rock Viharaya",
                estimatedDuration: "1h 45m",
                costLKR: 500,
                costUSD: 1.5,
                highlight: "Ancient Clifftop Buddhist Shrine",
                imageUrl: "https://images.unsplash.com/photo-1588598198321-9735fd52455b?auto=format&fit=crop&w=800&q=80",
                latitude: 6.2135,
                longitude: 81.3360
            ),
            TripStop(
                time: "05:15 PM",
                title: "Palatupana Coastal Dunes Sunset Vista",
                category: "Scenic",
                icon: "sun.horizon.fill",
                description: "Golden sand dunes rolling down into crashing Indian Ocean waves where sea eagles soar against pink and gold twilight skies.",
                locationName: "Palatupana Coastal Dunes, Yala",
                estimatedDuration: "1h 30m",
                costLKR: 0,
                costUSD: 0.0,
                highlight: "Dramatic Coastal Dune Golden Hour",
                imageUrl: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80",
                latitude: 6.3320,
                longitude: 81.4280
            ),
            TripStop(
                time: "07:30 PM",
                title: "Cinnamon Wild Safari Deck: Lantern-lit Bush BBQ",
                category: "Dinner & Drinks",
                icon: "fork.knife",
                description: "Overlooking a natural crocodile lake, enjoy tender skewers of charcoal-grilled chicken, fresh reef fish, sweet roasted corn, and cold drinks under southern stars.",
                locationName: "Cinnamon Wild Deck, Yala",
                estimatedDuration: "2h 30m",
                costLKR: 7200,
                costUSD: 24.0,
                highlight: "Over-Water Safari Deck Dinner",
                imageUrl: "https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?auto=format&fit=crop&w=800&q=80",
                latitude: 6.3380,
                longitude: 81.4350
            )
        ]
        
        return TripDay(
            dayNumber: dayNumber,
            dayOfWeek: dayOfWeek,
            dayOfMonth: dayOfMonth,
            fullDateString: fullDateString,
            title: "Flamingo Wetlands, Ocean Temples & Coastal Sand Dunes",
            region: "Bundala & Kirinda Coast",
            weather: "Sunny Coastal Savannah",
            temperature: "31°C",
            stops: stops
        )
    }

    // MARK: - Wildlife Safari Day 3: Udawalawe Elephant Herds
    private func buildWildlifeSafariDay3(dayNumber: Int, dayOfWeek: String, dayOfMonth: String, fullDateString: String, tags: [String] = []) -> TripDay {
        let stops = [
            TripStop(
                time: "07:30 AM",
                title: "Walawe Riverbank Breakfast & Highland Coffee",
                category: "Breakfast & Cafe",
                icon: "cup.and.saucer.fill",
                description: "Enjoy sweet tropical papaya, scrambled country eggs with warm roti, and steaming highland coffee overlooking the peaceful Walawe river.",
                locationName: "Walawe River Cafe, Udawalawe",
                estimatedDuration: "1h 00m",
                costLKR: 2000,
                costUSD: 6.5,
                highlight: "Riverside Jungle Morning",
                imageUrl: "https://images.unsplash.com/photo-1554118811-1e0d58224f24?auto=format&fit=crop&w=800&q=80",
                latitude: 6.4420,
                longitude: 80.8920
            ),
            TripStop(
                time: "09:00 AM",
                title: "Udawalawe Elephant Transit Home Milk Feeding",
                category: "Conservation",
                icon: "heart.fill",
                description: "Witness over 40 orphaned and injured baby elephants bounding playfully into the sanctuary yard for their morning milk feeding before rehabilitation.",
                locationName: "Elephant Transit Home",
                estimatedDuration: "1h 45m",
                costLKR: 2000,
                costUSD: 6.5,
                highlight: "Rescued Baby Elephant Milk Feeding",
                imageUrl: "https://images.unsplash.com/photo-1549366021-9f761d450615?auto=format&fit=crop&w=800&q=80",
                latitude: 6.4740,
                longitude: 80.8870
            ),
            TripStop(
                time: "11:30 AM",
                title: "Grand Udawalawe Garden Organic Curry Feast",
                category: "Lunch & Dining",
                icon: "fork.knife",
                description: "Heirloom country curries: spicy free-range chicken curry, creamy lotus root curry, crispy pol sambol, and sweet mango chutney.",
                locationName: "Grand Udawalawe Restaurant",
                estimatedDuration: "1h 30m",
                costLKR: 3600,
                costUSD: 12.0,
                highlight: "Organic Garden-to-Table Curries",
                imageUrl: "https://images.unsplash.com/photo-1546708973-b339540b5162?auto=format&fit=crop&w=800&q=80",
                latitude: 6.4450,
                longitude: 80.8900
            ),
            TripStop(
                time: "02:00 PM",
                title: "Udawalawe Reservoir Elephant Herd Safari",
                category: "Wildlife",
                icon: "pawprint.fill",
                description: "Afternoon 4x4 open jeep safari along the massive Udawalawe reservoir. Encounter family herds of 50+ wild elephants grazing peacefully with newborn calves.",
                locationName: "Udawalawe National Park Gate",
                estimatedDuration: "3h 00m",
                costLKR: 11500,
                costUSD: 38.0,
                highlight: "Massive Wild Elephant Herds by the Water",
                passRequired: true,
                passName: "Udawalawe Wildlife Permit",
                imageUrl: "https://images.unsplash.com/photo-1534177616072-ef7dc120449d?auto=format&fit=crop&w=800&q=80",
                latitude: 6.4780,
                longitude: 80.8950
            ),
            TripStop(
                time: "05:30 PM",
                title: "Udawalawe Reservoir Dam Golden Sunset",
                category: "Scenic",
                icon: "sun.horizon.fill",
                description: "Breathtaking sunset across the vast lake waters with mountain ranges in the distance and flocks of waterbirds soaring across the twilight sky.",
                locationName: "Udawalawe Dam Viewpoint",
                estimatedDuration: "1h 15m",
                costLKR: 0,
                costUSD: 0.0,
                highlight: "Vast Reservoir Mountain Sunset",
                imageUrl: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80",
                latitude: 6.4520,
                longitude: 80.8980
            ),
            TripStop(
                time: "07:30 PM",
                title: "Kalu's Campfire Starlight Dinner & Spiced Tea",
                category: "Dinner & Drinks",
                icon: "fork.knife",
                description: "Campfire dinner beneath a blanket of tropical stars: fragrant chicken biryani with mint sambol, wood-fired naan bread, and spiced hot ginger tea.",
                locationName: "Kalu's Safari Camp, Udawalawe",
                estimatedDuration: "2h 15m",
                costLKR: 5400,
                costUSD: 17.5,
                highlight: "Campfire Biryani Under Southern Stars",
                imageUrl: "https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?auto=format&fit=crop&w=800&q=80",
                latitude: 6.4400,
                longitude: 80.8850
            )
        ]
        
        return TripDay(
            dayNumber: dayNumber,
            dayOfWeek: dayOfWeek,
            dayOfMonth: dayOfMonth,
            fullDateString: fullDateString,
            title: "Udawalawe Elephant Herds, Rescued Calves & Reservoir Sunsets",
            region: "Udawalawe Sanctuary",
            weather: "Warm & Sunny",
            temperature: "30°C",
            stops: stops
        )
    }
}
