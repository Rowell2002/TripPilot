import SwiftUI
import MapKit
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Map Filter Enum
enum MapFilter: String, CaseIterable, Identifiable {
    case allPins = "All Places (18)"
    case todayRoute = "Day Route 🗺️"
    case cafes = "Cafes & Breakfast ☕"
    case dining = "Dining & Feast 🍛"
    case unesco = "UNESCO Heritage 🏰"
    case hillCountry = "Highlands & Tea 🍵"
    case wildlife = "Wildlife & Safaris 🐘"
    case beaches = "Coast & Surf 🌊"
    
    var id: String { rawValue }
    
    var iconName: String {
        switch self {
        case .allPins: return "circle.hexagongrid.fill"
        case .todayRoute: return "arrow.triangle.swap"
        case .cafes: return "cup.and.saucer.fill"
        case .dining: return "fork.knife"
        case .unesco: return "building.columns.fill"
        case .hillCountry: return "leaf.fill"
        case .wildlife: return "pawprint.fill"
        case .beaches: return "water.waves"
        }
    }
}

// MARK: - Interactive Map View
struct InteractiveMapView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var tripManager = TripManager.shared
    
    var initialDayIndex: Int = 0
    
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
    private let coralOrange = Color(red: 251/255, green: 146/255, blue: 60/255)        // #fb923c
    private let textOnSurface = Color(red: 223/255, green: 226/255, blue: 238/255)      // #dfe2ee
    private let textOnSurfaceVariant = Color(red: 189/255, green: 200/255, blue: 209/255) // #bdc8d1
    private let outlineVariant = Color.white.opacity(0.12)
    
    // Interactive State
    @State private var selectedFilter: MapFilter = .todayRoute
    @State private var selectedDayIndex: Int = 0
    @State private var selectedTripStop: TripStop? = nil
    @State private var searchText: String = ""
    @State private var is3DEnabled: Bool = false
    @State private var isAudioPlaying: Bool = false
    @State private var isSpotSaved: Bool = false
    @State private var isGpsRadarPulsing: Bool = false
    @State private var isRecenterPressed: Bool = false
    @State private var toastMessage: String? = nil
    @State private var showGeofenceRings: Bool = true
    
    // Navigation Triggers
    @State private var navigateToPlaceDiscovery: Bool = false
    @State private var navigateToPlaceDetail: Bool = false
    
    // Map Camera & Selected Place State
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 7.9570, longitude: 80.7603), // Central Sri Lanka / Sigiriya
            span: MKCoordinateSpan(latitudeDelta: 1.2, longitudeDelta: 1.2)
        )
    )
    @State private var selectedPlace: SriLankaPlace = SriLankaDataService.shared.places[0]
    
    // Catalog
    private var allPlaces: [SriLankaPlace] {
        SriLankaDataService.shared.places
    }
    
    // Active Itinerary Day & Stops
    private var activeDay: TripDay? {
        guard !tripManager.currentTrip.days.isEmpty else { return nil }
        let idx = min(max(selectedDayIndex, 0), tripManager.currentTrip.days.count - 1)
        return tripManager.currentTrip.days[idx]
    }
    
    private var todayStops: [TripStop] {
        activeDay?.stops ?? []
    }
    
    // Filtered Places for Map Display
    private var displayPlaces: [SriLankaPlace] {
        var list = allPlaces
        
        switch selectedFilter {
        case .allPins:
            break
        case .todayRoute:
            return [] // Routed through todayStops instead
        case .cafes:
            list = list.filter { $0.category == .cafe }
        case .dining:
            list = list.filter { $0.category == .dining || $0.category == .food }
        case .unesco:
            list = list.filter { $0.category == .heritage || $0.isUNESCO }
        case .hillCountry:
            list = list.filter { $0.district == "Badulla" || $0.district == "Nuwara Eliya" || $0.district == "Kandy" }
        case .wildlife:
            list = list.filter { $0.category == .wildlife }
        case .beaches:
            list = list.filter { $0.category == .beach }
        }
        
        if !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let q = searchText.lowercased()
            list = list.filter {
                $0.name.lowercased().contains(q) ||
                $0.district.lowercased().contains(q) ||
                $0.province.lowercased().contains(q)
            }
        }
        
        return list
    }
    
    // Route Polyline Coordinates for Active Day
    private var todayRouteCoordinates: [CLLocationCoordinate2D] {
        todayStops.compactMap { $0.coordinate }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // 1. Top Header Bar
                    topHeaderBarSection
                        .padding(.top, 46)
                        .responsiveContentWidth(1000)
                    
                    // 2. Native MapKit Area
                    nativeMapContainerArea
                        .frame(height: DeviceLayout.isIPad ? 680 : 560)
                        .responsiveContentWidth(1000)
                    
                    // 3. Geofenced Landmark Discovery Sheet
                    landmarkDiscoverySheet
                        .responsiveContentWidth(1000)
                    
                    Spacer().frame(height: 110)
                }
            }
            .background(darkBackground.ignoresSafeArea())
            
        }
        .navigationBarBackButtonHidden(true)
        .preferredColorScheme(.dark)
        .navigationDestination(isPresented: $navigateToPlaceDiscovery) {
            PlaceDiscoveryView()
        }
        .navigationDestination(isPresented: $navigateToPlaceDetail) {
            PlaceDetailView(place: selectedPlace)
        }
        .overlay(alignment: .top) {
            if let toast = toastMessage {
                Text(toast)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .background(surfaceContainerHigh)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(primaryContainer.opacity(0.4), lineWidth: 1))
                    .shadow(color: Color.black.opacity(0.7), radius: 12, y: 6)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .padding(.top, 60)
                    .zIndex(100)
            }
        }
        .onAppear {
            selectedDayIndex = initialDayIndex
            fitCameraToStops(todayStops)
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                isGpsRadarPulsing = true
            }
        }
    }
    
    // MARK: - 1. Top Header Bar
    private var topHeaderBarSection: some View {
        HStack(spacing: 12) {
            Button(action: {
                AppNavigationRouter.shared.switchTab(to: .home)
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .bold))
                    Text("Back")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                }
                .foregroundColor(primaryCyan)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(surfaceContainerLow)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(outlineVariant, lineWidth: 1))
            }
            
            VStack(alignment: .leading, spacing: 1) {
                HStack(spacing: 6) {
                    Text("Sri Lanka Live Map")
                        .font(.system(size: 18, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                    Text("🇱🇰")
                        .font(.system(size: 16))
                }
                
                HStack(spacing: 6) {
                    Circle()
                        .fill(secondaryMint)
                        .frame(width: 6, height: 6)
                        .shadow(color: secondaryMint.opacity(0.8), radius: isGpsRadarPulsing ? 4 : 1)
                    Text(selectedFilter == .todayRoute ? "Active Day 1 Itinerary Route" : "\(displayPlaces.count) places mapped")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(textOnSurfaceVariant)
                }
            }
            
            Spacer()
            
            // Geofence Radar Toggle Button
            Button(action: {
                showGeofenceRings.toggle()
                triggerToast(showGeofenceRings ? "Geofence 1.0 km rings visible" : "Geofence rings hidden")
            }) {
                ZStack {
                    Circle()
                        .fill(showGeofenceRings ? secondaryMint.opacity(0.2) : surfaceContainerLow)
                        .frame(width: 38, height: 38)
                    
                    Image(systemName: showGeofenceRings ? "dot.radiowaves.left.and.right" : "dot.radiowaves.right")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(showGeofenceRings ? secondaryMint : textOnSurfaceVariant)
                }
                .overlay(Circle().stroke(showGeofenceRings ? secondaryMint : outlineVariant, lineWidth: 1))
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
    }
    
    // MARK: - 2. Native MapKit Container Area
    private var nativeMapContainerArea: some View {
        ZStack {
            // Modern Declarative SwiftUI Map
            Map(position: $cameraPosition) {
                UserAnnotation()
                
                // 1. RENDER PLACES CATALOG (WHEN NOT IN ROUTE-ONLY MODE)
                if selectedFilter != .todayRoute {
                    ForEach(displayPlaces) { place in
                        Annotation(place.name, coordinate: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)) {
                            customPlacePin(place: place, isSelected: selectedPlace.id == place.id && selectedTripStop == nil)
                        }
                        
                        // Visual Geofence Radius Circle (1.0 km)
                        if showGeofenceRings {
                            MapCircle(center: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude), radius: 1000)
                                .foregroundStyle(
                                    (place.category == .dining || place.category == .cafe ? coralOrange : primaryContainer)
                                        .opacity(0.12)
                                )
                                .stroke(
                                    place.category == .dining || place.category == .cafe ? coralOrange : primaryContainer,
                                    lineWidth: selectedPlace.id == place.id ? 2.0 : 1.0
                                )
                        }
                    }
                }
                
                // 2. RENDER ACTIVE DAY'S ITINERARY ROUTE (BREAKFAST, SIGHTS, LUNCH, SUNSET, DINNER)
                if selectedFilter == .todayRoute || !todayRouteCoordinates.isEmpty {
                    // Sequential Luminous Polyline
                    MapPolyline(coordinates: todayRouteCoordinates)
                        .stroke(
                            LinearGradient(
                                colors: [amberGold, coralOrange, primaryContainer, secondaryMint],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round)
                        )
                    
                    // Sequential Numbered & Semantic Stop Pins
                    ForEach(Array(todayStops.enumerated()), id: \.element.id) { index, stop in
                        if let coord = stop.coordinate {
                            Annotation(stop.title, coordinate: coord) {
                                orderedStopPin(stop: stop, stepNumber: index + 1)
                            }
                        }
                    }
                }
            }
            .mapStyle(.standard(elevation: .realistic, emphasis: .muted, pointsOfInterest: .excludingAll))
            .preferredColorScheme(.dark)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 24, style: .continuous).stroke(outlineVariant, lineWidth: 1))
            .padding(.horizontal, 16)
            
            // Floating Top Controls: Search, Day Switcher & Filter Chips
            VStack(spacing: 8) {
                // Search Bar
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(primaryContainer)
                    
                    TextField("Search cafes, restaurants, or sights in Sri Lanka...", text: $searchText)
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundColor(.white)
                    
                    Button(action: {
                        navigateToPlaceDiscovery = true
                    }) {
                        Image(systemName: "safari.fill")
                            .font(.system(size: 14))
                            .foregroundColor(secondaryMint)
                    }
                }
                .padding(.horizontal, 14)
                .frame(height: 44)
                .background(surfaceContainerLow.opacity(0.95))
                .clipShape(Capsule())
                .overlay(Capsule().stroke(outlineVariant, lineWidth: 1))
                .shadow(color: Color.black.opacity(0.6), radius: 10, y: 4)
                
                // Day Selector Ribbon
                if !tripManager.currentTrip.days.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 7) {
                            ForEach(0..<tripManager.currentTrip.days.count, id: \.self) { dayIdx in
                                let day = tripManager.currentTrip.days[dayIdx]
                                let isSelected = (selectedDayIndex == dayIdx) && (selectedFilter == .todayRoute)
                                
                                Button(action: {
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                                        selectedDayIndex = dayIdx
                                        selectedFilter = .todayRoute
                                        selectedTripStop = nil
                                        fitCameraToStops(day.stops)
                                    }
                                    triggerToast("Viewing Day \(day.dayNumber): \(day.region) itinerary")
                                }) {
                                    HStack(spacing: 5) {
                                        Text("DAY \(day.dayNumber)")
                                            .font(.system(size: 10, weight: .heavy, design: .rounded))
                                            .foregroundColor(isSelected ? .black : primaryCyan)
                                        
                                        Text(day.region)
                                            .font(.system(size: 11, weight: isSelected ? .bold : .medium, design: .rounded))
                                            .foregroundColor(isSelected ? .black : .white)
                                            .lineLimit(1)
                                    }
                                    .padding(.horizontal, 11)
                                    .padding(.vertical, 6)
                                    .background(isSelected ? primaryContainer : surfaceContainerLow.opacity(0.92))
                                    .clipShape(Capsule())
                                    .overlay(Capsule().stroke(isSelected ? primaryContainer : outlineVariant, lineWidth: 1))
                                }
                            }
                        }
                    }
                }
                
                // Category Filter Chips Ribbon
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 7) {
                        ForEach(MapFilter.allCases) { filter in
                            Button(action: {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                                    selectedFilter = filter
                                    selectedTripStop = nil
                                    handleFilterChange(filter)
                                }
                            }) {
                                HStack(spacing: 5) {
                                    Image(systemName: filter.iconName)
                                        .font(.system(size: 11, weight: .bold))
                                    Text(filter.rawValue)
                                        .font(.system(size: 11.5, weight: selectedFilter == filter ? .bold : .medium, design: .rounded))
                                }
                                .foregroundColor(selectedFilter == filter ? Color(red: 0/255, green: 40/255, blue: 60/255) : textOnSurface)
                                .padding(.horizontal, 11)
                                .padding(.vertical, 6)
                                .background(selectedFilter == filter ? primaryContainer : surfaceContainerLow.opacity(0.92))
                                .clipShape(Capsule())
                                .overlay(Capsule().stroke(selectedFilter == filter ? primaryContainer : outlineVariant, lineWidth: 1))
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 28)
            .padding(.top, 16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
            // Right-Side Controls (Re-Center & 3D Pitch)
            VStack(spacing: 8) {
                VStack(spacing: 0) {
                    Button(action: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                            isRecenterPressed = true
                            if selectedFilter == .todayRoute {
                                fitCameraToStops(todayStops)
                            } else {
                                cameraPosition = .region(
                                    MKCoordinateRegion(
                                        center: CLLocationCoordinate2D(latitude: 7.8731, longitude: 80.7718),
                                        span: MKCoordinateSpan(latitudeDelta: 3.2, longitudeDelta: 3.2)
                                    )
                                )
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            isRecenterPressed = false
                        }
                        triggerToast("Centered: \(activeDay?.region ?? "Sri Lanka")")
                    }) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(primaryContainer)
                            .frame(width: 40, height: 40)
                            .scaleEffect(isRecenterPressed ? 0.85 : 1.0)
                    }
                    
                    Rectangle().fill(outlineVariant).frame(width: 24, height: 1)
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
                            is3DEnabled.toggle()
                            let targetCoord = selectedTripStop?.coordinate ?? CLLocationCoordinate2D(latitude: selectedPlace.latitude, longitude: selectedPlace.longitude)
                            if is3DEnabled {
                                cameraPosition = .camera(
                                    MapCamera(
                                        centerCoordinate: targetCoord,
                                        distance: 12000,
                                        heading: 25,
                                        pitch: 52
                                    )
                                )
                            } else {
                                cameraPosition = .region(
                                    MKCoordinateRegion(
                                        center: targetCoord,
                                        latitudinalMeters: 7000,
                                        longitudinalMeters: 7000
                                    )
                                )
                            }
                        }
                        triggerToast(is3DEnabled ? "3D Elevation Active" : "Standard Top-Down")
                    }) {
                        Text(is3DEnabled ? "2D" : "3D")
                            .font(.system(size: 13, weight: .heavy, design: .rounded))
                            .foregroundColor(is3DEnabled ? secondaryMint : textOnSurface)
                            .frame(width: 40, height: 40)
                    }
                }
                .background(surfaceContainerLow.opacity(0.95))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(outlineVariant, lineWidth: 1))
                .shadow(color: Color.black.opacity(0.5), radius: 8, y: 4)
            }
            .padding(.top, 145)
            .padding(.trailing, 28)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        }
    }
    
    // MARK: - Custom Place Annotation Pin
    @ViewBuilder
    private func customPlacePin(place: SriLankaPlace, isSelected: Bool) -> some View {
        let isFoodOrCafe = place.category == .dining || place.category == .cafe || place.category == .food
        let pinColor = isFoodOrCafe ? (place.category == .cafe ? amberGold : coralOrange) : (place.isUNESCO ? amberGold : primaryContainer)
        
        Button(action: {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                selectedTripStop = nil
                selectedPlace = place
                flyCamera(to: place)
            }
        }) {
            VStack(spacing: 3) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(pinColor.opacity(0.3))
                            .frame(width: 44, height: 44)
                            .scaleEffect(isGpsRadarPulsing ? 1.25 : 0.95)
                    }
                    
                    Circle()
                        .fill(isSelected ? pinColor : surfaceContainer)
                        .frame(width: isSelected ? 36 : 30, height: isSelected ? 36 : 30)
                        .overlay(Circle().stroke(isSelected ? Color.white : pinColor, lineWidth: isSelected ? 2 : 1.5))
                        .shadow(color: pinColor.opacity(0.5), radius: 8)
                    
                    Image(systemName: place.category.iconName)
                        .font(.system(size: isSelected ? 15 : 12, weight: .bold))
                        .foregroundColor(isSelected ? .black : pinColor)
                }
                
                Text(place.name)
                    .font(.system(size: 10, weight: isSelected ? .heavy : .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 2.5)
                    .background(surfaceContainerLow.opacity(0.95))
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(isSelected ? pinColor : outlineVariant, lineWidth: 1))
                    .shadow(color: Color.black.opacity(0.6), radius: 4)
            }
        }
    }
    
    // MARK: - Ordered Itinerary Stop Pin (1, 2, 3...)
    @ViewBuilder
    private func orderedStopPin(stop: TripStop, stepNumber: Int) -> some View {
        let catLower = stop.category.lowercased()
        let isBreakfastOrCafe = catLower.contains("breakfast") || catLower.contains("cafe")
        let isDining = catLower.contains("lunch") || catLower.contains("dining") || catLower.contains("dinner") || catLower.contains("curry")
        let isSunset = catLower.contains("sunset") || catLower.contains("scenic")
        
        let pinColor: Color = {
            if isBreakfastOrCafe { return amberGold }
            if isDining { return coralOrange }
            if isSunset { return Color(red: 245/255, green: 158/255, blue: 11/255) }
            return primaryContainer
        }()
        
        let badgeIcon: String = {
            if isBreakfastOrCafe { return "cup.and.saucer.fill" }
            if isDining { return "fork.knife" }
            if isSunset { return "sun.horizon.fill" }
            return stop.icon.isEmpty ? "mappin.circle.fill" : stop.icon
        }()
        
        let isSelected = selectedTripStop?.id == stop.id
        
        Button(action: {
            selectedTripStop = stop
            if let coord = stop.coordinate {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                    cameraPosition = .region(
                        MKCoordinateRegion(
                            center: coord,
                            latitudinalMeters: 4000,
                            longitudinalMeters: 4000
                        )
                    )
                }
                triggerToast("Step \(stepNumber): \(stop.title)")
            }
        }) {
            VStack(spacing: 2) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(pinColor.opacity(0.35))
                            .frame(width: 44, height: 44)
                            .scaleEffect(isGpsRadarPulsing ? 1.25 : 0.95)
                    }
                    
                    Circle()
                        .fill(pinColor)
                        .frame(width: isSelected ? 34 : 28, height: isSelected ? 34 : 28)
                        .overlay(Circle().stroke(Color.white, lineWidth: isSelected ? 2 : 1.5))
                        .shadow(color: pinColor.opacity(0.6), radius: 6)
                    
                    HStack(spacing: 2) {
                        Text("\(stepNumber)")
                            .font(.system(size: 11, weight: .heavy, design: .rounded))
                            .foregroundColor(.black)
                        Image(systemName: badgeIcon)
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(.black)
                    }
                }
                
                HStack(spacing: 4) {
                    Text(stop.time)
                        .font(.system(size: 8.5, weight: .bold, design: .rounded))
                        .foregroundColor(pinColor)
                    
                    Text("•")
                        .font(.system(size: 7))
                        .foregroundColor(textOnSurfaceVariant)
                    
                    Text(stop.title)
                        .font(.system(size: 9.5, weight: isSelected ? .heavy : .bold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(1)
                }
                .padding(.horizontal, 7)
                .padding(.vertical, 3)
                .background(surfaceContainerLow.opacity(0.95))
                .clipShape(Capsule())
                .overlay(Capsule().stroke(isSelected ? pinColor : outlineVariant, lineWidth: 1))
                .shadow(color: Color.black.opacity(0.6), radius: 4)
            }
        }
    }
    
    // MARK: - 3. Landmark & Stop Discovery Sheet
    private var landmarkDiscoverySheet: some View {
        VStack(alignment: .leading, spacing: 16) {
            Capsule()
                .fill(Color.white.opacity(0.2))
                .frame(width: 40, height: 5)
                .frame(maxWidth: .infinity)
                .padding(.top, 10)
            
            if let stop = selectedTripStop {
                // ITINERARY STOP CARD (BREAKFAST, LUNCH, DINNER, SIGHT)
                let catLower = stop.category.lowercased()
                let isBreakfastOrCafe = catLower.contains("breakfast") || catLower.contains("cafe")
                let isDining = catLower.contains("lunch") || catLower.contains("dining") || catLower.contains("dinner")
                let themeColor = isBreakfastOrCafe ? amberGold : (isDining ? coralOrange : primaryContainer)
                
                // Header Category
                HStack {
                    HStack(spacing: 7) {
                        Circle()
                            .fill(themeColor)
                            .frame(width: 7, height: 7)
                        Text("ITINERARY STOP • \(stop.category.uppercased())")
                            .font(.system(size: 10.5, weight: .heavy, design: .rounded))
                            .tracking(0.6)
                            .foregroundColor(themeColor)
                    }
                    .padding(.horizontal, 11)
                    .padding(.vertical, 5)
                    .background(themeColor.opacity(0.15))
                    .clipShape(Capsule())
                    
                    Spacer()
                    
                    Button(action: {
                        selectedTripStop = nil
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 18))
                            .foregroundColor(textOnSurfaceVariant)
                    }
                }
                
                // Title & Time
                VStack(alignment: .leading, spacing: 4) {
                    Text(stop.title)
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("\(stop.locationName) • \(stop.time) (\(stop.estimatedDuration))")
                        .font(.system(size: 12.5, weight: .medium))
                        .foregroundColor(textOnSurfaceVariant)
                    
                    HStack(spacing: 10) {
                        HStack(spacing: 4) {
                            Image(systemName: "banknote.fill")
                                .font(.system(size: 11))
                                .foregroundColor(secondaryMint)
                            Text("Rs \(stop.costLKR.formatted()) ($ \(String(format: "%.1f", stop.costUSD)))")
                                .font(.system(size: 12.5, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 9)
                        .padding(.vertical, 4)
                        .background(surfaceContainerHigh)
                        .clipShape(Capsule())
                        
                        if !stop.highlight.isEmpty {
                            Text(stop.highlight)
                                .font(.system(size: 11.5, weight: .semibold, design: .rounded))
                                .foregroundColor(themeColor)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(themeColor.opacity(0.12))
                                .clipShape(Capsule())
                        }
                    }
                    .padding(.top, 4)
                }
                
                // Description & Dish / Visit notes
                VStack(alignment: .leading, spacing: 6) {
                    Text(isDining || isBreakfastOrCafe ? "CURATED MENU & AMBIANCE" : "ABOUT THIS EXPERIENCE")
                        .font(.system(size: 10.5, weight: .bold, design: .rounded))
                        .tracking(0.6)
                        .foregroundColor(primaryCyan)
                    
                    Text(stop.description)
                        .font(.system(size: 12.5, weight: .regular))
                        .foregroundColor(textOnSurface)
                        .lineSpacing(3)
                }
                .padding(12)
                .background(surfaceContainerLow)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                
                // Action Buttons (Apple Maps Navigation)
                VStack(spacing: 10) {
                    if let lat = stop.latitude, let lon = stop.longitude {
                        Button(action: {
                            openInAppleMaps(latitude: lat, longitude: lon, name: stop.title)
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
                                    .font(.system(size: 15, weight: .bold))
                                Text("Directions in Apple Maps")
                                    .font(.system(size: 13.5, weight: .bold, design: .rounded))
                            }
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(
                                LinearGradient(colors: [primaryContainer, secondaryMint], startPoint: .leading, endPoint: .trailing)
                            )
                            .clipShape(Capsule())
                        }
                    }
                }
            } else {
                // PLACE CATALOG CARD
                HStack {
                    HStack(spacing: 7) {
                        Circle()
                            .fill(selectedPlace.category == .dining || selectedPlace.category == .cafe ? coralOrange : secondaryMint)
                            .frame(width: 7, height: 7)
                        Text("SMART GEOFENCE ACTIVE • \(selectedPlace.category.rawValue.uppercased())")
                            .font(.system(size: 10.5, weight: .heavy, design: .rounded))
                            .tracking(0.6)
                            .foregroundColor(selectedPlace.category == .dining || selectedPlace.category == .cafe ? coralOrange : secondaryMint)
                    }
                    .padding(.horizontal, 11)
                    .padding(.vertical, 5)
                    .background((selectedPlace.category == .dining || selectedPlace.category == .cafe ? coralOrange : secondaryMint).opacity(0.15))
                    .clipShape(Capsule())
                    
                    Spacer()
                    
                    Button(action: {
                        isSpotSaved.toggle()
                        triggerToast(isSpotSaved ? "Saved \(selectedPlace.name) to Travel Vault" : "Removed from Favorites")
                    }) {
                        Image(systemName: isSpotSaved ? "bookmark.fill" : "bookmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(isSpotSaved ? secondaryMint : textOnSurface)
                            .frame(width: 34, height: 34)
                            .background(surfaceContainerHigh)
                            .clipShape(Circle())
                    }
                }
                
                // Title, District & Ratings
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(selectedPlace.name)
                            .font(.system(size: 21, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text(selectedPlace.sinhalaName)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(primaryCyan)
                    }
                    
                    Text("\(selectedPlace.district), \(selectedPlace.province) • \(selectedPlace.bestTimeToVisit)")
                        .font(.system(size: 12.5, weight: .medium))
                        .foregroundColor(textOnSurfaceVariant)
                    
                    HStack(spacing: 8) {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 11))
                                .foregroundColor(amberGold)
                            Text(String(format: "%.1f", selectedPlace.rating))
                                .font(.system(size: 12.5, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            Text("(\(selectedPlace.reviewCount) reviews)")
                                .font(.system(size: 11.5))
                                .foregroundColor(textOnSurfaceVariant)
                        }
                        .padding(.horizontal, 9)
                        .padding(.vertical, 4)
                        .background(surfaceContainerHigh)
                        .clipShape(Capsule())
                        
                        HStack(spacing: 5) {
                            Circle()
                                .fill(secondaryMint)
                                .frame(width: 6, height: 6)
                            Text(selectedPlace.openingHours)
                                .font(.system(size: 12, weight: .semibold, design: .rounded))
                                .foregroundColor(secondaryMint)
                                .lineLimit(1)
                        }
                    }
                    .padding(.top, 4)
                }
                
                // Signature Highlights / Dishes
                VStack(alignment: .leading, spacing: 8) {
                    Text(selectedPlace.category == .dining || selectedPlace.category == .cafe ? "SIGNATURE DISHES & SPECIALTIES" : "KEY HIGHLIGHTS")
                        .font(.system(size: 10.5, weight: .bold, design: .rounded))
                        .tracking(0.6)
                        .foregroundColor(primaryCyan)
                    
                    ForEach(selectedPlace.highlights.prefix(3), id: \.self) { item in
                        HStack(spacing: 8) {
                            Image(systemName: selectedPlace.category == .dining || selectedPlace.category == .cafe ? "fork.knife.circle.fill" : "checkmark.circle.fill")
                                .font(.system(size: 13))
                                .foregroundColor(selectedPlace.category == .dining || selectedPlace.category == .cafe ? coralOrange : secondaryMint)
                            Text(item)
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .foregroundColor(textOnSurface)
                        }
                    }
                }
                .padding(12)
                .background(surfaceContainerLow)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                
                // Action Buttons
                VStack(spacing: 10) {
                    HStack(spacing: 10) {
                        Button(action: {
                            TripManager.shared.addCustomStop(
                                title: selectedPlace.name,
                                category: selectedPlace.category.rawValue,
                                notes: selectedPlace.highlights.first ?? "Must-visit spot",
                                entranceFeeLKR: selectedPlace.entranceFeeLKR,
                                dayIndex: selectedDayIndex
                            )
                            triggerToast("Added \(selectedPlace.name) to Day \(selectedDayIndex + 1)!")
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 14, weight: .bold))
                                Text("Add to Itinerary")
                                    .font(.system(size: 13, weight: .bold, design: .rounded))
                            }
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 46)
                            .background(primaryContainer)
                            .clipShape(Capsule())
                        }
                        
                        Button(action: {
                            openInAppleMaps(latitude: selectedPlace.latitude, longitude: selectedPlace.longitude, name: selectedPlace.name)
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
                                    .font(.system(size: 14, weight: .bold))
                                Text("Directions")
                                    .font(.system(size: 13, weight: .bold, design: .rounded))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 46)
                            .background(surfaceContainerHigh)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(outlineVariant, lineWidth: 1))
                        }
                    }
                    
                    Button(action: {
                        navigateToPlaceDetail = true
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "info.circle.fill")
                                .font(.system(size: 14, weight: .bold))
                            Text("View Full Place Guide & Reviews")
                                .font(.system(size: 13.5, weight: .bold, design: .rounded))
                        }
                        .foregroundColor(secondaryMint)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(surfaceContainerLow)
                        .clipShape(Capsule())
                    }
                }
            }
        }
        .padding(.horizontal, 18)
        .padding(.bottom, 24)
        .background(Color(red: 13/255, green: 17/255, blue: 23/255))
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 28, style: .continuous).stroke(outlineVariant, lineWidth: 1))
        .offset(y: -24)
    }
    
    // MARK: - Helpers
    private func fitCameraToStops(_ stops: [TripStop]) {
        let coords = stops.compactMap { $0.coordinate }
        guard !coords.isEmpty else { return }
        
        let lats = coords.map { $0.latitude }
        let lons = coords.map { $0.longitude }
        let minLat = lats.min() ?? 0
        let maxLat = lats.max() ?? 0
        let minLon = lons.min() ?? 0
        let maxLon = lons.max() ?? 0
        
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
        let span = MKCoordinateSpan(
            latitudeDelta: max(0.2, (maxLat - minLat) * 1.5),
            longitudeDelta: max(0.2, (maxLon - minLon) * 1.5)
        )
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
            cameraPosition = .region(MKCoordinateRegion(center: center, span: span))
        }
    }
    
    private func openInAppleMaps(latitude: Double, longitude: Double, name: String) {
        let coord = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let placemark = MKPlacemark(coordinate: coord)
        let item = MKMapItem(placemark: placemark)
        item.name = name
        item.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
    
    private func flyCamera(to place: SriLankaPlace) {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            cameraPosition = .region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude),
                    latitudinalMeters: 6000,
                    longitudinalMeters: 6000
                )
            )
        }
    }
    
    private func handleFilterChange(_ filter: MapFilter) {
        if filter == .todayRoute {
            fitCameraToStops(todayStops)
            triggerToast("Displaying Day \(selectedDayIndex + 1) Route")
        } else if let matching = displayPlaces.first {
            selectedPlace = matching
            flyCamera(to: matching)
            triggerToast("Filtered: \(filter.rawValue)")
        }
    }
    
    private func triggerToast(_ msg: String) {
        withAnimation {
            toastMessage = msg
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation {
                if toastMessage == msg {
                    toastMessage = nil
                }
            }
        }
    }
}

#Preview {
    InteractiveMapView()
}
