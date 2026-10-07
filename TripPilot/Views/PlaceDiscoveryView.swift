//
//  PlaceDiscoveryView.swift
//  TripPilot
//
//  Generated from Stitch Screen: 3528925142de42cda942075ba194dd05
//  Title: TripPilot - Place Directory & Discovery (Dark Mode)
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Enums & Models
enum PlaceCategory: String, CaseIterable, Identifiable {
    case all = "All Places"
    case mustSee = "Must-See (12)"
    case dining = "Michelin & Dining"
    case coffee = "Specialty Coffee"
    
    var id: String { rawValue }
    
    var iconName: String {
        switch self {
        case .all: return "safari.fill"
        case .mustSee: return "sparkles"
        case .dining: return "fork.knife"
        case .coffee: return "cup.and.saucer.fill"
        }
    }
}

struct EditorPickItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let description: String
    let distance: String
    let rating: String
    let reviewCount: String
    let priceOrEntry: String
    let badgeText: String
    let badgeIcon: String
    let badgeColor: Color
    let imageUrl: String
}

struct TrendingPlaceItem: Identifiable {
    let id = UUID()
    let title: String
    let categoryMatch: String
    let tags: [String]
    let statusText: String
    let distance: String
    let footerDetail: String
    let footerIcon: String
    let rating: String
    let buttonText: String
    let isPrimaryButton: Bool
    let imageUrl: String
}

struct SmartCollectionItem: Identifiable {
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
    
    // Stitch Theme Colors
    private let darkBackground = Color(red: 15/255, green: 19/255, blue: 28/255)            // #0f131c
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
    @State private var selectedTab: AppTab = .home
    @State private var selectedCategory: PlaceCategory = .all
    @State private var searchText: String = ""
    @State private var activeNotice: String? = nil
    @State private var isRadarPulsing: Bool = false
    @State private var bookmarkedPlaceIds: Set<UUID> = []
    @State private var addedPlaceTitles: Set<String> = []
    @State private var navigateToMap: Bool = false
    @State private var navigateToItinerary: Bool = false
    
    // Mock Data
    private let editorPicks: [EditorPickItem] = [
        EditorPickItem(
            title: "teamLab Borderless",
            subtitle: "Azabudai Hills",
            description: "Mind-bending multisensory digital art spaces without boundaries.",
            distance: "1.4 km • Azabudai",
            rating: "4.9",
            reviewCount: "(42k)",
            priceOrEntry: "$38 admission",
            badgeText: "AI Highlight",
            badgeIcon: "bolt.fill",
            badgeColor: Color(red: 56/255, green: 189/255, blue: 248/255),
            imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuDe1SiLAzdcRjLur_UMEGbVZ1ASmCKRi1S4GpJidcWLj_V5UbKJFArbFa7qGr6e2837M0RtyjoCCHn4ezun_P--bbAh-2MUt1M00Q84Pa9B6gvSk0SxttQcvRlKiOyF1aRL4waTa8xBs29REQhhY7KQ_Er_YT_aL05enhAqW270karOBxJXyoG9c4gQin-kgn_fiUCUu5ogTmE4TwBWo_GI_el1dqLo5ay4UARQR9AqXJEqfwt0ZsQyoQ"
        ),
        EditorPickItem(
            title: "Fushimi Inari Shrine",
            subtitle: "Kyoto Shinkansen",
            description: "Ten thousand vermilion torii paths traversing sacred Mount Inari.",
            distance: "2h 15m Express",
            rating: "4.9",
            reviewCount: "(118k)",
            priceOrEntry: "Free Entry",
            badgeText: "UNESCO Heritage",
            badgeIcon: "checkmark.seal.fill",
            badgeColor: Color(red: 68/255, green: 226/255, blue: 205/255),
            imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuAcpx7o21wfukCk9-cQQD65E29ExVt9rHgcs9eY_JRFTaoX_q-yt4RXLr-IV3JVtEJFd9TzJeH54v3ZRKhQfUwL2pagSfKq_3SM02wMxS3Z5uM5Ng4hdMcaxbanTdaFynWWoy7J6WE7v_SSar8xf4OVEy7N9-ej5Vpor2-68IhCFQs1fwotH3znBtLzZ4jgbIyAEOPcAsjErhteAj8fqV1kJi5zj3hNRcgNF3boyU3M3g2kDv37KRT5xw"
        )
    ]
    
    private let trendingPlaces: [TrendingPlaceItem] = [
        TrendingPlaceItem(
            title: "Meiji Jingu Forest Walk",
            categoryMatch: "98% Match",
            tags: ["Nature", "Peaceful", "Audio Guide"],
            statusText: "Low Crowds Now",
            distance: "850m away",
            footerDetail: "Closes at 18:30 • Free",
            footerIcon: "clock.fill",
            rating: "4.8",
            buttonText: "Add to Day",
            isPrimaryButton: true,
            imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuDPR7i3JuV6L2do4zIe46YokK98CjZJRHgZicFhUT4qiU44VQXRiP6FgQ0rG5ZbIgYSHfG14XCx6SrNw8E3x-zP0KYP5PXlq7B8qBFu4oW-QbVFqDQRaRlg3D-EO_pWToMuL8k-A5xRM547tvv1TF0MlcMubynl-05Q2P6Td7Ksq5Rbj2nAwFaQ8COwca_hGEeFglY_vrDS8rGpCrIbJVm73IEEFqMbk_nmxa69U0A6beqcQ5m2o37nPQ"
        ),
        TrendingPlaceItem(
            title: "Fuunji Tsukemen & Ramen",
            categoryMatch: "$$ • Ramen",
            tags: ["Local Favorite", "Craft Broth"],
            statusText: "Line: ~15 mins",
            distance: "1.8 km • Shinjuku",
            footerDetail: "Signature Special Dip Tsukemen",
            footerIcon: "hand.thumbsup.fill",
            rating: "4.8",
            buttonText: "Add to Day",
            isPrimaryButton: false,
            imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuDCfmAFZvQWrKlD3JQpqoWcoHcvLZ2lTZfDXpYJsDjiGR-48nj3xWtIpXSFAV9LuLhrsk2biqyBO71DG3AHDtOCdoVUMsOLzv5Q2ToJM2lR_IORIlTbZBLSvdc6CbFQ9dm1wgxEhFzAR9_-khFj0DhSMSzlM4sS82bPd9oF-SwVxihoHwMOVEj6jpPx7-buUb2hD1qCP0ZAjr14f3xV0FRL5B0v06tPu2TCC-kluxzyFW1Bi-lxPyNtUw"
        ),
        TrendingPlaceItem(
            title: "Shibuya Sky 360",
            categoryMatch: "47th Floor",
            tags: ["Golden Hour", "Panoramic"],
            statusText: "Sunset in 1h 40m",
            distance: "2.1 km • Shibuya",
            footerDetail: "$18 • Limited slots",
            footerIcon: "ticket.fill",
            rating: "4.9",
            buttonText: "Book Sunset Slot",
            isPrimaryButton: false,
            imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuCdQaiUW-xSHl8OJNlSD57ztLoJQjRgxXXgLifFoOsqlIktichYYz4Jc8qGN5JHIsFnRh_pixRzLvuFj-eYjDnelo8ly4M1BywNdazOy5fUnWfKanzBhF_R0KynhEaLYoudFK-ADO4wqWB4Pv0slNDqMZTqettZUQ2qJgM9yaXjrhizYE_rz0Kmx43ri8yvC6NlCtwWS8YImS541s68lrc8nHU4tRZ7TMVqXyXhAXk7amxz_H3aIGb7HQ"
        )
    ]
    
    private let smartCollections: [SmartCollectionItem] = [
        SmartCollectionItem(
            title: "Hidden Tokyo Speakeasies",
            tag: "Nightlife",
            tagColor: Color(red: 68/255, green: 226/255, blue: 205/255),
            subtitle: "8 secret doors",
            iconName: "lock.fill",
            imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuCyNFkmOsPzUrvcQti6M1X6vXoN3ElIi6TgOzSOKAk-E8l4emX2bV7Kw5YKHaYJnBoYMf6t6-k1Ti3OpHxA0EwLcEVIwjSyqOCEQrtJnsE0P3KoCjT3Z3YgowsQy_tmOTNkrj90rn__yUvtgwkw7e05PMKSp75Ffwnfkjjk7TdHQDvzoVdCrzh13DM3D6jBXpWWN8cABhuMZ28iFhlW4ysr7R_MF5SxzIZ-j_BpHU7m_AEKvQir7kvW7g"
        ),
        SmartCollectionItem(
            title: "Traditional Tea Houses",
            tag: "Zen Retreats",
            tagColor: Color(red: 123/255, green: 180/255, blue: 255/255),
            subtitle: "12 tranquil spots",
            iconName: "leaf.fill",
            imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuAQslxrR65SvOmsvu62V0TSkB0jTl257qvW96SMptI2vn3j0sgi_RPiiNwppvr4sJIicU10zOKlhXN9DCF8i_xW9ZMicjz_j2FqxTyJ-nhKl66txGjWw28Dgd88kl95F4rWOXHoVL4BsftZ5E1_zMc_gl9IBUneOAJjS4Qmvv4UXG6ce1rsYBYdYESuZF0fN2ciG7nQwS5GUHcyg8dpc9P0jc_BgMmMxHSX8UWQOtYoNeqIBKGvk5yWLA"
        )
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background
            darkBackground
                .ignoresSafeArea()
                
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
                
                // Main Scrollable Content
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 22) {
                        // Section 1: Header Bar & Search Controls
                        headerSearchSection
                            .padding(.top, 16)
                        
                        // Section 2: Horizontal Category Filter Chips
                        categoryFilterChipsSection
                        
                        // Section 3: Curated Editor's Picks (Carousel)
                        editorsPicksSection
                        
                        // Section 4: Trending Nearby (Live Radar)
                        trendingNearbySection
                        
                        // Section 5: Interactive Map Preview Callout
                        mapPreviewCalloutSection
                        
                        // Section 6: Smart Collections (2-Column Grid)
                        smartCollectionsSection
                        
                        // Spacing for floating tab bar
                        Spacer()
                            .frame(height: 120)
                    }
                    .frame(width: UIScreen.main.bounds.width - 36, alignment: .leading)
                    .padding(.horizontal, 18)
                    .padding(.top, 64) // Offset for fixed top bar
                }
                .frame(width: UIScreen.main.bounds.width)
                
                // Fixed Header Bar (Top)
                VStack(spacing: 0) {
                    fixedTopHeaderBar
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width)
                .ignoresSafeArea(edges: .top)
                
                // Shared Floating Glassmorphic Bottom Navigation Bar
                FloatingBottomNavBar(selectedTab: $selectedTab) { tab in
                    if tab == .itinerary {
                        navigateToItinerary = true
                    } else if tab == .map {
                        navigateToMap = true
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
    
    // MARK: - Fixed Top Header Bar
    private var fixedTopHeaderBar: some View {
        HStack(spacing: 12) {
            // Brand Logo & Title
            HStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(primaryContainer.opacity(0.2))
                        .frame(width: 32, height: 32)
                    Image(systemName: "airplane")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(primaryContainer)
                }
                
                VStack(alignment: .leading, spacing: 1) {
                    Text("TripPilot")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(primaryCyan)
                    Text("Home")
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundColor(textOnSurfaceVariant)
                }
            }
            
            Spacer()
            
            // Notification Bell
            Button(action: {
                triggerNotice("All destination notifications updated")
            }) {
                Image(systemName: "bell.fill")
                    .font(.system(size: 16))
                    .foregroundColor(textOnSurfaceVariant)
                    .frame(width: 38, height: 38)
                    .background(surfaceContainerHigh.opacity(0.6))
                    .clipShape(Circle())
            }
            
            // User Avatar
            AsyncImage(url: URL(string: "https://lh3.googleusercontent.com/aida/AEtjO1WbNCRVng1YYoKMvCcv7D2q6xjo8UufqH4GP8FISueWQxMB9Gw3PJWicyoq-4uZkFQWwigSXwA1jR5Z9WtwEdXjqWMcsMX7wq5i0eTxZ-_JudPFbceomq4ajCyPSR2HjdYRg9ZIb3ABugIzUP4dcxPyooewc5gUssWJzR4XerrkrV8SwkooahwmPtFejGVSv_qRDn--hG98qJNkItO--8-vA_VJ7wfMS5W5v9nbFEUCToSdvl5JanjnU7pG")) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Circle().fill(surfaceContainerHigh)
                }
            }
            .frame(width: 32, height: 32)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(primaryContainer.opacity(0.4), lineWidth: 1.5)
            )
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
    
    // MARK: - Section 1: Header Search & Controls
    private var headerSearchSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(secondaryMint)
                            .frame(width: 6, height: 6)
                            .shadow(color: secondaryMint.opacity(0.8), radius: isRadarPulsing ? 4 : 2)
                        Text("TOKYO METRO PILOT")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .tracking(0.8)
                            .foregroundColor(secondaryMint)
                    }
                    
                    Text("Discover Places")
                        .font(.system(size: 28, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                // Toggle Map View button
                Button(action: {
                    navigateToMap = true
                }) {
                    Image(systemName: "map.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(primaryContainer)
                        .frame(width: 40, height: 40)
                        .background(surfaceContainerHigh)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(outlineVariant, lineWidth: 1)
                        )
                        .shadow(color: primaryContainer.opacity(0.2), radius: 6)
                }
            }
            
            // Search Bar
            HStack(spacing: 10) {
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 16))
                        .foregroundColor(textOnSurfaceVariant)
                    
                    TextField("Search shrines, ramen...", text: $searchText)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.white)
                    
                    Button(action: {
                        triggerNotice("Listening for place search...")
                    }) {
                        Image(systemName: "mic.fill")
                            .font(.system(size: 14))
                            .foregroundColor(textOnSurfaceVariant)
                    }
                }
                .padding(.horizontal, 14)
                .frame(height: 46)
                .background(surfaceContainerHigh)
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(outlineVariant, lineWidth: 1)
                )
                
                // Filter Settings Button
                Button(action: {
                    triggerNotice("Place discovery filters opened")
                }) {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(textOnSurface)
                        .frame(width: 46, height: 46)
                        .background(surfaceContainerHigh)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(outlineVariant, lineWidth: 1)
                        )
                }
            }
        }
    }
    
    // MARK: - Section 2: Horizontal Filter Chips
    private var categoryFilterChipsSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(PlaceCategory.allCases) { category in
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
        .frame(width: UIScreen.main.bounds.width - 36, alignment: .leading)
    }
    
    // MARK: - Section 3: Curated Editor's Picks
    private var editorsPicksSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(primaryContainer)
                    Text("Curated Editor's Picks")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text("2 of 8")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(textOnSurfaceVariant)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(editorPicks) { pick in
                        editorPickCard(pick)
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width - 36, alignment: .leading)
        }
    }
    
    private func editorPickCard(_ pick: EditorPickItem) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image Hero Container
            ZStack(alignment: .topTrailing) {
                ZStack(alignment: .bottomLeading) {
                    AsyncImage(url: URL(string: pick.imageUrl)) { phase in
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
                    
                    // Dark Gradient Overlay
                    LinearGradient(
                        colors: [surfaceContainerLow, surfaceContainerLow.opacity(0.2), Color.clear],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    
                    // Bottom Rating & Admission overlay
                    HStack {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 10))
                                .foregroundColor(Color(red: 251/255, green: 191/255, blue: 36/255))
                            Text(pick.rating)
                                .font(.system(size: 12, weight: .heavy, design: .rounded))
                                .foregroundColor(.white)
                            Text(pick.reviewCount)
                                .font(.system(size: 10))
                                .foregroundColor(textOnSurfaceVariant)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(surfaceContainerHigh.opacity(0.9))
                        .clipShape(Capsule())
                        
                        Spacer()
                        
                        Text(pick.priceOrEntry)
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(secondaryMint)
                            .padding(.horizontal, 9)
                            .padding(.vertical, 3)
                            .background(surfaceContainerHigh.opacity(0.9))
                            .clipShape(Capsule())
                    }
                    .padding(10)
                }
                
                // Top Badges & Bookmark Button
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: pick.badgeIcon)
                            .font(.system(size: 10, weight: .bold))
                        Text(pick.badgeText)
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(pick.badgeColor)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 4)
                    .background(surfaceContainerLowest.opacity(0.85))
                    .clipShape(Capsule())
                    
                    Spacer()
                    
                    Button(action: {
                        if bookmarkedPlaceIds.contains(pick.id) {
                            bookmarkedPlaceIds.remove(pick.id)
                            triggerNotice("Removed \(pick.title) from saved places")
                        } else {
                            bookmarkedPlaceIds.insert(pick.id)
                            triggerNotice("Saved \(pick.title) to Travel Vault")
                        }
                    }) {
                        Image(systemName: bookmarkedPlaceIds.contains(pick.id) ? "bookmark.fill" : "bookmark")
                            .font(.system(size: 14))
                            .foregroundColor(bookmarkedPlaceIds.contains(pick.id) ? primaryContainer : textOnSurface)
                            .frame(width: 32, height: 32)
                            .background(surfaceContainerLowest.opacity(0.75))
                            .clipShape(Circle())
                    }
                }
                .padding(10)
            }
            .frame(width: 300, height: 180)
            
            // Content Card Details
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: 3) {
                    HStack {
                        Text(pick.title)
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .lineLimit(1)
                        Spacer()
                        Text(pick.subtitle)
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundColor(textOnSurfaceVariant)
                    }
                    
                    Text(pick.description)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(textOnSurfaceVariant)
                        .lineLimit(1)
                }
                
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 11))
                            .foregroundColor(primaryContainer)
                        Text(pick.distance)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(textOnSurfaceVariant)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        if addedPlaceTitles.contains(pick.title) {
                            addedPlaceTitles.remove(pick.title)
                            triggerNotice("Removed from itinerary")
                        } else {
                            addedPlaceTitles.insert(pick.title)
                            triggerNotice("Added \(pick.title) to today's itinerary!")
                        }
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: addedPlaceTitles.contains(pick.title) ? "checkmark" : "plus")
                                .font(.system(size: 11, weight: .bold))
                            Text(addedPlaceTitles.contains(pick.title) ? "Added" : "Add to Day")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                        }
                        .foregroundColor(addedPlaceTitles.contains(pick.title) ? secondaryMint : primaryContainer)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(addedPlaceTitles.contains(pick.title) ? secondaryMint.opacity(0.2) : primaryContainer.opacity(0.18))
                        .clipShape(Capsule())
                    }
                }
            }
            .padding(12)
        }
        .frame(width: 300)
        .background(surfaceContainerLow)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18).stroke(outlineVariant, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.4), radius: 10, y: 4)
    }
    
    // MARK: - Section 4: Trending Nearby
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
                    
                    Text("Trending Nearby")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "dot.radiowaves.left.and.right")
                        .font(.system(size: 11))
                    Text("Live Radar Active")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                }
                .foregroundColor(secondaryMint)
                .padding(.horizontal, 9)
                .padding(.vertical, 4)
                .background(surfaceContainerHigh)
                .clipShape(Capsule())
            }
            
            // Vertical Cards Stack
            VStack(spacing: 12) {
                ForEach(trendingPlaces) { place in
                    trendingPlaceCard(place)
                }
            }
        }
    }
    
    private func trendingPlaceCard(_ place: TrendingPlaceItem) -> some View {
        VStack(spacing: 10) {
            HStack(spacing: 12) {
                // Square Thumbnail
                ZStack(alignment: .bottomLeading) {
                    AsyncImage(url: URL(string: place.imageUrl)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else {
                            Color.gray.opacity(0.3)
                        }
                    }
                    .frame(width: 90, height: 90)
                    .clipped()
                    
                    HStack(spacing: 3) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 8))
                            .foregroundColor(Color(red: 251/255, green: 191/255, blue: 36/255))
                        Text(place.rating)
                            .font(.system(size: 10, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(surfaceContainerLowest.opacity(0.85))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .padding(5)
                }
                .frame(width: 90, height: 90)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12).stroke(outlineVariant, lineWidth: 1)
                )
                
                // Info
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(place.title)
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .lineLimit(1)
                        Spacer()
                        Text(place.categoryMatch)
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(secondaryMint)
                    }
                    
                    // Tags row
                    HStack(spacing: 4) {
                        ForEach(place.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.system(size: 10, weight: .medium, design: .rounded))
                                .foregroundColor(textOnSurfaceVariant)
                                .padding(.horizontal, 7)
                                .padding(.vertical, 2)
                                .background(surfaceContainerHigh)
                                .clipShape(Capsule())
                        }
                    }
                    
                    // Status & Distance
                    HStack(spacing: 6) {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(secondaryMint)
                                .frame(width: 5, height: 5)
                            Text(place.statusText)
                                .font(.system(size: 11, weight: .semibold, design: .rounded))
                                .foregroundColor(secondaryMint)
                        }
                        
                        Text("•")
                            .foregroundColor(textOnSurfaceVariant)
                        
                        Text(place.distance)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(textOnSurfaceVariant)
                    }
                }
            }
            
            // Footer Action Row
            HStack {
                HStack(spacing: 5) {
                    Image(systemName: place.footerIcon)
                        .font(.system(size: 12))
                        .foregroundColor(primaryContainer)
                    Text(place.footerDetail)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(textOnSurfaceVariant)
                }
                
                Spacer()
                
                Button(action: {
                    if addedPlaceTitles.contains(place.title) {
                        addedPlaceTitles.remove(place.title)
                        triggerNotice("Removed from itinerary")
                    } else {
                        addedPlaceTitles.insert(place.title)
                        triggerNotice("Added \(place.title) to today's itinerary!")
                    }
                }) {
                    HStack(spacing: 5) {
                        Image(systemName: addedPlaceTitles.contains(place.title) ? "checkmark" : (place.isPrimaryButton ? "plus" : "arrow.right"))
                            .font(.system(size: 11, weight: .bold))
                        Text(addedPlaceTitles.contains(place.title) ? "Added" : place.buttonText)
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(
                        addedPlaceTitles.contains(place.title) ?
                        secondaryMint :
                        (place.isPrimaryButton ? Color(red: 0/255, green: 40/255, blue: 60/255) : primaryContainer)
                    )
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(
                        addedPlaceTitles.contains(place.title) ?
                        secondaryMint.opacity(0.2) :
                        (place.isPrimaryButton ? primaryContainer : surfaceContainerHigh)
                    )
                    .clipShape(Capsule())
                    .overlay(
                        Capsule().stroke(place.isPrimaryButton ? Color.clear : outlineVariant, lineWidth: 1)
                    )
                }
            }
        }
        .padding(12)
        .background(surfaceContainerLow)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16).stroke(outlineVariant, lineWidth: 1)
        )
    }
    
    // MARK: - Section 5: Interactive Map Preview Callout
    private var mapPreviewCalloutSection: some View {
        Button(action: {
            navigateToMap = true
        }) {
            ZStack(alignment: .bottomLeading) {
                // Background Night Map Texture
                AsyncImage(url: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuBUe5sSIREWsi9xl7WhG57VzPoa_1t5f-zLxT8JQdKE5djWuC-xvTT9dKHsMqdgBBl2F3U9owW5Apnd8_5kz0F6k23xOJhyRs9urJHBn4A7NrNYUeCFvIkH7fvzGe61QIC3z5H7MEKem6WOUBco8ViGzI453GaK1Cgfmj4xAXaXKHiWUVub1HDRfAynsaVYKBro6ZYHLcbyEEKX_h5FgaKQvq84y-mC3VFHYBis7xVWUYPYEvvQvLOqAw")) { phase in
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
                
                // Gradient Overlay
                LinearGradient(
                    colors: [surfaceContainerLow.opacity(0.95), surfaceContainerLow.opacity(0.4), Color.clear],
                    startPoint: .bottom,
                    endPoint: .top
                )
                
                // Details & Action
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        HStack(spacing: 5) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 12))
                                .foregroundColor(secondaryMint)
                            Text("18 saved pins nearby")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                                .foregroundColor(secondaryMint)
                        }
                        
                        Text("Explore Tokyo District Map")
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
                    .overlay(
                        Capsule().stroke(outlineVariant, lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.5), radius: 6)
                }
                .padding(14)
            }
            .frame(height: 130)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18).stroke(outlineVariant, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.4), radius: 10, y: 4)
        }
    }
    
    // MARK: - Section 6: Smart Collections
    private var smartCollectionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Smart Collections")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    triggerNotice("Viewing all 14 Smart Collections")
                }) {
                    HStack(spacing: 4) {
                        Text("See All (14)")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 11, weight: .bold))
                    }
                    .foregroundColor(primaryContainer)
                }
            }
            
            // 2-Column Grid
            HStack(spacing: 12) {
                ForEach(smartCollections) { item in
                    smartCollectionCard(item)
                }
            }
        }
    }
    
    private func smartCollectionCard(_ item: SmartCollectionItem) -> some View {
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
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(item.tagColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(surfaceContainerLowest.opacity(0.85))
                        .clipShape(Capsule())
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.title)
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                        
                        HStack(spacing: 4) {
                            Image(systemName: item.iconName)
                                .font(.system(size: 10))
                                .foregroundColor(item.tagColor)
                            Text(item.subtitle)
                                .font(.system(size: 11, weight: .medium, design: .rounded))
                                .foregroundColor(textOnSurfaceVariant)
                        }
                    }
                }
                .padding(10)
            }
            .frame(height: 160)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16).stroke(outlineVariant, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.5), radius: 8, y: 4)
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
