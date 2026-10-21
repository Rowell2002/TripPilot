import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Map Models
struct MapPin: Identifiable {
    let id = UUID()
    let name: String
    let category: String
    let icon: String
    let coordinateOffset: CGPoint // Normalized offset on map canvas
    let isDestination: Bool
    let color: Color
}

enum MapFilter: String, CaseIterable, Identifiable {
    case discover = "Discover Places"
    case allPins = "All Pins (8)"
    case mustVisit = "UNESCO Heritage"
    case wildlife = "Wildlife & Parks"
    case scenicTrain = "Scenic Rail"
    case coastal = "Coast & Surfing"
    
    var id: String { rawValue }
    
    var iconName: String {
        switch self {
        case .discover: return "safari"
        case .allPins: return "circle.hexagongrid.fill"
        case .mustVisit: return "star.fill"
        case .wildlife: return "pawprint.fill"
        case .scenicTrain: return "tram.fill"
        case .coastal: return "water.waves"
        }
    }
}

struct InteractiveMapView: View {
    @Environment(\.dismiss) private var dismiss
    
    // Theme Colors
    private let darkBackground = Color(red: 15/255, green: 19/255, blue: 28/255)            // #0f131c
    private let mapCanvasBg = Color(red: 10/255, green: 14/255, blue: 22/255)             // #0a0e16
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
    @State private var selectedTab: AppTab = .map
    @State private var selectedFilter: MapFilter = .allPins
    @State private var searchText: String = "Sigiriya Rock Fortress, Central Province"
    @State private var is3DEnabled: Bool = false
    @State private var isAudioPlaying: Bool = true
    @State private var isSpotSaved: Bool = false
    @State private var isGpsRadarPulsing: Bool = false
    @State private var isRecenterPressed: Bool = false
    @State private var toastMessage: String? = nil
    @State private var navigateToItinerary: Bool = false
    @State private var navigateToPlaceDiscovery: Bool = false
    @State private var navigateToBudget: Bool = false
    @State private var navigateToProfile: Bool = false
    
    // Pinned Sri Lanka Landmarks
    private let landmarkPins: [MapPin] = [
        MapPin(name: "Sigiriya Rock", category: "UNESCO", icon: "mountain.2.fill", coordinateOffset: CGPoint(x: 0.52, y: 0.30), isDestination: true, color: Color(red: 251/255, green: 191/255, blue: 36/255)),
        MapPin(name: "Temple of Tooth", category: "Sacred", icon: "building.columns.fill", coordinateOffset: CGPoint(x: 0.50, y: 0.48), isDestination: false, color: Color(red: 68/255, green: 226/255, blue: 205/255)),
        MapPin(name: "Nine Arches Bridge", category: "Scenic Rail", icon: "tram.fill", coordinateOffset: CGPoint(x: 0.62, y: 0.62), isDestination: false, color: Color(red: 56/255, green: 189/255, blue: 248/255)),
        MapPin(name: "Yala Safari", category: "Wildlife", icon: "pawprint.fill", coordinateOffset: CGPoint(x: 0.72, y: 0.78), isDestination: false, color: Color(red: 248/255, green: 113/255, blue: 113/255)),
        MapPin(name: "Galle Fort", category: "UNESCO Coast", icon: "shield.fill", coordinateOffset: CGPoint(x: 0.35, y: 0.85), isDestination: false, color: Color(red: 142/255, green: 213/255, blue: 255/255))
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // 1. Top Header Bar
                    topHeaderBarSection
                        .padding(.top, 46)
                    
                    // 2. Interactive Map Canvas Area
                    mapCanvasArea
                        .frame(height: 560)
                    
                    // 3. Geofenced Landmark Discovery Sheet
                    landmarkDiscoverySheet
                    
                    Spacer().frame(height: 110)
                }
            }
            .background(darkBackground.ignoresSafeArea())
            
            // 4. Floating Glassmorphic Bottom Navigation Bar
            FloatingBottomNavBar(selectedTab: $selectedTab) { tab in
                if tab == .home {
                    dismiss()
                } else if tab == .itinerary {
                    navigateToItinerary = true
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
        .preferredColorScheme(.dark)
        .navigationDestination(isPresented: $navigateToItinerary) {
            DailyItineraryView()
        }
        .navigationDestination(isPresented: $navigateToPlaceDiscovery) {
            PlaceDiscoveryView()
        }
        .navigationDestination(isPresented: $navigateToBudget) {
            BudgetExpensesView()
        }
        .navigationDestination(isPresented: $navigateToProfile) {
            SettingsProfileView()
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
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                isGpsRadarPulsing = true
            }
        }
    }
    
    // MARK: - 1. Top Header Bar
    private var topHeaderBarSection: some View {
        VStack(spacing: 8) {
            HStack(spacing: 12) {
                HStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(primaryContainer.opacity(0.2))
                            .frame(width: 34, height: 34)
                        Image(systemName: "safari.fill")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(primaryContainer)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("TripPilot")
                            .font(.system(size: 18, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                        Text("SRI LANKA ISLAND MAP 🇱🇰")
                            .font(.system(size: 9.5, weight: .bold, design: .rounded))
                            .tracking(1.0)
                            .foregroundColor(secondaryMint)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    triggerToast("Live GPS telemetry active across Sri Lanka")
                }) {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "bell.fill")
                            .font(.system(size: 16))
                            .foregroundColor(textOnSurface)
                            .frame(width: 38, height: 38)
                            .background(surfaceContainerHigh.opacity(0.6))
                            .clipShape(Circle())
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 6)
        }
        .background(darkBackground)
    }
    
    // MARK: - 2. Interactive Map Canvas Area
    private var mapCanvasArea: some View {
        GeometryReader { geo in
            ZStack {
                // Cartography Background
                AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1544735716-392fe2489ffa?q=80&w=800&auto=format&fit=crop")) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geo.size.width, height: geo.size.height)
                            .clipped()
                            .colorMultiply(Color(red: 0.7, green: 0.85, blue: 1.0))
                            .brightness(-0.25)
                            .contrast(1.3)
                    } else {
                        ZStack {
                            mapCanvasBg
                            Color.blue.opacity(0.08)
                        }
                    }
                }
                .rotation3DEffect(
                    .degrees(is3DEnabled ? 18 : 0),
                    axis: (x: 1.0, y: 0.0, z: 0.0)
                )
                
                // Dark Gradient Shading
                LinearGradient(
                    colors: [
                        darkBackground.opacity(0.85),
                        mapCanvasBg.opacity(0.2),
                        mapCanvasBg.opacity(0.95)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .allowsHitTesting(false)
                
                // Luminous Route Path from Colombo to Sigiriya
                Path { path in
                    let start = CGPoint(x: geo.size.width * 0.35, y: geo.size.height * 0.72)
                    let end = CGPoint(x: geo.size.width * 0.52, y: geo.size.height * 0.33)
                    let cp1 = CGPoint(x: geo.size.width * 0.40, y: geo.size.height * 0.55)
                    let cp2 = CGPoint(x: geo.size.width * 0.48, y: geo.size.height * 0.42)
                    
                    path.move(to: start)
                    path.addCurve(to: end, control1: cp1, control2: cp2)
                }
                .stroke(
                    LinearGradient(
                        colors: [primaryContainer, secondaryMint, amberGold],
                        startPoint: .bottom,
                        endPoint: .top
                    ),
                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                )
                .shadow(color: primaryContainer.opacity(0.8), radius: 8)
                
                // Route Timing Badge
                HStack(spacing: 5) {
                    Image(systemName: "car.fill")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(primaryContainer)
                    Text("Expressway • 3h 15m")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(surfaceContainerLow.opacity(0.95))
                .clipShape(Capsule())
                .overlay(Capsule().stroke(primaryContainer.opacity(0.5), lineWidth: 1))
                .position(x: geo.size.width * 0.46, y: geo.size.height * 0.52)
                
                // Pinned Landmark Markers
                ForEach(landmarkPins) { pin in
                    let pinX = geo.size.width * pin.coordinateOffset.x
                    let pinY = geo.size.height * pin.coordinateOffset.y
                    
                    VStack(spacing: 3) {
                        if pin.isDestination {
                            ZStack {
                                Circle()
                                    .fill(amberGold)
                                    .frame(width: 44, height: 44)
                                    .shadow(color: amberGold.opacity(0.8), radius: 12)
                                
                                Image(systemName: pin.icon)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.black)
                            }
                            
                            Text(pin.name)
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(surfaceContainerLow.opacity(0.95))
                                .clipShape(Capsule())
                                .overlay(Capsule().stroke(amberGold.opacity(0.6), lineWidth: 1))
                        } else {
                            ZStack {
                                Circle()
                                    .fill(surfaceContainer)
                                    .frame(width: 36, height: 36)
                                    .overlay(Circle().stroke(pin.color.opacity(0.6), lineWidth: 1.5))
                                    .shadow(color: pin.color.opacity(0.35), radius: 8)
                                
                                Image(systemName: pin.icon)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(pin.color)
                            }
                            
                            Text(pin.name)
                                .font(.system(size: 10, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(surfaceContainerLow.opacity(0.9))
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                    }
                    .position(x: pinX, y: pinY)
                    .onTapGesture {
                        triggerToast("Selected: \(pin.name) • Tap below for details")
                    }
                }
                
                // Floating Top Search Bar & Filters
                VStack(spacing: 10) {
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(primaryContainer)
                        
                        TextField("Search places in Sri Lanka...", text: $searchText)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
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
                    .frame(height: 48)
                    .background(surfaceContainerLow.opacity(0.95))
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(outlineVariant, lineWidth: 1))
                    .shadow(color: Color.black.opacity(0.6), radius: 14, y: 6)
                    
                    // Filter Chips Ribbon
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(MapFilter.allCases) { filter in
                                Button(action: {
                                    if filter == .discover {
                                        navigateToPlaceDiscovery = true
                                    } else {
                                        withAnimation(.spring(response: 0.3)) {
                                            selectedFilter = filter
                                        }
                                    }
                                }) {
                                    HStack(spacing: 6) {
                                        Image(systemName: filter.iconName)
                                            .font(.system(size: 12, weight: .bold))
                                        Text(filter.rawValue)
                                            .font(.system(size: 12, weight: selectedFilter == filter ? .bold : .medium, design: .rounded))
                                    }
                                    .foregroundColor(selectedFilter == filter ? Color(red: 0/255, green: 40/255, blue: 60/255) : textOnSurface)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 7)
                                    .background(selectedFilter == filter ? primaryContainer : surfaceContainerLow.opacity(0.92))
                                    .clipShape(Capsule())
                                    .overlay(Capsule().stroke(selectedFilter == filter ? primaryContainer : outlineVariant, lineWidth: 1))
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .position(x: geo.size.width / 2, y: 56)
                
                // Right Side Controls
                VStack(spacing: 8) {
                    VStack(spacing: 0) {
                        Button(action: {
                            withAnimation(.spring(response: 0.2)) {
                                isRecenterPressed = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                isRecenterPressed = false
                            }
                            triggerToast("Re-centered to Cultural Triangle")
                        }) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(primaryContainer)
                                .frame(width: 42, height: 42)
                                .scaleEffect(isRecenterPressed ? 0.85 : 1.0)
                        }
                        
                        Rectangle().fill(outlineVariant).frame(width: 28, height: 1)
                        
                        Button(action: {
                            withAnimation(.spring(response: 0.4)) {
                                is3DEnabled.toggle()
                            }
                            triggerToast(is3DEnabled ? "3D island topography enabled" : "2D top view")
                        }) {
                            Text("3D")
                                .font(.system(size: 13, weight: .heavy, design: .rounded))
                                .foregroundColor(is3DEnabled ? primaryContainer : .white)
                                .frame(width: 44, height: 42)
                        }
                    }
                    .frame(width: 44)
                    .background(surfaceContainerLow.opacity(0.92))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(outlineVariant, lineWidth: 1))
                }
                .position(x: geo.size.width - 34, y: 220)
            }
        }
    }
    
    // MARK: - 3. Geofenced Landmark Discovery Sheet
    private var landmarkDiscoverySheet: some View {
        VStack(alignment: .leading, spacing: 18) {
            Capsule()
                .fill(Color.white.opacity(0.2))
                .frame(width: 40, height: 5)
                .frame(maxWidth: .infinity)
                .padding(.top, 10)
            
            HStack {
                HStack(spacing: 7) {
                    Circle()
                        .fill(amberGold)
                        .frame(width: 7, height: 7)
                    Text("ACTIVE DESTINATION • CULTURAL TRIANGLE")
                        .font(.system(size: 11, weight: .heavy, design: .rounded))
                        .tracking(0.6)
                        .foregroundColor(amberGold)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(amberGold.opacity(0.15))
                .clipShape(Capsule())
                
                Spacer()
                
                HStack(spacing: 8) {
                    Button(action: {
                        isSpotSaved.toggle()
                        triggerToast(isSpotSaved ? "Saved Sigiriya Rock to Favorites" : "Removed from Favorites")
                    }) {
                        Image(systemName: isSpotSaved ? "bookmark.fill" : "bookmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(isSpotSaved ? secondaryMint : textOnSurface)
                            .frame(width: 34, height: 34)
                            .background(surfaceContainerHigh)
                            .clipShape(Circle())
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Sigiriya Rock Fortress")
                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Matale District, Central Province • UNESCO World Heritage")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(textOnSurfaceVariant)
                
                HStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 11))
                            .foregroundColor(amberGold)
                        Text("4.9")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        Text("(48.2k reviews)")
                            .font(.system(size: 12))
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
                        Text("Open 07:00 AM")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundColor(secondaryMint)
                    }
                }
                .padding(.top, 4)
            }
            
            // Smart Trivia Box
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    Circle()
                        .fill(primaryContainer.opacity(0.2))
                        .frame(width: 36, height: 36)
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(primaryContainer)
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    Text("Did You Know?")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Sigiriya features some of the oldest landscaped water gardens in human history and 5th-century fresco paintings preserved 100 meters up on sheer granite cliffs.")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(textOnSurfaceVariant)
                        .lineSpacing(2)
                }
            }
            .padding(14)
            .background(surfaceContainerLow)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            // Interactive Audio Walk
            VStack(spacing: 10) {
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: "headphones")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(primaryContainer)
                        Text("Sigiriya Citadel • Audio Walk")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("1:12 / 3:45")
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(primaryContainer)
                }
                
                HStack(spacing: 12) {
                    Button(action: {
                        isAudioPlaying.toggle()
                        triggerToast(isAudioPlaying ? "Resumed Sigiriya audio story" : "Paused audio")
                    }) {
                        ZStack {
                            Circle()
                                .fill(primaryContainer)
                                .frame(width: 40, height: 40)
                            Image(systemName: isAudioPlaying ? "pause.fill" : "play.fill")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                        }
                    }
                    
                    Text("Narrating: The Mirror Wall & Kashyapa's Sky Palace")
                        .font(.system(size: 12))
                        .foregroundColor(textOnSurfaceVariant)
                    
                    Spacer()
                }
            }
            .padding(14)
            .background(surfaceContainer)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            // Action Buttons
            VStack(spacing: 10) {
                Button(action: {
                    TripManager.shared.addCustomStop(
                        title: "Sigiriya Rock Fortress",
                        category: "Culture",
                        notes: "UNESCO 5th century citadel with Lion Staircase",
                        entranceFeeLKR: 10800
                    )
                    triggerToast("Added Sigiriya to your active Sri Lanka itinerary!")
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 16, weight: .bold))
                        Text("Add Sigiriya to Itinerary")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(primaryContainer)
                    .clipShape(Capsule())
                }
                
                Button(action: {
                    navigateToPlaceDiscovery = true
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "safari.fill")
                            .font(.system(size: 14, weight: .bold))
                        Text("Discover More Sri Lanka Places")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(secondaryMint)
                    .frame(maxWidth: .infinity)
                    .frame(height: 46)
                    .background(surfaceContainerHigh)
                    .clipShape(Capsule())
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
    
    // MARK: - Actions
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
