//
//  TripGeneratorWizardView.swift
//  TripPilot
//
//  Generated from Stitch Screen: 8d8a4efc2be2494cb71a61d7922d5b19
//  Title: TripPilot - Trip Generator Wizard (Dark Mode)
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Enums
enum CompanionType: String, CaseIterable, Identifiable {
    case solo = "Solo"
    case couple = "Couple (2)"
    case family = "Family (3+)"
    case friends = "Friends Group"
    
    var id: String { rawValue }
    
    var iconName: String {
        switch self {
        case .solo: return "person.fill"
        case .couple: return "person.2.fill"
        case .family: return "figure.2.and.child.holdinghands"
        case .friends: return "person.3.fill"
        }
    }
}

enum RhythmPace: String, CaseIterable, Identifiable {
    case relaxed = "Relaxed"
    case balanced = "Balanced"
    case intense = "Intense"
    
    var id: String { rawValue }
    
    var stopsDescription: String {
        switch self {
        case .relaxed: return "2-3 stops/day"
        case .balanced: return "4-5 stops/day"
        case .intense: return "Action-packed"
        }
    }
    
    var iconName: String {
        switch self {
        case .relaxed: return "sparkles"
        case .balanced: return "safari.fill"
        case .intense: return "bolt.fill"
        }
    }
}

enum BudgetTier: String, CaseIterable, Identifiable {
    case saver = "Smart Saver"
    case comfort = "Comfort Premium"
    case luxury = "Ultra Luxury"
    
    var id: String { rawValue }
    
    var subtitle: String {
        switch self {
        case .saver: return "Boutique hostels & local dining"
        case .comfort: return "Design hotels, Michelin Bib Gourmand, Shinkansen Green Car"
        case .luxury: return "5-star Onsen Ryokans, private guides"
        }
    }
    
    var pricePerDay: String {
        switch self {
        case .saver: return "$120"
        case .comfort: return "$280"
        case .luxury: return "$650+"
        }
    }
    
    var iconName: String {
        switch self {
        case .saver: return "banknote.fill"
        case .comfort: return "building.columns.fill"
        case .luxury: return "diamond.fill"
        }
    }
}

struct QuickDestination: Identifiable {
    let id = UUID()
    let name: String
    let flag: String
    let subtitle: String
    let season: String
    let seasonTag: String
}

// MARK: - Main View
struct TripGeneratorWizardView: View {
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
    @State private var selectedDestination: String = "Tokyo & Kyoto"
    @State private var destinationSubtitle: String = "Japan • Multi-City Transit (HSR)"
    @State private var destinationFlag: String = "🇯🇵"
    @State private var seasonText: String = "Autumn Foliage Peak Season"
    @State private var seasonBadge: String = "Koyo Nov Peak"
    
    @State private var travelDatesText: String = "Oct 24 - Nov 04, 2025"
    @State private var travelDurationText: String = "12 Days • 11 Nights"
    @State private var weatherSummary: String = "Mild & Crisp • 18°C"
    
    @State private var selectedCompanion: CompanionType = .couple
    @State private var selectedPace: RhythmPace = .balanced
    @State private var selectedBudget: BudgetTier = .comfort
    
    @State private var selectedTags: [String] = [
        "🍜 Food & Street Eats",
        "⛩️ Historic Shrines",
        "📸 Photography",
        "☕ Specialty Cafes",
        "🌿 Nature & Onsens"
    ]
    @State private var availableTags: [String] = [
        "🛍️ Vintage Thrift",
        "🎨 Contemporary Art",
        "🍸 Hidden Speakeasies",
        "🌸 Sakura Gardens",
        "🏯 Samurai Heritage"
    ]
    
    @State private var showEditDatesSheet: Bool = false
    @State private var showTuneSheet: Bool = false
    @State private var isGenerating: Bool = false
    @State private var generationProgress: Double = 0.0
    @State private var generationStage: String = "Analyzing destination DNA..."
    @State private var navigateToDailyItinerary: Bool = false
    @State private var activeToast: String? = nil
    @State private var isAiPulsing: Bool = false
    
    // Quick suggestion destinations
    private let quickSuggestions: [QuickDestination] = [
        QuickDestination(name: "Paris", flag: "🇫🇷", subtitle: "France • Romance & Cafés", season: "Mild Autumn", seasonTag: "Oct-Nov Best"),
        QuickDestination(name: "Amalfi Coast", flag: "🇮🇹", subtitle: "Italy • Cliffside Escapes", season: "Shoulder Season Sun", seasonTag: "Crisp Views"),
        QuickDestination(name: "Reykjavik", flag: "🇮🇸", subtitle: "Iceland • Northern Lights", season: "Aurora Borealis Season", seasonTag: "Peak Aurora"),
        QuickDestination(name: "New York", flag: "🇺🇸", subtitle: "USA • Broadway & Skyline", season: "Fall Foliage in Central Park", seasonTag: "Crisp Fall")
    ]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                // Background
                darkBackground
                    .ignoresSafeArea()
                
                // Ambient Radial Glows
                GeometryReader { _ in
                    Circle()
                        .fill(primaryContainer.opacity(0.08))
                        .frame(width: 380, height: 380)
                        .blur(radius: 90)
                        .offset(x: -80, y: -60)
                    
                    Circle()
                        .fill(secondaryMint.opacity(0.06))
                        .frame(width: 320, height: 320)
                        .blur(radius: 80)
                        .offset(x: 160, y: 350)
                }
                .ignoresSafeArea()
                
                // Main Scrollable Form
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        // Section 0: Step Indicator & Title
                        topStepHeaderSection
                        
                        // Section 1: Target Destination
                        destinationSection
                        
                        // Section 2: Travel Window & Weather
                        datesAndWeatherSection
                        
                        // Section 3: Travel Companions & Pace
                        companionsAndPaceSection
                        
                        // Section 4: Budget Profile
                        budgetSection
                        
                        // Section 5: Travel Vibes & Interests
                        vibesAndInterestsSection
                        
                        // Bottom spacer for sticky action bar
                        Spacer()
                            .frame(height: 140)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 76) // Space for fixed header
                }
                
                // Fixed Header Bar (Top)
                VStack(spacing: 0) {
                    headerBarSection
                    Spacer()
                }
                .ignoresSafeArea(edges: .top)
                
                // Fixed Bottom Action Bar
                stickyBottomActionBar
            }
            .navigationBarBackButtonHidden(true)
            .preferredColorScheme(.dark)
            .navigationDestination(isPresented: $navigateToDailyItinerary) {
                DailyItineraryView()
            }
            .sheet(isPresented: $showEditDatesSheet) {
                editDatesSheetView
            }
            .sheet(isPresented: $showTuneSheet) {
                tuneDestinationSheetView
            }
            .overlay {
                if isGenerating {
                    aiGeneratingOverlayView
                }
            }
            .overlay(alignment: .top) {
                if let toast = activeToast {
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
                withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                    isAiPulsing = true
                }
            }
        }
    }
    
    // MARK: - Header Bar Section (Fixed Top)
    private var headerBarSection: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                // Close button
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(textOnSurface)
                        .frame(width: 40, height: 40)
                        .background(surfaceContainerHigh.opacity(0.6))
                        .clipShape(Circle())
                }
                
                // Brand logo & Title
                HStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(primaryContainer.opacity(0.25))
                            .frame(width: 30, height: 30)
                        Image(systemName: "airplane")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(primaryContainer)
                    }
                    
                    Text("Trip Generator")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                // Save Draft Button
                Button(action: {
                    triggerToast("Draft saved to TripPilot Cloud")
                }) {
                    Text("Save Draft")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(textOnSurfaceVariant)
                        .padding(.horizontal, 8)
                }
                
                // User Profile Avatar
                AsyncImage(url: URL(string: "https://lh3.googleusercontent.com/aida/AEtjO1VG20ezXOFcscUPX5J7lUFzSYH2YKZ90oH7xJub8CsIfL_lM7zNOwOH3bHTteMEpXi3kxGlLn1ENRaUfiw5SuQaIMzalnWhFcG_80hdjDljdrld0USRi6S_nu1Fsc6WbOS2U3KSbzqrS_mfZUbfDu45b6tWEMW3xH9WaypWg15TlwDzyJdZaT_zC-ETJgRiAsDmc2y8yq8cw4yA3Fikc0zkiThcW0sxug3iinQ4RJT45vU4jj9cgrWaNQzm")) { phase in
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
                    Circle().stroke(primaryContainer.opacity(0.5), lineWidth: 1.5)
                )
            }
            .padding(.horizontal, 16)
            .padding(.top, 50)
            .padding(.bottom, 10)
            
            // Progress Bar (Step 2 of 4 -> 50%)
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(surfaceContainerHigh.opacity(0.8))
                        .frame(height: 3)
                    
                    Capsule()
                        .fill(primaryContainer)
                        .frame(width: geo.size.width * 0.5, height: 3)
                        .shadow(color: primaryContainer.opacity(0.8), radius: 6)
                }
            }
            .frame(height: 3)
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
        }
        .background(
            surfaceContainerLowest.opacity(0.95)
                .background(.ultraThinMaterial)
        )
        .overlay(alignment: .bottom) {
            Divider().background(outlineVariant)
        }
    }
    
    // MARK: - Top Step Header Section
    private var topStepHeaderSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Badges row
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(primaryContainer)
                    Text("STEP 2 OF 4 • TRIP DNA")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .tracking(0.8)
                        .foregroundColor(primaryContainer)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 5)
                .background(surfaceContainerHigh)
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(outlineVariant, lineWidth: 1)
                )
                
                Spacer()
                
                // AI Engine Ready
                HStack(spacing: 6) {
                    Circle()
                        .fill(secondaryMint)
                        .frame(width: 7, height: 7)
                        .shadow(color: secondaryMint.opacity(0.8), radius: isAiPulsing ? 5 : 2)
                        .scaleEffect(isAiPulsing ? 1.2 : 0.9)
                    Text("AI Engine Ready")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundColor(secondaryMint)
                }
            }
            
            // Title & Subtitle
            Text("Where are we flying, Elena?")
                .font(.system(size: 26, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
                .padding(.top, 4)
            
            Text("Let AI craft your custom day-by-day itinerary in seconds.")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(textOnSurfaceVariant)
        }
    }
    
    // MARK: - Section 1: Target Destination
    private var destinationSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Section Label
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "airplane.departure")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(primaryContainer)
                    Text("Target Destination")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text("HIGH MATCH")
                    .font(.system(size: 11, weight: .heavy, design: .rounded))
                    .tracking(0.6)
                    .foregroundColor(secondaryMint)
            }
            
            // Main Destination Card
            VStack(spacing: 14) {
                // Destination Row
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(surfaceContainerHigh)
                            .frame(width: 48, height: 48)
                            .overlay(
                                Circle().stroke(outlineVariant, lineWidth: 1)
                            )
                        Text(destinationFlag)
                            .font(.system(size: 24))
                    }
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text(selectedDestination)
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        Text(destinationSubtitle)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(textOnSurfaceVariant)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showTuneSheet = true
                    }) {
                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(textOnSurfaceVariant)
                            .frame(width: 38, height: 38)
                            .background(surfaceContainerHigh.opacity(0.8))
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(outlineVariant, lineWidth: 1)
                            )
                    }
                }
                
                // Season Match Micro-Pill
                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(secondaryMint)
                        Text(seasonText)
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundColor(textOnSurface)
                    }
                    
                    Spacer()
                    
                    Text(seasonBadge)
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundColor(secondaryMint)
                        .padding(.horizontal, 9)
                        .padding(.vertical, 3)
                        .background(secondaryMint.opacity(0.15))
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(surfaceContainer)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12).stroke(outlineVariant, lineWidth: 1)
                )
                
                // Destination Discovery Visual Strip
                HStack(spacing: 10) {
                    // Photo 1: Tokyo Pagoda
                    ZStack(alignment: .bottomLeading) {
                        AsyncImage(url: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuCrQTcPiDbYUvAVVwmrM19ubJHwtODGFMAL9b0YlRpZmxh75ZIY9eYHnn6MulTbcu7wFHCLX3zgKUoOqDywdFsKdGll8eIOGxk3ONR3XmK1uhNNkHq2P4w_Yya4GUw7czqkdDJLfMHa03vqpx1Psngp8Bx_Qj8EKtvHC3kUBhWfnqMtjry7aKsidJIvN4oe2_7XM0IjIxPmOBvJCTDohM8EOj5C5SxVWlSnVld9sul4SNq0GJvz7TuWsQ")) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } else {
                                Color.gray.opacity(0.3)
                            }
                        }
                        .frame(height: 96)
                        .clipped()
                        
                        LinearGradient(
                            colors: [Color.black.opacity(0.85), Color.black.opacity(0.2), Color.clear],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                        
                        Text("Shinjuku Gyoen & Shibuya")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                            .padding(8)
                    }
                    .frame(height: 96)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12).stroke(outlineVariant, lineWidth: 1)
                    )
                    
                    // Photo 2: Kyoto Bamboo Walkway
                    ZStack(alignment: .bottomLeading) {
                        AsyncImage(url: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuBqvnS2K6teESPcYvg5Aoxxb0zeWogwCUFiW-tJ3wULsjQCg5d4fojDC_X0JF-TVpJ-R-Jy-OPZA3Ht2B1KpzIqXST0R_59v2k3zCfFrAyQIMGyc8L7ogOfkTG9MVp3SNIq2FdJcytkn-AHch1TTwkWODkpIoV8MwpT6wpvUyJaTjdkUSlsfCaWhVq-D7u7vP4vehQkh6K5UCHd1jd_MeenwHoxdo68IFWdnzCG9ekyFwR960a007D-gg")) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } else {
                                Color.gray.opacity(0.3)
                            }
                        }
                        .frame(height: 96)
                        .clipped()
                        
                        LinearGradient(
                            colors: [Color.black.opacity(0.85), Color.black.opacity(0.2), Color.clear],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                        
                        Text("Gion & Arashiyama Paths")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                            .padding(8)
                    }
                    .frame(height: 96)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12).stroke(outlineVariant, lineWidth: 1)
                    )
                }
                
                // Quick Suggestion Chips
                VStack(alignment: .leading, spacing: 6) {
                    Text("QUICK SUGGESTIONS")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(textOnSurfaceVariant.opacity(0.7))
                        .tracking(0.8)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(quickSuggestions) { item in
                                Button(action: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedDestination = item.name
                                        destinationFlag = item.flag
                                        destinationSubtitle = item.subtitle
                                        seasonText = item.season
                                        seasonBadge = item.seasonTag
                                    }
                                    triggerToast("Destination set to \(item.name) \(item.flag)")
                                }) {
                                    HStack(spacing: 5) {
                                        Text(item.name)
                                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                                        Text(item.flag)
                                    }
                                    .foregroundColor(selectedDestination == item.name ? primaryContainer : textOnSurface)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 7)
                                    .background(selectedDestination == item.name ? surfaceContainerHighest : surfaceContainer)
                                    .clipShape(Capsule())
                                    .overlay(
                                        Capsule().stroke(selectedDestination == item.name ? primaryContainer.opacity(0.6) : outlineVariant, lineWidth: 1)
                                    )
                                }
                            }
                        }
                    }
                }
                .padding(.top, 2)
            }
            .padding(16)
            .background(surfaceContainerLow)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20).stroke(outlineVariant, lineWidth: 1)
            )
        }
    }
    
    // MARK: - Section 2: Travel Window & Weather
    private var datesAndWeatherSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: "calendar")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(primaryContainer)
                Text("Travel Window & Weather")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 12) {
                // Dates Row
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(primaryContainer.opacity(0.15))
                            .frame(width: 44, height: 44)
                            .overlay(
                                Circle().stroke(primaryContainer.opacity(0.3), lineWidth: 1)
                            )
                        Image(systemName: "calendar.badge.clock")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(primaryContainer)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(travelDatesText)
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        Text(travelDurationText)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(textOnSurfaceVariant)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showEditDatesSheet = true
                    }) {
                        Text("Edit Dates")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundColor(primaryContainer)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 7)
                            .background(surfaceContainerHigh)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule().stroke(outlineVariant, lineWidth: 1)
                            )
                    }
                }
                
                // Weather Forecast Strip
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: "sun.max.fill")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(secondaryMint)
                        Text(weatherSummary)
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "drop.fill")
                            .font(.system(size: 13))
                            .foregroundColor(primaryContainer)
                        Text("Minimal Rain (~12%)")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(textOnSurfaceVariant)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(surfaceContainer)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12).stroke(outlineVariant, lineWidth: 1)
                )
            }
            .padding(16)
            .background(surfaceContainerLow)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20).stroke(outlineVariant, lineWidth: 1)
            )
        }
    }
    
    // MARK: - Section 3: Travel Party & Daily Pace
    private var companionsAndPaceSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            // Companions
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 6) {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(primaryContainer)
                    Text("Travel Companions")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                
                // Segmented 2x2 Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    ForEach(CompanionType.allCases) { companion in
                        Button(action: {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                                selectedCompanion = companion
                            }
                        }) {
                            HStack(spacing: 8) {
                                if selectedCompanion == companion {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(primaryContainer)
                                }
                                
                                Text(companion.rawValue)
                                    .font(.system(size: 13, weight: selectedCompanion == companion ? .bold : .medium, design: .rounded))
                                    .foregroundColor(selectedCompanion == companion ? primaryContainer : textOnSurfaceVariant)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(selectedCompanion == companion ? surfaceContainerHigh : surfaceContainerLowest)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(selectedCompanion == companion ? primaryContainer.opacity(0.6) : outlineVariant, lineWidth: selectedCompanion == companion ? 1.5 : 1)
                            )
                            .shadow(color: selectedCompanion == companion ? primaryContainer.opacity(0.2) : .clear, radius: 8)
                        }
                    }
                }
                .padding(6)
                .background(surfaceContainerLowest)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16).stroke(outlineVariant, lineWidth: 1)
                )
            }
            
            // Pace Selector
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: "gauge.with.dots.needle.50percent")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(primaryContainer)
                        Text("Daily Rhythm & Pace")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("Optimal Balance")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(primaryContainer)
                }
                
                HStack(spacing: 8) {
                    ForEach(RhythmPace.allCases) { pace in
                        Button(action: {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                                selectedPace = pace
                            }
                        }) {
                            ZStack(alignment: .top) {
                                VStack(spacing: 6) {
                                    Image(systemName: pace.iconName)
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(selectedPace == pace ? primaryContainer : textOnSurfaceVariant)
                                        .padding(.top, pace == .balanced ? 6 : 2)
                                    
                                    Text(pace.rawValue)
                                        .font(.system(size: 14, weight: selectedPace == pace ? .bold : .semibold, design: .rounded))
                                        .foregroundColor(selectedPace == pace ? .white : textOnSurfaceVariant)
                                    
                                    Text(pace.stopsDescription)
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundColor(selectedPace == pace ? primaryContainer : textOnSurfaceVariant.opacity(0.8))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    selectedPace == pace ?
                                    AnyView(
                                        LinearGradient(
                                            colors: [primaryContainer.opacity(0.2), primaryCyan.opacity(0.08)],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    ) :
                                    AnyView(surfaceContainerLow)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(selectedPace == pace ? primaryContainer : outlineVariant, lineWidth: selectedPace == pace ? 2 : 1)
                                )
                                .shadow(color: selectedPace == pace ? primaryContainer.opacity(0.3) : .clear, radius: 10)
                                
                                // Recommended badge for Balanced
                                if pace == .balanced {
                                    Text("RECOMMENDED")
                                        .font(.system(size: 8, weight: .heavy, design: .rounded))
                                        .tracking(0.6)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2.5)
                                        .background(secondaryContainer)
                                        .clipShape(Capsule())
                                        .offset(y: -7)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Section 4: Budget Profile
    private var budgetSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "banknote.fill")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(primaryContainer)
                    Text("Budget Profile")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text("Excl. international flights")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(textOnSurfaceVariant)
            }
            
            VStack(spacing: 10) {
                ForEach(BudgetTier.allCases) { tier in
                    Button(action: {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                            selectedBudget = tier
                        }
                    }) {
                        HStack(spacing: 12) {
                            // Left accent line if active
                            if selectedBudget == tier {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(primaryContainer)
                                    .frame(width: 4)
                                    .shadow(color: primaryContainer.opacity(0.8), radius: 4)
                            }
                            
                            // Icon in circle
                            ZStack {
                                Circle()
                                    .fill(selectedBudget == tier ? primaryContainer.opacity(0.2) : surfaceContainerHigh)
                                    .frame(width: 42, height: 42)
                                    .overlay(
                                        Circle().stroke(selectedBudget == tier ? primaryContainer.opacity(0.4) : outlineVariant, lineWidth: 1)
                                    )
                                Image(systemName: tier.iconName)
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(selectedBudget == tier ? primaryContainer : textOnSurfaceVariant)
                            }
                            
                            // Info
                            VStack(alignment: .leading, spacing: 3) {
                                HStack(spacing: 6) {
                                    Text(tier.rawValue)
                                        .font(.system(size: 15, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                    
                                    if tier == .comfort {
                                        Text("Elena's Choice")
                                            .font(.system(size: 10, weight: .heavy, design: .rounded))
                                            .foregroundColor(primaryContainer)
                                            .padding(.horizontal, 7)
                                            .padding(.vertical, 2)
                                            .background(primaryContainer.opacity(0.2))
                                            .clipShape(Capsule())
                                            .overlay(
                                                Capsule().stroke(primaryContainer.opacity(0.4), lineWidth: 0.8)
                                            )
                                    }
                                }
                                
                                Text(tier.subtitle)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(textOnSurfaceVariant)
                                    .lineLimit(1)
                            }
                            
                            Spacer()
                            
                            // Price
                            VStack(alignment: .trailing, spacing: 1) {
                                Text(tier.pricePerDay)
                                    .font(.system(size: 17, weight: .heavy, design: .rounded))
                                    .foregroundColor(selectedBudget == tier ? primaryContainer : .white)
                                Text("/day")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(textOnSurfaceVariant)
                            }
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 14)
                        .background(
                            selectedBudget == tier ?
                            AnyView(
                                LinearGradient(
                                    colors: [primaryContainer.opacity(0.14), surfaceContainerLow, surfaceContainerLow],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            ) :
                            AnyView(surfaceContainerLow)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(selectedBudget == tier ? primaryContainer.opacity(0.6) : outlineVariant, lineWidth: 1)
                        )
                        .shadow(color: selectedBudget == tier ? primaryContainer.opacity(0.18) : .clear, radius: 10)
                    }
                }
            }
        }
    }
    
    // MARK: - Section 5: Travel Vibes & Interests
    private var vibesAndInterestsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "paintpalette.fill")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(primaryContainer)
                    Text("Travel Vibes & Interests")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text("\(selectedTags.count) Selected")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(primaryContainer)
            }
            
            // Flow Tags
            FlowLayout(spacing: 8) {
                // Active Selected Tags (Removable)
                ForEach(selectedTags, id: \.self) { tag in
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTags.removeAll { $0 == tag }
                            availableTags.append(tag)
                        }
                    }) {
                        HStack(spacing: 6) {
                            Text(tag)
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                            Image(systemName: "xmark")
                                .font(.system(size: 11, weight: .bold))
                        }
                        .foregroundColor(Color(red: 0/255, green: 53/255, blue: 74/255))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 9)
                        .background(primaryContainer)
                        .clipShape(Capsule())
                        .shadow(color: primaryContainer.opacity(0.35), radius: 6)
                    }
                }
                
                // Available Suggestion Tags (Addable)
                ForEach(availableTags, id: \.self) { tag in
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            availableTags.removeAll { $0 == tag }
                            selectedTags.append(tag)
                        }
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "plus")
                                .font(.system(size: 11, weight: .bold))
                            Text(tag)
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                        }
                        .foregroundColor(textOnSurfaceVariant)
                        .padding(.horizontal, 13)
                        .padding(.vertical, 8)
                        .background(surfaceContainerHigh)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule().stroke(outlineVariant, lineWidth: 1)
                        )
                    }
                }
            }
        }
    }
    
    // MARK: - Sticky Bottom Action Bar
    private var stickyBottomActionBar: some View {
        VStack(spacing: 10) {
            // ETA Badge
            HStack(spacing: 6) {
                Image(systemName: "bolt.fill")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(secondaryMint)
                Text("AI generation takes ~8 seconds")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(textOnSurface)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(surfaceContainerHigh.opacity(0.8))
            .clipShape(Capsule())
            .overlay(
                Capsule().stroke(outlineVariant, lineWidth: 1)
            )
            
            // Primary Generate Button
            Button(action: {
                startAiGenerationSequence()
            }) {
                HStack(spacing: 10) {
                    Image(systemName: "wand.and.stars")
                        .font(.system(size: 20, weight: .bold))
                    Text("Generate Smart Itinerary")
                        .font(.system(size: 17, weight: .heavy, design: .rounded))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 16, weight: .bold))
                }
                .foregroundColor(Color(red: 0/255, green: 40/255, blue: 60/255))
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    LinearGradient(
                        colors: [primaryContainer, primaryCyan, secondaryMint],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(Capsule())
                .shadow(color: primaryContainer.opacity(0.5), radius: 16, y: 4)
            }
            .padding(.horizontal, 16)
        }
        .padding(.top, 12)
        .padding(.bottom, 24)
        .background(
            surfaceContainerLowest.opacity(0.96)
                .background(.ultraThinMaterial)
        )
        .overlay(alignment: .top) {
            Divider().background(outlineVariant)
        }
    }
    
    // MARK: - AI Generating Overlay
    private var aiGeneratingOverlayView: some View {
        ZStack {
            Color.black.opacity(0.85)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Pulsing glowing orb
                ZStack {
                    Circle()
                        .fill(primaryContainer.opacity(0.2))
                        .frame(width: 140, height: 140)
                        .blur(radius: 20)
                    
                    Circle()
                        .stroke(
                            AngularGradient(
                                colors: [primaryContainer, secondaryMint, skyBlue, primaryContainer],
                                center: .center
                            ),
                            lineWidth: 4
                        )
                        .frame(width: 100, height: 100)
                        .rotationEffect(.degrees(generationProgress * 360 * 3))
                    
                    Image(systemName: "sparkles")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(primaryContainer)
                }
                
                VStack(spacing: 8) {
                    Text("TripPilot AI Architect")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(generationStage)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(secondaryMint)
                        .multilineTextAlignment(.center)
                }
                
                // Progress Bar
                VStack(spacing: 6) {
                    ProgressView(value: generationProgress, total: 1.0)
                        .tint(primaryContainer)
                        .frame(width: 240)
                    
                    Text("\(Int(generationProgress * 100))%")
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(textOnSurfaceVariant)
                }
            }
            .padding(32)
            .background(surfaceContainerLow)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .overlay(
                RoundedRectangle(cornerRadius: 24).stroke(primaryContainer.opacity(0.4), lineWidth: 1)
            )
            .shadow(color: primaryContainer.opacity(0.3), radius: 24)
            .padding(24)
        }
    }
    
    // MARK: - Sheets
    private var editDatesSheetView: some View {
        NavigationStack {
            ZStack {
                darkBackground.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    HStack {
                        Text("Select Travel Window")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        Spacer()
                        Button("Done") {
                            showEditDatesSheet = false
                        }
                        .foregroundColor(primaryContainer)
                        .font(.system(size: 16, weight: .bold))
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Choose Departure & Return Dates")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(textOnSurfaceVariant)
                        
                        DatePicker("Start Date", selection: .constant(Date()), displayedComponents: .date)
                            .datePickerStyle(.graphical)
                            .tint(primaryContainer)
                            .colorScheme(.dark)
                            .padding()
                            .background(surfaceContainerLow)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
    
    private var tuneDestinationSheetView: some View {
        NavigationStack {
            ZStack {
                darkBackground.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    HStack {
                        Text("Customize Target Destination")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        Spacer()
                        Button("Done") {
                            showTuneSheet = false
                        }
                        .foregroundColor(primaryContainer)
                        .font(.system(size: 16, weight: .bold))
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    VStack(spacing: 12) {
                        ForEach(quickSuggestions) { dest in
                            Button(action: {
                                selectedDestination = dest.name
                                destinationFlag = dest.flag
                                destinationSubtitle = dest.subtitle
                                seasonText = dest.season
                                seasonBadge = dest.seasonTag
                                showTuneSheet = false
                            }) {
                                HStack(spacing: 12) {
                                    Text(dest.flag)
                                        .font(.system(size: 24))
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(dest.name)
                                            .font(.system(size: 16, weight: .bold, design: .rounded))
                                            .foregroundColor(.white)
                                        Text(dest.subtitle)
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(textOnSurfaceVariant)
                                    }
                                    Spacer()
                                    if selectedDestination == dest.name {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(primaryContainer)
                                            .font(.system(size: 14, weight: .bold))
                                    }
                                }
                                .padding()
                                .background(surfaceContainerLow)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(selectedDestination == dest.name ? primaryContainer : outlineVariant, lineWidth: 1)
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
        }
        .presentationDetents([.medium])
    }
    
    // MARK: - Actions
    private var skyBlue: Color {
        Color(red: 56/255, green: 189/255, blue: 248/255)
    }
    
    private func triggerToast(_ msg: String) {
        withAnimation {
            activeToast = msg
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation {
                if activeToast == msg {
                    activeToast = nil
                }
            }
        }
    }
    
    private func startAiGenerationSequence() {
        withAnimation {
            isGenerating = true
            generationProgress = 0.0
            generationStage = "Analyzing travel companions & vibe DNA..."
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { timer in
            if generationProgress < 0.3 {
                generationProgress += 0.1
                generationStage = "Querying live weather & peak foliage in \(selectedDestination)..."
            } else if generationProgress < 0.6 {
                generationProgress += 0.15
                generationStage = "Mapping Michelin spots & scenic walking hops..."
            } else if generationProgress < 0.9 {
                generationProgress += 0.15
                generationStage = "Generating Shinkansen schedules & booking references..."
            } else {
                timer.invalidate()
                generationProgress = 1.0
                generationStage = "Done! Opening Daily Itinerary..."
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    withAnimation {
                        isGenerating = false
                        navigateToDailyItinerary = true
                    }
                }
            }
        }
    }
}

// MARK: - FlowLayout Helper for Tags
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = arrangeSubviews(proposal: proposal, subviews: subviews)
        var height: CGFloat = 0
        for row in rows {
            let rowHeight = row.map { $0.sizeThatFits(.unspecified).height }.max() ?? 0
            height += rowHeight + spacing
        }
        if height > 0 { height -= spacing }
        return CGSize(width: proposal.width ?? 0, height: height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let rows = arrangeSubviews(proposal: proposal, subviews: subviews)
        var y = bounds.minY
        for row in rows {
            var x = bounds.minX
            let rowHeight = row.map { $0.sizeThatFits(.unspecified).height }.max() ?? 0
            for view in row {
                let size = view.sizeThatFits(.unspecified)
                view.place(at: CGPoint(x: x, y: y + (rowHeight - size.height) / 2), proposal: ProposedViewSize(size))
                x += size.width + spacing
            }
            y += rowHeight + spacing
        }
    }
    
    private func arrangeSubviews(proposal: ProposedViewSize, subviews: Subviews) -> [[LayoutSubview]] {
        let maxWidth = proposal.width ?? 0
        var rows: [[LayoutSubview]] = []
        var currentRow: [LayoutSubview] = []
        var currentLineWidth: CGFloat = 0
        
        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if currentLineWidth + size.width > maxWidth && !currentRow.isEmpty {
                rows.append(currentRow)
                currentRow = [view]
                currentLineWidth = size.width + spacing
            } else {
                currentRow.append(view)
                currentLineWidth += size.width + spacing
            }
        }
        if !currentRow.isEmpty {
            rows.append(currentRow)
        }
        return rows
    }
}
