//
//  BudgetExpensesView.swift
//  TripPilot
//
//  Generated from Stitch Screen: c4b607b59f554c17a088880ccbe58731
//  Title: TripPilot - Budget & Expenses (Dark Mode)
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Models
struct ExpenseTransaction: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let category: String
    let categoryColor: Color
    let iconName: String
    let timeAgo: String
    let location: String
    let amountUSD: Double
    let amountJPY: Int
}

struct BudgetCategoryEnvelope: Identifiable {
    let id = UUID()
    let name: String
    let detail: String
    let iconName: String
    let color: Color
    let spentUSD: Double
    let targetUSD: Double
    let spentJPY: Int
    let targetJPY: Int
    
    var progress: Double {
        min(spentUSD / targetUSD, 1.0)
    }
}

// MARK: - Main View
struct BudgetExpensesView: View {
    @Environment(\.dismiss) private var dismiss
    
    // Stitch Theme Palette
    private let darkBackground = Color(red: 0/255, green: 0/255, blue: 0/255)                  // #000000
    private let surfaceContainerLowest = Color(red: 11/255, green: 15/255, blue: 23/255)     // #0b0f17
    private let surfaceContainerLow = Color(red: 17/255, green: 24/255, blue: 39/255)        // #111827
    private let surfaceContainer = Color(red: 24/255, green: 34/255, blue: 52/255)           // #182234
    private let surfaceCard = Color(red: 21/255, green: 31/255, blue: 48/255)                // #151f30
    private let surfaceContainerHigh = Color(red: 38/255, green: 42/255, blue: 51/255)       // #262a33
    private let primarySky = Color(red: 56/255, green: 189/255, blue: 248/255)               // #38bdf8
    private let primaryBlue = Color(red: 142/255, green: 213/255, blue: 255/255)             // #8ed5ff
    private let royalBlue = Color(red: 37/255, green: 99/255, blue: 235/255)                 // #2563eb
    private let secondaryMint = Color(red: 68/255, green: 226/255, blue: 205/255)            // #44e2cd
    private let emeraldGreen = Color(red: 16/255, green: 185/255, blue: 129/255)             // #10b981
    private let amberGold = Color(red: 245/255, green: 158/255, blue: 11/255)                // #f59e0b
    private let purpleAccent = Color(red: 168/255, green: 85/255, blue: 247/255)             // #a855f7
    private let slateMuted = Color(red: 148/255, green: 163/255, blue: 184/255)              // slate-400
    private let outlineBorder = Color.white.opacity(0.08)
    
    // FX Rate
    private let fxRate: Double = 152.40 // 1 USD = 152.40 JPY
    
    // Interactive State
    @State private var selectedTab: AppTab = .budget
    @State private var isUSD: Bool = true
    @State private var isFlightPulsing: Bool = false
    @State private var showLogExpenseSheet: Bool = false
    @State private var showSplitBillSheet: Bool = false
    @State private var showTripPickerSheet: Bool = false
    @State private var activeNotice: String? = nil
    @State private var isSettledWithMarcus: Bool = false
    
    // Navigation destinations
    @State private var navigateToHome: Bool = false
    @State private var navigateToItinerary: Bool = false
    @State private var navigateToMap: Bool = false
    @State private var navigateToReceiptScanner: Bool = false
    
    // Donut chart hover/selection
    @State private var selectedDonutIndex: Int? = nil
    
    // Sample Transactions
    @State private var transactions: [ExpenseTransaction] = [
        ExpenseTransaction(
            title: "Sushi Yoshitake Omakase",
            subtitle: "3 Michelin Star dinner experience",
            category: "Dining",
            categoryColor: Color(red: 245/255, green: 158/255, blue: 11/255),
            iconName: "fork.knife",
            timeAgo: "Today, 1:45 PM",
            location: "Ginza, Tokyo",
            amountUSD: 236.22,
            amountJPY: 36000
        ),
        ExpenseTransaction(
            title: "Shinkansen Bullet Train",
            subtitle: "2 Reserved Seats Nozomi Express",
            category: "Transit",
            categoryColor: Color(red: 96/255, green: 165/255, blue: 250/255),
            iconName: "tram.fill",
            timeAgo: "Yesterday",
            location: "Tokyo → Kyoto",
            amountUSD: 186.35,
            amountJPY: 28400
        ),
        ExpenseTransaction(
            title: "Meiji Shrine Amulet & Pass",
            subtitle: "Sacred inner garden entry",
            category: "Culture",
            categoryColor: Color(red: 52/255, green: 211/255, blue: 153/255),
            iconName: "sparkles",
            timeAgo: "Yesterday",
            location: "Shibuya",
            amountUSD: 20.99,
            amountJPY: 3200
        ),
        ExpenseTransaction(
            title: "7-Eleven Convenience Snack",
            subtitle: "Onigiri, matcha latte & melon pan",
            category: "Snacks",
            categoryColor: Color(red: 245/255, green: 158/255, blue: 11/255),
            iconName: "bag.fill",
            timeAgo: "Oct 24",
            location: "Otemachi",
            amountUSD: 5.84,
            amountJPY: 890
        )
    ]
    
    // Sample Categories
    private let categories: [BudgetCategoryEnvelope] = [
        BudgetCategoryEnvelope(
            name: "Food & Dining",
            detail: "¥114,665 spent of ¥182,880",
            iconName: "fork.knife",
            color: Color(red: 245/255, green: 158/255, blue: 11/255),
            spentUSD: 752.40,
            targetUSD: 1200.00,
            spentJPY: 114665,
            targetJPY: 182880
        ),
        BudgetCategoryEnvelope(
            name: "Flights & Transit",
            detail: "Includes JR Shinkansen Pass",
            iconName: "tram.fill",
            color: Color(red: 37/255, green: 99/255, blue: 235/255),
            spentUSD: 1588.00,
            targetUSD: 1600.00,
            spentJPY: 242011,
            targetJPY: 243840
        ),
        BudgetCategoryEnvelope(
            name: "Accommodations",
            detail: "Tokyo & Kyoto Ryokans",
            iconName: "bed.double.fill",
            color: Color(red: 56/255, green: 189/255, blue: 248/255),
            spentUSD: 1340.00,
            targetUSD: 1800.00,
            spentJPY: 204216,
            targetJPY: 274320
        )
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background
            darkBackground
                .ignoresSafeArea()
            
            // Atmospheric Glows
            GeometryReader { _ in
                Circle()
                    .fill(primarySky.opacity(0.08))
                    .frame(width: 340, height: 340)
                    .blur(radius: 80)
                    .offset(x: -80, y: -40)
                
                Circle()
                    .fill(secondaryMint.opacity(0.06))
                    .frame(width: 300, height: 300)
                    .blur(radius: 70)
                    .offset(x: 180, y: 380)
            }
            .ignoresSafeArea()
            
            // Main Scrollable Content
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Header spacing buffer
                    Spacer()
                        .frame(height: 70)
                    
                    // MARK: - 1. Trip Capsule & Quick FX Currency Switcher
                    tripHeaderAndFXSection
                    
                    // MARK: - 2. High-Impact Safe-to-Spend Overview Card
                    safeToSpendOverviewCard
                    
                    // MARK: - 3. Primary Interactive Actions (Log & Split)
                    primaryActionsRow
                    
                    // MARK: - 4. Group Balance Settlement Banner
                    groupBalanceSettlementBanner
                    
                    // MARK: - 5. Visual Analytics: Spending Breakdown Donut Chart
                    spendingBreakdownDonutSection
                    
                    // MARK: - 6. Category Breakdown Envelopes
                    categoryEnvelopesSection
                    
                    // MARK: - 7. Recent Transactions Feed
                    recentTransactionsSection
                    
                    // MARK: - 8. Shared Expense Group (Travelers)
                    sharedTravelersSection
                    
                    // Bottom Spacing for Floating Tab Bar
                    Spacer()
                        .frame(height: 110)
                }
                .padding(.horizontal, 18)
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
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 8)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .preferredColorScheme(.dark)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) {
                isFlightPulsing = true
            }
        }
        .navigationDestination(isPresented: $navigateToItinerary) {
            DailyItineraryView()
        }
        .navigationDestination(isPresented: $navigateToMap) {
            InteractiveMapView()
        }
        .navigationDestination(isPresented: $navigateToReceiptScanner) {
            ReceiptScannerExpenseLoggerView()
        }
        .sheet(isPresented: $showLogExpenseSheet) {
            logExpenseModalSheet
        }
        .sheet(isPresented: $showSplitBillSheet) {
            splitBillModalSheet
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
                        Capsule().stroke(primarySky.opacity(0.4), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.7), radius: 12, y: 6)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .padding(.top, 74)
                    .zIndex(100)
            }
        }
    }
    
    // MARK: - Top Header Bar
    private var topHeaderBar: some View {
        VStack(spacing: 6) {
            // Status bar Flight Capsule Row
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 34, height: 34)
                        .background(surfaceContainerLow.opacity(0.9))
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(outlineBorder, lineWidth: 1)
                        )
                }
                
                Spacer()
                
                // Flight Status Chip
                HStack(spacing: 6) {
                    Image(systemName: "airplane.departure")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(primarySky)
                        .scaleEffect(isFlightPulsing ? 1.15 : 0.9)
                    
                    Text("JL 005 • In 2h 15m")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundColor(Color(red: 226/255, green: 232/255, blue: 240/255))
                        .tracking(0.5)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 5)
                .background(Color(red: 22/255, green: 31/255, blue: 46/255))
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(Color.white.opacity(0.12), lineWidth: 1)
                )
                
                Spacer()
                
                // Notifications button
                Button(action: {
                    triggerNotice("🔔 FX alert: JPY weakened by +0.8% today")
                }) {
                    ZStack(alignment: .topTrailing) {
                        Circle()
                            .fill(surfaceContainerLow.opacity(0.9))
                            .frame(width: 34, height: 34)
                            .overlay(
                                Circle().stroke(outlineBorder, lineWidth: 1)
                            )
                        
                        Image(systemName: "bell.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .frame(width: 34, height: 34)
                        
                        Circle()
                            .fill(Color.red)
                            .frame(width: 7, height: 7)
                            .offset(x: -2, y: 2)
                    }
                }
            }
            .padding(.horizontal, 18)
            .padding(.top, 46)
            
            // Brand Logo & Title Row
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [primarySky, royalBlue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 32, height: 32)
                        .shadow(color: primarySky.opacity(0.3), radius: 6, y: 2)
                    
                    Image(systemName: "chart.pie.fill")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 1) {
                    Text("TripPilot")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("BUDGET & FX")
                        .font(.system(size: 9.5, weight: .bold, design: .rounded))
                        .foregroundColor(primaryBlue)
                        .tracking(1.2)
                }
                
                Spacer()
                
                // User Avatar Elena
                AsyncImage(url: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuDb-R9RyzdwNRctHnbqddjU4N7mKMarUqir3UqzLA4HjDNG09Aj82ik5Z1r7nij7zDOHWjY0zodcVbu3DsW3CQvWFud_7eMalaLZEhe9y-o8-D3u7t_NExiyBopidw4pSIzYHWh8swveQg29oBNfmhS1FqxUt09-2vfzoM8V3XMdTdZoUQQm5CNGaFIzj7glDfI4hwA-cp3dsSgjG3LYtFIDaQtQD5jQb4Z5Qs8EVZSSWRmtleqKHWveA")) { phase in
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
                    Circle().stroke(primarySky.opacity(0.4), lineWidth: 1.5)
                )
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 8)
        }
        .background(
            darkBackground.opacity(0.92)
                .background(.ultraThinMaterial)
        )
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.white.opacity(0.06))
                .frame(height: 1)
        }
    }
    
    // MARK: - 1. Trip Header & Currency Switcher
    private var tripHeaderAndFXSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Trip Selector Capsule & Date
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "suitcase.rolling.fill")
                        .font(.system(size: 12))
                        .foregroundColor(primarySky)
                    
                    Text("Japan Autumn Tour")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(slateMuted)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(surfaceContainerLow)
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(outlineBorder, lineWidth: 1)
                )
                
                Spacer()
                
                Text("Oct 24 – Nov 04")
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundColor(slateMuted)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(surfaceContainerLow)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule().stroke(outlineBorder, lineWidth: 1)
                    )
            }
            
            // Screen Title & FX Currency Switcher Pill
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Trip Budget")
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Live multicurrency tracker")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(slateMuted)
                }
                
                Spacer()
                
                // Currency Switcher Button
                Button(action: {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                        isUSD.toggle()
                    }
                }) {
                    HStack(spacing: 6) {
                        Text(isUSD ? "USD ($)" : "JPY (¥)")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundColor(primarySky)
                        
                        Image(systemName: "arrow.left.arrow.right")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(slateMuted)
                        
                        Text(isUSD ? "JPY (¥)" : "USD ($)")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundColor(slateMuted)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(surfaceContainerLow)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule().stroke(outlineBorder, lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.3), radius: 6, y: 2)
                }
            }
            
            // Live FX Rate Ticker
            HStack(spacing: 6) {
                Circle()
                    .fill(secondaryMint)
                    .frame(width: 6, height: 6)
                    .shadow(color: secondaryMint, radius: 4)
                
                Text("1 USD = 152.40 JPY • Tokyo Mid-Market Live FX")
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundColor(slateMuted)
            }
            .padding(.horizontal, 4)
        }
    }
    
    // MARK: - 2. High-Impact Safe-to-Spend Overview Card
    private var safeToSpendOverviewCard: some View {
        ZStack(alignment: .topTrailing) {
            // Ambient Corner Glow
            Circle()
                .fill(primarySky.opacity(0.18))
                .frame(width: 180, height: 180)
                .blur(radius: 40)
                .offset(x: 40, y: -40)
                .allowsHitTesting(false)
            
            VStack(alignment: .leading, spacing: 16) {
                // Top row: Metric & Utilization Badge
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("REMAINING SAFE-TO-SPEND")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(slateMuted)
                            .tracking(0.6)
                        
                        Text(isUSD ? "$2,319.50" : "¥353,492")
                            .font(.system(size: 36, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("64% Utilized")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(primaryBlue)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color(red: 0/255, green: 76/255, blue: 105/255).opacity(0.8))
                            .clipShape(Capsule())
                            .overlay(
                                Capsule().stroke(primarySky.opacity(0.4), lineWidth: 1)
                            )
                            .shadow(color: primarySky.opacity(0.2), radius: 6)
                        
                        Text("8 Days Remaining")
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                            .foregroundColor(slateMuted)
                    }
                }
                
                // Segmented Multi-Color Progress Bar
                VStack(spacing: 6) {
                    GeometryReader { geo in
                        let width = geo.size.width
                        HStack(spacing: 2) {
                            Capsule()
                                .fill(royalBlue)
                                .frame(width: width * 0.38)
                                .shadow(color: royalBlue.opacity(0.6), radius: 4)
                            Capsule()
                                .fill(primarySky)
                                .frame(width: width * 0.32)
                                .shadow(color: primarySky.opacity(0.6), radius: 4)
                            Capsule()
                                .fill(amberGold)
                                .frame(width: width * 0.18)
                                .shadow(color: amberGold.opacity(0.6), radius: 4)
                            Capsule()
                                .fill(emeraldGreen)
                                .frame(width: width * 0.08)
                                .shadow(color: emeraldGreen.opacity(0.6), radius: 4)
                            Capsule()
                                .fill(purpleAccent)
                                .frame(width: width * 0.04)
                                .shadow(color: purpleAccent.opacity(0.6), radius: 4)
                        }
                    }
                    .frame(height: 10)
                    .background(Color.black.opacity(0.6))
                    .clipShape(Capsule())
                    .overlay(
                        Capsule().stroke(Color.white.opacity(0.08), lineWidth: 1)
                    )
                    
                    // Spent vs Total Label
                    HStack {
                        HStack(spacing: 2) {
                            Text("Spent:")
                                .foregroundColor(slateMuted)
                            Text(isUSD ? "$4,180.50" : "¥637,108")
                                .foregroundColor(.white)
                                .bold()
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 2) {
                            Text("Total Cap:")
                                .foregroundColor(slateMuted)
                            Text(isUSD ? "$6,500.00" : "¥990,600")
                                .foregroundColor(.white)
                                .bold()
                        }
                    }
                    .font(.system(size: 12, design: .rounded))
                }
                
                // Daily Burn Rate Banner
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color(red: 0/255, green: 76/255, blue: 105/255).opacity(0.6))
                            .frame(width: 32, height: 32)
                            .overlay(
                                Circle().stroke(primarySky.opacity(0.4), lineWidth: 1)
                            )
                        
                        Image(systemName: "gauge.with.needle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(primarySky)
                    }
                    
                    VStack(alignment: .leading, spacing: 1) {
                        HStack(spacing: 4) {
                            Text(isUSD ? "$289.90" : "¥44,180")
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("/ day safe pace")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(slateMuted)
                        }
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.down.right")
                            .font(.system(size: 11, weight: .bold))
                        Text("On Track")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(secondaryMint)
                }
                .padding(10)
                .background(Color.black.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.white.opacity(0.06), lineWidth: 1)
                )
            }
            .padding(18)
        }
        .background(
            LinearGradient(
                colors: [surfaceContainerLow, surfaceCard, surfaceContainerLowest],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(outlineBorder, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.5), radius: 16, y: 6)
    }
    
    // MARK: - 3. Primary Actions (Log & Split)
    private var primaryActionsRow: some View {
        HStack(spacing: 12) {
            // Log Expense Primary CTA (2/3 width)
            Button(action: {
                navigateToReceiptScanner = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 16, weight: .bold))
                    
                    Text("Log Expense")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(
                    LinearGradient(
                        colors: [Color(red: 2/255, green: 132/255, blue: 199/255), Color(red: 14/255, green: 165/255, blue: 233/255), primarySky],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(Capsule())
                .shadow(color: primarySky.opacity(0.35), radius: 12, y: 4)
            }
            
            // Split Group CTA (1/3 width)
            Button(action: {
                showSplitBillSheet = true
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(primarySky)
                    
                    Text("Split")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                .frame(width: 100)
                .frame(height: 52)
                .background(surfaceContainerLow)
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(Color.white.opacity(0.12), lineWidth: 1)
                )
            }
        }
    }
    
    // MARK: - 4. Group Balance Settlement Banner
    private var groupBalanceSettlementBanner: some View {
        HStack(spacing: 12) {
            // Marcus Avatar with Call Received Badge
            ZStack(alignment: .bottomTrailing) {
                AsyncImage(url: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuCrjrvhGFcSJU2Zd4Cz0JAA5kdEEqFJydlEqE1qQMBQIoKF84dHx5EruFawPjn8pH_DS6QLDWFcPTbi0QkJxaj1BR-r1o1xysi2haLa9XHpDAixQZ0FmOEBZwBpHor5o9AH36QAprlWSyKjqb1pfbzXJIjhj1n96OjCDUZj_tkDIxatbXGWrpaRghWBjIVEQ9gb59a0rGkIAYw54dfcdA-LW00mMamEHPm5OuHH6sFZn4IMNy2qZKYSqg")) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        Circle().fill(surfaceContainerHigh)
                    }
                }
                .frame(width: 42, height: 42)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                
                // Direction badge
                ZStack {
                    Circle()
                        .fill(secondaryMint)
                        .frame(width: 16, height: 16)
                    
                    Image(systemName: "arrow.down.left")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.black)
                }
                .offset(x: 2, y: 2)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("GROUP BALANCE")
                    .font(.system(size: 9.5, weight: .bold, design: .rounded))
                    .foregroundColor(slateMuted)
                    .tracking(0.6)
                
                if isSettledWithMarcus {
                    Text("Marcus is all settled up 🎉")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(secondaryMint)
                } else {
                    HStack(spacing: 4) {
                        Text("Marcus owes you")
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text(isUSD ? "$312.40" : "¥47,610")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundColor(secondaryMint)
                    }
                }
                
                Text("Hotel Deposit • Ryokan Aman Tokyo")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(slateMuted)
            }
            
            Spacer()
            
            // Settle Up Button
            Button(action: {
                withAnimation {
                    isSettledWithMarcus.toggle()
                    if isSettledWithMarcus {
                        triggerNotice("✅ Marked $312.40 from Marcus as Settled!")
                    } else {
                        triggerNotice("Reopened Marcus group balance.")
                    }
                }
            }) {
                Text(isSettledWithMarcus ? "Undo" : "Settle Up")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundColor(isSettledWithMarcus ? slateMuted : primarySky)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(surfaceContainer)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule().stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            }
        }
        .padding(14)
        .background(surfaceContainerLow)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(outlineBorder, lineWidth: 1)
        )
    }
    
    // MARK: - 5. Visual Analytics: Spending Breakdown Donut Chart
    private var spendingBreakdownDonutSection: some View {
        VStack(spacing: 16) {
            // Header Row
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Spending Breakdown")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("5 Active Allocation Buckets")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(slateMuted)
                }
                
                Spacer()
                
                Button(action: {
                    triggerNotice("📊 Exporting PDF Budget Statement...")
                }) {
                    ZStack {
                        Circle()
                            .fill(surfaceContainer)
                            .frame(width: 32, height: 32)
                            .overlay(
                                Circle().stroke(outlineBorder, lineWidth: 1)
                            )
                        
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(slateMuted)
                    }
                }
            }
            
            // Interactive Donut Chart Geometry
            ZStack {
                // Outer Donut Ring
                DonutChartView(
                    slices: [
                        DonutSlice(color: royalBlue, percentage: 0.38),
                        DonutSlice(color: primarySky, percentage: 0.32),
                        DonutSlice(color: amberGold, percentage: 0.18),
                        DonutSlice(color: emeraldGreen, percentage: 0.08),
                        DonutSlice(color: purpleAccent, percentage: 0.04)
                    ]
                )
                .frame(width: 190, height: 190)
                
                // Donut Core Badge
                VStack(spacing: 2) {
                    Text("TOTAL SPENT")
                        .font(.system(size: 9.5, weight: .bold, design: .rounded))
                        .foregroundColor(slateMuted)
                        .tracking(0.8)
                    
                    Text(isUSD ? "$4,180" : "¥637,100")
                        .font(.system(size: 22, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(isUSD ? "JPY 637,100" : "USD $4,180")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(secondaryMint)
                }
            }
            .padding(.vertical, 6)
            
            // Donut 2x2 Legend Grid
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                legendItem(title: "Flights & Rail", percent: "38%", color: royalBlue)
                legendItem(title: "Lodging", percent: "32%", color: primarySky)
                legendItem(title: "Food & Dining", percent: "18%", color: amberGold)
                legendItem(title: "Culture & Passes", percent: "8%", color: emeraldGreen)
            }
        }
        .padding(18)
        .background(surfaceContainerLow)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(outlineBorder, lineWidth: 1)
        )
    }
    
    private func legendItem(title: String, percent: String, color: Color) -> some View {
        HStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
                .shadow(color: color.opacity(0.8), radius: 4)
            
            Text(title)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(Color(red: 226/255, green: 232/255, blue: 240/255))
                .lineLimit(1)
            
            Spacer()
            
            Text(percent)
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(Color.black.opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
    }
    
    // MARK: - 6. Category Envelopes
    private var categoryEnvelopesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Category Envelopes")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    triggerNotice("🎯 Target budgets adjusted to safe thresholds")
                }) {
                    Text("MANAGE TARGETS")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(primarySky)
                        .tracking(0.6)
                }
            }
            .padding(.horizontal, 2)
            
            VStack(spacing: 10) {
                ForEach(categories) { envelope in
                    categoryCard(envelope: envelope)
                }
            }
        }
    }
    
    private func categoryCard(envelope: BudgetCategoryEnvelope) -> some View {
        VStack(spacing: 10) {
            HStack(spacing: 12) {
                // Category Icon
                ZStack {
                    Circle()
                        .fill(envelope.color.opacity(0.18))
                        .frame(width: 38, height: 38)
                        .overlay(
                            Circle().stroke(envelope.color.opacity(0.35), lineWidth: 1)
                        )
                    
                    Image(systemName: envelope.iconName)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(envelope.color)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(envelope.name)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(envelope.detail)
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(slateMuted)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(isUSD ? String(format: "$%.2f", envelope.spentUSD) : String(format: "¥%d", envelope.spentJPY))
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    let leftUSD = max(envelope.targetUSD - envelope.spentUSD, 0)
                    let leftJPY = max(envelope.targetJPY - envelope.spentJPY, 0)
                    let isTight = envelope.progress > 0.95
                    
                    Text(isUSD ? String(format: "$%.2f left", leftUSD) : String(format: "¥%d left", leftJPY))
                        .font(.system(size: 10.5, weight: .bold, design: .rounded))
                        .foregroundColor(isTight ? Color.red.opacity(0.9) : secondaryMint)
                }
            }
            
            // Progress Track
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.black.opacity(0.6))
                        .frame(height: 7)
                    
                    Capsule()
                        .fill(envelope.color)
                        .frame(width: geo.size.width * CGFloat(envelope.progress), height: 7)
                        .shadow(color: envelope.color.opacity(0.7), radius: 4)
                }
            }
            .frame(height: 7)
        }
        .padding(14)
        .background(surfaceContainerLow)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(outlineBorder, lineWidth: 1)
        )
    }
    
    // MARK: - 7. Recent Transactions Feed
    private var recentTransactionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 8) {
                    Text("Recent Activity")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("\(transactions.count)")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundColor(slateMuted)
                        .frame(width: 20, height: 20)
                        .background(surfaceContainer)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(outlineBorder, lineWidth: 1)
                        )
                }
                
                Spacer()
                
                Button(action: {
                    triggerNotice("📜 Viewing all 48 trip transactions")
                }) {
                    Text("VIEW ALL")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(primarySky)
                        .tracking(0.6)
                }
            }
            .padding(.horizontal, 2)
            
            VStack(spacing: 0) {
                ForEach(Array(transactions.enumerated()), id: \.element.id) { index, item in
                    transactionRow(item: item)
                    
                    if index < transactions.count - 1 {
                        Divider()
                            .background(Color.white.opacity(0.06))
                            .padding(.leading, 56)
                    }
                }
            }
            .background(surfaceContainerLow)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(outlineBorder, lineWidth: 1)
            )
        }
    }
    
    private func transactionRow(item: ExpenseTransaction) -> some View {
        HStack(spacing: 12) {
            // Category Icon Pin
            ZStack {
                Circle()
                    .fill(item.categoryColor.opacity(0.18))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Circle().stroke(item.categoryColor.opacity(0.35), lineWidth: 1)
                    )
                
                Image(systemName: item.iconName)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(item.categoryColor)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.system(size: 13.5, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                HStack(spacing: 4) {
                    Text(item.timeAgo)
                    Text("•")
                    Text(item.category)
                        .foregroundColor(item.categoryColor)
                    Text("•")
                    Text(item.location)
                }
                .font(.system(size: 10.5, weight: .medium, design: .rounded))
                .foregroundColor(slateMuted)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 1) {
                Text(isUSD ? String(format: "-$%.2f", item.amountUSD) : String(format: "-¥%d", item.amountJPY))
                    .font(.system(size: 13.5, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text(isUSD ? String(format: "¥%d", item.amountJPY) : String(format: "$%.2f", item.amountUSD))
                    .font(.system(size: 10.5, weight: .medium, design: .rounded))
                    .foregroundColor(slateMuted)
            }
        }
        .padding(14)
    }
    
    // MARK: - 8. Shared Travelers Section
    private var sharedTravelersSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("SHARED EXPENSE GROUP")
                .font(.system(size: 10, weight: .bold, design: .rounded))
                .foregroundColor(slateMuted)
                .tracking(0.6)
                .padding(.horizontal, 2)
            
            HStack(spacing: 10) {
                // Traveler 1: Elena
                HStack(spacing: 10) {
                    AsyncImage(url: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuDzeY-G7eFFeDZXXjVdI5eD-pIw0maVL-xQkO0y1byke7YFg-m3hsfjGHfnI9OquYqDmIitONJQL57oXzPkJ-yc00RbUlMedSM_U0ePwQTyvOGUbF5imyhs0OShQrrVVxo8z4I3KXWIEBS7NUlZ-_fRz82XybMk0eabc60bN9z3RcTLPp6joosgAOL9mmvOXSh5O6dXchXyjOQEpzZRBGwk1treoD5_jcfcnOfSx1TuwXlZUFTG4ZhzxQ")) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else {
                            Circle().fill(surfaceContainerHigh)
                        }
                    }
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white.opacity(0.12), lineWidth: 1))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Elena Vance")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Settled Up")
                            .font(.system(size: 10.5, weight: .semibold, design: .rounded))
                            .foregroundColor(secondaryMint)
                    }
                    
                    Spacer()
                }
                .padding(10)
                .background(surfaceContainerLow)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(outlineBorder, lineWidth: 1)
                )
                
                // Traveler 2: Marcus
                HStack(spacing: 10) {
                    AsyncImage(url: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuDCdtLmCcKCN4Hp2T__jMT-pbLt2Dvsmn_2rebENeyOqp5bcXZ8VRcnx4MN2822LKbl71uz_m-IHyjNEt_vPltNhOMe1Eep1mftu-x4PuDlL4tJ5uosVluk2tNij0LXSJMK_jOjyFRK_vt9H0Bg-qCvw0jkvC4YC5lMvcp3z0PftpyaTtGX1vpd0Koz6NFQheGK0mBcwcCI8vzZbyxytBMMzetYbYbjMOs2xbMI4Qptu08cU3RE_ksqoA")) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else {
                            Circle().fill(surfaceContainerHigh)
                        }
                    }
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white.opacity(0.12), lineWidth: 1))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Marcus Chen")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text(isSettledWithMarcus ? "Settled Up" : "Owes $312.40")
                            .font(.system(size: 10.5, weight: .semibold, design: .rounded))
                            .foregroundColor(isSettledWithMarcus ? secondaryMint : primaryBlue)
                    }
                    
                    Spacer()
                }
                .padding(10)
                .background(surfaceContainerLow)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(outlineBorder, lineWidth: 1)
                )
            }
        }
    }
    
    // MARK: - Modals
    private var logExpenseModalSheet: some View {
        LogExpenseSheet(isUSD: isUSD) { newExpense in
            withAnimation {
                transactions.insert(newExpense, at: 0)
                triggerNotice("📸 Logged \(newExpense.title) (\(String(format: "$%.2f", newExpense.amountUSD)))!")
            }
        }
    }
    
    private var splitBillModalSheet: some View {
        SplitBillSheet(isUSD: isUSD) { amountPerPerson in
            triggerNotice("👥 Bill split requested: $\(String(format: "%.2f", amountPerPerson)) per person")
        }
    }
    
    private func triggerNotice(_ message: String) {
        withAnimation {
            activeNotice = message
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) {
            withAnimation {
                if activeNotice == message {
                    activeNotice = nil
                }
            }
        }
    }
}

// MARK: - Donut Chart Helper Shape
struct DonutSlice: Identifiable {
    let id = UUID()
    let color: Color
    let percentage: Double
}

struct DonutChartView: View {
    let slices: [DonutSlice]
    
    var body: some View {
        ZStack {
            // Background track
            Circle()
                .stroke(Color(red: 26/255, green: 35/255, blue: 51/255), lineWidth: 22)
            
            // Render Slices
            ForEach(0..<slices.count, id: \.self) { index in
                let startAngle = angle(for: index)
                let endAngle = startAngle + Angle(degrees: slices[index].percentage * 360)
                
                DonutSliceShape(startAngle: startAngle, endAngle: endAngle)
                    .stroke(
                        slices[index].color,
                        style: StrokeStyle(lineWidth: 22, lineCap: .round)
                    )
                    .shadow(color: slices[index].color.opacity(0.4), radius: 6)
            }
        }
    }
    
    private func angle(for index: Int) -> Angle {
        var totalPercent: Double = 0
        for i in 0..<index {
            totalPercent += slices[i].percentage
        }
        return Angle(degrees: (totalPercent * 360) - 90)
    }
}

struct DonutSliceShape: Shape {
    let startAngle: Angle
    let endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = (min(rect.width, rect.height) - 22) / 2
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        return path
    }
}

// MARK: - Submodal: Log Expense Sheet
struct LogExpenseSheet: View {
    @Environment(\.dismiss) private var dismiss
    let isUSD: Bool
    var onSave: (ExpenseTransaction) -> Void
    
    @State private var merchantName: String = ""
    @State private var amountText: String = ""
    @State private var selectedCategory: String = "Dining"
    @State private var location: String = "Tokyo, Japan"
    
    private let categories = ["Dining", "Transit", "Culture", "Lodging", "Shopping"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Amount Hero Input
                        VStack(spacing: 6) {
                            Text(isUSD ? "AMOUNT (USD)" : "AMOUNT (JPY)")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                                .foregroundColor(Color(red: 148/255, green: 163/255, blue: 184/255))
                                .tracking(1)
                            
                            HStack(alignment: .firstTextBaseline, spacing: 4) {
                                Text(isUSD ? "$" : "¥")
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                                    .foregroundColor(Color(red: 56/255, green: 189/255, blue: 248/255))
                                
                                TextField("0.00", text: $amountText)
                                    .font(.system(size: 44, weight: .heavy, design: .rounded))
                                    .foregroundColor(.white)
                                    .keyboardType(.decimalPad)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .padding(20)
                        .background(Color(red: 17/255, green: 24/255, blue: 39/255))
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                        
                        // Merchant Name
                        VStack(alignment: .leading, spacing: 6) {
                            Text("MERCHANT / EXPENSE")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                                .foregroundColor(Color(red: 148/255, green: 163/255, blue: 184/255))
                            
                            TextField("e.g. Starbucks Reserve Roastery", text: $merchantName)
                                .font(.system(size: 15))
                                .foregroundColor(.white)
                                .padding(14)
                                .background(Color(red: 17/255, green: 24/255, blue: 39/255))
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                )
                        }
                        
                        // Category Selector
                        VStack(alignment: .leading, spacing: 8) {
                            Text("CATEGORY")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                                .foregroundColor(Color(red: 148/255, green: 163/255, blue: 184/255))
                            
                            HStack(spacing: 8) {
                                ForEach(categories, id: \.self) { cat in
                                    Button(action: {
                                        selectedCategory = cat
                                    }) {
                                        Text(cat)
                                            .font(.system(size: 12, weight: .bold, design: .rounded))
                                            .foregroundColor(selectedCategory == cat ? .black : .white)
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 8)
                                            .background(selectedCategory == cat ? Color(red: 56/255, green: 189/255, blue: 248/255) : Color(red: 24/255, green: 34/255, blue: 52/255))
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                        }
                        
                        // Receipt Scan Button
                        Button(action: {}) {
                            HStack(spacing: 8) {
                                Image(systemName: "doc.text.viewfinder")
                                    .font(.system(size: 16))
                                Text("Scan Physical Receipt with Camera")
                                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                            }
                            .foregroundColor(Color(red: 142/255, green: 213/255, blue: 255/255))
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Color(red: 17/255, green: 24/255, blue: 39/255))
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(Color(red: 56/255, green: 189/255, blue: 248/255).opacity(0.3), lineWidth: 1)
                            )
                        }
                        .padding(.top, 6)
                        
                        // Save Button
                        Button(action: {
                            let amount = Double(amountText) ?? 24.50
                            let title = merchantName.isEmpty ? "Tokyo Cafe & Dining" : merchantName
                            let newExp = ExpenseTransaction(
                                title: title,
                                subtitle: "Logged in Tokyo",
                                category: selectedCategory,
                                categoryColor: Color(red: 245/255, green: 158/255, blue: 11/255),
                                iconName: "fork.knife",
                                timeAgo: "Just now",
                                location: location,
                                amountUSD: amount,
                                amountJPY: Int(amount * 152.40)
                            )
                            onSave(newExp)
                            dismiss()
                        }) {
                            Text("Save to Trip Budget")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(
                                    LinearGradient(
                                        colors: [Color(red: 2/255, green: 132/255, blue: 199/255), Color(red: 56/255, green: 189/255, blue: 248/255)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .clipShape(Capsule())
                                .shadow(color: Color(red: 56/255, green: 189/255, blue: 248/255).opacity(0.35), radius: 10, y: 4)
                        }
                        .padding(.top, 10)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Log New Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(Color(red: 56/255, green: 189/255, blue: 248/255))
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

// MARK: - Submodal: Split Bill Sheet
struct SplitBillSheet: View {
    @Environment(\.dismiss) private var dismiss
    let isUSD: Bool
    var onSplitRequested: (Double) -> Void
    
    @State private var totalBill: String = "240.00"
    @State private var numberOfPeople: Int = 3
    
    private var perPersonAmount: Double {
        let total = Double(totalBill) ?? 0.0
        guard numberOfPeople > 0 else { return 0.0 }
        return total / Double(numberOfPeople)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Calculation Card
                    VStack(spacing: 8) {
                        Text("EACH PERSON PAYS")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(Color(red: 148/255, green: 163/255, blue: 184/255))
                            .tracking(1)
                        
                        Text(String(format: "$%.2f", perPersonAmount))
                            .font(.system(size: 48, weight: .heavy, design: .rounded))
                            .foregroundColor(Color(red: 68/255, green: 226/255, blue: 205/255))
                        
                        Text(String(format: "JPY ¥%d per traveler", Int(perPersonAmount * 152.40)))
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundColor(Color(red: 148/255, green: 163/255, blue: 184/255))
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 17/255, green: 24/255, blue: 39/255))
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                    
                    // Stepper for number of people
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Split Between")
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            Text("Elena, Marcus + Guests")
                                .font(.system(size: 12))
                                .foregroundColor(Color(red: 148/255, green: 163/255, blue: 184/255))
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 14) {
                            Button(action: {
                                if numberOfPeople > 2 { numberOfPeople -= 1 }
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(numberOfPeople > 2 ? Color(red: 56/255, green: 189/255, blue: 248/255) : Color.gray.opacity(0.4))
                            }
                            
                            Text("\(numberOfPeople)")
                                .font(.system(size: 20, weight: .heavy, design: .rounded))
                                .foregroundColor(.white)
                                .frame(minWidth: 28)
                            
                            Button(action: {
                                if numberOfPeople < 12 { numberOfPeople += 1 }
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(Color(red: 56/255, green: 189/255, blue: 248/255))
                            }
                        }
                    }
                    .padding(16)
                    .background(Color(red: 17/255, green: 24/255, blue: 39/255))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    
                    Spacer()
                    
                    // Send Request Button
                    Button(action: {
                        onSplitRequested(perPersonAmount)
                        dismiss()
                    }) {
                        Text("Send Split Request via Apple Pay")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(
                                LinearGradient(
                                    colors: [Color(red: 37/255, green: 99/255, blue: 235/255), Color(red: 56/255, green: 189/255, blue: 248/255)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(Capsule())
                    }
                }
                .padding(20)
            }
            .navigationTitle("Split Group Bill")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(Color(red: 56/255, green: 189/255, blue: 248/255))
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    BudgetExpensesView()
}
