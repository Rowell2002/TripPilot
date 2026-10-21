import SwiftUI
import PDFKit
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Timeframe Enum
enum AnalyticsTimeframe: String, CaseIterable, Identifiable {
    case sriLanka = "Sri Lanka Expedition"
    case recentTrip = "Active Itinerary"
    case allTime = "All-Time"
    
    var id: String { rawValue }
}

// MARK: - Milestone Badge Model
struct MilestoneItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let iconName: String
    let isUnlocked: Bool
    let statusText: String
    let progress: Double?
    let iconColor: Color
    let iconBgColor: Color
}

// MARK: - Main View
struct TravelAnalyticsMilestonesView: View {
    @Environment(\.dismiss) private var dismiss
    var initialScrollToBottom: Bool = false
    
    // Theme Colors
    private let darkBackground = Color(red: 15/255, green: 19/255, blue: 28/255)            // #0f131c
    private let surfaceContainerLowest = Color(red: 10/255, green: 14/255, blue: 22/255)   // #0a0e16
    private let surfaceContainerLow = Color(red: 24/255, green: 28/255, blue: 36/255)      // #181c24
    private let surfaceContainer = Color(red: 28/255, green: 32/255, blue: 40/255)         // #1c2028
    private let surfaceContainerHigh = Color(red: 38/255, green: 42/255, blue: 51/255)     // #262a33
    private let surfaceContainerHighest = Color(red: 49/255, green: 53/255, blue: 62/255)  // #31353e
    
    private let primarySky = Color(red: 56/255, green: 189/255, blue: 248/255)             // #38bdf8
    private let primaryTint = Color(red: 142/255, green: 213/255, blue: 255/255)           // #8ed5ff
    private let secondaryMint = Color(red: 68/255, green: 226/255, blue: 205/255)          // #44e2cd
    private let tertiaryIndigo = Color(red: 175/255, green: 207/255, blue: 255/255)        // #afcfff
    private let tertiaryContainer = Color(red: 123/255, green: 180/255, blue: 255/255)     // #7bb4ff
    private let amberGold = Color(red: 251/255, green: 191/255, blue: 36/255)              // amber-400
    private let errorRed = Color(red: 255/255, green: 107/255, blue: 107/255)              // #ff6b6b
    
    private let textOnSurface = Color(red: 223/255, green: 226/255, blue: 238/255)          // #dfe2ee
    private let textVariant = Color(red: 189/255, green: 200/255, blue: 209/255)            // #bdc8d1
    private let textMuted = Color(red: 135/255, green: 146/255, blue: 154/255)              // #87929a
    
    // State Variables
    @State private var selectedTimeframe: AnalyticsTimeframe = .sriLanka
    @State private var isLivePulsing: Bool = false
    @State private var ringsAnimated: Bool = false
    @State private var showExportSheet: Bool = false
    @State private var showAllBadgesSheet: Bool = false
    @State private var feedbackNotice: String? = nil
    @State private var exportedPDFURL: URL? = nil
    @State private var showShareSheet: Bool = false
    @State private var generatedPDFData: Data? = nil
    
    // Bottom Tab Bar State
    @State private var selectedTab: AppTab = .profile
    @State private var navigateToHome: Bool = false
    @State private var navigateToItinerary: Bool = false
    @State private var navigateToMap: Bool = false
    @State private var navigateToBudget: Bool = false
    
    // Milestones Data
    private let milestonesList: [MilestoneItem] = [
        MilestoneItem(
            title: "Highland Railway Maestro",
            subtitle: "Main Line Scenic Train >500 km across Ceylon tea hills",
            iconName: "tram.fill",
            isUnlocked: true,
            statusText: "Unlocked",
            progress: nil,
            iconColor: Color(red: 56/255, green: 189/255, blue: 248/255),
            iconBgColor: Color(red: 56/255, green: 189/255, blue: 248/255).opacity(0.12)
        ),
        MilestoneItem(
            title: "UNESCO Citadel Summit",
            subtitle: "Sigiriya Lion Rock ancient citadel climbed & verified",
            iconName: "mountain.2.fill",
            isUnlocked: true,
            statusText: "Unlocked",
            progress: nil,
            iconColor: Color(red: 68/255, green: 226/255, blue: 205/255),
            iconBgColor: Color(red: 68/255, green: 226/255, blue: 205/255).opacity(0.12)
        ),
        MilestoneItem(
            title: "Ceylon Crab Connoisseur",
            subtitle: "Ministry of Crab & Galle Face street delicacies verified",
            iconName: "fork.knife",
            isUnlocked: true,
            statusText: "Unlocked",
            progress: nil,
            iconColor: Color(red: 175/255, green: 207/255, blue: 255/255),
            iconBgColor: Color(red: 175/255, green: 207/255, blue: 255/255).opacity(0.12)
        ),
        MilestoneItem(
            title: "Next: Southern Surf Bay",
            subtitle: "Weligama & Mirissa blue whale safari • 3 of 4 legs booked",
            iconName: "sailboat.fill",
            isUnlocked: false,
            statusText: "In 48d",
            progress: 0.75,
            iconColor: Color(red: 189/255, green: 200/255, blue: 209/255),
            iconBgColor: Color(red: 49/255, green: 53/255, blue: 62/255)
        )
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background
            darkBackground
                .ignoresSafeArea()
            
            // Ambient Radial Glows
            Group {
                Circle()
                    .fill(primarySky.opacity(0.06))
                    .frame(width: 340, height: 340)
                    .blur(radius: 80)
                    .offset(x: -80, y: -60)
                
                Circle()
                    .fill(secondaryMint.opacity(0.05))
                    .frame(width: 320, height: 320)
                    .blur(radius: 70)
                    .offset(x: 140, y: 300)
            }
            .ignoresSafeArea()
            
            // Main Scrollable Content
            ScrollViewReader { scrollProxy in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Header spacing buffer
                        Spacer()
                            .frame(height: 64)
                        
                        // MARK: - 1. Title & User Tier Banner
                        subHeaderTierSection
                        
                        // MARK: - 2. Timeframe Segmented Control
                        timeframeSegmentedControl
                        
                        // MARK: - 3. Apple Fitness-Style Activity Rings
                        activityRingsCard
                        
                        // MARK: - 4. Lifetime Summary Bento Grid
                        lifetimeSummaryGrid
                        
                        // MARK: - 5. Global Footprint Distribution
                        globalFootprintSection
                        
                        // MARK: - 6. Milestones & Badges
                        milestonesSection
                        
                        // MARK: - 7. Efficiency & Budget Pulse
                        efficiencyPulseCard
                        
                        // MARK: - 8. Export Passport CTA
                        exportPassportCTA
                            .id("bottomView")
                        
                        // Bottom Spacing for Floating Tab Bar
                        Spacer()
                            .frame(height: 135)
                    }
                    .padding(.horizontal, 16)
                }
                .onAppear {
                    if initialScrollToBottom {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            withAnimation(.easeInOut(duration: 0.8)) {
                                scrollProxy.scrollTo("bottomView", anchor: .bottom)
                            }
                        }
                    }
                }
            }
            
            // MARK: - Fixed Top Translucent Header Bar
            VStack(spacing: 0) {
                topHeaderBar
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .ignoresSafeArea(edges: .top)
            
            // MARK: - Floating Glassmorphic Bottom Navigation Bar
            FloatingBottomNavBar(selectedTab: $selectedTab) { tab in
                if tab == .home {
                    dismiss()
                } else if tab == .itinerary {
                    navigateToItinerary = true
                } else if tab == .map {
                    navigateToMap = true
                } else if tab == .budget {
                    navigateToBudget = true
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 8)
            
            // Toast Notification Overlay
            if let notice = feedbackNotice {
                VStack {
                    Spacer().frame(height: 72)
                    Text(notice)
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(surfaceContainerHigh)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule().stroke(primarySky.opacity(0.5), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.7), radius: 12, y: 6)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    Spacer()
                }
                .zIndex(100)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                isLivePulsing = true
            }
            withAnimation(.spring(response: 1.0, dampingFraction: 0.75).delay(0.2)) {
                ringsAnimated = true
            }
        }
        .sheet(isPresented: $showExportSheet) {
            exportPassportPreviewSheet
        }
        .sheet(isPresented: $showAllBadgesSheet) {
            allBadgesModalView
        }
        .navigationDestination(isPresented: $navigateToItinerary) {
            DailyItineraryView()
        }
        .navigationDestination(isPresented: $navigateToMap) {
            InteractiveMapView()
        }
        .navigationDestination(isPresented: $navigateToBudget) {
            BudgetExpensesView()
        }
    }
    
    // MARK: - Fixed Top Header Bar
    private var topHeaderBar: some View {
        HStack {
            // Back Button & Brand Logo
            HStack(spacing: 8) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(primaryTint)
                        .frame(width: 36, height: 36)
                        .background(surfaceContainerLow.opacity(0.9))
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.white.opacity(0.08), lineWidth: 1)
                        )
                }
                
                // Brand Mark
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [primarySky, Color(red: 2/255, green: 132/255, blue: 199/255)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 1) {
                    Text("TripPilot")
                        .font(.system(size: 17, weight: .heavy, design: .rounded))
                        .foregroundColor(primaryTint)
                    
                    Text("Profile Settings")
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundColor(textVariant)
                }
            }
            
            Spacer()
            
            // Notifications Bell & User Avatar
            HStack(spacing: 8) {
                Button(action: {
                    triggerHapticFeedback()
                    showToast("No new milestone notifications")
                }) {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "bell.fill")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(textVariant)
                            .frame(width: 40, height: 40)
                            .background(surfaceContainerLow.opacity(0.9))
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(Color.white.opacity(0.08), lineWidth: 1)
                            )
                        
                        Circle()
                            .fill(primarySky)
                            .frame(width: 7, height: 7)
                            .offset(x: -8, y: 8)
                    }
                }
                
                // Avatar
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(red: 24/255, green: 76/255, blue: 120/255), Color(red: 14/255, green: 40/255, blue: 70/255)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 36, height: 36)
                    
                    Text("EV")
                        .font(.system(size: 13, weight: .heavy, design: .rounded))
                        .foregroundColor(primaryTint)
                }
                .overlay(
                    Circle().stroke(primarySky.opacity(0.4), lineWidth: 1.5)
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 48)
        .padding(.bottom, 10)
        .background(
            surfaceContainerLowest.opacity(0.85)
                .background(.ultraThinMaterial)
                .shadow(color: Color.black.opacity(0.45), radius: 8, y: 2)
        )
    }
    
    // MARK: - 1. Title & Tier Banner
    private var subHeaderTierSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center) {
                Text("Analytics & Milestones")
                    .font(.system(size: 26, weight: .heavy, design: .rounded))
                    .foregroundColor(textOnSurface)
                    .tracking(-0.5)
                
                Spacer()
                
                // Live Sync Pill
                HStack(spacing: 5) {
                    Circle()
                        .fill(secondaryMint)
                        .frame(width: 7, height: 7)
                        .scaleEffect(isLivePulsing ? 1.25 : 0.85)
                        .opacity(isLivePulsing ? 1.0 : 0.6)
                    
                    Text("LIVE SYNC")
                        .font(.system(size: 10, weight: .heavy, design: .rounded))
                        .foregroundColor(secondaryMint)
                        .tracking(0.8)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(secondaryMint.opacity(0.12))
                .clipShape(Capsule())
            }
            
            // Tier Status Pill
            HStack(spacing: 8) {
                Image(systemName: "star.fill")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(primarySky)
                
                HStack(spacing: 4) {
                    Text("Tier:")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(textVariant)
                    
                    Text("Globetrotter Elite")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(primarySky)
                    
                    Text("• LEVEL 8")
                        .font(.system(size: 11, weight: .heavy, design: .rounded))
                        .foregroundColor(textOnSurface)
                }
                
                Circle()
                    .fill(textVariant.opacity(0.4))
                    .frame(width: 4, height: 4)
                
                Text("Top 2%")
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundColor(textVariant)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(surfaceContainer)
            .clipShape(Capsule())
            .overlay(
                Capsule().stroke(Color.white.opacity(0.06), lineWidth: 1)
            )
        }
    }
    
    // MARK: - 2. Timeframe Segmented Control
    private var timeframeSegmentedControl: some View {
        HStack(spacing: 4) {
            ForEach(AnalyticsTimeframe.allCases) { timeframe in
                Button(action: {
                    triggerHapticFeedback()
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        selectedTimeframe = timeframe
                    }
                }) {
                    Text(timeframe.rawValue)
                        .font(.system(size: 12, weight: selectedTimeframe == timeframe ? .bold : .medium, design: .rounded))
                        .foregroundColor(selectedTimeframe == timeframe ? Color(red: 0/255, green: 30/255, blue: 44/255) : textVariant)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(
                            selectedTimeframe == timeframe ?
                            AnyView(
                                Capsule()
                                    .fill(primarySky)
                                    .shadow(color: primarySky.opacity(0.35), radius: 6, y: 2)
                            ) :
                            AnyView(Color.clear)
                        )
                }
            }
        }
        .padding(4)
        .background(surfaceContainerLow)
        .clipShape(Capsule())
        .overlay(
            Capsule().stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
    }
    
    // MARK: - 3. Apple Fitness-Style Activity Rings Module
    private var activityRingsCard: some View {
        VStack(spacing: 16) {
            // Card Header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("ANNUAL TRAJECTORY")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(textVariant)
                        .tracking(0.8)
                    
                    Text("Travel Activity Rings")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(textOnSurface)
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(surfaceContainerHigh)
                        .frame(width: 34, height: 34)
                    
                    Image(systemName: "circle.circle")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(primarySky)
                }
            }
            
            // Concentric Glowing Rings + Legends
            HStack(spacing: 12) {
                // Concentric SVG/Shape Rings
                ZStack {
                    // Track 1 (Outer - Countries)
                    Circle()
                        .stroke(surfaceContainerHigh.opacity(0.7), lineWidth: 11)
                        .frame(width: 124, height: 124)
                    
                    Circle()
                        .trim(from: 0, to: ringsAnimated ? 0.72 : 0)
                        .stroke(
                            primarySky,
                            style: StrokeStyle(lineWidth: 11, lineCap: .round)
                        )
                        .frame(width: 124, height: 124)
                        .rotationEffect(.degrees(-90))
                        .shadow(color: primarySky.opacity(0.55), radius: 6)
                    
                    // Track 2 (Middle - Miles)
                    Circle()
                        .stroke(surfaceContainerHigh.opacity(0.7), lineWidth: 11)
                        .frame(width: 96, height: 96)
                    
                    Circle()
                        .trim(from: 0, to: ringsAnimated ? 0.96 : 0)
                        .stroke(
                            secondaryMint,
                            style: StrokeStyle(lineWidth: 11, lineCap: .round)
                        )
                        .frame(width: 96, height: 96)
                        .rotationEffect(.degrees(-90))
                        .shadow(color: secondaryMint.opacity(0.55), radius: 6)
                    
                    // Track 3 (Inner - UNESCO)
                    Circle()
                        .stroke(surfaceContainerHigh.opacity(0.7), lineWidth: 11)
                        .frame(width: 68, height: 68)
                    
                    Circle()
                        .trim(from: 0, to: ringsAnimated ? 0.70 : 0)
                        .stroke(
                            tertiaryIndigo,
                            style: StrokeStyle(lineWidth: 11, lineCap: .round)
                        )
                        .frame(width: 68, height: 68)
                        .rotationEffect(.degrees(-90))
                        .shadow(color: tertiaryIndigo.opacity(0.55), radius: 6)
                    
                    // Center Navigation Glyph
                    Image(systemName: "location.north.fill")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(primarySky)
                }
                .frame(width: 130, height: 130)
                
                // Ring Breakdown Metrics
                VStack(spacing: 8) {
                    // Metric 1: Countries
                    ringMetricRow(
                        color: primarySky,
                        title: "Countries Visited",
                        subtitle: "18 of 25 goal",
                        percentage: "72%"
                    )
                    
                    // Metric 2: Miles
                    ringMetricRow(
                        color: secondaryMint,
                        title: "Flight Miles",
                        subtitle: "48.2k / 50k mi",
                        percentage: "96%"
                    )
                    
                    // Metric 3: UNESCO Sanctuaries
                    ringMetricRow(
                        color: tertiaryIndigo,
                        title: "UNESCO Sites",
                        subtitle: "14 of 20 targets",
                        percentage: "70%"
                    )
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(16)
        .background(surfaceContainer)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .overlay(
            RoundedRectangle(cornerRadius: 22).stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.35), radius: 10, y: 4)
    }
    
    private func ringMetricRow(color: Color, title: String, subtitle: String, percentage: String) -> some View {
        HStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
                .shadow(color: color.opacity(0.7), radius: 4)
            
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundColor(textOnSurface)
                    .lineLimit(1)
                
                Text(subtitle)
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundColor(textVariant)
                    .lineLimit(1)
            }
            
            Spacer(minLength: 2)
            
            Text(percentage)
                .font(.system(size: 13, weight: .heavy, design: .rounded))
                .foregroundColor(color)
        }
        .padding(.horizontal, 9)
        .padding(.vertical, 7)
        .background(surfaceContainerHigh)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: - 4. Lifetime Summary Bento Grid
    private var lifetimeSummaryGrid: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Lifetime Summary")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(textOnSurface)
                
                Spacer()
                
                Text("Since Jan 2021")
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundColor(textVariant)
            }
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                // Bento 1: Countries
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "globe.americas.fill")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(primarySky)
                        
                        Spacer()
                        
                        Text("3 Cont.")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundColor(textVariant)
                    }
                    
                    Text("18")
                        .font(.system(size: 32, weight: .heavy, design: .rounded))
                        .foregroundColor(textOnSurface)
                    
                    Text("Countries Explored")
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundColor(textVariant)
                    
                    // Flag Tags
                    HStack(spacing: 4) {
                        flagPill("🇯🇵 JP")
                        flagPill("🇨🇭 CH")
                        flagPill("🇮🇹 IT")
                    }
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(surfaceContainer)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .overlay(
                    RoundedRectangle(cornerRadius: 18).stroke(Color.white.opacity(0.06), lineWidth: 1)
                )
                
                // Bento 2: Cities
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "building.2.fill")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(secondaryMint)
                        
                        Spacer()
                        
                        Text("Avg 4.8d")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundColor(secondaryMint)
                    }
                    
                    Text("46")
                        .font(.system(size: 32, weight: .heavy, design: .rounded))
                        .foregroundColor(textOnSurface)
                    
                    Text("Total Cities")
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundColor(textVariant)
                    
                    Text("Top: Kandy • Galle Fort")
                        .font(.system(size: 10, weight: .semibold, design: .rounded))
                        .foregroundColor(textVariant)
                        .lineLimit(1)
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(surfaceContainer)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .overlay(
                    RoundedRectangle(cornerRadius: 18).stroke(Color.white.opacity(0.06), lineWidth: 1)
                )
                
                // Bento 3: Distance Flown
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "airplane")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(tertiaryIndigo)
                        
                        Spacer()
                        
                        Text("3.2x Earth")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundColor(tertiaryIndigo)
                    }
                    
                    Text("128,450")
                        .font(.system(size: 24, weight: .heavy, design: .rounded))
                        .foregroundColor(textOnSurface)
                    
                    Text("Kilometers Flown")
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundColor(textVariant)
                    
                    // Progress Bar
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(surfaceContainerHigh)
                            .frame(height: 5)
                        
                        Capsule()
                            .fill(tertiaryIndigo)
                            .frame(width: 80, height: 5)
                    }
                    .padding(.top, 2)
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(surfaceContainer)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .overlay(
                    RoundedRectangle(cornerRadius: 18).stroke(Color.white.opacity(0.06), lineWidth: 1)
                )
                
                // Bento 4: Carbon Offset
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(secondaryMint)
                        
                        Spacer()
                        
                        Text("Gold Std")
                            .font(.system(size: 9, weight: .bold, design: .rounded))
                            .foregroundColor(secondaryMint)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(secondaryMint.opacity(0.14))
                            .clipShape(Capsule())
                    }
                    
                    Text("100%")
                        .font(.system(size: 24, weight: .heavy, design: .rounded))
                        .foregroundColor(secondaryMint)
                    
                    Text("Neutralized")
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundColor(textVariant)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(secondaryMint)
                        
                        Text("Verified Offset")
                            .font(.system(size: 10, weight: .semibold, design: .rounded))
                            .foregroundColor(textVariant)
                    }
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(surfaceContainer)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .overlay(
                    RoundedRectangle(cornerRadius: 18).stroke(Color.white.opacity(0.06), lineWidth: 1)
                )
            }
        }
    }
    
    private func flagPill(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 10, weight: .medium, design: .rounded))
            .foregroundColor(textOnSurface)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(surfaceContainerHigh)
            .clipShape(Capsule())
    }
    
    // MARK: - 5. Global Footprint Distribution
    private var globalFootprintSection: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("REGIONAL EXPOSURE")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(textVariant)
                        .tracking(0.8)
                    
                    Text("Global Footprint")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(textOnSurface)
                }
                
                Spacer()
                
                HStack(spacing: 5) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(errorRed)
                    
                    Text("4Q Voyager Streak")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundColor(textOnSurface)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(surfaceContainerHigh)
                .clipShape(Capsule())
            }
            
            // Segmented Distribution Bar
            VStack(spacing: 8) {
                GeometryReader { geo in
                    HStack(spacing: 2) {
                        // Asia 42%
                        RoundedRectangle(cornerRadius: 3)
                            .fill(primarySky)
                            .frame(width: geo.size.width * 0.42)
                        
                        // Europe 38%
                        RoundedRectangle(cornerRadius: 3)
                            .fill(secondaryMint)
                            .frame(width: geo.size.width * 0.38)
                        
                        // North America 20%
                        RoundedRectangle(cornerRadius: 3)
                            .fill(tertiaryContainer)
                            .frame(width: geo.size.width * 0.20 - 4)
                    }
                }
                .frame(height: 10)
                .clipShape(Capsule())
                
                // Legend
                HStack(spacing: 14) {
                    HStack(spacing: 5) {
                        Circle().fill(primarySky).frame(width: 7, height: 7)
                        Text("Asia (42%)")
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .foregroundColor(textVariant)
                    }
                    
                    HStack(spacing: 5) {
                        Circle().fill(secondaryMint).frame(width: 7, height: 7)
                        Text("Europe (38%)")
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .foregroundColor(textVariant)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 5) {
                        Circle().fill(tertiaryContainer).frame(width: 7, height: 7)
                        Text("N. America (20%)")
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .foregroundColor(textVariant)
                    }
                }
            }
        }
        .padding(18)
        .background(surfaceContainer)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .overlay(
            RoundedRectangle(cornerRadius: 22).stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }
    
    // MARK: - 6. Milestones & Badges
    private var milestonesSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Milestones & Badges")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(textOnSurface)
                
                Spacer()
                
                Button(action: {
                    triggerHapticFeedback()
                    showAllBadgesSheet = true
                }) {
                    Text("View All (24)")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(primarySky)
                }
            }
            
            VStack(spacing: 2) {
                ForEach(milestonesList) { milestone in
                    milestoneRow(milestone)
                }
            }
            .background(surfaceContainerHigh.opacity(0.4))
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18).stroke(Color.white.opacity(0.06), lineWidth: 1)
            )
        }
    }
    
    private func milestoneRow(_ item: MilestoneItem) -> some View {
        VStack(spacing: 8) {
            HStack(spacing: 12) {
                // Icon
                ZStack {
                    Circle()
                        .fill(item.iconBgColor)
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: item.iconName)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(item.iconColor)
                }
                
                // Text details
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text(item.title)
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(textOnSurface)
                        
                        Text(item.statusText)
                            .font(.system(size: 9, weight: .bold, design: .rounded))
                            .foregroundColor(item.isUnlocked ? item.iconColor : textVariant)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(item.iconBgColor)
                            .clipShape(Capsule())
                    }
                    
                    Text(item.subtitle)
                        .font(.system(size: 11, weight: .regular, design: .rounded))
                        .foregroundColor(textVariant)
                        .lineLimit(1)
                }
                
                Spacer()
                
                // Status icon or percentage
                if item.isUnlocked {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(secondaryMint)
                } else if let progress = item.progress {
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 13, weight: .heavy, design: .rounded))
                        .foregroundColor(primarySky)
                }
            }
            
            // Progress Bar if in progress
            if let progress = item.progress {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(surfaceContainerLowest)
                            .frame(height: 6)
                        
                        Capsule()
                            .fill(primarySky)
                            .frame(width: geo.size.width * progress, height: 6)
                    }
                }
                .frame(height: 6)
                .padding(.top, 2)
            }
        }
        .padding(14)
        .background(surfaceContainer)
    }
    
    // MARK: - 7. Efficiency & Budget Pulse
    private var efficiencyPulseCard: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text("FLEET & SPENDING PRECISION")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(textVariant)
                    .tracking(0.8)
                
                HStack(spacing: 4) {
                    Text("Average Spend:")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(textOnSurface)
                    
                    Text("$248/day")
                        .font(.system(size: 14, weight: .heavy, design: .rounded))
                        .foregroundColor(primarySky)
                }
                
                HStack(spacing: 4) {
                    Text("Transit On-Time Rate:")
                        .font(.system(size: 11, weight: .regular, design: .rounded))
                        .foregroundColor(textVariant)
                    
                    Text("99.4%")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundColor(secondaryMint)
                }
            }
            
            Spacer()
            
            ZStack {
                Circle()
                    .fill(surfaceContainerHigh)
                    .frame(width: 44, height: 44)
                
                Image(systemName: "speedometer")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(secondaryMint)
            }
        }
        .padding(16)
        .background(surfaceContainer)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18).stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
    }
    
    // MARK: - 8. Export Passport CTA
    private var exportPassportCTA: some View {
        VStack(spacing: 8) {
            Button(action: {
                triggerHapticFeedback()
                showExportSheet = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 16, weight: .bold))
                    
                    Text("Export 2024 Travel Passport (PDF)")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                }
                .foregroundColor(Color(red: 0/255, green: 30/255, blue: 44/255))
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    LinearGradient(
                        colors: [primarySky, Color(red: 2/255, green: 132/255, blue: 199/255)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(Capsule())
                .shadow(color: primarySky.opacity(0.35), radius: 10, y: 4)
            }
            
            HStack(spacing: 5) {
                Image(systemName: "checkmark.shield.fill")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(textMuted)
                
                Text("Cryptographically verified using standard ICAO Doc 9303 checksum")
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundColor(textMuted)
                    .lineLimit(1)
            }
        }
    }
    
    // MARK: - Sheets & Modals
    private var exportPassportPreviewSheet: some View {
        ZStack {
            darkBackground.ignoresSafeArea()
            
            VStack(spacing: 16) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Travel Passport (PDF)")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(textOnSurface)
                        Text("Live PDFKit Preview • ICAO 9303 Compliance")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(primarySky)
                    }
                    
                    Spacer()
                    
                    Button("Done") {
                        showExportSheet = false
                    }
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(primarySky)
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
                
                // Live PDFKit Document Preview
                if let pdfData = generatedPDFData {
                    PDFKitRepresentedView(data: pdfData)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.4), radius: 14, y: 6)
                        .padding(.horizontal, 20)
                } else {
                    VStack(spacing: 12) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: primarySky))
                        Text("Rendering Vector PDF...")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundColor(textMuted)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                // Export CTA Button
                Button(action: {
                    triggerHapticFeedback()
                    if let url = PassportPDFGenerator.shared.exportTemporaryPDF() {
                        exportedPDFURL = url
                        showShareSheet = true
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "square.and.arrow.up.fill")
                            .font(.system(size: 15, weight: .bold))
                        Text("Save PDF to Files / Share")
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(Color(red: 0/255, green: 30/255, blue: 44/255))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        LinearGradient(
                            colors: [primarySky, Color(red: 2/255, green: 132/255, blue: 199/255)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Capsule())
                    .shadow(color: primarySky.opacity(0.35), radius: 10, y: 4)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }
        }
        .onAppear {
            if generatedPDFData == nil {
                generatedPDFData = PassportPDFGenerator.shared.generatePDF()
            }
        }
        .sheet(isPresented: $showShareSheet) {
            if let url = exportedPDFURL {
                ShareSheet(items: [url]) {
                    showToast("Passport PDF saved successfully!")
                }
            }
        }
    }
    
    private var allBadgesModalView: some View {
        ZStack {
            darkBackground.ignoresSafeArea()
            
            VStack(spacing: 16) {
                HStack {
                    Text("All Milestone Badges (24)")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(textOnSurface)
                    
                    Spacer()
                    
                    Button("Close") {
                        showAllBadgesSheet = false
                    }
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(primarySky)
                }
                .padding(.top, 24)
                .padding(.horizontal, 20)
                
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(milestonesList) { item in
                            milestoneRow(item)
                        }
                        
                        // Additional archived badges
                        milestoneRow(
                            MilestoneItem(
                                title: "Nordic Aurora Witness",
                                subtitle: "Tromsø polar night excursion logged",
                                iconName: "sparkles",
                                isUnlocked: true,
                                statusText: "Unlocked",
                                progress: nil,
                                iconColor: secondaryMint,
                                iconBgColor: secondaryMint.opacity(0.12)
                            )
                        )
                        
                        milestoneRow(
                            MilestoneItem(
                                title: "Patagonia Trekker",
                                subtitle: "Torres del Paine W-Circuit verified",
                                iconName: "figure.hiking",
                                isUnlocked: true,
                                statusText: "Unlocked",
                                progress: nil,
                                iconColor: amberGold,
                                iconBgColor: amberGold.opacity(0.12)
                            )
                        )
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .presentationDetents([.large])
    }
    
    // MARK: - Helpers
    private func triggerHapticFeedback() {
        #if canImport(UIKit)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
        #endif
    }
    
    private func showToast(_ message: String) {
        feedbackNotice = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
            withAnimation(.easeOut(duration: 0.3)) {
                feedbackNotice = nil
            }
        }
    }
}
