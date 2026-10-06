//
//  DailyItineraryView.swift
//  TripPilot
//
//  Generated from Stitch Screen: a156ef00d4304ea1ba8677c957f33173
//  Title: TripPilot - Daily Itinerary (Dark Mode)
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct DailyItineraryView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: AppTab = .itinerary
    @State private var selectedDateIndex: Int = 2 // SAT 26
    @State private var showPassModal: Bool = false
    @State private var showAudioStoryModal: Bool = false
    @State private var showReorderModal: Bool = false
    @State private var showAddStopModal: Bool = false
    @State private var showDaySettingsModal: Bool = false
    @State private var activeNotice: String? = nil
    @State private var isFlightPulsing: Bool = false
    @State private var isAudioPlaying: Bool = true
    @State private var navigateToInteractiveMap: Bool = false
    
    // Stitch Theme Colors
    private let darkBackground = Color(red: 11/255, green: 15/255, blue: 23/255)       // #0b0f17
    private let surfaceContainerLowest = Color(red: 17/255, green: 24/255, blue: 39/255) // #111827
    private let surfaceContainerLow = Color(red: 22/255, green: 32/255, blue: 50/255)    // #162032
    private let surfaceContainerHigh = Color(red: 31/255, green: 41/255, blue: 61/255)   // #1f293d
    private let skyBlue = Color(red: 56/255, green: 189/255, blue: 248/255)             // #38bdf8
    private let royalBlue = Color(red: 37/255, green: 99/255, blue: 235/255)           // #2563eb
    private let primaryCyan = Color(red: 68/255, green: 226/255, blue: 205/255)          // #44e2cd
    private let tealAccent = Color(red: 20/255, green: 184/255, blue: 166/255)          // #14b8a6
    private let amberAccent = Color(red: 251/255, green: 191/255, blue: 36/255)        // #fbbf24
    private let textOnSurface = Color(red: 241/255, green: 245/255, blue: 249/255)       // slate-100
    private let textMuted = Color(red: 148/255, green: 163/255, blue: 184/255)          // slate-400
    private let outlineVariant = Color.white.opacity(0.08)
    
    // Sample dates for carousel
    private let daysList: [(day: String, date: String)] = [
        ("THU", "24"),
        ("FRI", "25"),
        ("SAT", "26"),
        ("SUN", "27"),
        ("MON", "28"),
        ("TUE", "29"),
        ("WED", "30")
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background
            darkBackground
                .ignoresSafeArea()
            
            // Atmospheric Glow Effects
            GeometryReader { _ in
                Circle()
                    .fill(skyBlue.opacity(0.06))
                    .frame(width: 320, height: 320)
                    .blur(radius: 80)
                    .offset(x: -60, y: -40)
                
                Circle()
                    .fill(tealAccent.opacity(0.05))
                    .frame(width: 300, height: 300)
                    .blur(radius: 70)
                    .offset(x: 180, y: 350)
            }
            .ignoresSafeArea()
            
            // Scrollable Content
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // MARK: - Header Bar (Live flight chip + Logo + Actions)
                    headerSection
                        .padding(.top, 4)
                    
                    // MARK: - Hero & Date Title Section (Section 0)
                    heroTitleSection
                    
                    // MARK: - Date Selector Carousel (Section 1)
                    dateSelectorCarousel
                    
                    // MARK: - Day Schedule Summary Card (Section 2)
                    dayScheduleOverviewCard
                    
                    // MARK: - Timeline Detailed Stops (Section 3)
                    timelineStopsSection
                    
                    // MARK: - Day Utilities Card (Section 4)
                    dayUtilitiesSection
                    
                    // Bottom spacing for floating tab bar
                    Spacer()
                        .frame(height: 110)
                }
                .padding(.horizontal, 18)
            }
            
            // MARK: - Floating Glassmorphic Bottom Navigation Bar
            FloatingBottomNavBar(selectedTab: $selectedTab) { tab in
                if tab == .home {
                    dismiss()
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
            withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) {
                isFlightPulsing = true
            }
        }
        .sheet(isPresented: $showPassModal) {
            shibuyaSkyPassSheet
        }
        .sheet(isPresented: $showAudioStoryModal) {
            audioStoryPlayerSheet
        }
        .sheet(isPresented: $showReorderModal) {
            reorderStopsSheet
        }
        .sheet(isPresented: $showAddStopModal) {
            addStopSheet
        }
        .sheet(isPresented: $showDaySettingsModal) {
            daySettingsSheet
        }
        .navigationDestination(isPresented: $navigateToInteractiveMap) {
            InteractiveMapView()
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
    
    // MARK: - 1. Top Header Bar
    private var headerSection: some View {
        VStack(spacing: 12) {
            // Live Flight Status Capsule
            HStack(spacing: 8) {
                Image(systemName: "airplane.departure")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(skyBlue)
                    .scaleEffect(isFlightPulsing ? 1.15 : 0.9)
                
                Text("JL 005 • In 2h 15m")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(red: 226/255, green: 232/255, blue: 240/255))
                    .tracking(0.5)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 5)
            .background(surfaceContainerLow)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.3), radius: 6, y: 2)
            
            // Brand & Navigation Controls
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
                
                // Logo & Title
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
                        
                        Image(systemName: "calendar")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 1) {
                        Text("TripPilot")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(textOnSurface)
                        
                        Text("ITINERARY")
                            .font(.system(size: 9.5, weight: .bold, design: .rounded))
                            .foregroundColor(textMuted)
                            .tracking(1.2)
                    }
                }
                
                Spacer()
                
                // Right Actions: Notifications & Avatar
                HStack(spacing: 10) {
                    Button(action: {
                        triggerNotice("🔔 Gate 14 boarding starts in 1h 45m")
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
                                .fill(Color(red: 244/255, green: 63/255, blue: 94/255))
                                .frame(width: 8, height: 8)
                                .offset(x: -8, y: 8)
                        }
                    }
                    
                    // Profile Avatar
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
                            .fill(tealAccent)
                            .frame(width: 10, height: 10)
                            .overlay(Circle().stroke(darkBackground, lineWidth: 2))
                    }
                }
            }
        }
    }
    
    // MARK: - 2. Hero & Date Title Section (Section 0)
    private var heroTitleSection: some View {
        VStack(spacing: 10) {
            // Badges row
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "suitcase.rolling.fill")
                        .font(.system(size: 12))
                        .foregroundColor(skyBlue)
                    
                    Text("DAY 3 OF 12")
                        .font(.system(size: 10.5, weight: .bold, design: .rounded))
                        .foregroundColor(Color(red: 203/255, green: 213/255, blue: 225/255))
                        .tracking(0.8)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 5)
                .background(surfaceContainerLow)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(outlineVariant, lineWidth: 1)
                )
                
                Spacer()
                
                HStack(spacing: 6) {
                    Image(systemName: "sun.max.fill")
                        .font(.system(size: 13))
                        .foregroundColor(amberAccent)
                    
                    Text("Tokyo 21°C • Clear")
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(red: 226/255, green: 232/255, blue: 240/255))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 5)
                .background(surfaceContainerLow)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(outlineVariant, lineWidth: 1)
                )
            }
            
            // Title & Switcher
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Tokyo & Kyoto")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(textOnSurface)
                        .tracking(-0.3)
                    
                    Text("Saturday, October 26 • Gentle autumn weather")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundColor(textMuted)
                }
                
                Spacer()
                
                Button(action: {
                    showDaySettingsModal = true
                }) {
                    ZStack {
                        Circle()
                            .fill(surfaceContainerLow)
                            .frame(width: 38, height: 38)
                            .overlay(
                                Circle()
                                    .stroke(outlineVariant, lineWidth: 1)
                            )
                        
                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(textOnSurface)
                    }
                }
            }
            .padding(.top, 4)
        }
    }
    
    // MARK: - 3. Date Selector Carousel (Section 1)
    private var dateSelectorCarousel: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(0..<daysList.count, id: \.self) { index in
                    let item = daysList[index]
                    let isSelected = selectedDateIndex == index
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.28, dampingFraction: 0.78)) {
                            selectedDateIndex = index
                        }
                    }) {
                        VStack(spacing: 3) {
                            Text(item.day)
                                .font(.system(size: 10.5, weight: .bold, design: .rounded))
                                .foregroundColor(isSelected ? Color.white.opacity(0.9) : Color(red: 100/255, green: 116/255, blue: 139/255))
                            
                            Text(item.date)
                                .font(.system(size: 18, weight: isSelected ? .heavy : .bold, design: .rounded))
                                .foregroundColor(isSelected ? .white : Color(red: 226/255, green: 232/255, blue: 240/255))
                            
                            if isSelected {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 5, height: 5)
                                    .padding(.top, 1)
                            }
                        }
                        .frame(width: isSelected ? 66 : 58, height: isSelected ? 68 : 62)
                        .background(
                            isSelected ?
                                LinearGradient(colors: [skyBlue, royalBlue], startPoint: .top, endPoint: .bottom) :
                                LinearGradient(colors: [surfaceContainerLowest, surfaceContainerLowest], startPoint: .top, endPoint: .bottom)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(isSelected ? skyBlue.opacity(0.5) : outlineVariant, lineWidth: 1)
                        )
                        .shadow(color: isSelected ? skyBlue.opacity(0.35) : Color.clear, radius: 10, y: 4)
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }
    
    // MARK: - 4. Day Schedule Overview Card (Section 2)
    private var dayScheduleOverviewCard: some View {
        VStack(spacing: 14) {
            // Header Row
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "point.topleft.down.curvedto.point.bottomright.up")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(skyBlue)
                    
                    Text("Day Schedule")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(textOnSurface)
                }
                
                Spacer()
                
                HStack(spacing: 8) {
                    Button(action: {
                        showReorderModal = true
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "arrow.up.arrow.down")
                                .font(.system(size: 11, weight: .bold))
                            
                            Text("Reorder")
                                .font(.system(size: 11.5, weight: .semibold, design: .rounded))
                                .fixedSize()
                        }
                        .foregroundColor(Color(red: 226/255, green: 232/255, blue: 240/255))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(surfaceContainerHigh)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(outlineVariant, lineWidth: 1)
                        )
                    }
                    
                    Button(action: {
                        showAddStopModal = true
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "plus")
                                .font(.system(size: 11, weight: .heavy))
                            
                            Text("Stop")
                                .font(.system(size: 11.5, weight: .bold, design: .rounded))
                                .fixedSize()
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 13)
                        .padding(.vertical, 6)
                        .background(
                            LinearGradient(
                                colors: [skyBlue, royalBlue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                        .shadow(color: skyBlue.opacity(0.3), radius: 6, y: 2)
                    }
                }
            }
            
            // 3-Column Metrics Grid
            HStack(spacing: 8) {
                metricCell(title: "STOPS", value: "5 Places", valueColor: .white)
                metricCell(title: "TRANSFERS", value: "1 Metro", valueColor: .white)
                metricCell(title: "WALKING", value: "6.4 km", valueColor: skyBlue)
            }
        }
        .padding(16)
        .background(surfaceContainerLowest)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(outlineVariant, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.3), radius: 12, y: 4)
    }
    
    private func metricCell(title: String, value: String, valueColor: Color) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.system(size: 9.5, weight: .bold, design: .rounded))
                .foregroundColor(textMuted)
                .tracking(0.5)
            
            Text(value)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(valueColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(surfaceContainerLow)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
    }
    
    // MARK: - 5. Timeline Detailed Stops (Section 3)
    private var timelineStopsSection: some View {
        VStack(spacing: 0) {
            // STOP 1: 08:30 AM (Coffee)
            stop1BlueBottleCoffee
            
            // STOP 2: 09:45 AM (Meiji Jingu Shrine)
            stop2MeijiJinguShrine
            
            // STOP 3: 01:00 PM (Katsukura Tonkatsu)
            stop3KatsukuraTonkatsu
            
            // STOP 4: 03:30 PM (Shibuya Sky 360)
            stop4ShibuyaSky
            
            // STOP 5: 07:30 PM (Omoide Yokocho Izakaya)
            stop5OmoideYokocho
        }
        .padding(.leading, 6)
    }
    
    // MARK: - Stop 1
    private var stop1BlueBottleCoffee: some View {
        timelineRow(
            bead: {
                ZStack {
                    Circle()
                        .fill(surfaceContainerLowest)
                        .frame(width: 24, height: 24)
                        .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 1))
                    
                    Circle()
                        .fill(skyBlue)
                        .frame(width: 10, height: 10)
                        .shadow(color: skyBlue, radius: 5)
                }
            },
            timeText: "08:30 AM",
            timeColor: skyBlue,
            tagView: {
                Text("45 MIN")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(Color(red: 203/255, green: 213/255, blue: 225/255))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(surfaceContainerLow)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(outlineVariant, lineWidth: 1))
            },
            content: {
                VStack(alignment: .leading, spacing: 10) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 6) {
                            Text("Blue Bottle Coffee Aoyama")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(textOnSurface)
                            
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 13))
                                .foregroundColor(skyBlue)
                        }
                        
                        Text("Light roast pour-over & fresh sesame pastry in the tranquil bamboo courtyard.")
                            .font(.system(size: 12.5))
                            .foregroundColor(textMuted)
                            .lineSpacing(2)
                    }
                    
                    // Walking hop badge
                    HStack(spacing: 6) {
                        Image(systemName: "figure.walk")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(skyBlue)
                        
                        Text("12 min scenic walk (0.8 km) to shrine")
                            .font(.system(size: 11.5, weight: .medium, design: .rounded))
                            .foregroundColor(Color(red: 226/255, green: 232/255, blue: 240/255))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(surfaceContainerLow)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(Color.white.opacity(0.06), lineWidth: 1)
                    )
                }
                .padding(14)
                .background(surfaceContainerLowest)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(outlineVariant, lineWidth: 1)
                )
            }
        )
    }
    
    // MARK: - Stop 2
    private var stop2MeijiJinguShrine: some View {
        timelineRow(
            bead: {
                ZStack {
                    Circle()
                        .fill(tealAccent)
                        .frame(width: 26, height: 26)
                        .overlay(Circle().stroke(Color.white.opacity(0.3), lineWidth: 1))
                        .shadow(color: tealAccent.opacity(0.5), radius: 6)
                    
                    Image(systemName: "building.columns.fill")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color(red: 11/255, green: 15/255, blue: 23/255))
                }
            },
            timeText: "09:45 AM",
            timeColor: tealAccent,
            tagView: {
                HStack(spacing: 5) {
                    Circle()
                        .fill(tealAccent)
                        .frame(width: 6, height: 6)
                    
                    Text("LOW CROWD")
                        .font(.system(size: 9.5, weight: .heavy, design: .rounded))
                        .foregroundColor(Color(red: 94/255, green: 234/255, blue: 212/255))
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(Color(red: 19/255, green: 78/255, blue: 74/255).opacity(0.4))
                .clipShape(Capsule())
                .overlay(Capsule().stroke(tealAccent.opacity(0.4), lineWidth: 1))
            },
            content: {
                VStack(alignment: .leading, spacing: 0) {
                    // Image Banner with Badges
                    ZStack(alignment: .bottomLeading) {
                        AsyncImage(url: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuCUBmMYz7dWcF-p-XrJq15EhxKN_2Kb1ALHVsKlm-Zx6GPbZAR2dgZHBhti1qIrkAN-obN9HgCVRYszJxDTqN6ftPZtahTET8PoFpn36XmogW-uWBi39wddx8cZ8sUnUzBe3FYiaHZu6inaG4b_MhE86-xrnYNs0i99ilw-moR8JMsZUgkC2vhlD0ljdBc91Z4Ke8IsB6OgCBKOPc6p0C5O8-Zrew3zlSK0IpqveVYeljt2YHhVRhbELw")) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 125)
                                    .clipped()
                            default:
                                LinearGradient(
                                    colors: [Color(red: 20/255, green: 40/255, blue: 35/255), surfaceContainerLowest],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                                .frame(height: 125)
                            }
                        }
                        
                        LinearGradient(
                            colors: [Color.clear, surfaceContainerLowest],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        
                        // Top floating tags
                        HStack {
                            Text("UNESCO Spot")
                                .font(.system(size: 9.5, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color.black.opacity(0.65))
                                .clipShape(Capsule())
                                .overlay(Capsule().stroke(Color.white.opacity(0.15), lineWidth: 0.8))
                            
                            Text("Pass Included")
                                .font(.system(size: 9.5, weight: .bold, design: .rounded))
                                .foregroundColor(tealAccent)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color.black.opacity(0.65))
                                .clipShape(Capsule())
                                .overlay(Capsule().stroke(tealAccent.opacity(0.4), lineWidth: 0.8))
                        }
                        .padding(10)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    }
                    
                    // Card Details
                    VStack(alignment: .leading, spacing: 10) {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Meiji Jingu Shrine & Forest")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(textOnSurface)
                            
                            Text("Inner shrine gardens, wishing ema plaques, and peaceful forest tree walk.")
                                .font(.system(size: 12.5))
                                .foregroundColor(textMuted)
                        }
                        
                        HStack {
                            Button(action: {
                                showAudioStoryModal = true
                            }) {
                                HStack(spacing: 5) {
                                    Image(systemName: "headphones")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(skyBlue)
                                    
                                    Text("3m Audio Story")
                                        .font(.system(size: 11.5, weight: .bold, design: .rounded))
                                        .foregroundColor(Color(red: 226/255, green: 232/255, blue: 240/255))
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(surfaceContainerLow)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                )
                            }
                            
                            Spacer()
                            
                            Text("~1h 45m visit")
                                .font(.system(size: 11, weight: .medium, design: .rounded))
                                .foregroundColor(textMuted)
                        }
                    }
                    .padding(14)
                    
                    // Transit hop connector
                    HStack {
                        HStack(spacing: 6) {
                            Image(systemName: "tram.fill")
                                .font(.system(size: 13))
                                .foregroundColor(skyBlue)
                            
                            Text("Ginza Line • Harajuku → Shibuya")
                                .font(.system(size: 12, weight: .semibold, design: .rounded))
                                .foregroundColor(Color(red: 226/255, green: 232/255, blue: 240/255))
                        }
                        
                        Spacer()
                        
                        Text("8 MIN")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundColor(textMuted)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 2.5)
                            .background(surfaceContainerLowest)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 9)
                    .background(surfaceContainerLow)
                }
                .background(surfaceContainerLowest)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(outlineVariant, lineWidth: 1)
                )
            }
        )
    }
    
    // MARK: - Stop 3
    private var stop3KatsukuraTonkatsu: some View {
        timelineRow(
            bead: {
                ZStack {
                    Circle()
                        .fill(surfaceContainerLowest)
                        .frame(width: 24, height: 24)
                        .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 1))
                    
                    Circle()
                        .fill(skyBlue)
                        .frame(width: 10, height: 10)
                        .shadow(color: skyBlue, radius: 5)
                }
            },
            timeText: "01:00 PM",
            timeColor: .white,
            tagView: {
                Text("RESERVED")
                    .font(.system(size: 10, weight: .heavy, design: .rounded))
                    .foregroundColor(Color(red: 186/255, green: 230/255, blue: 253/255))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(skyBlue.opacity(0.2))
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(skyBlue.opacity(0.4), lineWidth: 1))
            },
            content: {
                VStack(alignment: .leading, spacing: 10) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Katsukura Tonkatsu Shinjuku")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(textOnSurface)
                        
                        Text("Kyoto-style premium Kurobuta pork cutlet with house-ground sesame dipping sauce.")
                            .font(.system(size: 12.5))
                            .foregroundColor(textMuted)
                            .lineSpacing(2)
                    }
                    
                    HStack(spacing: 8) {
                        Text("CONF: #TP-8842")
                            .font(.system(size: 10.5, weight: .bold, design: .monospaced))
                            .foregroundColor(Color(red: 203/255, green: 213/255, blue: 225/255))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(surfaceContainerLow)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white.opacity(0.06), lineWidth: 1))
                        
                        Text("2 Guests • Counter")
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .foregroundColor(Color(red: 203/255, green: 213/255, blue: 225/255))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(surfaceContainerLow)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white.opacity(0.06), lineWidth: 1))
                        
                        Spacer()
                        
                        Image(systemName: "fork.knife")
                            .font(.system(size: 13))
                            .foregroundColor(textMuted)
                    }
                }
                .padding(14)
                .background(surfaceContainerLowest)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(outlineVariant, lineWidth: 1)
                )
            }
        )
    }
    
    // MARK: - Stop 4
    private var stop4ShibuyaSky: some View {
        timelineRow(
            bead: {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [skyBlue, royalBlue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 26, height: 26)
                        .overlay(Circle().stroke(Color.white.opacity(0.3), lineWidth: 1))
                        .shadow(color: skyBlue.opacity(0.5), radius: 6)
                    
                    Image(systemName: "sparkles")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white)
                }
            },
            timeText: "03:30 PM",
            timeColor: skyBlue,
            tagView: {
                Text("GOLDEN HOUR")
                    .font(.system(size: 9.5, weight: .heavy, design: .rounded))
                    .foregroundColor(amberAccent)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(amberAccent.opacity(0.18))
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(amberAccent.opacity(0.4), lineWidth: 1))
            },
            content: {
                VStack(alignment: .leading, spacing: 0) {
                    // Image Banner
                    ZStack(alignment: .bottomLeading) {
                        AsyncImage(url: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuCHSU-udI3gO3Gq8ugQPlNooXT5C0UKLe3NYNCBZBTvOsicgjS2zMgUXpiO7MJKdWo0pHjhiO4tm71j81ZC2Fz7WDVkqY-6VHyUVvyrdhu1uuvC5_WAZZNh2zL-uuOgJEdMQ4yZb8xh_w5CCnUmUckrTIukPNWY3TdLtojH24onxiepx6BxcFrD3nw1bONEKD9n7XX6m5D9p2-MPcpZGJ1zklUEv5NslgKzkv2cpgHZu3K5u1th-IJiAA")) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 125)
                                    .clipped()
                            default:
                                LinearGradient(
                                    colors: [Color(red: 25/255, green: 40/255, blue: 60/255), surfaceContainerLowest],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                                .frame(height: 125)
                            }
                        }
                        
                        LinearGradient(
                            colors: [Color.clear, surfaceContainerLowest.opacity(0.9), surfaceContainerLowest],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Shibuya Sky 360°")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                
                                Text("Rooftop Observation Deck (47F)")
                                    .font(.system(size: 11, weight: .medium, design: .rounded))
                                    .foregroundColor(Color(red: 203/255, green: 213/255, blue: 225/255))
                            }
                            
                            Spacer()
                            
                            Text("PASS ACTIVE")
                                .font(.system(size: 10, weight: .heavy, design: .rounded))
                                .foregroundColor(Color(red: 11/255, green: 15/255, blue: 23/255))
                                .padding(.horizontal, 9)
                                .padding(.vertical, 4)
                                .background(skyBlue)
                                .clipShape(Capsule())
                                .shadow(color: skyBlue.opacity(0.4), radius: 5)
                        }
                        .padding(12)
                    }
                    
                    // Pass Control Box
                    HStack {
                        HStack(spacing: 8) {
                            Image(systemName: "qrcode")
                                .font(.system(size: 24))
                                .foregroundColor(skyBlue)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("ENTRY SLOT")
                                    .font(.system(size: 9.5, weight: .bold, design: .rounded))
                                    .foregroundColor(textMuted)
                                
                                Text("16:30 Sunset Priority")
                                    .font(.system(size: 12, weight: .bold, design: .rounded))
                                    .foregroundColor(textOnSurface)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            showPassModal = true
                        }) {
                            Text("Show Pass")
                                .font(.system(size: 11.5, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 7)
                                .background(
                                    LinearGradient(
                                        colors: [skyBlue, royalBlue],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .clipShape(Capsule())
                                .shadow(color: skyBlue.opacity(0.35), radius: 8, y: 2)
                        }
                    }
                    .padding(12)
                    .background(surfaceContainerLow)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(Color.white.opacity(0.06), lineWidth: 1)
                    )
                    .padding(12)
                }
                .background(surfaceContainerLowest)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(outlineVariant, lineWidth: 1)
                )
            }
        )
    }
    
    // MARK: - Stop 5
    private var stop5OmoideYokocho: some View {
        timelineRow(
            bead: {
                ZStack {
                    Circle()
                        .fill(surfaceContainerLowest)
                        .frame(width: 24, height: 24)
                        .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 1))
                    
                    Circle()
                        .fill(Color(red: 167/255, green: 139/255, blue: 250/255))
                        .frame(width: 10, height: 10)
                        .shadow(color: Color(red: 167/255, green: 139/255, blue: 250/255), radius: 5)
                }
            },
            timeText: "07:30 PM",
            timeColor: .white,
            tagView: {
                Text("CASUAL VIBE")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(Color(red: 203/255, green: 213/255, blue: 225/255))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(surfaceContainerLow)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(outlineVariant, lineWidth: 1))
            },
            content: {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Omoide Yokocho Izakaya Crawl")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(textOnSurface)
                        
                        Spacer()
                        
                        Image(systemName: "wineglass.fill")
                            .font(.system(size: 14))
                            .foregroundColor(textMuted)
                    }
                    
                    Text("Atmospheric lantern-lit alleyway for grilled yakitori skewers, highballs, and regional craft beer.")
                        .font(.system(size: 12.5))
                        .foregroundColor(textMuted)
                        .lineSpacing(2)
                    
                    // Cash Tip Badge
                    HStack(spacing: 6) {
                        Image(systemName: "banknote.fill")
                            .font(.system(size: 12))
                            .foregroundColor(amberAccent)
                        
                        Text("Tip: Carry ~¥5,000 in cash")
                            .font(.system(size: 11.5, weight: .semibold, design: .rounded))
                            .foregroundColor(Color(red: 226/255, green: 232/255, blue: 240/255))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(surfaceContainerLow)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(Color.white.opacity(0.06), lineWidth: 1)
                    )
                }
                .padding(14)
                .background(surfaceContainerLowest)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(outlineVariant, lineWidth: 1)
                )
            },
            isLast: true
        )
    }
    
    // MARK: - Timeline Row Container with continuous guide line
    private func timelineRow<B: View, T: View, C: View>(
        bead: () -> B,
        timeText: String,
        timeColor: Color,
        tagView: () -> T,
        content: () -> C,
        isLast: Bool = false
    ) -> some View {
        HStack(alignment: .top, spacing: 14) {
            // Bead & Line Column
            VStack(spacing: 0) {
                bead()
                    .padding(.top, 1)
                
                if !isLast {
                    Rectangle()
                        .fill(Color(red: 30/255, green: 41/255, blue: 59/255)) // #1e293b
                        .frame(width: 2)
                        .frame(maxHeight: .infinity)
                        .padding(.top, 4)
                }
            }
            .frame(width: 26)
            
            // Event Details
            VStack(alignment: .leading, spacing: 8) {
                // Time & Tag Row
                HStack {
                    Text(timeText)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(timeColor)
                    
                    Spacer()
                    
                    tagView()
                }
                
                content()
            }
            .padding(.bottom, isLast ? 0 : 22)
        }
    }
    
    // MARK: - 6. Day Utilities Section (Section 4)
    private var dayUtilitiesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("DAY UTILITIES")
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundColor(textMuted)
                .tracking(0.8)
            
            HStack(spacing: 8) {
                Button(action: {
                    triggerNotice("📄 Generating high-resolution Itinerary PDF...")
                }) {
                    utilityButton(icon: "doc.richtext.fill", title: "Share PDF", iconColor: skyBlue)
                }
                
                Button(action: {
                    triggerNotice("🗺️ Offline maps for Tokyo & Kyoto cached (42 MB)")
                }) {
                    utilityButton(icon: "arrow.down.circle.fill", title: "Offline Map", iconColor: skyBlue)
                }
                
                Button(action: {
                    triggerNotice("✨ AI re-optimized transit hops to save 18 mins!")
                }) {
                    utilityButton(icon: "sparkles", title: "AI Optimize", iconColor: tealAccent)
                }
            }
        }
        .padding(16)
        .background(surfaceContainerLowest)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(outlineVariant, lineWidth: 1)
        )
    }
    
    private func utilityButton(icon: String, title: String, iconColor: Color) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(iconColor)
            
            Text(title)
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundColor(textOnSurface)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(surfaceContainerLow)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
    }
    
    // MARK: - Helper Notification Trigger
    private func triggerNotice(_ msg: String) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
            activeNotice = msg
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation(.easeOut(duration: 0.3)) {
                if activeNotice == msg {
                    activeNotice = nil
                }
            }
        }
    }
    
    // MARK: - Sheet 1: Shibuya Sky Digital Entry Pass
    private var shibuyaSkyPassSheet: some View {
        ZStack {
            darkBackground.ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Sheet drag handle
                Capsule()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 40, height: 4)
                    .padding(.top, 12)
                
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Digital Entry Pass")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Shibuya Sky 360° Observation Deck")
                            .font(.system(size: 13))
                            .foregroundColor(skyBlue)
                    }
                    
                    Spacer()
                    
                    Button(action: { showPassModal = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(textMuted)
                    }
                }
                .padding(.horizontal, 20)
                
                // Digital Ticket Card
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("BOOKING REFERENCE")
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .foregroundColor(textMuted)
                            Text("TP-SHIBUYA-7719")
                                .font(.system(size: 16, weight: .bold, design: .monospaced))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        Text("CONFIRMED")
                            .font(.system(size: 11, weight: .heavy, design: .rounded))
                            .foregroundColor(tealAccent)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(tealAccent.opacity(0.15))
                            .clipShape(Capsule())
                    }
                    
                    Divider().background(Color.white.opacity(0.1))
                    
                    // QR Code visual
                    VStack(spacing: 8) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.white)
                                .frame(width: 200, height: 200)
                            
                            Image(systemName: "qrcode")
                                .font(.system(size: 160))
                                .foregroundColor(.black)
                        }
                        
                        Text("Scan at 14F Shibuya Scramble Tower Gate")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(textMuted)
                    }
                    .padding(.vertical, 8)
                    
                    HStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("TIME SLOT")
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .foregroundColor(textMuted)
                            Text("16:30 - 18:00")
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("PASSENGER")
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .foregroundColor(textMuted)
                            Text("Elena Vance +1")
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(20)
                .background(surfaceContainerLowest)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(skyBlue.opacity(0.3), lineWidth: 1)
                )
                .padding(.horizontal, 20)
                
                // Add to Apple Wallet Button
                Button(action: {
                    showPassModal = false
                    triggerNotice("🎟️ Pass added to Apple Wallet")
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "wallet.pass.fill")
                            .font(.system(size: 16))
                        Text("Add to Apple Wallet")
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color.white)
                    .clipShape(Capsule())
                    .padding(.horizontal, 20)
                }
                
                Spacer()
            }
        }
        .presentationDetents([.fraction(0.72)])
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Sheet 2: Meiji Jingu 3m Audio Story
    private var audioStoryPlayerSheet: some View {
        ZStack {
            darkBackground.ignoresSafeArea()
            
            VStack(spacing: 22) {
                Capsule()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 40, height: 4)
                    .padding(.top, 12)
                
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("TripPilot Audio Guide")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundColor(skyBlue)
                        
                        Text("Meiji Jingu: The Sacred Forest")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Button(action: { showAudioStoryModal = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(textMuted)
                    }
                }
                .padding(.horizontal, 20)
                
                // Audio Wave Animation simulation
                HStack(spacing: 4) {
                    ForEach(0..<24, id: \.self) { i in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(i % 3 == 0 ? skyBlue : (i % 2 == 0 ? primaryCyan : Color.white.opacity(0.2)))
                            .frame(width: 4, height: CGFloat.random(in: 15...55))
                    }
                }
                .frame(height: 70)
                .padding(.vertical, 8)
                
                // Controls
                HStack(spacing: 36) {
                    Button(action: {}) {
                        Image(systemName: "gobackward.15")
                            .font(.system(size: 22))
                            .foregroundColor(textOnSurface)
                    }
                    
                    Button(action: {
                        isAudioPlaying.toggle()
                    }) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(colors: [skyBlue, royalBlue], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                                .frame(width: 60, height: 60)
                                .shadow(color: skyBlue.opacity(0.4), radius: 10)
                            
                            Image(systemName: isAudioPlaying ? "pause.fill" : "play.fill")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    
                    Button(action: {}) {
                        Image(systemName: "goforward.15")
                            .font(.system(size: 22))
                            .foregroundColor(textOnSurface)
                    }
                }
                
                Text("Narrated by AI Cultural Storyteller • 3m 12s remaining")
                    .font(.system(size: 12))
                    .foregroundColor(textMuted)
                
                Spacer()
            }
        }
        .presentationDetents([.fraction(0.48)])
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Sheet 3: Reorder Stops
    private var reorderStopsSheet: some View {
        ZStack {
            darkBackground.ignoresSafeArea()
            
            VStack(spacing: 16) {
                Capsule()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 40, height: 4)
                    .padding(.top, 12)
                
                HStack {
                    Text("Reorder Stops")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button("Done") {
                        showReorderModal = false
                        triggerNotice("✅ Itinerary schedule updated")
                    }
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(skyBlue)
                }
                .padding(.horizontal, 20)
                
                VStack(spacing: 10) {
                    reorderRow(number: "1", title: "Blue Bottle Coffee Aoyama", time: "08:30 AM")
                    reorderRow(number: "2", title: "Meiji Jingu Shrine & Forest", time: "09:45 AM")
                    reorderRow(number: "3", title: "Katsukura Tonkatsu Shinjuku", time: "01:00 PM")
                    reorderRow(number: "4", title: "Shibuya Sky 360°", time: "03:30 PM")
                    reorderRow(number: "5", title: "Omoide Yokocho Izakaya Crawl", time: "07:30 PM")
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
        .presentationDetents([.fraction(0.6)])
        .preferredColorScheme(.dark)
    }
    
    private func reorderRow(number: String, title: String, time: String) -> some View {
        HStack(spacing: 12) {
            Text(number)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(skyBlue)
                .frame(width: 24, height: 24)
                .background(surfaceContainerLow)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                Text(time)
                    .font(.system(size: 11))
                    .foregroundColor(textMuted)
            }
            
            Spacer()
            
            Image(systemName: "line.3.horizontal")
                .font(.system(size: 16))
                .foregroundColor(textMuted)
        }
        .padding(12)
        .background(surfaceContainerLowest)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(outlineVariant, lineWidth: 1))
    }
    
    // MARK: - Sheet 4: Add New Stop
    private var addStopSheet: some View {
        ZStack {
            darkBackground.ignoresSafeArea()
            
            VStack(spacing: 16) {
                Capsule()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 40, height: 4)
                    .padding(.top, 12)
                
                HStack {
                    Text("Add Stop to Day 3")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button("Cancel") { showAddStopModal = false }
                        .foregroundColor(textMuted)
                }
                .padding(.horizontal, 20)
                
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(textMuted)
                        TextField("Search places in Tokyo...", text: .constant(""))
                            .foregroundColor(.white)
                    }
                    .padding(12)
                    .background(surfaceContainerLowest)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(outlineVariant, lineWidth: 1))
                    
                    Text("POPULAR NEAR SHIBUYA")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(textMuted)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 8)
                    
                    suggestedStopRow(name: "Yoyogi Park Sakura Grove", type: "Park • 15 min visit")
                    suggestedStopRow(name: "Nezu Museum Garden", type: "Art & Tea House • 45 min")
                    suggestedStopRow(name: "Tower Records Shibuya", type: "Culture & Vinyl • 30 min")
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
        .presentationDetents([.fraction(0.55)])
        .preferredColorScheme(.dark)
    }
    
    private func suggestedStopRow(name: String, type: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.system(size: 13.5, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                Text(type)
                    .font(.system(size: 11))
                    .foregroundColor(textMuted)
            }
            
            Spacer()
            
            Button(action: {
                showAddStopModal = false
                triggerNotice("📍 Added '\(name)' to Day 3")
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(skyBlue)
            }
        }
        .padding(12)
        .background(surfaceContainerLowest)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: - Sheet 5: Day Settings
    private var daySettingsSheet: some View {
        ZStack {
            darkBackground.ignoresSafeArea()
            
            VStack(spacing: 16) {
                Capsule()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 40, height: 4)
                    .padding(.top, 12)
                
                HStack {
                    Text("Day 3 Settings")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button("Done") { showDaySettingsModal = false }
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(skyBlue)
                }
                .padding(.horizontal, 20)
                
                VStack(spacing: 12) {
                    Toggle("Smart Weather Rerouting", isOn: .constant(true))
                        .tint(skyBlue)
                        .padding(12)
                        .background(surfaceContainerLowest)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Toggle("Crowd-Density Alerts", isOn: .constant(true))
                        .tint(tealAccent)
                        .padding(12)
                        .background(surfaceContainerLowest)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Toggle("Transit Fare Auto-Calculation", isOn: .constant(true))
                        .tint(amberAccent)
                        .padding(12)
                        .background(surfaceContainerLowest)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
        .presentationDetents([.fraction(0.42)])
        .preferredColorScheme(.dark)
    }
}

#Preview {
    DailyItineraryView()
}
