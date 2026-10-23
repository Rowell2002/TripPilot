import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Enums & Models
enum SriLankaFilterCategory: String, CaseIterable, Identifiable {
    case all = "All Sri Lanka"
    case culture = "Heritage & Culture"
    case nature = "Wildlife & Safaris"
    case highlands = "Highlands & Tea"
    case beach = "Coastal & Surf"
    case urban = "Cities & Dining"
    
    var id: String { rawValue }
    
    var iconName: String {
        switch self {
        case .all: return "safari.fill"
        case .culture: return "building.columns.fill"
        case .nature: return "pawprint.fill"
        case .highlands: return "mountain.2.fill"
        case .beach: return "water.waves"
        case .urban: return "fork.knife"
        }
    }
}

struct SriLankaSmartCollectionItem: Identifiable {
    let id = UUID()
    let title: String
    let tag: String
    let tagColor: Color
    let subtitle: String
    let iconName: String
    let imageUrl: String
}

// MARK: - Main View
struct PlaceDiscoveryView: View {
    @Environment(\.dismiss) private var dismiss
    
    // Theme Colors
    private let darkBackground = Color(red: 15/255, green: 19/255, blue: 28/255)            // #0f131c
    private let surfaceContainerLowest = Color(red: 10/255, green: 14/255, blue: 22/255)  // #0a0e16
    private let surfaceContainerLow = Color(red: 24/255, green: 28/255, blue: 36/255)   // #181c24
    private let surfaceContainer = Color(red: 28/255, green: 32/255, blue: 40/255)      // #1c2028
    private let surfaceContainerHigh = Color(red: 38/255, green: 42/255, blue: 51/255)  // #262a33
    private let primaryCyan = Color(red: 142/255, green: 213/255, blue: 255/255)         // #8ed5ff
    private let primaryContainer = Color(red: 56/255, green: 189/255, blue: 248/255)    // #38bdf8
    private let secondaryMint = Color(red: 68/255, green: 226/255, blue: 205/255)       // #44e2cd
    private let amberGold = Color(red: 251/255, green: 191/255, blue: 36/255)          // #fbbf24
    private let textOnSurface = Color(red: 223/255, green: 226/255, blue: 238/255)      // #dfe2ee
    private let textOnSurfaceVariant = Color(red: 189/255, green: 200/255, blue: 209/255) // #bdc8d1
    private let outlineVariant = Color.white.opacity(0.12)
    
    // Interactive State
    @State private var selectedTab: AppTab = .home
    @State private var selectedCategory: SriLankaFilterCategory = .all
    @State private var searchText: String = ""
    @State private var activeNotice: String? = nil
    @State private var isRadarPulsing: Bool = false
    @State private var bookmarkedPlaceIds: Set<UUID> = []
    @State private var addedPlaceNames: Set<String> = []
    
    // Navigation Triggers
    @State private var navigateToMap: Bool = false
    @State private var navigateToItinerary: Bool = false
    @State private var navigateToPlaceDetail: Bool = false
    @State private var navigateToBudget: Bool = false
    @State private var navigateToProfile: Bool = false
    @State private var selectedPlace: SriLankaPlace = SriLankaDataService.shared.places[0]
    
    // Filtered Places
    private var allPlaces: [SriLankaPlace] {
        SriLankaDataService.shared.places
    }
    
    private var filteredPlaces: [SriLankaPlace] {
        var result = allPlaces
        
        switch selectedCategory {
        case .all:
            break
        case .culture:
            result = result.filter { $0.category == .culture || $0.category == .heritage }
        case .nature:
            result = result.filter { $0.category == .wildlife }
        case .highlands:
            result = result.filter { $0.category == .nature }
        case .beach:
            result = result.filter { $0.category == .beach }
        case .urban:
            result = result.filter { $0.category == .food }
        }
        
        if !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let query = searchText.lowercased()
            result = result.filter {
                $0.name.lowercased().contains(query) ||
                $0.region.lowercased().contains(query) ||
                $0.highlights.joined(separator: " ").lowercased().contains(query)
            }
        }
        
        return result
    }
    
    private let smartCollections: [SriLankaSmartCollectionItem] = [
        SriLankaSmartCollectionItem(
            title: "Highland Tea & Mist",
            tag: "Tea Country",
            tagColor: Color(red: 68/255, green: 226/255, blue: 205/255),
            subtitle: "8 scenic estates & waterfalls",
            iconName: "leaf.fill",
            imageUrl: "https://images.unsplash.com/photo-1544735716-392fe2489ffa?q=80&w=800&auto=format&fit=crop"
        ),
        SriLankaSmartCollectionItem(
            title: "Ancient Kingdoms & Citadels",
            tag: "UNESCO Heritage",
            tagColor: Color(red: 251/255, green: 191/255, blue: 36/255),
            subtitle: "Sigiriya, Polonnaruwa & Dambulla",
            iconName: "building.columns.fill",
            imageUrl: "https://images.unsplash.com/photo-1586861635167-e5223aadc9fe?q=80&w=800&auto=format&fit=crop"
        ),
        SriLankaSmartCollectionItem(
            title: "Wild Leopard & Elephant Safaris",
            tag: "Wildlife Reserves",
            tagColor: Color(red: 248/255, green: 113/255, blue: 113/255),
            subtitle: "Yala, Wilpattu & Minneriya",
            iconName: "pawprint.fill",
            imageUrl: "https://images.unsplash.com/photo-1575550959106-5a7defe28b56?q=80&w=800&auto=format&fit=crop"
        ),
        SriLankaSmartCollectionItem(
            title: "Southern Forts & Surf Breaks",
            tag: "Coastal Jewels",
            tagColor: Color(red: 56/255, green: 189/255, blue: 248/255),
            subtitle: "Galle, Mirissa & Weligama",
            iconName: "water.waves",
            imageUrl: "https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?q=80&w=800&auto=format&fit=crop"
        )
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            darkBackground.ignoresSafeArea()
            
            // Ambient Radial Glows
            GeometryReader { _ in
                Circle()
                    .fill(primaryContainer.opacity(0.06))
                    .frame(width: 340, height: 340)
                    .blur(radius: 80)
                    .offset(x: -80, y: -40)
                
                Circle()
                    .fill(secondaryMint.opacity(0.05))
                    .frame(width: 300, height: 300)
                    .blur(radius: 70)
                    .offset(x: 180, y: 380)
            }
            .ignoresSafeArea()
            
            // Main Content Scroll
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    // Header Search
                    headerSearchSection
                        .padding(.top, 16)
                    
                    // Filter Chips
                    categoryFilterChipsSection
                    
                    // Curated UNESCO & Highlights
                    curatedHeritageSection
                    
                    // Trending Radar in Sri Lanka
                    trendingNearbySection
                    
                    // Island Map Preview
                    islandMapPreviewCalloutSection
                    
                    // Smart Collections
                    smartCollectionsSection
                    
                    Spacer().frame(height: 120)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 18)
                .padding(.top, 64)
                .responsiveContentWidth(1000)
            }
            .frame(maxWidth: .infinity)
            
            // Fixed Top Header
            VStack(spacing: 0) {
                fixedTopHeaderBar
                    .responsiveContentWidth(1000)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .ignoresSafeArea(edges: .top)
            
            // Floating Navigation Bar
            FloatingBottomNavBar(selectedTab: $selectedTab) { tab in
                if tab == .home {
                    dismiss()
                } else if tab == .itinerary {
                    navigateToItinerary = true
                } else if tab == .map {
                    navigateToMap = true
                } else if tab == .budget {
                    navigateToBudget = true
                } else if tab == .profile {
                    navigateToProfile = true
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 8)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .preferredColorScheme(.dark)
        .navigationDestination(isPresented: $navigateToMap) {
            InteractiveMapView()
        }
        .navigationDestination(isPresented: $navigateToItinerary) {
            DailyItineraryView()
        }
        .navigationDestination(isPresented: $navigateToPlaceDetail) {
            PlaceDetailView(place: selectedPlace)
        }
        .navigationDestination(isPresented: $navigateToBudget) {
            BudgetExpensesView()
        }
        .navigationDestination(isPresented: $navigateToProfile) {
            SettingsProfileView()
        }
        .overlay(alignment: .top) {
            if let notice = activeNotice {
                Text(notice)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .background(surfaceContainerHigh)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule().stroke(primaryContainer.opacity(0.4), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.7), radius: 12, y: 6)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .padding(.top, 70)
                    .zIndex(100)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                isRadarPulsing = true
            }
        }
    }
    
    // MARK: - Top Header Bar
    private var fixedTopHeaderBar: some View {
        HStack(spacing: 12) {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(textOnSurface)
                    .frame(width: 34, height: 34)
                    .background(surfaceContainerHigh.opacity(0.7))
                    .clipShape(Circle())
            }
            
            HStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(primaryContainer.opacity(0.2))
                        .frame(width: 32, height: 32)
                    Image(systemName: "safari.fill")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(primaryContainer)
                }
                
                VStack(alignment: .leading, spacing: 1) {
                    Text("TripPilot")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(primaryCyan)
                    Text("Sri Lanka Explorer 🇱🇰")
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundColor(textOnSurfaceVariant)
                }
            }
            
            Spacer()
            
            Button(action: {
                triggerNotice("Sri Lanka alerts: Sunny 29°C in Colombo & Galle")
            }) {
                Image(systemName: "bell.fill")
                    .font(.system(size: 16))
                    .foregroundColor(textOnSurfaceVariant)
                    .frame(width: 38, height: 38)
                    .background(surfaceContainerHigh.opacity(0.6))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 18)
        .padding(.top, 50)
        .padding(.bottom, 10)
        .background(
            surfaceContainerLowest.opacity(0.92)
                .background(.ultraThinMaterial)
        )
        .overlay(alignment: .bottom) {
            Divider().background(outlineVariant)
        }
    }
    
    // MARK: - Header Search
    private var headerSearchSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(secondaryMint)
                            .frame(width: 6, height: 6)
                            .shadow(color: secondaryMint.opacity(0.8), radius: isRadarPulsing ? 4 : 2)
                        Text("SRI LANKA EXPEDITION PILOT")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .tracking(0.8)
                            .foregroundColor(secondaryMint)
                    }
                    
                    Text("Explore Sri Lanka")
                        .font(.system(size: 28, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Button(action: {
                    navigateToMap = true
                }) {
                    Image(systemName: "map.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(primaryContainer)
                        .frame(width: 40, height: 40)
                        .background(surfaceContainerHigh)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(outlineVariant, lineWidth: 1))
                }
            }
            
            // Search Input
            HStack(spacing: 10) {
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 16))
                        .foregroundColor(textOnSurfaceVariant)
                    
                    TextField("Search Sigiriya, Ella, Galle...", text: $searchText)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.white)
                    
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(textOnSurfaceVariant)
                        }
                    }
                }
                .padding(.horizontal, 14)
                .frame(height: 46)
                .background(surfaceContainerHigh)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(outlineVariant, lineWidth: 1))
            }
        }
    }
    
    // MARK: - Category Filter Chips
    private var categoryFilterChipsSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(SriLankaFilterCategory.allCases) { category in
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedCategory = category
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: category.iconName)
                                .font(.system(size: 13, weight: .semibold))
                            Text(category.rawValue)
                                .font(.system(size: 13, weight: selectedCategory == category ? .bold : .medium, design: .rounded))
                        }
                        .foregroundColor(selectedCategory == category ? Color(red: 0/255, green: 40/255, blue: 60/255) : textOnSurface)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(selectedCategory == category ? primaryContainer : surfaceContainerHigh)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule().stroke(selectedCategory == category ? primaryContainer : outlineVariant, lineWidth: 1)
                        )
                        .shadow(color: selectedCategory == category ? primaryContainer.opacity(0.35) : .clear, radius: 8)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Curated UNESCO & Heritage Picks
    private var curatedHeritageSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(primaryContainer)
                    Text("Curated Island Icons")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text("\(filteredPlaces.count) Destinations")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(textOnSurfaceVariant)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(filteredPlaces) { place in
                        Button(action: {
                            selectedPlace = place
                            navigateToPlaceDetail = true
                        }) {
                            curatedPlaceCard(place)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private func curatedPlaceCard(_ place: SriLankaPlace) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                ZStack(alignment: .bottomLeading) {
                    AsyncImage(url: URL(string: place.imageUrls.first ?? "")) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else {
                            Color.gray.opacity(0.3)
                        }
                    }
                    .frame(width: 300, height: 180)
                    .clipped()
                    
                    LinearGradient(
                        colors: [surfaceContainerLow, surfaceContainerLow.opacity(0.2), Color.clear],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    
                    HStack {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 10))
                                .foregroundColor(amberGold)
                            Text(String(format: "%.1f", place.rating))
                                .font(.system(size: 12, weight: .heavy, design: .rounded))
                                .foregroundColor(.white)
                            Text("(\(place.reviewCount))")
                                .font(.system(size: 10))
                                .foregroundColor(textOnSurfaceVariant)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(surfaceContainerHigh.opacity(0.9))
                        .clipShape(Capsule())
                        
                        Spacer()
                        
                        Text(place.entranceFeeUSD > 0 ? "$\(place.entranceFeeUSD) USD" : "Free Entry")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(secondaryMint)
                            .padding(.horizontal, 9)
                            .padding(.vertical, 3)
                            .background(surfaceContainerHigh.opacity(0.9))
                            .clipShape(Capsule())
                    }
                    .padding(10)
                }
                
                // Badges
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: place.isUNESCO ? "checkmark.seal.fill" : "sparkles")
                            .font(.system(size: 10, weight: .bold))
                        Text(place.isUNESCO ? "UNESCO" : place.category.rawValue)
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(place.isUNESCO ? secondaryMint : primaryCyan)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 4)
                    .background(surfaceContainerLowest.opacity(0.85))
                    .clipShape(Capsule())
                    
                    Spacer()
                    
                    Button(action: {
                        if bookmarkedPlaceIds.contains(place.id) {
                            bookmarkedPlaceIds.remove(place.id)
                            triggerNotice("Removed \(place.name) from saved")
                        } else {
                            bookmarkedPlaceIds.insert(place.id)
                            triggerNotice("Saved \(place.name) to Travel Vault")
                        }
                    }) {
                        Image(systemName: bookmarkedPlaceIds.contains(place.id) ? "bookmark.fill" : "bookmark")
                            .font(.system(size: 14))
                            .foregroundColor(bookmarkedPlaceIds.contains(place.id) ? primaryContainer : textOnSurface)
                            .frame(width: 32, height: 32)
                            .background(surfaceContainerLowest.opacity(0.75))
                            .clipShape(Circle())
                    }
                }
                .padding(10)
            }
            .frame(width: 300, height: 180)
            
            // Details
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: 3) {
                    HStack {
                        Text(place.name)
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .lineLimit(1)
                        Spacer()
                    }
                    
                    Text(place.region)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(textOnSurfaceVariant)
                        .lineLimit(1)
                }
                
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 11))
                            .foregroundColor(primaryContainer)
                        Text(place.recommendedDuration)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(textOnSurfaceVariant)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        if addedPlaceNames.contains(place.name) {
                            addedPlaceNames.remove(place.name)
                            triggerNotice("Removed from itinerary")
                        } else {
                            addedPlaceNames.insert(place.name)
                            TripManager.shared.addCustomStop(
                                title: place.name,
                                category: place.category.rawValue,
                                notes: place.highlights.first ?? "Must-visit landmark",
                                entranceFeeLKR: place.entranceFeeLKR
                            )
                            triggerNotice("Added \(place.name) to your active trip!")
                        }
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: addedPlaceNames.contains(place.name) ? "checkmark" : "plus")
                                .font(.system(size: 11, weight: .bold))
                            Text(addedPlaceNames.contains(place.name) ? "Added" : "Add to Trip")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                        }
                        .foregroundColor(addedPlaceNames.contains(place.name) ? secondaryMint : primaryContainer)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(addedPlaceNames.contains(place.name) ? secondaryMint.opacity(0.2) : primaryContainer.opacity(0.18))
                        .clipShape(Capsule())
                    }
                }
            }
            .padding(12)
        }
        .frame(width: 300)
        .background(surfaceContainerLow)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(outlineVariant, lineWidth: 1))
        .shadow(color: Color.black.opacity(0.4), radius: 10, y: 4)
    }
    
    // MARK: - Trending Radar
    private var trendingNearbySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                HStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(secondaryMint.opacity(0.25))
                            .frame(width: 14, height: 14)
                            .scaleEffect(isRadarPulsing ? 1.4 : 0.9)
                        Circle()
                            .fill(secondaryMint)
                            .frame(width: 8, height: 8)
                    }
                    
                    Text("Trending Across Sri Lanka")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "dot.radiowaves.left.and.right")
                        .font(.system(size: 11))
                    Text("Live Telemetry")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                }
                .foregroundColor(secondaryMint)
                .padding(.horizontal, 9)
                .padding(.vertical, 4)
                .background(surfaceContainerHigh)
                .clipShape(Capsule())
            }
            
            VStack(spacing: 12) {
                ForEach(allPlaces.suffix(4)) { place in
                    Button(action: {
                        selectedPlace = place
                        navigateToPlaceDetail = true
                    }) {
                        trendingPlaceRow(place)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    private func trendingPlaceRow(_ place: SriLankaPlace) -> some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: place.imageUrls.first ?? "")) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Color.gray.opacity(0.3)
                }
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(place.name)
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    Spacer()
                    HStack(spacing: 3) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 9))
                            .foregroundColor(amberGold)
                        Text(String(format: "%.1f", place.rating))
                            .font(.system(size: 11, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                    }
                }
                
                Text(place.region)
                    .font(.system(size: 12))
                    .foregroundColor(textOnSurfaceVariant)
                    .lineLimit(1)
                
                HStack(spacing: 6) {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(secondaryMint)
                            .frame(width: 5, height: 5)
                        Text(place.bestTimeToVisit)
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                            .foregroundColor(secondaryMint)
                            .lineLimit(1)
                    }
                }
            }
        }
        .padding(12)
        .background(surfaceContainerLow)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(outlineVariant, lineWidth: 1))
    }
    
    // MARK: - Island Map Callout
    private var islandMapPreviewCalloutSection: some View {
        Button(action: {
            navigateToMap = true
        }) {
            ZStack(alignment: .bottomLeading) {
                AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1544735716-392fe2489ffa?q=80&w=800&auto=format&fit=crop")) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 130)
                            .clipped()
                            .colorMultiply(Color(red: 0.65, green: 0.8, blue: 0.95))
                            .brightness(-0.2)
                    } else {
                        Color(red: 16/255, green: 24/255, blue: 40/255)
                    }
                }
                .frame(height: 130)
                
                LinearGradient(
                    colors: [surfaceContainerLow.opacity(0.95), surfaceContainerLow.opacity(0.4), Color.clear],
                    startPoint: .bottom,
                    endPoint: .top
                )
                
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        HStack(spacing: 5) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 12))
                                .foregroundColor(secondaryMint)
                            Text("All Sri Lanka Pins & Coordinates")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                                .foregroundColor(secondaryMint)
                        }
                        
                        Text("Explore Interactive Island Map")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 5) {
                        Text("Open Map")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 11, weight: .bold))
                    }
                    .foregroundColor(textOnSurface)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(surfaceContainerHigh)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(outlineVariant, lineWidth: 1))
                }
                .padding(14)
            }
            .frame(height: 130)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(outlineVariant, lineWidth: 1))
            .shadow(color: Color.black.opacity(0.4), radius: 10, y: 4)
        }
    }
    
    // MARK: - Smart Collections
    private var smartCollectionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Sri Lanka Curated Collections")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(smartCollections) { item in
                    smartCollectionCard(item)
                }
            }
        }
    }
    
    private func smartCollectionCard(_ item: SriLankaSmartCollectionItem) -> some View {
        Button(action: {
            triggerNotice("Opened \(item.title) collection")
        }) {
            ZStack(alignment: .bottomLeading) {
                AsyncImage(url: URL(string: item.imageUrl)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        Color.gray.opacity(0.3)
                    }
                }
                .frame(height: 160)
                .clipped()
                
                LinearGradient(
                    colors: [surfaceContainerLowest.opacity(0.95), surfaceContainerLowest.opacity(0.4), Color.clear],
                    startPoint: .bottom,
                    endPoint: .top
                )
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.tag)
                        .font(.system(size: 9.5, weight: .bold, design: .rounded))
                        .foregroundColor(item.tagColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(surfaceContainerLowest.opacity(0.85))
                        .clipShape(Capsule())
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.title)
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                        
                        Text(item.subtitle)
                            .font(.system(size: 10.5, weight: .medium, design: .rounded))
                            .foregroundColor(textOnSurfaceVariant)
                            .lineLimit(1)
                    }
                }
                .padding(10)
            }
            .frame(height: 160)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(outlineVariant, lineWidth: 1))
        }
    }
    
    // MARK: - Helper Actions
    private func triggerNotice(_ msg: String) {
        withAnimation {
            activeNotice = msg
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation {
                if activeNotice == msg {
                    activeNotice = nil
                }
            }
        }
    }
}

#Preview {
    PlaceDiscoveryView()
}
