//
//  PastJourneysView.swift
//  TripPilot
//
//  Generated from Stitch Screen: 294b4de162394d7595302169ee012048
//  Title: TripPilot - Past Journeys (Dark Mode)
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct PastJourneysView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedSegment: MyTripsHubView.TripSegment
    @State private var searchText: String = ""
    @State private var selectedYearFilter: YearFilter = .allYears
    @State private var selectedTab: AppTab = .trips
    @State private var activeNotice: String? = nil
    @State private var showPassportSheet: Bool = false
    @State private var showStorySheet: Bool = false
    @State private var selectedStoryTitle: String = ""
    
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
    
    enum YearFilter: String, CaseIterable {
        case allYears = "All Years"
        case year2024 = "2024 (3)"
        case year2023 = "2023 (4)"
        case year2022 = "2022 (1)"
        case favorites = "Favorites"
    }
    
    init(selectedSegment: Binding<MyTripsHubView.TripSegment> = .constant(.pastJourneys)) {
        self._selectedSegment = selectedSegment
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background
            darkBackground
                .ignoresSafeArea()
            
            // Atmospheric Ambient Glows
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
                    // Header Bar
                    headerBarSection
                        .padding(.top, 8)
                    
                    // Search Bar
                    searchBarSection
                    
                    // Segmented Control Switcher
                    segmentedControlSection
                    
                    // Horizontal Year Filter Pills
                    yearFilterRibbon
                    
                    // Lifetime Travel Passport Card
                    passportCardSection
                    
                    // 2024 Archive Section
                    archive2024Section
                    
                    // 2023 Archive Section
                    archive2023Section
                    
                    // Annual Travel Scrapbook Module
                    scrapbookModuleSection
                    
                    // Bottom Spacing for Floating Tab Bar
                    Spacer()
                        .frame(height: 110)
                }
                .padding(.horizontal, 18)
            }
            
            // Floating Glassmorphic Bottom Navigation Bar
            FloatingBottomNavBar(selectedTab: $selectedTab) { tab in
                if tab == .home {
                    dismiss()
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 8)
        }
        .navigationBarBackButtonHidden(true)
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showPassportSheet) {
            passportDetailSheet
        }
        .sheet(isPresented: $showStorySheet) {
            reliveStorySheet
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
                    
                    Image(systemName: "photo.stack.fill")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 1) {
                    Text("TripPilot")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(textOnSurface)
                    
                    Text("PAST JOURNEYS (8)")
                        .font(.system(size: 9.5, weight: .bold, design: .rounded))
                        .foregroundColor(primaryCyan)
                        .tracking(1.0)
                }
            }
            
            Spacer()
            
            // Search button and profile avatar
            HStack(spacing: 10) {
                Button(action: {
                    triggerNotice("🔍 Search Past Journeys")
                }) {
                    ZStack {
                        Circle()
                            .fill(surfaceContainerLow)
                            .frame(width: 38, height: 38)
                            .overlay(
                                Circle()
                                    .stroke(outlineVariant, lineWidth: 1)
                            )
                        
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 14))
                            .foregroundColor(textOnSurface)
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
    
    // MARK: - Search Bar Section
    private var searchBarSection: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(textMuted)
            
            TextField("Search memories, places, dates...", text: $searchText)
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
    }
    
    // MARK: - Segmented Navigation Switcher
    private var segmentedControlSection: some View {
        HStack(spacing: 0) {
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                    selectedSegment = .activeAndUpcoming
                }
            }) {
                Text("Active & Upcoming (3)")
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
                HStack(spacing: 5) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 12))
                        .foregroundColor(primaryCyan)
                    
                    Text("Past Journeys (8)")
                        .font(.system(size: 13, weight: selectedSegment == .pastJourneys ? .semibold : .medium, design: .rounded))
                }
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
    
    // MARK: - Year Filter Ribbon
    private var yearFilterRibbon: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(YearFilter.allCases, id: \.self) { filter in
                    Button(action: {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                            selectedYearFilter = filter
                        }
                    }) {
                        HStack(spacing: 5) {
                            if filter == .favorites {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 11))
                                    .foregroundColor(primaryCyan)
                            }
                            
                            Text(filter.rawValue)
                                .font(.system(size: 12, weight: selectedYearFilter == filter ? .bold : .medium, design: .rounded))
                        }
                        .foregroundColor(selectedYearFilter == filter ? Color(red: 0/255, green: 73/255, blue: 101/255) : textMuted)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(
                            selectedYearFilter == filter ? skyBlue : surfaceContainerLow
                        )
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(selectedYearFilter == filter ? Color.clear : outlineVariant, lineWidth: 1)
                        )
                        .shadow(color: selectedYearFilter == filter ? skyBlue.opacity(0.3) : Color.clear, radius: 8, y: 2)
                    }
                }
            }
            .padding(.vertical, 2)
        }
    }
    
    // MARK: - Lifetime Travel Passport Card
    private var passportCardSection: some View {
        VStack(spacing: 14) {
            // Passport Card Header
            HStack {
                HStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(surfaceContainerHigh)
                            .frame(width: 36, height: 36)
                            .overlay(
                                Circle()
                                    .stroke(outlineVariant, lineWidth: 1)
                            )
                        
                        Image(systemName: "globe.americas.fill")
                            .font(.system(size: 18))
                            .foregroundColor(skyBlue)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Elena's Travel Passport")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(textOnSurface)
                        
                        Text("VOYAGER TIER • LEVEL 4")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundColor(primaryCyan)
                            .tracking(0.6)
                    }
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(secondaryMint.opacity(0.15))
                        .frame(width: 32, height: 32)
                        .overlay(
                            Circle()
                                .stroke(secondaryMint.opacity(0.3), lineWidth: 1)
                        )
                    
                    Image(systemName: "checkmark.shield.fill")
                        .font(.system(size: 15))
                        .foregroundColor(primaryCyan)
                }
            }
            
            // Passport Grid Stats (4 columns)
            HStack(spacing: 8) {
                passportStatBlock(value: "14", label: "Countries")
                passportStatBlock(value: "48", label: "Cities")
                passportStatBlock(value: "38.4k", label: "km Flown")
                passportStatBlock(value: "8", label: "Trips")
            }
            
            // Interactive Link
            HStack {
                Text("6 custom passport stamps earned")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(textMuted)
                
                Spacer()
                
                Button(action: {
                    showPassportSheet = true
                }) {
                    HStack(spacing: 4) {
                        Text("View Passport & Badges")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 11, weight: .bold))
                    }
                    .foregroundColor(skyBlue)
                }
            }
            .padding(.top, 2)
        }
        .padding(16)
        .background(surfaceContainerLow)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(outlineVariant, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.4), radius: 12, y: 4)
    }
    
    private func passportStatBlock(value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(skyBlue)
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(textMuted)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(surfaceContainer.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(outlineVariant, lineWidth: 0.6)
        )
    }
    
    // MARK: - 2024 Archive Section
    private var archive2024Section: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header Row
            HStack {
                HStack(spacing: 6) {
                    Circle()
                        .fill(skyBlue)
                        .frame(width: 6, height: 6)
                        .shadow(color: skyBlue, radius: 4)
                    
                    Text("2024 ARCHIVES • 3 JOURNEYS")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundColor(textMuted)
                        .tracking(0.6)
                }
                
                Spacer()
                
                Text("39 Days Away")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundColor(skyBlue)
            }
            .padding(.horizontal, 2)
            
            // Featured Card 1: Kyoto & Tokyo Blossom
            kyotoBlossomCard
            
            // Card 2: Nordic Auroras & Fjords
            nordicAurorasCard
        }
    }
    
    // Featured Card: Kyoto & Tokyo Blossom
    private var kyotoBlossomCard: some View {
        VStack(spacing: 0) {
            // Cover Image Canvas
            ZStack(alignment: .bottomLeading) {
                AsyncImage(url: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuDx_9tDMaMtfCCFfPDdDfY0nt3pFaLV51is_m3AI3_HvgLd_Ddjlv2VEZ19eCrjkg0JqrQsoc7CxAy4IwuBZYSWJYUn9KiBFFlQUYIECT3q06WMsZZnZbLQh8mBCDOQMy7zIUqrNrTlh-sNZ8PI2kEZANKpDQWTa-Ac0UrlMGGZL2kw0Zvk9c5QINOesa7XGcNbTOfk-0m_8YJHFArwT7SlkT69yaGSvAYd0-DIRizlTYLFp21WhPXDmQ")) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        Rectangle().fill(surfaceContainerHigh)
                    }
                }
                .frame(height: 180)
                .clipped()
                
                // Gradient Scrim Overlays
                LinearGradient(
                    colors: [Color.clear, surfaceContainerLow.opacity(0.6), surfaceContainerLow],
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                // Top Metadata Badges
                VStack {
                    HStack {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 10))
                                .foregroundColor(primaryCyan)
                            Text("Elena's Favorite")
                                .font(.system(size: 10, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                            Text("5.0")
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .foregroundColor(primaryCyan)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(surfaceContainerLowest.opacity(0.85))
                        .clipShape(Capsule())
                        .overlay(
                            Capsule().stroke(outlineVariant, lineWidth: 0.8)
                        )
                        
                        Spacer()
                        
                        Text("Mar 28 – Apr 10, 2024")
                            .font(.system(size: 10, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(surfaceContainerLowest.opacity(0.85))
                            .clipShape(Capsule())
                            .overlay(
                                Capsule().stroke(outlineVariant, lineWidth: 0.8)
                            )
                    }
                    .padding(12)
                    
                    Spacer()
                }
                
                // Destination Title
                VStack(alignment: .leading, spacing: 2) {
                    Text("JAPAN EXPEDITION")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(skyBlue)
                        .tracking(0.8)
                    
                    Text("Kyoto & Tokyo Blossom")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                .padding(14)
            }
            .frame(height: 180)
            
            // Details & Metrics
            VStack(spacing: 12) {
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "map.fill")
                            .font(.system(size: 11))
                            .foregroundColor(skyBlue)
                        Text("24 Spots Visited")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(textOnSurface)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "dollarsign.circle.fill")
                            .font(.system(size: 11))
                            .foregroundColor(primaryCyan)
                        Text("$3,420 Total")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(textOnSurface)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "photo.stack.fill")
                            .font(.system(size: 11))
                            .foregroundColor(Color(red: 175/255, green: 207/255, blue: 255/255))
                        Text("1,420 Media")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(textOnSurface)
                    }
                }
                
                // Companions Row
                HStack {
                    HStack(spacing: 6) {
                        HStack(spacing: -6) {
                            avatarLetter(letter: "E", bg: skyBlue)
                            avatarLetter(letter: "M", bg: primaryCyan)
                            avatarLetter(letter: "S", bg: Color.purple)
                        }
                        
                        Text("With Mark & Sophia")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(textMuted)
                    }
                    
                    Spacer()
                    
                    Text("14 Days")
                        .font(.system(size: 10.5, weight: .bold, design: .rounded))
                        .foregroundColor(textMuted)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(surfaceContainer)
                        .clipShape(Capsule())
                }
                
                // Action Buttons
                HStack(spacing: 8) {
                    Button(action: {
                        selectedStoryTitle = "Kyoto & Tokyo Blossom"
                        showStorySheet = true
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 13, weight: .bold))
                            Text("Relive Story")
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
                        triggerNotice("📋 Itinerary duplicated to Drafts!")
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "doc.on.doc.fill")
                                .font(.system(size: 12))
                                .foregroundColor(skyBlue)
                            Text("Rebook")
                                .font(.system(size: 12, weight: .semibold, design: .rounded))
                                .foregroundColor(textOnSurface)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(surfaceContainer)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule().stroke(outlineVariant, lineWidth: 1)
                        )
                    }
                }
            }
            .padding(14)
            .background(surfaceContainerLow)
        }
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(outlineVariant, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.4), radius: 10, y: 4)
    }
    
    // Card 2: Nordic Auroras & Fjords
    private var nordicAurorasCard: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                AsyncImage(url: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuDYVN5VMFiu8R_JPPRMTdqlPzUhQPZY7GdgWj2T_H7koFEvC-BSaEWPZ14M0-VKaYb4GsAHVFxGEYfgxJSXEfsa9aW_PvvyZv1D-qC-ReHy1dpi7eFKAg2LzfSKS7754cTGI3vpYTYs7Vz9i5D-u7BPf1Cjfd3tZ3rBJxY0WZcelCU2EE_Up-lh2EgR7HotRs2Eq9gin8XnWjzjSM59-pIPogbUkBIynUZahIm3Eq_rvcfRZD8ihUOKhw")) { phase in
                    if let image = phase.image {
                        image.resizable().aspectRatio(contentMode: .fill)
                    } else {
                        Rectangle().fill(surfaceContainerHigh)
                    }
                }
                .frame(height: 140)
                .clipped()
                
                LinearGradient(
                    colors: [Color.clear, surfaceContainerLow.opacity(0.6), surfaceContainerLow],
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                VStack {
                    HStack {
                        Text("Sub-zero Expedition")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundColor(primaryCyan)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3.5)
                            .background(surfaceContainerLowest.opacity(0.85))
                            .clipShape(Capsule())
                        
                        Spacer()
                        
                        Text("Jan 12 – Jan 22, 2024")
                            .font(.system(size: 10, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3.5)
                            .background(surfaceContainerLowest.opacity(0.85))
                            .clipShape(Capsule())
                    }
                    .padding(10)
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("NORWAY & ICELAND")
                        .font(.system(size: 9.5, weight: .bold, design: .rounded))
                        .foregroundColor(primaryCyan)
                        .tracking(0.8)
                    Text("Nordic Auroras & Fjords")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                .padding(12)
            }
            .frame(height: 140)
            
            VStack(alignment: .leading, spacing: 10) {
                // Highlight Tags
                HStack(spacing: 6) {
                    chipTag("Tromsø")
                    chipTag("Lofoten Islands")
                    chipTag("Reykjavik")
                    chipTag("16 Key Spots", textColor: skyBlue)
                }
                
                HStack {
                    HStack(spacing: 5) {
                        Image(systemName: "snowflake")
                            .font(.system(size: 12))
                            .foregroundColor(skyBlue)
                        Text("11 Days • Polar Circle Route")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(textMuted)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        selectedStoryTitle = "Nordic Auroras & Fjords"
                        showStorySheet = true
                    }) {
                        HStack(spacing: 3) {
                            Text("Recap & Journal")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                            Image(systemName: "chevron.right")
                                .font(.system(size: 9, weight: .bold))
                        }
                        .foregroundColor(skyBlue)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(surfaceContainer)
                        .clipShape(Capsule())
                    }
                }
            }
            .padding(12)
            .background(surfaceContainerLow)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(outlineVariant, lineWidth: 1)
        )
    }
    
    // MARK: - 2023 Archive Section
    private var archive2023Section: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 6) {
                    Circle()
                        .fill(primaryCyan)
                        .frame(width: 6, height: 6)
                        .shadow(color: primaryCyan, radius: 4)
                    
                    Text("2023 ARCHIVES • 4 JOURNEYS")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundColor(textMuted)
                        .tracking(0.6)
                }
                
                Spacer()
                
                Text("54 Days Away")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundColor(primaryCyan)
            }
            .padding(.horizontal, 2)
            
            // Card 3: Amalfi Coast & Sicily Discovery
            amalfi2023Card
            
            // Card 4: Patagonia Wild Trails
            patagoniaCard
        }
    }
    
    private var amalfi2023Card: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                AsyncImage(url: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuBxe5VwZ8zN1JaorxnnH0TTcR6H4wqZsCalfHHVP5_lW9LkoCMkaXKU20WXs7jx4onMD7DpNQVJ-mlf-l5HLzKwxxaUBm9KrXGsarWx9tcInNS5cYFwM-cHCZIgqxS1honnK3Q5p-qxC7ltZP9SqoyQ2-_fzpnnlTkKibv7zbVDyiPUeXARTJDsLQqPP9xtB5QlYa_qfZz3PCvw6WoH9fz9F8zI_MVlnXRBYn1mKbDCwNV7RNYyYXU1dA")) { phase in
                    if let image = phase.image {
                        image.resizable().aspectRatio(contentMode: .fill)
                    } else {
                        Rectangle().fill(surfaceContainerHigh)
                    }
                }
                .frame(height: 140)
                .clipped()
                
                LinearGradient(
                    colors: [Color.clear, surfaceContainerLow.opacity(0.6), surfaceContainerLow],
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                VStack {
                    HStack {
                        Text("Culinary & Coastal")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundColor(primaryCyan)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3.5)
                            .background(surfaceContainerLowest.opacity(0.85))
                            .clipShape(Capsule())
                        
                        Spacer()
                        
                        Text("Sep 04 – Sep 18, 2023")
                            .font(.system(size: 10, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3.5)
                            .background(surfaceContainerLowest.opacity(0.85))
                            .clipShape(Capsule())
                    }
                    .padding(10)
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("ITALY ODYSSEY")
                        .font(.system(size: 9.5, weight: .bold, design: .rounded))
                        .foregroundColor(skyBlue)
                        .tracking(0.8)
                    Text("Amalfi Coast & Sicily Discovery")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                .padding(12)
            }
            .frame(height: 140)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 6) {
                    chipTag("Positano")
                    chipTag("Capri")
                    chipTag("Taormina")
                    chipTag("31 Culinary Spots", textColor: primaryCyan)
                }
                
                HStack {
                    Text("15 Days • 890 Photos logged")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(textMuted)
                    
                    Spacer()
                    
                    Button(action: {
                        selectedStoryTitle = "Amalfi Coast & Sicily"
                        showStorySheet = true
                    }) {
                        HStack(spacing: 3) {
                            Text("View Notes")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                            Image(systemName: "chevron.right")
                                .font(.system(size: 9, weight: .bold))
                        }
                        .foregroundColor(skyBlue)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(surfaceContainer)
                        .clipShape(Capsule())
                    }
                }
            }
            .padding(12)
            .background(surfaceContainerLow)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(outlineVariant, lineWidth: 1)
        )
    }
    
    private var patagoniaCard: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                AsyncImage(url: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuArApXU8d731hjtrYjTOdHmTGdFmdtWQvCv8nINVMUrXEU9jGwjcQbBeQX6fmWUF7DTqBnuvStKqbCmwZ8d0VKorDW60n1RjU_iLD3ibO9Mmba_vIITo6NR4TBf8JWRTyX_lvpKPzzqYrLWJdNxhOdcit-F0fnF3p3aEMNuc6qeUr_Q50Z2MfjndH9QGMGCejmL2gD0IC8bLAI1H7yfz8dnZ09IxkrTzjpMOonMMFIzwfCst9tEMVEnXA")) { phase in
                    if let image = phase.image {
                        image.resizable().aspectRatio(contentMode: .fill)
                    } else {
                        Rectangle().fill(surfaceContainerHigh)
                    }
                }
                .frame(height: 140)
                .clipped()
                
                LinearGradient(
                    colors: [Color.clear, surfaceContainerLow.opacity(0.6), surfaceContainerLow],
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                VStack {
                    HStack {
                        Text("W-Trek Trekker")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundColor(skyBlue)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3.5)
                            .background(surfaceContainerLowest.opacity(0.85))
                            .clipShape(Capsule())
                        
                        Spacer()
                        
                        Text("Nov 02 – Nov 14, 2023")
                            .font(.system(size: 10, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3.5)
                            .background(surfaceContainerLowest.opacity(0.85))
                            .clipShape(Capsule())
                    }
                    .padding(10)
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("CHILE & ARGENTINA")
                        .font(.system(size: 9.5, weight: .bold, design: .rounded))
                        .foregroundColor(primaryCyan)
                        .tracking(0.8)
                    Text("Patagonia Wild Trails")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                .padding(12)
            }
            .frame(height: 140)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "figure.hiking")
                            .font(.system(size: 12))
                            .foregroundColor(primaryCyan)
                        Text("108 km Trekked")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(textOnSurface)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "mountain.2.fill")
                            .font(.system(size: 12))
                            .foregroundColor(skyBlue)
                        Text("Grade: Strenuous")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(textOnSurface)
                    }
                }
                
                HStack {
                    Text("13 Days • Campsite Lodging")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(textMuted)
                    
                    Spacer()
                    
                    Button(action: {
                        selectedStoryTitle = "Patagonia Wild Trails"
                        showStorySheet = true
                    }) {
                        HStack(spacing: 3) {
                            Text("Trip Recap")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                            Image(systemName: "chevron.right")
                                .font(.system(size: 9, weight: .bold))
                        }
                        .foregroundColor(skyBlue)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(surfaceContainer)
                        .clipShape(Capsule())
                    }
                }
            }
            .padding(12)
            .background(surfaceContainerLow)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(outlineVariant, lineWidth: 1)
        )
    }
    
    // MARK: - Annual Travel Scrapbook Module
    private var scrapbookModuleSection: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(surfaceContainerHigh)
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: "book.pages.fill")
                        .font(.system(size: 20))
                        .foregroundColor(skyBlue)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Annual Travel Scrapbook")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(textOnSurface)
                    Text("Generate a polished visual PDF or hardcover album.")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(textMuted)
                        .lineLimit(1)
                }
                
                Spacer()
            }
            
            // Collage Grid (4 photos)
            HStack(spacing: 6) {
                scrapbookImage("https://lh3.googleusercontent.com/aida-public/AB6AXuDjFOydDrlAhYr3A8Fgw1EJAbMZXBjUvSkLnW_VeKLeyTxa8vrqjlWaK3DqUBcL1krcvcmMyT_Ynqn4_XabJqIp_MHGWzsWF_Ebs1nPDgzYoUGjFoW5dgHkqFCgodbCVM6ZFyN94IqC5QIOHo6ZfsnoN2mzlibAUFHULcfbY7m9iACvI-2xvOKADjfXTLaLaGF1bu6hws4Z_t9l03zphp-lskWvI5h2H9wJtCR3JL__y4BV0U5nywQndQ")
                scrapbookImage("https://lh3.googleusercontent.com/aida-public/AB6AXuDQcUqfy3lokp7hg4_2_AA8TfyHI5Ueo9hrbBBYJfH7MbDkGgVEJDoUfZgK3GWzv-2wy85C1MB-z8zeW2S2KEh6LTwPM_UY0h3uC26_T16C7xpdU__Mf0IN4qnrZO62W1_tfjry9QrmkGy1wpAguObX83NXBssNpsdBfkxSWGUsVYiY4AG5oC-oTZogdhfd9Iucsx-0aRvu5FY7rSaj2s2rQZpWGjhCIveZLoofbNqek_iTlK6HvXe5uQ")
                scrapbookImage("https://lh3.googleusercontent.com/aida-public/AB6AXuDLtJaGyd7ABgGCySS4w7zOwax7c8hQuy_fqCM_0D8xjbs5ntGVAn7aqxJNARluTVrGkXEl-ngZqpg2S0hYM5B_l3pLjbQC-sfco84x4vl7kNJeY4WXg1glMSQ2sjjN2nyoSHyspTZmA1iREQZxANgcaMLPRRw15b7wdxiFk62pfW94H1RkHf6zM3i5FLeW0yOSr28UTI1EKlq6-iF-C9kw1w1sViMaCaHIsrbU8Cr26h0PZUMn0G6XPQ")
                
                // +1.8k Badge
                ZStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(surfaceContainerHigh)
                        .frame(height: 52)
                    Text("+1.8k")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(skyBlue)
                }
                .frame(maxWidth: .infinity)
            }
            
            // Export Buttons
            HStack(spacing: 8) {
                Button(action: {
                    triggerNotice("📖 Generating 2024 Travel Photobook PDF...")
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "square.and.arrow.up.fill")
                            .font(.system(size: 13, weight: .bold))
                        Text("Export 2024 Book (PDF)")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(Color(red: 0/255, green: 73/255, blue: 101/255))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 11)
                    .background(skyBlue)
                    .clipShape(Capsule())
                    .shadow(color: skyBlue.opacity(0.3), radius: 8, y: 2)
                }
                
                Button(action: {
                    triggerNotice("📤 Share Travel Memories link copied!")
                }) {
                    ZStack {
                        Circle()
                            .fill(surfaceContainerHigh)
                            .frame(width: 44, height: 44)
                            .overlay(
                                Circle().stroke(outlineVariant, lineWidth: 1)
                            )
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 15))
                            .foregroundColor(textOnSurface)
                    }
                }
            }
            .padding(.top, 2)
        }
        .padding(14)
        .background(surfaceContainer)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(outlineVariant, lineWidth: 1)
        )
    }
    
    private func scrapbookImage(_ urlString: String) -> some View {
        AsyncImage(url: URL(string: urlString)) { phase in
            if let image = phase.image {
                image.resizable().aspectRatio(contentMode: .fill)
            } else {
                Rectangle().fill(surfaceContainerHigh)
            }
        }
        .frame(height: 52)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
    
    private func avatarLetter(letter: String, bg: Color) -> some View {
        Text(letter)
            .font(.system(size: 10, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .frame(width: 22, height: 22)
            .background(bg)
            .clipShape(Circle())
            .overlay(Circle().stroke(surfaceContainerLow, lineWidth: 1.5))
    }
    
    private func chipTag(_ text: String, textColor: Color? = nil) -> some View {
        Text(text)
            .font(.system(size: 10, weight: .medium, design: .rounded))
            .foregroundColor(textColor ?? textMuted)
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .background(surfaceContainer)
            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
    }
    
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
    private var passportDetailSheet: some View {
        ZStack {
            darkBackground.ignoresSafeArea()
            VStack(spacing: 20) {
                HStack {
                    Text("Passport & Badges")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(textOnSurface)
                    Spacer()
                    Button("Done") { showPassportSheet = false }
                        .foregroundColor(skyBlue)
                        .font(.system(size: 15, weight: .bold))
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                VStack(spacing: 12) {
                    passportRow(country: "Japan 🇯🇵", stamps: "Tokyo, Kyoto, Hakone", date: "April 2024")
                    passportRow(country: "Norway 🇳🇴", stamps: "Tromsø, Lofoten", date: "January 2024")
                    passportRow(country: "Italy 🇮🇹", stamps: "Amalfi, Capri, Taormina", date: "September 2023")
                    passportRow(country: "Chile 🇨🇱", stamps: "Torres del Paine", date: "November 2023")
                }
                .padding(.horizontal, 20)
                Spacer()
            }
        }
        .presentationDetents([.medium])
    }
    
    private func passportRow(country: String, stamps: String, date: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(country)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                Text(stamps)
                    .font(.system(size: 12))
                    .foregroundColor(textMuted)
            }
            Spacer()
            Text(date)
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundColor(primaryCyan)
        }
        .padding(12)
        .background(surfaceContainerLow)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var reliveStorySheet: some View {
        ZStack {
            darkBackground.ignoresSafeArea()
            VStack(spacing: 20) {
                HStack {
                    Text(selectedStoryTitle)
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(textOnSurface)
                    Spacer()
                    Button("Close") { showStorySheet = false }
                        .foregroundColor(skyBlue)
                        .font(.system(size: 15, weight: .bold))
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                VStack(spacing: 14) {
                    Image(systemName: "film.stack")
                        .font(.system(size: 40))
                        .foregroundColor(skyBlue)
                        .padding(.top, 20)
                    
                    Text("AI Travel Memory Reel")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Compiled from 1,420 photos, restaurant check-ins, and geo-pins across your journey.")
                        .font(.system(size: 13))
                        .foregroundColor(textMuted)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
                Spacer()
            }
        }
        .presentationDetents([.medium])
    }
}

#Preview {
    NavigationStack {
        PastJourneysView(selectedSegment: .constant(.pastJourneys))
    }
}
