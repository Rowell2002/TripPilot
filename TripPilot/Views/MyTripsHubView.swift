//
//  MyTripsHubView.swift
//  TripPilot
//
//  Generated from Stitch Screen: 47d0bae51dee43a8abbaea8844fbffd9
//  Title: TripPilot - My Trips Hub (Dark Mode)
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct MyTripsHubView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var searchText: String = ""
    @State private var selectedFilter: TripFilter = .all
    @State private var selectedSegment: TripSegment = .activeAndUpcoming
    @State private var selectedTab: AppTab = .trips
    @State private var isLivePulsing: Bool = false
    @State private var activeNotice: String? = nil
    @State private var showPlanJourneySheet: Bool = false
    @State private var showItinerarySheet: Bool = false
    
    init(selectedSegment: TripSegment = .activeAndUpcoming) {
        self._selectedSegment = State(initialValue: selectedSegment)
    }
    
    // Stitch Theme Colors
    private let darkBackground = Color(red: 15/255, green: 19/255, blue: 28/255)       // #0f131c
    private let surfaceContainerLowest = Color(red: 10/255, green: 14/255, blue: 22/255) // #0a0e16
    private let surfaceContainerLow = Color(red: 24/255, green: 28/255, blue: 36/255)  // #181c24
    private let surfaceContainer = Color(red: 28/255, green: 32/255, blue: 40/255)     // #1c2028
    private let surfaceContainerHigh = Color(red: 38/255, green: 42/255, blue: 51/255) // #262a33
    private let primaryCyan = Color(red: 68/255, green: 226/255, blue: 205/255)        // #44e2cd
    private let secondaryMint = Color(red: 3/255, green: 198/255, blue: 178/255)       // #03c6b2
    private let skyBlue = Color(red: 56/255, green: 189/255, blue: 248/255)           // #38bdf8
    private let textOnSurface = Color(red: 223/255, green: 226/255, blue: 238/255)     // #dfe2ee
    private let textMuted = Color(red: 135/255, green: 146/255, blue: 154/255)        // #87929a
    private let outlineVariant = Color.white.opacity(0.1)
    
    enum TripFilter: String, CaseIterable {
        case all = "All"
        case active = "Active"
        case upcoming = "Upcoming"
        case archived = "Archived"
    }
    
    enum TripSegment: String {
        case activeAndUpcoming = "Active & Upcoming"
        case pastJourneys = "Past Journeys (8)"
    }
    
    var body: some View {
        Group {
            if selectedSegment == .activeAndUpcoming {
                activeAndUpcomingContentView
            } else {
                PastJourneysView(selectedSegment: $selectedSegment)
            }
        }
        .navigationBarBackButtonHidden(true)
        .preferredColorScheme(.dark)
    }
    
    private var activeAndUpcomingContentView: some View {
        ZStack(alignment: .bottom) {
            // Background
            darkBackground
                .ignoresSafeArea()
            
            // Ambient Glow Effects
            GeometryReader { _ in
                Circle()
                    .fill(skyBlue.opacity(0.06))
                    .frame(width: 320, height: 320)
                    .blur(radius: 80)
                    .offset(x: -60, y: -40)
                
                Circle()
                    .fill(primaryCyan.opacity(0.05))
                    .frame(width: 300, height: 300)
                    .blur(radius: 70)
                    .offset(x: 180, y: 380)
            }
            .ignoresSafeArea()
            
            // Scrollable Content
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // MARK: - Header Bar (Back button + Title + Profile)
                    headerBarSection
                        .padding(.top, 8)
                    
                    // MARK: - Search & Filter Controls
                    searchAndFilterSection
                    
                    // MARK: - Filter Chips Ribbon
                    filterChipsRibbon
                    
                    // MARK: - View Switcher Segmented Control
                    segmentedControlSection
                    
                    // MARK: - Section 1: Active Ongoing Journey
                    activeJourneySection
                    
                    // MARK: - Section 2: Upcoming Confirmed Trips
                    upcomingJourneysSection
                    
                    // MARK: - Section 3: AI Trip Drafts & Inspirations
                    aiDraftsSection
                    
                    // MARK: - Plan New Journey Primary Button
                    planNewJourneyButton
                    
                    // Bottom spacing for floating tab bar
                    Spacer()
                        .frame(height: 110)
                }
                .padding(.horizontal, 18)
            }
            
            // MARK: - Floating Glassmorphic Bottom Tab Bar
            FloatingBottomNavBar(selectedTab: $selectedTab) { tab in
                if tab == .home {
                    dismiss()
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 8)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                isLivePulsing = true
            }
        }
        .sheet(isPresented: $showPlanJourneySheet) {
            planNewJourneySheetView
        }
        .sheet(isPresented: $showItinerarySheet) {
            itinerarySheetView
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
                        Capsule()
                            .stroke(skyBlue.opacity(0.4), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.6), radius: 10, y: 5)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .padding(.top, 50)
                    .zIndex(100)
            }
        }
    }
    
    // MARK: - Header Bar Section
    private var headerBarSection: some View {
        HStack(alignment: .center, spacing: 12) {
            // Back Button
            Button(action: {
                dismiss()
            }) {
                ZStack {
                    Circle()
                        .fill(surfaceContainerLow)
                        .frame(width: 38, height: 38)
                        .overlay(
                            Circle()
                                .stroke(outlineVariant, lineWidth: 1)
                        )
                    
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(textOnSurface)
                }
            }
            
            // Logo / Branding & Title
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [skyBlue, Color(red: 2/255, green: 132/255, blue: 199/255)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 36, height: 36)
                        .overlay(
                            Circle()
                                .stroke(skyBlue.opacity(0.4), lineWidth: 1)
                        )
                        .shadow(color: skyBlue.opacity(0.25), radius: 8, y: 2)
                    
                    Image(systemName: "suitcase.rolling.fill")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 1) {
                    Text("My Trips")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(textOnSurface)
                    
                    Text("EXECUTIVE ITINERARY HUB")
                        .font(.system(size: 9.5, weight: .bold, design: .rounded))
                        .foregroundColor(textMuted)
                        .tracking(1.0)
                }
            }
            
            Spacer()
            
            // Notifications & User Profile
            HStack(spacing: 10) {
                Button(action: {
                    triggerNotice("🔔 1 notification: Gate updated for JL 006")
                }) {
                    ZStack(alignment: .topTrailing) {
                        Circle()
                            .fill(surfaceContainerLow)
                            .frame(width: 38, height: 38)
                            .overlay(
                                Circle()
                                    .stroke(outlineVariant, lineWidth: 1)
                            )
                        
                        Image(systemName: "bell.fill")
                            .font(.system(size: 14))
                            .foregroundColor(textOnSurface)
                            .frame(width: 38, height: 38)
                        
                        Circle()
                            .fill(skyBlue)
                            .frame(width: 7, height: 7)
                            .shadow(color: skyBlue, radius: 4)
                            .offset(x: -2, y: 2)
                    }
                }
                
                // Profile Avatar with Status Ring
                ZStack(alignment: .bottomTrailing) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color(red: 244/255, green: 114/255, blue: 182/255), Color(red: 168/255, green: 85/255, blue: 247/255)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 36, height: 36)
                            .overlay(
                                Circle()
                                    .stroke(skyBlue.opacity(0.4), lineWidth: 1.5)
                            )
                        
                        Text("E")
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    
                    Circle()
                        .fill(secondaryMint)
                        .frame(width: 10, height: 10)
                        .overlay(Circle().stroke(darkBackground, lineWidth: 2))
                }
            }
        }
    }
    
    // MARK: - Search & Filter Section
    private var searchAndFilterSection: some View {
        HStack(spacing: 10) {
            // Search Input Field
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(textMuted)
                
                TextField("Search destinations, bookings, tags...", text: $searchText)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(textOnSurface)
                    #if os(iOS)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    #endif
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(textMuted)
                    }
                }
                
                Button(action: {
                    triggerNotice("🎙️ Voice search listening...")
                }) {
                    Image(systemName: "mic.fill")
                        .font(.system(size: 14))
                        .foregroundColor(textMuted)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(surfaceContainerLow)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(outlineVariant, lineWidth: 1)
            )
            
            // Tune / Filter button
            Button(action: {
                triggerNotice("⚙️ Trip Filters & Sorting Options")
            }) {
                ZStack {
                    Circle()
                        .fill(surfaceContainerLow)
                        .frame(width: 42, height: 42)
                        .overlay(
                            Circle()
                                .stroke(outlineVariant, lineWidth: 1)
                        )
                    
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(textOnSurface)
                }
            }
        }
    }
    
    // MARK: - Filter Chips Ribbon
    private var filterChipsRibbon: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(TripFilter.allCases, id: \.self) { filter in
                    Button(action: {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                            selectedFilter = filter
                        }
                    }) {
                        HStack(spacing: 5) {
                            Text(filter.rawValue)
                                .font(.system(size: 12, weight: selectedFilter == filter ? .bold : .medium, design: .rounded))
                            
                            if filter == .all {
                                Text("4")
                                    .font(.system(size: 10, weight: .bold))
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 1.5)
                                    .background(selectedFilter == .all ? Color.black.opacity(0.25) : surfaceContainerHigh)
                                    .clipShape(Capsule())
                            }
                        }
                        .foregroundColor(selectedFilter == filter ? Color(red: 0/255, green: 73/255, blue: 101/255) : textMuted)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(
                            selectedFilter == filter ? skyBlue : surfaceContainerLow
                        )
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(selectedFilter == filter ? Color.clear : outlineVariant, lineWidth: 1)
                        )
                        .shadow(color: selectedFilter == filter ? skyBlue.opacity(0.3) : Color.clear, radius: 8, y: 2)
                    }
                }
            }
            .padding(.vertical, 2)
        }
    }
    
    // MARK: - Segmented Control (Active & Upcoming vs Past)
    private var segmentedControlSection: some View {
        HStack(spacing: 0) {
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                    selectedSegment = .activeAndUpcoming
                }
            }) {
                Text(TripSegment.activeAndUpcoming.rawValue)
                    .font(.system(size: 13, weight: selectedSegment == .activeAndUpcoming ? .semibold : .medium, design: .rounded))
                    .foregroundColor(selectedSegment == .activeAndUpcoming ? skyBlue : textMuted)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 9)
                    .background(
                        selectedSegment == .activeAndUpcoming ? surfaceContainerHigh : Color.clear
                    )
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(selectedSegment == .activeAndUpcoming ? outlineVariant : Color.clear, lineWidth: 1)
                    )
            }
            
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                    selectedSegment = .pastJourneys
                }
            }) {
                Text(TripSegment.pastJourneys.rawValue)
                    .font(.system(size: 13, weight: selectedSegment == .pastJourneys ? .semibold : .medium, design: .rounded))
                    .foregroundColor(selectedSegment == .pastJourneys ? skyBlue : textMuted)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 9)
                    .background(
                        selectedSegment == .pastJourneys ? surfaceContainerHigh : Color.clear
                    )
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(selectedSegment == .pastJourneys ? outlineVariant : Color.clear, lineWidth: 1)
                    )
            }
        }
        .padding(4)
        .background(surfaceContainerLowest)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(outlineVariant, lineWidth: 1)
        )
    }
    
    // MARK: - Section 1: Active Ongoing Journey
    private var activeJourneySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Section Header
            HStack {
                HStack(spacing: 8) {
                    Circle()
                        .fill(secondaryMint)
                        .frame(width: 8, height: 8)
                        .shadow(color: secondaryMint, radius: 4)
                        .scaleEffect(isLivePulsing ? 1.25 : 0.85)
                    
                    Text("Active Journey")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(textOnSurface)
                }
                
                Spacer()
                
                Text("EN ROUTE")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundColor(primaryCyan)
                    .tracking(1.0)
            }
            
            // Hero Card: Autumn in Japan
            VStack(spacing: 0) {
                // Image Header with Scrim
                ZStack(alignment: .bottomLeading) {
                    AsyncImage(url: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuC2PaIlB4zHLJ-mryPUvBIIx9oJvetEnNnq6Y-O-kl81_3RjwTiyg56OE_8mbElJWzlvvdG0KxBpw7eJDu38b62pVHgi5pRMTYNAb-zBloDAciyyKa0XZz3ppSf651XmeNYYB8fl_EdY7zNGP1H0FqbbzVceiU6kn-yHIn3kUdnx5Occ6ywTPaI-dohcSf0io_cXk9EiszmnU8clzlIj7MPJRREWhz4QIGc_tItZhs1MPXwBA5HLR5I2A")) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else {
                            ZStack {
                                LinearGradient(
                                    colors: [Color(red: 24/255, green: 28/255, blue: 36/255), Color(red: 10/255, green: 14/255, blue: 22/255)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                Image(systemName: "torii.gate")
                                    .font(.system(size: 40))
                                    .foregroundColor(Color.white.opacity(0.15))
                            }
                        }
                    }
                    .frame(height: 190)
                    .clipped()
                    
                    // Gradient Scrim Overlays
                    LinearGradient(
                        colors: [Color.clear, surfaceContainerLowest.opacity(0.6), surfaceContainerLowest],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    
                    // Floating Pills on Top of Image
                    VStack {
                        HStack {
                            // Live Day Status Pill
                            HStack(spacing: 5) {
                                Circle()
                                    .fill(secondaryMint)
                                    .frame(width: 6, height: 6)
                                    .shadow(color: secondaryMint, radius: 4)
                                
                                Text("LIVE • DAY 3 OF 12")
                                    .font(.system(size: 10, weight: .heavy, design: .rounded))
                                    .foregroundColor(.white)
                                    .tracking(0.5)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.black.opacity(0.75))
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(outlineVariant, lineWidth: 1)
                            )
                            
                            Spacer()
                            
                            // Weather Pill
                            HStack(spacing: 5) {
                                Image(systemName: "cloud.sun.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(skyBlue)
                                Text("18°C Kyoto")
                                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.black.opacity(0.75))
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(outlineVariant, lineWidth: 1)
                            )
                        }
                        .padding(12)
                        
                        Spacer()
                    }
                    
                    // Destination Headline
                    VStack(alignment: .leading, spacing: 3) {
                        Text("EAST ASIA • GRAND TOUR")
                            .font(.system(size: 10.5, weight: .bold, design: .rounded))
                            .foregroundColor(skyBlue)
                            .tracking(0.8)
                        
                        Text("Autumn in Japan 🍁")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 12))
                                .foregroundColor(skyBlue)
                            Text("Tokyo, Hakone & Kyoto")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Color(white: 0.75))
                        }
                    }
                    .padding(14)
                }
                .frame(height: 190)
                
                // Key Stats Ribbon (3 columns)
                VStack(spacing: 12) {
                    HStack(spacing: 8) {
                        statRibbonColumn(icon: "map.fill", iconColor: skyBlue, value: "14", label: "STOPS PLANNED")
                        statRibbonColumn(icon: "dollarsign.circle.fill", iconColor: primaryCyan, value: "$2,319", label: "BUDGET LEFT")
                        statRibbonColumn(icon: "person.2.fill", iconColor: Color(red: 175/255, green: 207/255, blue: 255/255), value: "3", label: "COMPANIONS")
                    }
                    
                    // Current Up-Next Micro Card
                    HStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(skyBlue.opacity(0.2))
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Circle()
                                        .stroke(skyBlue.opacity(0.4), lineWidth: 1)
                                )
                            
                            Image(systemName: "tram.fill")
                                .font(.system(size: 16))
                                .foregroundColor(skyBlue)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("NEXT UP • 14:10")
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .foregroundColor(skyBlue)
                                .tracking(0.5)
                            
                            Text("Shinkansen Nozomi 311 to Kyoto")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                                .lineLimit(1)
                        }
                        
                        Spacer()
                        
                        Text("Car 7 • Seat 14A")
                            .font(.system(size: 10.5, weight: .bold, design: .rounded))
                            .foregroundColor(Color(red: 123/255, green: 208/255, blue: 255/255))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(surfaceContainer)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(outlineVariant, lineWidth: 1)
                            )
                    }
                    .padding(10)
                    .background(surfaceContainerHigh.opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(outlineVariant, lineWidth: 1)
                    )
                    
                    // Quick Access CTAs (3 buttons)
                    HStack(spacing: 8) {
                        Button(action: {
                            showItinerarySheet = true
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "calendar")
                                    .font(.system(size: 13, weight: .bold))
                                Text("Itinerary")
                                    .font(.system(size: 12, weight: .bold, design: .rounded))
                            }
                            .foregroundColor(Color(red: 0/255, green: 73/255, blue: 101/255))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(skyBlue)
                            .clipShape(Capsule())
                            .shadow(color: skyBlue.opacity(0.3), radius: 8, y: 2)
                        }
                        
                        Button(action: {
                            triggerNotice("🗺️ Opening Live Interactive Map of Tokyo & Kyoto")
                        }) {
                            HStack(spacing: 5) {
                                Image(systemName: "location.north.circle.fill")
                                    .font(.system(size: 13))
                                    .foregroundColor(skyBlue)
                                Text("Live Map")
                                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(surfaceContainerHigh.opacity(0.8))
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(outlineVariant, lineWidth: 1)
                            )
                        }
                        
                        Button(action: {
                            triggerNotice("🧾 Group Expense Splitter: $2,319 remaining")
                        }) {
                            HStack(spacing: 5) {
                                Image(systemName: "receipt")
                                    .font(.system(size: 13))
                                    .foregroundColor(primaryCyan)
                                Text("Split Bill")
                                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(surfaceContainerHigh.opacity(0.8))
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(outlineVariant, lineWidth: 1)
                            )
                        }
                    }
                }
                .padding(14)
                .background(surfaceContainerLow)
            }
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(outlineVariant, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.5), radius: 14, y: 6)
        }
    }
    
    private func statRibbonColumn(icon: String, iconColor: Color, value: String, label: String) -> some View {
        VStack(spacing: 2) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 12))
                    .foregroundColor(iconColor)
                Text(value)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(textOnSurface)
            }
            Text(label)
                .font(.system(size: 9, weight: .bold, design: .rounded))
                .foregroundColor(textMuted)
                .tracking(0.5)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(surfaceContainerHigh.opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(outlineVariant, lineWidth: 0.8)
        )
    }
    
    // MARK: - Section 2: Upcoming Confirmed Trips
    private var upcomingJourneysSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header Row
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "airplane.departure")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(skyBlue)
                    
                    Text("Upcoming Journeys")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(textOnSurface)
                }
                
                Spacer()
                
                Text("2 CONFIRMED")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundColor(skyBlue)
                    .tracking(0.8)
            }
            
            VStack(spacing: 12) {
                // Card 1: Amalfi & Capri
                amalfiTripCard
                
                // Card 2: Swiss Alps Escape
                swissAlpsTripCard
            }
        }
    }
    
    private var amalfiTripCard: some View {
        VStack(spacing: 10) {
            HStack(alignment: .top, spacing: 12) {
                // Thumbnail
                ZStack(alignment: .topLeading) {
                    AsyncImage(url: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuBxe5VwZ8zN1JaorxnnH0TTcR6H4wqZsCalfHHVP5_lW9LkoCMkaXKU20WXs7jx4onMD7DpNQVJ-mlf-l5HLzKwxxaUBm9KrXGsarWx9tcInNS5cYFwM-cHCZIgqxS1honnK3Q5p-qxC7ltZP9SqoyQ2-_fzpnnlTkKibv7zbVDyiPUeXARTJDsLQqPP9xtB5QlYa_qfZz3PCvw6WoH9fz9F8zI_MVlnXRBYn1mKbDCwNV7RNYyYXU1dA")) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else {
                            Rectangle().fill(surfaceContainerHigh)
                        }
                    }
                    .frame(width: 90, height: 90)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    
                    Text("JUN '26")
                        .font(.system(size: 9, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2.5)
                        .background(Color.black.opacity(0.8))
                        .clipShape(Capsule())
                        .padding(5)
                }
                .frame(width: 90, height: 90)
                
                // Trip Details
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Amalfi & Capri 🍋")
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(textOnSurface)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Text("In 48 Days")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundColor(primaryCyan)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 2.5)
                            .background(primaryCyan.opacity(0.15))
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(primaryCyan.opacity(0.3), lineWidth: 0.8)
                            )
                    }
                    
                    Text("June 12 – 20, 2026 • 8 Days")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(textMuted)
                    
                    HStack(spacing: 6) {
                        HStack(spacing: 3) {
                            Image(systemName: "airplane")
                                .font(.system(size: 9))
                                .foregroundColor(skyBlue)
                            Text("ITA Airways")
                                .font(.system(size: 10, weight: .semibold, design: .rounded))
                                .foregroundColor(textOnSurface)
                        }
                        .padding(.horizontal, 7)
                        .padding(.vertical, 2.5)
                        .background(surfaceContainer)
                        .clipShape(Capsule())
                        
                        HStack(spacing: 3) {
                            Image(systemName: "bed.double.fill")
                                .font(.system(size: 9))
                                .foregroundColor(primaryCyan)
                            Text("4 Stays")
                                .font(.system(size: 10, weight: .semibold, design: .rounded))
                                .foregroundColor(textOnSurface)
                        }
                        .padding(.horizontal, 7)
                        .padding(.vertical, 2.5)
                        .background(surfaceContainer)
                        .clipShape(Capsule())
                    }
                    .padding(.top, 2)
                }
            }
            
            // Trip Readiness Progress Bar
            VStack(spacing: 4) {
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 11))
                            .foregroundColor(primaryCyan)
                        Text("Trip Readiness")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(textMuted)
                    }
                    
                    Spacer()
                    
                    Text("82% Complete")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundColor(skyBlue)
                }
                
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(surfaceContainerHigh)
                            .frame(height: 5)
                        
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [skyBlue, primaryCyan],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geo.size.width * 0.82, height: 5)
                            .shadow(color: skyBlue.opacity(0.3), radius: 4)
                    }
                }
                .frame(height: 5)
            }
            .padding(10)
            .background(surfaceContainerHigh.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
        .padding(14)
        .background(surfaceContainerLow)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(outlineVariant, lineWidth: 1)
        )
    }
    
    private var swissAlpsTripCard: some View {
        HStack(alignment: .top, spacing: 12) {
            // Thumbnail
            ZStack(alignment: .topLeading) {
                AsyncImage(url: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuDfnq4zsOxdYxZ4qnARy1jEAcwdHLisn51aHRqEKp-A8m42vSUvWWafUfwfUQcqISvH5RbKoKkYaAeIka9O1fI6k7ieL2Nx4M5NazliapL9PgB2y-_cl81mnjh_zKMv4YfLe6_typ6BlrXT61YEU1DuIvSeHJbgduhVgWQIeOgBMAgsyeRN3tk9pfkv6VspNR1B5SOFgTt4KYhnzxUMzcOrO4einUTDFbzYX2iHB1uL00M1CTCXvHR1-Q")) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        Rectangle().fill(surfaceContainerHigh)
                    }
                }
                .frame(width: 90, height: 90)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                
                Text("DEC '26")
                    .font(.system(size: 9, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2.5)
                    .background(Color.black.opacity(0.8))
                    .clipShape(Capsule())
                    .padding(5)
            }
            .frame(width: 90, height: 90)
            
            // Details
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Swiss Alps Escape ❄️")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(textOnSurface)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text("Planning")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(textMuted)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 2.5)
                        .background(surfaceContainerHigh)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(outlineVariant, lineWidth: 0.8)
                        )
                }
                
                Text("Dec 18 – 26, 2026 • 9 Days")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(textMuted)
                
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 5) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(primaryCyan)
                        Text("Zermatt Ski Pass linked")
                            .font(.system(size: 11))
                            .foregroundColor(textOnSurface)
                    }
                    
                    HStack(spacing: 5) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 9))
                            .foregroundColor(skyBlue)
                        Text("Glacier Express pending")
                            .font(.system(size: 11))
                            .foregroundColor(textMuted)
                    }
                }
                .padding(.top, 4)
            }
        }
        .padding(14)
        .background(surfaceContainerLow)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(outlineVariant, lineWidth: 1)
        )
    }
    
    // MARK: - Section 3: AI Trip Drafts & Inspirations
    private var aiDraftsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header Row
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(primaryCyan)
                        .shadow(color: primaryCyan, radius: 4)
                    
                    Text("AI Drafts & Inspirations")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(textOnSurface)
                }
                
                Spacer()
                
                Text("1 ACTIVE PROPOSAL")
                    .font(.system(size: 10.5, weight: .bold, design: .rounded))
                    .foregroundColor(primaryCyan)
                    .tracking(0.8)
            }
            
            // AI Draft Card
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top) {
                    HStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(primaryCyan.opacity(0.15))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Circle()
                                        .stroke(primaryCyan.opacity(0.35), lineWidth: 1)
                                )
                                .shadow(color: primaryCyan.opacity(0.2), radius: 6)
                            
                            Image(systemName: "wand.and.stars")
                                .font(.system(size: 18))
                                .foregroundColor(primaryCyan)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Scottish Highlands 🏴󠁧󠁢󠁳󠁣󠁴󠁿")
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .foregroundColor(textOnSurface)
                            
                            Text("Drafted yesterday with AI Pilot • 5 Days")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(textMuted)
                        }
                    }
                    
                    Spacer()
                    
                    Circle()
                        .fill(primaryCyan)
                        .frame(width: 8, height: 8)
                        .shadow(color: primaryCyan, radius: 4)
                }
                
                // Quote summary card
                Text("\"Scenic road trip from Edinburgh to Isle of Skye featuring historic castle stays, whisky distillery tastings, and loch viewpoint hikes.\"")
                    .font(.system(size: 12, weight: .regular))
                    .italic()
                    .foregroundColor(textOnSurface)
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(surfaceContainerLowest.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(outlineVariant, lineWidth: 0.8)
                    )
                
                // Bottom Action Row
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 11))
                            .foregroundColor(textMuted)
                        Text("EST. £1,450 TOTAL")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(textMuted)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        triggerNotice("🤖 Opening AI Itinerary Studio for Scottish Highlands")
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "square.and.pencil")
                                .font(.system(size: 13, weight: .bold))
                            Text("Resume Builder")
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                        }
                        .foregroundColor(Color(red: 0/255, green: 73/255, blue: 101/255))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(skyBlue)
                        .clipShape(Capsule())
                        .shadow(color: skyBlue.opacity(0.3), radius: 8, y: 2)
                    }
                }
            }
            .padding(14)
            .background(surfaceContainerLow)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(primaryCyan.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: primaryCyan.opacity(0.1), radius: 12)
        }
    }
    
    // MARK: - Plan New Journey Primary Button
    private var planNewJourneyButton: some View {
        Button(action: {
            showPlanJourneySheet = true
        }) {
            HStack(spacing: 8) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 18, weight: .bold))
                Text("Plan New Journey")
                    .font(.system(size: 15, weight: .bold, design: .rounded))
            }
            .foregroundColor(Color(red: 0/255, green: 73/255, blue: 101/255))
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(
                LinearGradient(
                    colors: [secondaryMint, skyBlue, primaryCyan],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(Capsule())
            .shadow(color: skyBlue.opacity(0.35), radius: 14, y: 4)
        }
        .padding(.top, 4)
    }
    
    // MARK: - Helper Notification Banner
    private func triggerNotice(_ message: String) {
        withAnimation {
            activeNotice = message
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation {
                if activeNotice == message {
                    activeNotice = nil
                }
            }
        }
    }
    
    // MARK: - Sheets
    private var planNewJourneySheetView: some View {
        ZStack {
            darkBackground.ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Text("Plan New Journey")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(textOnSurface)
                    
                    Spacer()
                    
                    Button("Done") {
                        showPlanJourneySheet = false
                    }
                    .foregroundColor(skyBlue)
                    .font(.system(size: 15, weight: .bold))
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                VStack(spacing: 16) {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(skyBlue.opacity(0.15))
                                .frame(width: 44, height: 44)
                            Image(systemName: "sparkles")
                                .font(.system(size: 20))
                                .foregroundColor(skyBlue)
                        }
                        
                        VStack(alignment: .leading, spacing: 3) {
                            Text("AI Travel Assistant")
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            Text("Describe your dream destination and TripPilot will build your flights, hotels, and daily itinerary.")
                                .font(.system(size: 12))
                                .foregroundColor(textMuted)
                        }
                    }
                    .padding(14)
                    .background(surfaceContainerLow)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
        .presentationDetents([.medium])
    }
    
    private var itinerarySheetView: some View {
        ZStack {
            darkBackground.ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Text("Autumn in Japan 🍁 Itinerary")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(textOnSurface)
                    
                    Spacer()
                    
                    Button("Close") {
                        showItinerarySheet = false
                    }
                    .foregroundColor(skyBlue)
                    .font(.system(size: 15, weight: .bold))
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Day 3 • Tokyo → Kyoto")
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(primaryCyan)
                        
                        VStack(spacing: 8) {
                            itineraryRow(time: "10:30", title: "Flight JL 006 (SFO → HND)", status: "Completed")
                            itineraryRow(time: "14:10", title: "Shinkansen Nozomi 311 to Kyoto", status: "Boarding")
                            itineraryRow(time: "17:00", title: "Check-in at Hoshinoya Kyoto", status: "Confirmed")
                            itineraryRow(time: "19:30", title: "Gion Kaiseki Dinner Reservation", status: "Confirmed")
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                Spacer()
            }
        }
        .presentationDetents([.medium, .large])
    }
    
    private func itineraryRow(time: String, title: String, status: String) -> some View {
        HStack {
            Text(time)
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundColor(skyBlue)
                .frame(width: 45, alignment: .leading)
            
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(textOnSurface)
            
            Spacer()
            
            Text(status)
                .font(.system(size: 10, weight: .bold, design: .rounded))
                .foregroundColor(primaryCyan)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(primaryCyan.opacity(0.15))
                .clipShape(Capsule())
        }
        .padding(10)
        .background(surfaceContainerLow)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    NavigationStack {
        MyTripsHubView()
    }
}
