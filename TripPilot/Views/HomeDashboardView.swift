//
//  HomeDashboardView.swift
//  TripPilot
//
//  Generated from Stitch Screen: f3fd16dc7489464189dc3fccc51d45f0
//  Title: TripPilot - Home Dashboard (Dark Mode)
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct HomeDashboardView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: AppTab = .home
    @State private var isLivePulsing: Bool = false
    @State private var showBoardingPassModal: Bool = false
    @State private var showFlyoverMapModal: Bool = false
    @State private var activeUtilityNotice: String? = nil
    @State private var navigateToMyTrips: Bool = false
    @State private var navigateToItinerary: Bool = false
    @State private var navigateToInteractiveMap: Bool = false
    
    // Stitch Theme Colors
    private let darkBackground = Color(red: 10/255, green: 14/255, blue: 22/255)       // #0a0e16 / #000000
    private let surfaceDark = Color(red: 17/255, green: 24/255, blue: 39/255)          // #111827
    private let surfaceCard = Color(red: 22/255, green: 31/255, blue: 48/255)          // #161f30
    private let containerBorder = Color.white.opacity(0.08)
    private let primaryCyan = Color(red: 68/255, green: 226/255, blue: 205/255)        // #44e2cd
    private let skyBlue = Color(red: 56/255, green: 189/255, blue: 248/255)           // #38bdf8
    private let slateLight = Color(red: 226/255, green: 232/255, blue: 240/255)       // slate-200
    private let slateMuted = Color(red: 148/255, green: 163/255, blue: 184/255)       // slate-400
    private let slateDark = Color(red: 30/255, green: 41/255, blue: 59/255)           // #1e293b
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background
            darkBackground
                .ignoresSafeArea()
            
            // Ambient Top/Bottom Glows
            GeometryReader { _ in
                Circle()
                    .fill(skyBlue.opacity(0.07))
                    .frame(width: 320, height: 320)
                    .blur(radius: 80)
                    .offset(x: -60, y: -40)
                
                Circle()
                    .fill(primaryCyan.opacity(0.05))
                    .frame(width: 280, height: 280)
                    .blur(radius: 70)
                    .offset(x: 160, y: 360)
            }
            .ignoresSafeArea()
            
            // Scrollable Content
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // MARK: - App Navigation Header
                    navigationHeaderSection
                        .padding(.top, 8)
                    
                    // MARK: - 1. Live Flight Status Floating Capsule
                    liveFlightStatusCapsule
                    
                    // MARK: - 2. Personalized Greeting & Local Weather Capsule
                    greetingWeatherSection
                    
                    // MARK: - 3. Hero Upcoming Trip Card ("Autumn in Japan")
                    Button(action: {
                        navigateToMyTrips = true
                    }) {
                        heroTripCard
                    }
                    .buttonStyle(.plain)
                    
                    // MARK: - 4. Today's Live Itinerary Timeline Widget
                    todayScheduleWidget
                    
                    // MARK: - 5. Interactive Map Preview Widget
                    explorationMapWidget
                    
                    // MARK: - 6. Travel Statistics & Quick Budget 2-Column Grid
                    statsAndBudgetGrid
                    
                    // MARK: - 7. Smart Utilities Carousel Pills
                    smartUtilitiesSection
                    
                    // Bottom spacing for floating tab bar
                    Spacer()
                        .frame(height: 100)
                }
                .padding(.horizontal, 18)
            }
            
            // MARK: - 8. Floating Glassmorphic Bottom Tab Bar
            FloatingBottomNavBar(selectedTab: $selectedTab) { tab in
                if tab == .itinerary {
                    navigateToItinerary = true
                } else if tab == .map {
                    navigateToInteractiveMap = true
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 8)
        }
        .navigationBarBackButtonHidden(true)
        .preferredColorScheme(.dark)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                isLivePulsing = true
            }
        }
        .sheet(isPresented: $showBoardingPassModal) {
            boardingPassModalView
        }
        .sheet(isPresented: $showFlyoverMapModal) {
            flyoverMapModalView
        }
        .navigationDestination(isPresented: $navigateToMyTrips) {
            MyTripsHubView()
        }
        .navigationDestination(isPresented: $navigateToItinerary) {
            DailyItineraryView()
        }
        .navigationDestination(isPresented: $navigateToInteractiveMap) {
            InteractiveMapView()
        }
        .overlay(alignment: .top) {
            if let notice = activeUtilityNotice {
                Text(notice)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .background(surfaceCard)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(skyBlue.opacity(0.4), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.5), radius: 10, y: 5)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .padding(.top, 50)
                    .zIndex(100)
            }
        }
    }
    
    // MARK: - Top Navigation Header
    private var navigationHeaderSection: some View {
        HStack(alignment: .center, spacing: 12) {
            // Brand Logo & Title
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [skyBlue, Color(red: 2/255, green: 132/255, blue: 199/255)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 36, height: 36)
                        .shadow(color: skyBlue.opacity(0.35), radius: 8, y: 2)
                    
                    Image(systemName: "airplane")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(-45))
                }
                
                VStack(alignment: .leading, spacing: 1) {
                    Text("TripPilot")
                        .font(.system(size: 19, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .fixedSize(horizontal: true, vertical: false)
                    
                    Text("HOME")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(slateMuted)
                        .tracking(1.2)
                }
            }
            
            Spacer()
            
            // Flight quick tag
            HStack(spacing: 5) {
                Image(systemName: "airplane.departure")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(skyBlue)
                
                Text("JL 005")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundColor(slateLight)
            }
            .padding(.horizontal, 9)
            .padding(.vertical, 5)
            .background(surfaceDark.opacity(0.9))
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
            )
            
            // Notification & Profile Buttons
            HStack(spacing: 10) {
                Button(action: {
                    triggerNotice("🔔 No new notifications")
                }) {
                    ZStack(alignment: .topTrailing) {
                        Circle()
                            .fill(surfaceCard)
                            .frame(width: 38, height: 38)
                            .overlay(
                                Circle()
                                    .stroke(containerBorder, lineWidth: 1)
                            )
                        
                        Image(systemName: "bell.fill")
                            .font(.system(size: 14))
                            .foregroundColor(slateLight)
                            .frame(width: 38, height: 38)
                        
                        Circle()
                            .fill(Color.red)
                            .frame(width: 8, height: 8)
                            .overlay(Circle().stroke(Color.black, lineWidth: 1.5))
                            .offset(x: -2, y: 2)
                    }
                }
                
                Button(action: {
                    triggerNotice("👤 Elena's Traveler Profile (Frequent Flyer Diamond)")
                }) {
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
                                    .stroke(skyBlue.opacity(0.8), lineWidth: 2)
                            )
                        
                        Text("E")
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
    
    // MARK: - 1. Live Flight Status Floating Capsule
    private var liveFlightStatusCapsule: some View {
        HStack(spacing: 12) {
            // Live Status Indicator Pulse
            ZStack {
                Circle()
                    .fill(skyBlue.opacity(isLivePulsing ? 0.35 : 0.15))
                    .frame(width: 22, height: 22)
                    .scaleEffect(isLivePulsing ? 1.3 : 0.9)
                
                Circle()
                    .fill(skyBlue)
                    .frame(width: 10, height: 10)
                    .shadow(color: skyBlue, radius: 4)
            }
            .frame(width: 22, height: 22)
            
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text("JL 006")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Gate 42B")
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundColor(slateLight)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 2)
                        .background(Color.white.opacity(0.1))
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(Color.white.opacity(0.08), lineWidth: 1)
                        )
                    
                    Text("On Time")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundColor(primaryCyan)
                }
                
                Text("Departs in 1h 45m • SFO Terminal 2")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(slateMuted)
            }
            
            Spacer()
            
            // View Boarding Pass Button
            Button(action: {
                showBoardingPassModal = true
            }) {
                HStack(spacing: 4) {
                    Image(systemName: "qrcode")
                        .font(.system(size: 13, weight: .bold))
                    Text("Pass")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                }
                .foregroundColor(skyBlue)
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(skyBlue.opacity(0.15))
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(skyBlue.opacity(0.35), lineWidth: 1)
                )
                .shadow(color: skyBlue.opacity(0.2), radius: 6)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(surfaceDark.opacity(0.95))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(containerBorder, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.4), radius: 12, y: 4)
    }
    
    // MARK: - 2. Personalized Greeting & Local Weather Capsule
    private var greetingWeatherSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Good morning, Elena 👋")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Your adventure in Tokyo & Kyoto starts in 3 days.")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(slateMuted)
            }
            
            // Weather & Air Quality Micro Capsule
            HStack(spacing: 8) {
                Image(systemName: "cloud.sun.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.yellow, skyBlue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text("Tokyo 19°C")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Partly Sunny")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(slateMuted)
                
                Circle()
                    .fill(Color(white: 0.4))
                    .frame(width: 3, height: 3)
                
                Text("AQI 24 Good")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundColor(primaryCyan)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(surfaceCard.opacity(0.9))
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(containerBorder, lineWidth: 1)
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - 3. Hero Upcoming Trip Card: Autumn in Japan
    private var heroTripCard: some View {
        VStack(spacing: 0) {
            // Visual Image Header with Scrim
            ZStack(alignment: .bottomLeading) {
                // Background Cover Image
                AsyncImage(url: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuA7tmYajqiNYfg9w660mHGO_ILeXocc3W8atrwYJSvut93DCIWdqSCWTV80JxqK5mEOgaf4xHA05yV-1IbEsoBBYWyr6L0-7bGSihCsOZ18WhgtqaIYmv4UpOZOkAti5bPd1oV29kQayKjPfd6zKFO7zO0LU_V1b60Jk0uJ34fscQex2EZjAbJCQI2qyn7tCX-XwIv4cqegFz0agf4dHhhShzZ0jQ45ntcjhoR7DBZzwdaWr_fzVDf90g")) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        ZStack {
                            LinearGradient(
                                colors: [Color(red: 30/255, green: 41/255, blue: 59/255), Color(red: 15/255, green: 23/255, blue: 42/255)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            Image(systemName: "mountain.2.fill")
                                .font(.system(size: 48))
                                .foregroundColor(Color.white.opacity(0.15))
                        }
                    }
                }
                .frame(height: 190)
                .clipped()
                
                // Gradient Scrim Overlays
                LinearGradient(
                    colors: [Color.clear, surfaceDark.opacity(0.6), surfaceDark],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 190)
                
                // Top Floating Badge
                VStack {
                    HStack {
                        HStack(spacing: 5) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(skyBlue)
                            Text("Featured Journey")
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .textCase(.uppercase)
                                .tracking(0.6)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.black.opacity(0.65))
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(Color.white.opacity(0.15), lineWidth: 1)
                        )
                        
                        Spacer()
                    }
                    .padding(12)
                    
                    Spacer()
                }
                
                // Hero Trip Title Over Scrim
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("OCT 24 – NOV 04 • 12 DAYS")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(skyBlue)
                            .tracking(0.6)
                        
                        Spacer()
                        
                        Text("Day 1 of 12")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(skyBlue.opacity(0.25))
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(skyBlue.opacity(0.35), lineWidth: 1)
                            )
                    }
                    
                    Text("Autumn in Japan 🍁")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.system(size: 12))
                            .foregroundColor(slateMuted)
                        Text("Tokyo, Hakone & Kyoto")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(slateLight)
                    }
                }
                .padding(14)
            }
            .frame(height: 190)
            
            // Card Interior & Details
            VStack(spacing: 14) {
                // Trip Readiness Progress Bar
                VStack(spacing: 6) {
                    HStack {
                        HStack(spacing: 5) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 13))
                                .foregroundColor(primaryCyan)
                            Text("Packing & Docs Prepared")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(slateLight)
                        }
                        
                        Spacer()
                        
                        Text("85%")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    
                    // Progress Bar
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(slateDark)
                                .frame(height: 7)
                            
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [skyBlue, primaryCyan],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geo.size.width * 0.85, height: 7)
                                .shadow(color: skyBlue.opacity(0.4), radius: 6)
                        }
                    }
                    .frame(height: 7)
                }
                
                // Quick Context Chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        chipBadge(icon: "airplane", text: "HND Confirmed", iconColor: skyBlue)
                        chipBadge(icon: "bed.double.fill", text: "Aman Tokyo (4n)", iconColor: primaryCyan)
                        chipBadge(icon: "tram.fill", text: "JR Pass Active", iconColor: Color(red: 96/255, green: 165/255, blue: 250/255))
                    }
                }
            }
            .padding(16)
            .background(surfaceDark)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(containerBorder, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.5), radius: 14, y: 6)
    }
    
    private func chipBadge(icon: String, text: String, iconColor: Color) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(iconColor)
            Text(text)
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundColor(slateLight)
                .fixedSize(horizontal: true, vertical: false)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(surfaceCard)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }
    
    // MARK: - 4. Today's Live Itinerary Timeline Widget
    private var todayScheduleWidget: some View {
        VStack(spacing: 16) {
            // Header Row
            HStack {
                HStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(skyBlue.opacity(0.15))
                            .frame(width: 32, height: 32)
                            .overlay(
                                Circle()
                                    .stroke(skyBlue.opacity(0.25), lineWidth: 1)
                            )
                        
                        Image(systemName: "clock.fill")
                            .font(.system(size: 14))
                            .foregroundColor(skyBlue)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Today's Schedule")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Thursday, Oct 24 • Departure Day")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(slateMuted)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    triggerNotice("📅 Opening Complete 12-Day Trip Timeline")
                }) {
                    HStack(spacing: 3) {
                        Text("Timeline")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 10, weight: .bold))
                    }
                    .foregroundColor(skyBlue)
                }
            }
            
            // Stepper Timeline List with Vertical Guide
            ZStack(alignment: .leading) {
                // Continuous Vertical Guide Line
                Rectangle()
                    .fill(Color.white.opacity(0.12))
                    .frame(width: 2)
                    .padding(.leading, 12)
                    .padding(.vertical, 16)
                
                VStack(alignment: .leading, spacing: 14) {
                    // Item 1: Flight
                    timelineItemView(
                        time: "10:30 AM",
                        tag: "Now Boarding",
                        tagColor: skyBlue,
                        title: "Flight JL 006 (SFO → HND)",
                        subtitle: "Boeing 777-300ER • In-flight dining & ultra-fast Wi-Fi ready",
                        iconName: "airplane.departure",
                        iconBgColor: skyBlue,
                        iconFgColor: .black,
                        showGlow: true
                    )
                    
                    // Item 2: Transfer
                    timelineItemView(
                        time: "02:45 PM",
                        tag: "Pre-paid",
                        tagColor: slateLight,
                        title: "Private Haneda Limousine Transfer",
                        subtitle: "Driver: Kenjiro Sato (Toyota Alphard Executive Lounge)",
                        iconName: "car.fill",
                        iconBgColor: slateDark,
                        iconFgColor: slateLight,
                        showGlow: false
                    )
                    
                    // Item 3: Hotel Check-in
                    timelineItemView(
                        time: "04:30 PM",
                        tag: "Suite Confirmed",
                        tagColor: primaryCyan,
                        title: "Check-in at Aman Tokyo",
                        subtitle: "The Otemachi Tower • Early room entry requested",
                        iconName: "building.2.fill",
                        iconBgColor: slateDark,
                        iconFgColor: slateLight,
                        showGlow: false
                    )
                    
                    // Item 4: Omakase Dinner
                    timelineItemView(
                        time: "07:00 PM",
                        tag: "3 Michelin ⭐",
                        tagColor: skyBlue,
                        title: "Omakase at Sushi Yoshitake",
                        subtitle: "Ginza 7-Chome • Smart casual attire required",
                        iconName: "fork.knife",
                        iconBgColor: Color(red: 14/255, green: 165/255, blue: 233/255),
                        iconFgColor: .white,
                        showGlow: true
                    )
                }
            }
        }
        .padding(16)
        .background(surfaceDark)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(containerBorder, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.4), radius: 12, y: 4)
    }
    
    private func timelineItemView(
        time: String,
        tag: String,
        tagColor: Color,
        title: String,
        subtitle: String,
        iconName: String,
        iconBgColor: Color,
        iconFgColor: Color,
        showGlow: Bool
    ) -> some View {
        HStack(alignment: .top, spacing: 12) {
            // Icon Pin
            ZStack {
                Circle()
                    .fill(iconBgColor)
                    .frame(width: 26, height: 26)
                    .overlay(
                        Circle()
                            .stroke(surfaceDark, lineWidth: 3)
                    )
                    .shadow(color: showGlow ? iconBgColor.opacity(0.6) : Color.clear, radius: 6)
                
                Image(systemName: iconName)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(iconFgColor)
            }
            
            // Content Box
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(time)
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(showGlow ? skyBlue : .white)
                    
                    Spacer()
                    
                    Text(tag)
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(tagColor)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 2)
                        .background(tagColor.opacity(0.15))
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(tagColor.opacity(0.25), lineWidth: 0.8)
                        )
                }
                
                Text(title)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(slateMuted)
                    .lineLimit(2)
            }
            .padding(12)
            .background(surfaceCard.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(containerBorder, lineWidth: 1)
            )
        }
    }
    
    // MARK: - 5. Interactive Map Preview Widget
    private var explorationMapWidget: some View {
        VStack(spacing: 12) {
            // Header Row
            HStack {
                HStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(skyBlue.opacity(0.15))
                            .frame(width: 32, height: 32)
                            .overlay(
                                Circle()
                                    .stroke(skyBlue.opacity(0.25), lineWidth: 1)
                            )
                        
                        Image(systemName: "map.fill")
                            .font(.system(size: 14))
                            .foregroundColor(skyBlue)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Exploration Map")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Tokyo Metropolis Area")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(slateMuted)
                    }
                }
                
                Spacer()
                
                Text("4 Pinned Today")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundColor(slateLight)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 4)
                    .background(Color.white.opacity(0.1))
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            }
            
            // Interactive Map Visual Container
            Button(action: {
                navigateToInteractiveMap = true
            }) {
                ZStack(alignment: .bottom) {
                    // Map Background Image / Stylized Dark Map
                    AsyncImage(url: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuCBswjeA9E6H5-auy_pJnDKEtaJLNUvqbvf3VPGIjVjZs-wLN13iS3GrTs1rrz8tYL4Z3yITzHW4ccdBnteHCY3sexPvXTWAmL95iBU6bhLhqO9pLYVL_Cd9jSjpHKIAJXxx9P0OGP5cYO-BgmzE2o8fzhQq1VjwCqQXAnq3zsH_PTIJlDi1e5LGpsBKkg3mpWyOQr4yVQlbL8C7pE4quFu3u4eJqWmMWdFXbjf6T8MHI3JV2DLD-rL1Q")) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else {
                            ZStack {
                                LinearGradient(
                                    colors: [Color(red: 15/255, green: 23/255, blue: 42/255), Color(red: 30/255, green: 41/255, blue: 59/255)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                Image(systemName: "map")
                                    .font(.system(size: 44))
                                    .foregroundColor(Color.white.opacity(0.1))
                            }
                        }
                    }
                    .frame(height: 160)
                    .clipped()
                    
                    // Gradient Scrim Over Map
                    LinearGradient(
                        colors: [Color.clear, Color.black.opacity(0.4), Color.black.opacity(0.85)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    
                    // Floating Pinned Location Tags & Action
                    VStack(spacing: 8) {
                        HStack(spacing: 6) {
                            mapTagPill(name: "Shibuya Crossing", dotColor: skyBlue)
                            mapTagPill(name: "Ginza Six", dotColor: primaryCyan)
                            mapTagPill(name: "Roppongi Hills", dotColor: Color(red: 96/255, green: 165/255, blue: 250/255))
                            Spacer()
                        }
                        
                        HStack {
                            Text("Tap to launch 3D Flyover Map")
                                .font(.system(size: 12, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Image(systemName: "arrow.up.right.square.fill")
                                .font(.system(size: 15))
                                .foregroundColor(skyBlue)
                        }
                    }
                    .padding(12)
                }
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(containerBorder, lineWidth: 1)
                )
            }
        }
        .padding(16)
        .background(surfaceDark)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(containerBorder, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.4), radius: 12, y: 4)
    }
    
    private func mapTagPill(name: String, dotColor: Color) -> some View {
        HStack(spacing: 4) {
            Circle()
                .fill(dotColor)
                .frame(width: 6, height: 6)
                .shadow(color: dotColor, radius: 4)
            Text(name)
                .font(.system(size: 10, weight: .bold, design: .rounded))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(surfaceDark.opacity(0.9))
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(Color.white.opacity(0.15), lineWidth: 0.8)
        )
    }
    
    // MARK: - 6. Travel Statistics & Quick Budget 2-Column Grid
    private var statsAndBudgetGrid: some View {
        HStack(spacing: 12) {
            // Card 1: Trip Budget Progress
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("TRIP BUDGET")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(slateMuted)
                        .tracking(0.6)
                    
                    Spacer()
                    
                    Image(systemName: "wallet.pass.fill")
                        .font(.system(size: 14))
                        .foregroundColor(skyBlue)
                }
                
                HStack(spacing: 10) {
                    // Circular Ring Progress
                    ZStack {
                        Circle()
                            .stroke(slateDark, lineWidth: 4)
                            .frame(width: 44, height: 44)
                        
                        Circle()
                            .trim(from: 0, to: 0.71)
                            .stroke(skyBlue, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                            .frame(width: 44, height: 44)
                            .rotationEffect(.degrees(-90))
                        
                        Text("71%")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("$4,250")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("of $6,000 cap")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(slateMuted)
                    }
                }
                
                Text("$1,750 remaining")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(primaryCyan)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
                    .background(surfaceCard)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.06), lineWidth: 1)
                    )
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(surfaceDark)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(containerBorder, lineWidth: 1)
            )
            
            // Card 2: Bookmarks & Saved Spots
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("BOOKMARKS")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(slateMuted)
                        .tracking(0.6)
                    
                    Spacer()
                    
                    Image(systemName: "bookmark.fill")
                        .font(.system(size: 14))
                        .foregroundColor(primaryCyan)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("28")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Spots Saved in Tokyo")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(slateMuted)
                }
                
                // Overlapping Emoji Stack
                HStack(spacing: -6) {
                    emojiPill(emoji: "🍜", color: skyBlue)
                    emojiPill(emoji: "🏯", color: primaryCyan)
                    emojiPill(emoji: "☕", color: Color.orange)
                    
                    Text("+25")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(slateLight)
                        .frame(width: 24, height: 24)
                        .background(slateDark)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(surfaceDark, lineWidth: 1.5)
                        )
                }
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(surfaceDark)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(containerBorder, lineWidth: 1)
            )
        }
    }
    
    private func emojiPill(emoji: String, color: Color) -> some View {
        Text(emoji)
            .font(.system(size: 11))
            .frame(width: 24, height: 24)
            .background(color.opacity(0.2))
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(surfaceDark, lineWidth: 1.5)
            )
    }
    
    // MARK: - 7. Smart Utilities Carousel Pills
    private var smartUtilitiesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Smart Utilities")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("Swift Access")
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundColor(slateMuted)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    // Action 1: Add Activity
                    Button(action: {
                        triggerNotice("➕ New Activity Creator Opened")
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 14, weight: .bold))
                            Text("Add Activity")
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                        }
                        .foregroundColor(Color(red: 10/255, green: 14/255, blue: 22/255))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(skyBlue)
                        .clipShape(Capsule())
                        .shadow(color: skyBlue.opacity(0.35), radius: 8, y: 2)
                    }
                    
                    // Action 2: Scan Pass
                    utilityButton(icon: "doc.text.viewfinder", text: "Scan Pass", iconColor: skyBlue) {
                        triggerNotice("📷 Document & Pass Scanner Ready")
                    }
                    
                    // Action 3: Currency Converter
                    utilityButton(icon: "dollarsign.arrow.circlepath", text: "1 USD = 152.4 ¥", iconColor: primaryCyan) {
                        triggerNotice("💱 Live Forex Rate: 1 USD = 152.40 JPY")
                    }
                    
                    // Action 4: Embassy Emergency
                    utilityButton(icon: "exclamationmark.shield.fill", text: "US Embassy Tokyo", iconColor: Color.red) {
                        triggerNotice("🚨 Emergency Contact: +81 3-3224-5000")
                    }
                }
            }
        }
    }
    
    private func utilityButton(icon: String, text: String, iconColor: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(iconColor)
                Text(text)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(surfaceCard)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(containerBorder, lineWidth: 1)
            )
        }
    }
    
    // MARK: - Helper Notification Banner
    private func triggerNotice(_ message: String) {
        withAnimation {
            activeUtilityNotice = message
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation {
                if activeUtilityNotice == message {
                    activeUtilityNotice = nil
                }
            }
        }
    }
    
    // MARK: - Modals
    private var boardingPassModalView: some View {
        ZStack {
            darkBackground.ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Text("Digital Boarding Pass")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button("Done") {
                        showBoardingPassModal = false
                    }
                    .foregroundColor(skyBlue)
                    .font(.system(size: 15, weight: .bold))
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("SFO")
                                .font(.system(size: 28, weight: .heavy, design: .rounded))
                                .foregroundColor(.white)
                            Text("San Francisco")
                                .font(.system(size: 12))
                                .foregroundColor(slateMuted)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "airplane")
                            .font(.system(size: 22))
                            .foregroundColor(skyBlue)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("HND")
                                .font(.system(size: 28, weight: .heavy, design: .rounded))
                                .foregroundColor(.white)
                            Text("Tokyo Haneda")
                                .font(.system(size: 12))
                                .foregroundColor(slateMuted)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    Divider().background(Color.white.opacity(0.1))
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("FLIGHT")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(slateMuted)
                            Text("JL 006")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                        }
                        Spacer()
                        VStack(alignment: .center, spacing: 2) {
                            Text("GATE")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(slateMuted)
                            Text("42B")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(skyBlue)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("SEAT")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(slateMuted)
                            Text("2A (First)")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(primaryCyan)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Image(systemName: "qrcode")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 140, height: 140)
                        .foregroundColor(.white)
                        .padding(.vertical, 16)
                    
                    Text("Apple Wallet Compatible • Pass Active")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(slateMuted)
                        .padding(.bottom, 10)
                }
                .padding(16)
                .background(surfaceDark)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(containerBorder, lineWidth: 1)
                )
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
        .presentationDetents([.medium, .large])
    }
    
    private var flyoverMapModalView: some View {
        ZStack {
            darkBackground.ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Text("Tokyo Metropolis 3D Flyover")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button("Close") {
                        showFlyoverMapModal = false
                    }
                    .foregroundColor(skyBlue)
                    .font(.system(size: 15, weight: .bold))
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                VStack(spacing: 12) {
                    AsyncImage(url: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuCBswjeA9E6H5-auy_pJnDKEtaJLNUvqbvf3VPGIjVjZs-wLN13iS3GrTs1rrz8tYL4Z3yITzHW4ccdBnteHCY3sexPvXTWAmL95iBU6bhLhqO9pLYVL_Cd9jSjpHKIAJXxx9P0OGP5cYO-BgmzE2o8fzhQq1VjwCqQXAnq3zsH_PTIJlDi1e5LGpsBKkg3mpWyOQr4yVQlbL8C7pE4quFu3u4eJqWmMWdFXbjf6T8MHI3JV2DLD-rL1Q")) { phase in
                        if let image = phase.image {
                            image.resizable().aspectRatio(contentMode: .fit)
                        } else {
                            Rectangle()
                                .fill(surfaceDark)
                                .frame(height: 200)
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    Text("Interactive 3D landmarks for Shibuya, Ginza, Roppongi & Shinjuku are cached offline.")
                        .font(.system(size: 13))
                        .foregroundColor(slateMuted)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeDashboardView()
    }
}
