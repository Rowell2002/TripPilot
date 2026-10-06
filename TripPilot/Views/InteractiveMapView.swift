//
//  InteractiveMapView.swift
//  TripPilot
//
//  Generated from Stitch Screen: 72ae9a3bc3434720bcbd164a83d68cdf
//  Title: TripPilot - Interactive Map (Dark Mode)
//

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
    case allPins = "All Pins (18)"
    case mustVisit = "Must-Visit (6)"
    case foodDrink = "Food & Drink (8)"
    case transit = "Transit (4)"
    case saved = "Saved (12)"
    
    var id: String { rawValue }
    
    var iconName: String {
        switch self {
        case .discover: return "safari"
        case .allPins: return "circle.hexagongrid.fill"
        case .mustVisit: return "star.fill"
        case .foodDrink: return "fork.knife"
        case .transit: return "tram.fill"
        case .saved: return "bookmark.fill"
        }
    }
}

struct InteractiveMapView: View {
    @Environment(\.dismiss) private var dismiss
    
    // Stitch Theme Colors
    private let darkBackground = Color(red: 15/255, green: 19/255, blue: 28/255)            // #0f131c
    private let mapCanvasBg = Color(red: 10/255, green: 14/255, blue: 22/255)             // #0a0e16
    private let surfaceContainerLowest = Color(red: 10/255, green: 14/255, blue: 22/255)  // #0a0e16
    private let surfaceContainerLow = Color(red: 24/255, green: 28/255, blue: 36/255)   // #181c24
    private let surfaceContainer = Color(red: 28/255, green: 32/255, blue: 40/255)      // #1c2028
    private let surfaceContainerHigh = Color(red: 38/255, green: 42/255, blue: 51/255)  // #262a33
    private let surfaceContainerHighest = Color(red: 49/255, green: 53/255, blue: 62/255) // #31353e
    private let primaryCyan = Color(red: 142/255, green: 213/255, blue: 255/255)         // #8ed5ff
    private let primaryContainer = Color(red: 56/255, green: 189/255, blue: 248/255)    // #38bdf8
    private let secondaryMint = Color(red: 68/255, green: 226/255, blue: 205/255)       // #44e2cd
    private let secondaryContainer = Color(red: 3/255, green: 198/255, blue: 178/255)   // #03c6b2
    private let textOnSurface = Color(red: 223/255, green: 226/255, blue: 238/255)      // #dfe2ee
    private let textOnSurfaceVariant = Color(red: 189/255, green: 200/255, blue: 209/255) // #bdc8d1
    private let outlineVariant = Color.white.opacity(0.12)
    
    // Interactive State
    @State private var selectedTab: AppTab = .map
    @State private var selectedFilter: MapFilter = .allPins
    @State private var searchText: String = "Shibuya Crossing, Tokyo"
    @State private var is3DEnabled: Bool = false
    @State private var isAudioPlaying: Bool = true
    @State private var audioSeconds: Int = 42
    @State private var isSpotSaved: Bool = false
    @State private var isGpsRadarPulsing: Bool = false
    @State private var isRecenterPressed: Bool = false
    @State private var toastMessage: String? = nil
    @State private var navigateToHome: Bool = false
    @State private var navigateToItinerary: Bool = false
    @State private var showDirectionsSheet: Bool = false
    @State private var mapZoomLevel: CGFloat = 1.0
    
    // Pinned Landmarks on Tokyo Night Canvas
    private let landmarkPins: [MapPin] = [
        MapPin(name: "Senso-ji", category: "Historic", icon: "camera.fill", coordinateOffset: CGPoint(x: 0.78, y: 0.22), isDestination: false, color: Color(red: 68/255, green: 226/255, blue: 205/255)),
        MapPin(name: "Aman Tokyo", category: "Stay", icon: "bed.double.fill", coordinateOffset: CGPoint(x: 0.22, y: 0.30), isDestination: false, color: Color(red: 142/255, green: 213/255, blue: 255/255)),
        MapPin(name: "Meiji Shrine", category: "Destination", icon: "building.columns.fill", coordinateOffset: CGPoint(x: 0.52, y: 0.29), isDestination: true, color: Color(red: 56/255, green: 189/255, blue: 248/255)),
        MapPin(name: "Sushi Yoshitake", category: "Dining", icon: "fork.knife", coordinateOffset: CGPoint(x: 0.74, y: 0.46), isDestination: false, color: Color(red: 68/255, green: 226/255, blue: 205/255))
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main Night Cartography & Bottom Sheet Scroll
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // MARK: - 1. Top Header Bar
                    topHeaderBarSection
                        .padding(.top, 46)
                    
                    // MARK: - 2. Interactive Map Canvas Area
                    mapCanvasArea
                        .frame(height: 560)
                    
                    // MARK: - 3. Geofenced Landmark Discovery Sheet
                    landmarkDiscoverySheet
                    
                    // Spacing for floating bottom bar
                    Spacer()
                        .frame(height: 110)
                }
            }
            .background(darkBackground.ignoresSafeArea())
            
            // MARK: - 4. Floating Glassmorphic Bottom Navigation Bar
            FloatingBottomNavBar(selectedTab: $selectedTab) { tab in
                if tab == .home {
                    dismiss()
                } else if tab == .itinerary {
                    navigateToItinerary = true
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
        .overlay(alignment: .top) {
            if let toast = toastMessage {
                Text(toast)
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
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                isGpsRadarPulsing = true
            }
        }
    }
    
    // MARK: - 1. Top Header Bar
    private var topHeaderBarSection: some View {
        VStack(spacing: 6) {
            // Flight Status Chip
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(textOnSurface)
                        .frame(width: 32, height: 32)
                        .background(surfaceContainerHigh.opacity(0.6))
                        .clipShape(Circle())
                }
                
                Spacer()
                
                HStack(spacing: 6) {
                    Image(systemName: "airplane")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(primaryContainer)
                    Text("JL 005 • In 2h 15m")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .tracking(0.6)
                        .foregroundColor(primaryCyan)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 5)
                .background(surfaceContainerHigh)
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(outlineVariant, lineWidth: 1)
                )
                
                Spacer()
                
                // Balance spacing
                Color.clear.frame(width: 32, height: 32)
            }
            .padding(.horizontal, 16)
            
            // Brand Logo & Title Row
            HStack(spacing: 12) {
                HStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(primaryContainer.opacity(0.2))
                            .frame(width: 34, height: 34)
                        Image(systemName: "map.fill")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(primaryContainer)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("TripPilot")
                            .font(.system(size: 18, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                        Text("MAP • NIGHT")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .tracking(1.0)
                            .foregroundColor(primaryContainer)
                    }
                }
                
                Spacer()
                
                // Notifications button
                Button(action: {
                    triggerToast("No new navigation alerts")
                }) {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "bell.fill")
                            .font(.system(size: 16))
                            .foregroundColor(textOnSurface)
                            .frame(width: 38, height: 38)
                            .background(surfaceContainerHigh.opacity(0.6))
                            .clipShape(Circle())
                        
                        Circle()
                            .fill(Color(red: 255/255, green: 100/255, blue: 100/255))
                            .frame(width: 8, height: 8)
                            .offset(x: -4, y: 4)
                            .shadow(color: Color.red.opacity(0.6), radius: 4)
                    }
                }
                
                // User Avatar
                AsyncImage(url: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuDb-R9RyzdwNRctHnbqddjU4N7mKMarUqir3UqzLA4HjDNG09Aj82ik5Z1r7nij7zDOHWjY0zodcVbu3DsW3CQvWFud_7eMalaLZEhe9y-o8-D3u7t_NExiyBopidw4pSIzYHWh8swveQg29oBNfmhS1FqxUt09-2vfzoM8V3XMdTdZoUQQm5CNGaFIzj7glDfI4hwA-cp3dsSgjG3LYtFIDaQtQD5jQb4Z5Qs8EVZSSWRmtleqKHWveA")) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        Circle().fill(surfaceContainerHigh)
                    }
                }
                .frame(width: 34, height: 34)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(outlineVariant, lineWidth: 1)
                )
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
                // Background Night Cartography Image
                AsyncImage(url: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuBUe5sSIREWsi9xl7WhG57VzPoa_1t5f-zLxT8JQdKE5djWuC-xvTT9dKHsMqdgBBl2F3U9owW5Apnd8_5kz0F6k23xOJhyRs9urJHBn4A7NrNYUeCFvIkH7fvzGe61QIC3z5H7MEKem6WOUBco8ViGzI453GaK1Cgfmj4xAXaXKHiWUVub1HDRfAynsaVYKBro6ZYHLcbyEEKX_h5FgaKQvq84y-mC3VFHYBis7xVWUYPYEvvQvLOqAw")) { phase in
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
                
                // 3D Perspective Tilt Effect
                .rotation3DEffect(
                    .degrees(is3DEnabled ? 18 : 0),
                    axis: (x: 1.0, y: 0.0, z: 0.0)
                )
                
                // Night Map Ambient Gradient Shading
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
                
                // Luminous Route Path from GPS (Shibuya) to Meiji Shrine
                Path { path in
                    let start = CGPoint(x: geo.size.width * 0.42, y: geo.size.height * 0.70)
                    let end = CGPoint(x: geo.size.width * 0.52, y: geo.size.height * 0.33)
                    let cp1 = CGPoint(x: geo.size.width * 0.46, y: geo.size.height * 0.56)
                    let cp2 = CGPoint(x: geo.size.width * 0.49, y: geo.size.height * 0.42)
                    
                    path.move(to: start)
                    path.addCurve(to: end, control1: cp1, control2: cp2)
                }
                .stroke(
                    LinearGradient(
                        colors: [primaryContainer, secondaryMint, primaryCyan],
                        startPoint: .bottom,
                        endPoint: .top
                    ),
                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                )
                .shadow(color: primaryContainer.opacity(0.8), radius: 8)
                
                // White dashed inner route
                Path { path in
                    let start = CGPoint(x: geo.size.width * 0.42, y: geo.size.height * 0.70)
                    let end = CGPoint(x: geo.size.width * 0.52, y: geo.size.height * 0.33)
                    let cp1 = CGPoint(x: geo.size.width * 0.46, y: geo.size.height * 0.56)
                    let cp2 = CGPoint(x: geo.size.width * 0.49, y: geo.size.height * 0.42)
                    
                    path.move(to: start)
                    path.addCurve(to: end, control1: cp1, control2: cp2)
                }
                .stroke(
                    Color.white,
                    style: StrokeStyle(lineWidth: 2.5, lineCap: .round, dash: [4, 6])
                )
                
                // Floating Route Timing Badge
                HStack(spacing: 5) {
                    Image(systemName: "figure.walk")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(primaryContainer)
                    Text("14 min • 1.1 km")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(surfaceContainerLow.opacity(0.95))
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(primaryContainer.opacity(0.5), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.7), radius: 10, y: 4)
                .position(x: geo.size.width * 0.48, y: geo.size.height * 0.51)
                
                // Pinned Landmark Markers
                ForEach(landmarkPins) { pin in
                    let pinX = geo.size.width * pin.coordinateOffset.x
                    let pinY = geo.size.height * pin.coordinateOffset.y
                    
                    VStack(spacing: 3) {
                        if pin.isDestination {
                            // High-prominence Destination Pin (Meiji Shrine)
                            ZStack {
                                Circle()
                                    .fill(primaryContainer)
                                    .frame(width: 44, height: 44)
                                    .shadow(color: primaryContainer.opacity(0.8), radius: 12)
                                
                                Image(systemName: pin.icon)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Color(red: 0/255, green: 40/255, blue: 60/255))
                            }
                            
                            Text(pin.name)
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(surfaceContainerLow.opacity(0.95))
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule().stroke(primaryContainer.opacity(0.6), lineWidth: 1)
                                )
                        } else {
                            // Standard Pinned Pin
                            ZStack {
                                Circle()
                                    .fill(surfaceContainer)
                                    .frame(width: 36, height: 36)
                                    .overlay(
                                        Circle().stroke(pin.color.opacity(0.6), lineWidth: 1.5)
                                    )
                                    .shadow(color: pin.color.opacity(0.35), radius: 8)
                                
                                Circle()
                                    .fill(pin.color.opacity(0.2))
                                    .frame(width: 28, height: 28)
                                
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
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6).stroke(outlineVariant, lineWidth: 1)
                                )
                        }
                    }
                    .position(x: pinX, y: pinY)
                    .onTapGesture {
                        triggerToast("Selected: \(pin.name)")
                    }
                }
                
                // Current User GPS Radar Dot (Shibuya Crossing)
                ZStack {
                    // Outer radar ripple
                    Circle()
                        .fill(primaryContainer.opacity(0.2))
                        .frame(width: 72, height: 72)
                        .scaleEffect(isGpsRadarPulsing ? 1.3 : 0.8)
                        .opacity(isGpsRadarPulsing ? 0.3 : 0.8)
                    
                    // Middle aura
                    Circle()
                        .fill(secondaryMint.opacity(0.25))
                        .frame(width: 44, height: 44)
                    
                    // Center bead
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 20, height: 20)
                            .shadow(color: primaryContainer, radius: 8)
                        
                        Circle()
                            .fill(primaryContainer)
                            .frame(width: 14, height: 14)
                    }
                    
                    // Directional beam pointing toward Meiji Shrine
                    Image(systemName: "location.north.fill")
                        .font(.system(size: 11, weight: .heavy))
                        .foregroundColor(primaryContainer)
                        .offset(y: -18)
                        .rotationEffect(.degrees(16))
                }
                .position(x: geo.size.width * 0.42, y: geo.size.height * 0.70)
                
                // Floating Top Search Bar & Filters
                VStack(spacing: 10) {
                    // Search Bar Box
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(primaryContainer)
                        
                        TextField("Search spots, ramen, shrines...", text: $searchText)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.white)
                        
                        Button(action: {
                            triggerToast("Voice search activated")
                        }) {
                            Image(systemName: "mic.fill")
                                .font(.system(size: 14))
                                .foregroundColor(textOnSurfaceVariant)
                        }
                        
                        Button(action: {
                            triggerToast("Map filters updated")
                        }) {
                            Image(systemName: "slider.horizontal.3")
                                .font(.system(size: 14))
                                .foregroundColor(textOnSurfaceVariant)
                        }
                    }
                    .padding(.horizontal, 14)
                    .frame(height: 48)
                    .background(surfaceContainerLow.opacity(0.95))
                    .clipShape(Capsule())
                    .overlay(
                        Capsule().stroke(outlineVariant, lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.6), radius: 14, y: 6)
                    
                    // Filter Chips Ribbon
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(MapFilter.allCases) { filter in
                                Button(action: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedFilter = filter
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
                                    .overlay(
                                        Capsule().stroke(selectedFilter == filter ? primaryContainer : outlineVariant, lineWidth: 1)
                                    )
                                    .shadow(color: selectedFilter == filter ? primaryContainer.opacity(0.4) : .clear, radius: 6)
                                }
                            }
                        }
                        .padding(.horizontal, 2)
                    }
                }
                .padding(.horizontal, 16)
                .position(x: geo.size.width / 2, y: 56)
                
                // Right Side Map Controls Stack
                VStack(spacing: 8) {
                    VStack(spacing: 0) {
                        // Recenter button
                        Button(action: {
                            withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                                isRecenterPressed = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                isRecenterPressed = false
                            }
                            triggerToast("Map re-centered to your location")
                        }) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(primaryContainer)
                                .frame(width: 42, height: 42)
                                .scaleEffect(isRecenterPressed ? 0.85 : 1.0)
                        }
                        
                        Rectangle()
                            .fill(outlineVariant)
                            .frame(width: 28, height: 1)
                        
                        // 3D toggle
                        Button(action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                is3DEnabled.toggle()
                            }
                            triggerToast(is3DEnabled ? "3D perspective enabled" : "2D top view enabled")
                        }) {
                            Text("3D")
                                .font(.system(size: 13, weight: .heavy, design: .rounded))
                                .foregroundColor(is3DEnabled ? primaryContainer : .white)
                                .frame(width: 44, height: 42)
                        }
                        
                        Rectangle()
                            .fill(outlineVariant)
                            .frame(width: 28, height: 1)
                        
                        // Layers button
                        Button(action: {
                            triggerToast("Switched to OLED Night Cartography")
                        }) {
                            Image(systemName: "square.3.layers.3d")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(textOnSurfaceVariant)
                                .frame(width: 44, height: 42)
                        }
                    }
                    .frame(width: 44)
                    .background(surfaceContainerLow.opacity(0.92))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14).stroke(outlineVariant, lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.6), radius: 12, y: 4)
                    
                    // Quick Compass
                    Button(action: {
                        triggerToast("Compass aligned North")
                    }) {
                        Image(systemName: "safari")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(red: 255/255, green: 110/255, blue: 110/255))
                            .frame(width: 42, height: 42)
                            .background(surfaceContainerLow.opacity(0.92))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14).stroke(outlineVariant, lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.6), radius: 12, y: 4)
                    }
                }
                .position(x: geo.size.width - 34, y: 220)
            }
        }
    }
    
    // MARK: - 3. Geofenced Landmark Discovery Sheet
    private var landmarkDiscoverySheet: some View {
        VStack(alignment: .leading, spacing: 18) {
            // Drag Handle Bar
            Capsule()
                .fill(Color.white.opacity(0.2))
                .frame(width: 40, height: 5)
                .frame(maxWidth: .infinity)
                .padding(.top, 10)
            
            // Proximity Live Badge & Actions
            HStack {
                HStack(spacing: 7) {
                    Circle()
                        .fill(secondaryMint)
                        .frame(width: 7, height: 7)
                        .shadow(color: secondaryMint, radius: 4)
                    Text("LANDMARK NEARBY • 120M AWAY")
                        .font(.system(size: 11, weight: .heavy, design: .rounded))
                        .tracking(0.6)
                        .foregroundColor(secondaryMint)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(secondaryMint.opacity(0.15))
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(secondaryMint.opacity(0.35), lineWidth: 1)
                )
                
                Spacer()
                
                HStack(spacing: 8) {
                    Button(action: {
                        triggerToast("Spot link copied to clipboard")
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(textOnSurface)
                            .frame(width: 34, height: 34)
                            .background(surfaceContainerHigh)
                            .clipShape(Circle())
                    }
                    
                    Button(action: {
                        isSpotSaved.toggle()
                        triggerToast(isSpotSaved ? "Saved Shibuya Crossing to Favorites" : "Removed from Favorites")
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
            
            // Landmark Hero Details
            VStack(alignment: .leading, spacing: 4) {
                Text("Shibuya Crossing & Hachiko")
                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Shibuya City, Tokyo • World's Busiest Intersection")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(textOnSurfaceVariant)
                
                // Rating, Open Status, and Vibe Pill
                HStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 11))
                            .foregroundColor(secondaryMint)
                        Text("4.8")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        Text("(34.2k)")
                            .font(.system(size: 12))
                            .foregroundColor(textOnSurfaceVariant)
                    }
                    .padding(.horizontal, 9)
                    .padding(.vertical, 4)
                    .background(surfaceContainerHigh)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule().stroke(outlineVariant, lineWidth: 1)
                    )
                    
                    HStack(spacing: 5) {
                        Circle()
                            .fill(secondaryMint)
                            .frame(width: 6, height: 6)
                        Text("Open 24 Hours")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundColor(secondaryMint)
                    }
                    
                    Text("•")
                        .foregroundColor(textOnSurfaceVariant)
                    
                    Text("Famous Scramble")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(textOnSurfaceVariant)
                }
                .padding(.top, 4)
            }
            
            // Curated Landmark Visual Mosaic
            HStack(spacing: 8) {
                // Wide Angle Shot (Left 2 cols)
                ZStack(alignment: .bottomLeading) {
                    AsyncImage(url: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuApLRR6b12s83Ptp5t7iBqXRkgYelZOkiRzb2JVfNc6gE2GnwNIathnDmKZjXsYUQYswGWeJ7MPk6nHDKuzo_ySvY6usvtmRwfNV7qpJIK-8hsQhSP-3c_1rZMrOVX-iPHgLZdaQ6Ti9OI7K3TEF1lBHKJg0bXwc0eBXjaPkO4oUGX7HerRGP_DN0iOicZbCMvOhgGHV6unwmX0ouvH-xfK591q3MyXZZRJZJLBERwom44gVMONGeG7UQ")) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else {
                            Color.gray.opacity(0.3)
                        }
                    }
                    .frame(height: 144)
                    .clipped()
                    
                    LinearGradient(
                        colors: [Color.black.opacity(0.85), Color.clear],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    
                    Text("Live Atmosphere")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background(Color.black.opacity(0.7))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .padding(8)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 144)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14).stroke(outlineVariant, lineWidth: 1)
                )
                
                // Right stacked thumbnails
                VStack(spacing: 8) {
                    // Top: Hachiko
                    AsyncImage(url: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuCK-FPd0R76NQni8bbSy9b4o8XuZwbk0kzPAsMfHNUb3gQYEJjvdRO1TgHKV9b6pvZ0g9KvTPKuoKnV7fyhhd6LMSwFZgX2Tlw377f5BsZqDCdD0HMCKnKsQRS8xnraR__S8Cb1Z3S0K3rIdTqYsQU8z1N_sy291LMAgM8iPnliFhKaI3wkYPFUUZHQ6S3NECKSTDk89s7ma-ORlUQCTb5FIY_Us5_LFjkN9gAwmLA0AvQAXpTzkk_sqw")) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else {
                            Color.gray.opacity(0.3)
                        }
                    }
                    .frame(width: 100, height: 68)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12).stroke(outlineVariant, lineWidth: 1)
                    )
                    
                    // Bottom: Aerial Shibuya Sky with +42 overlay
                    ZStack {
                        AsyncImage(url: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuAczFOfD3TLacE8ATXbh4dVAcNy_w0vKmmMYzBllKpST4QgVWbtiKRuCSePbTIKkOTeljcwrpTadTcnmCIJ-8tGrD0r0Tdj1trV0Y-loewVRSWGCxzCCEaocLq-v08_wa9amDqneWzpzmCslCBXle_VTKOeDJhbaWj7QRp_XN1FZI85GCoNxRiJ82fYdIV2oo6QpnbbxOUysWIJsrBvXey2QkVvuZ40IJKNR3pSngAG-DCthJt25qIvTA")) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } else {
                                Color.gray.opacity(0.3)
                            }
                        }
                        
                        Color.black.opacity(0.65)
                        
                        Text("+42 photos")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .frame(width: 100, height: 68)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12).stroke(outlineVariant, lineWidth: 1)
                    )
                }
            }
            
            // Smart Trivia Bento Box
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    Circle()
                        .fill(primaryContainer.opacity(0.2))
                        .frame(width: 36, height: 36)
                        .overlay(
                            Circle().stroke(primaryContainer.opacity(0.4), lineWidth: 1)
                        )
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(primaryContainer)
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    Text("Did You Know?")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Over 2.4 million people cross this intersection every single day! Up to 3,000 pedestrians cross simultaneously on a single green light.")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(textOnSurfaceVariant)
                        .lineSpacing(2)
                }
            }
            .padding(14)
            .background(surfaceContainerLow)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16).stroke(outlineVariant, lineWidth: 1)
            )
            
            // Interactive Spatial Audio Guide Player
            VStack(spacing: 10) {
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: "headphones")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(primaryContainer)
                        Text("Shibuya Story • Audio Walk")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("0:42 / 2:15")
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(primaryContainer)
                }
                
                HStack(spacing: 12) {
                    // Play/Pause button
                    Button(action: {
                        isAudioPlaying.toggle()
                        triggerToast(isAudioPlaying ? "Resumed audio story" : "Paused audio story")
                    }) {
                        ZStack {
                            Circle()
                                .fill(primaryContainer)
                                .frame(width: 40, height: 40)
                                .shadow(color: primaryContainer.opacity(0.45), radius: 8)
                            
                            Image(systemName: isAudioPlaying ? "pause.fill" : "play.fill")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Color(red: 0/255, green: 40/255, blue: 60/255))
                        }
                    }
                    
                    // Animated dynamic equalizer bars
                    HStack(spacing: 3) {
                        ForEach(0..<16) { i in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(
                                    i < 8 ?
                                    (i % 2 == 0 ? primaryContainer : secondaryMint) :
                                    outlineVariant
                                )
                                .frame(width: 4, height: isAudioPlaying ? CGFloat([14, 22, 28, 16, 24, 30, 20, 26, 12, 18, 10, 22, 16, 14, 8, 12][i]) : 8)
                                .animation(
                                    isAudioPlaying ?
                                    Animation.easeInOut(duration: 0.45).repeatForever(autoreverses: true).delay(Double(i) * 0.05) :
                                    .default,
                                    value: isAudioPlaying
                                )
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    // Speaker volume button
                    Button(action: {
                        triggerToast("Spatial audio volume: 100%")
                    }) {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.system(size: 16))
                            .foregroundColor(textOnSurfaceVariant)
                    }
                }
            }
            .padding(14)
            .background(surfaceContainer)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16).stroke(outlineVariant, lineWidth: 1)
            )
            
            // Action Buttons Stack
            VStack(spacing: 10) {
                // Primary: Start Walking Directions
                Button(action: {
                    triggerToast("Starting walking route to Meiji Shrine (14 min)")
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "figure.walk")
                            .font(.system(size: 18, weight: .bold))
                        Text("Start Walking Directions")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(Color(red: 0/255, green: 40/255, blue: 60/255))
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(
                        LinearGradient(
                            colors: [Color(red: 2/255, green: 132/255, blue: 199/255), primaryContainer, secondaryContainer],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
                    .shadow(color: primaryContainer.opacity(0.4), radius: 14, y: 4)
                }
                
                // Secondary: Add to Today's Itinerary + Share
                HStack(spacing: 10) {
                    Button(action: {
                        triggerToast("Added Shibuya Crossing to Today's Itinerary")
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(primaryContainer)
                            Text("Add to Today's Itinerary")
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(surfaceContainerHigh)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule().stroke(outlineVariant, lineWidth: 1)
                        )
                    }
                    
                    Button(action: {
                        triggerToast("Location sent via TripPilot AirDrop")
                    }) {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 48, height: 48)
                            .background(surfaceContainerHigh)
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(outlineVariant, lineWidth: 1)
                            )
                    }
                }
                
                // Tertiary: Discover Places Nearby
                Button(action: {
                    triggerToast("Searching 24 attractions within 500m")
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "location.north.line.fill")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(primaryContainer)
                        Text("Discover Places Nearby")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(primaryContainer)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(surfaceContainerHigh.opacity(0.8))
                    .clipShape(Capsule())
                    .overlay(
                        Capsule().stroke(primaryContainer.opacity(0.35), lineWidth: 1)
                    )
                }
            }
            .padding(.top, 4)
        }
        .padding(.horizontal, 18)
        .padding(.top, 4)
        .padding(.bottom, 24)
        .background(
            Color(red: 13/255, green: 17/255, blue: 23/255)
        )
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(outlineVariant, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.8), radius: 24, y: -10)
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
