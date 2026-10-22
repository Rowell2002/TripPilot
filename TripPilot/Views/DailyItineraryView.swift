import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct DailyItineraryView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var tripManager = TripManager.shared
    @State private var selectedTab: AppTab = .itinerary
    @State private var selectedDateIndex: Int = 0
    @State private var showAudioStoryModal: Bool = false
    @State private var showReorderModal: Bool = false
    @State private var showAddStopModal: Bool = false
    @State private var showDaySettingsModal: Bool = false
    @State private var activeNotice: String? = nil
    @State private var isAudioPlaying: Bool = true
    @State private var navigateToInteractiveMap: Bool = false
    @State private var navigateToBudget: Bool = false
    @State private var navigateToProfile: Bool = false
    
    private var currentDay: TripDay {
        let days = tripManager.currentTrip.days
        if days.indices.contains(selectedDateIndex) {
            return days[selectedDateIndex]
        }
        return days.first ?? SriLankaDataService.shared.generateCustomTrip(destination: "Sigiriya & Ella", durationDays: 3, companion: "Couple", pace: "Balanced", budget: "Comfort", tags: []).days[0]
    }
    
    private var selectedDayIndex: Int { selectedDateIndex }
    
    // Theme Colors
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
                    // MARK: - Header Bar (Logo & Actions)
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
            InteractiveMapView(initialDayIndex: selectedDateIndex)
        }
        .navigationDestination(isPresented: $navigateToBudget) {
            BudgetExpensesView()
        }
        .navigationDestination(isPresented: $navigateToProfile) {
            SettingsProfileView()
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
        VStack(spacing: 8) {
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
                        triggerNotice("📍 Next scheduled stop: \(currentDay.stops.first?.title ?? "Sigiriya Lion Rock")")
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
                    
                    Text("DAY \(selectedDateIndex + 1) OF \(tripManager.currentTrip.durationDays)")
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
                    
                    Text("\(currentDay.region) \(currentDay.temperature) • \(currentDay.weather)")
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
                    Text(tripManager.currentTrip.title)
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundColor(textOnSurface)
                        .tracking(-0.3)
                    
                    Text("\(currentDay.fullDateString) • \(currentDay.title)")
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
                ForEach(0..<tripManager.currentTrip.days.count, id: \.self) { index in
                    let item = tripManager.currentTrip.days[index]
                    let isSelected = selectedDateIndex == index
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.28, dampingFraction: 0.78)) {
                            selectedDateIndex = index
                        }
                    }) {
                        VStack(spacing: 3) {
                            Text(item.dayOfWeek)
                                .font(.system(size: 10.5, weight: .bold, design: .rounded))
                                .foregroundColor(isSelected ? Color.white.opacity(0.9) : Color(red: 100/255, green: 116/255, blue: 139/255))
                            
                            Text(item.dayOfMonth)
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
                metricCell(title: "STOPS", value: "\(currentDay.stops.count) Places", valueColor: .white)
                metricCell(title: "REGION", value: currentDay.region, valueColor: .white)
                metricCell(title: "PACE", value: tripManager.currentTrip.pace, valueColor: skyBlue)
            }
            
            // MapKit Interactive Exploration Button
            Button(action: {
                navigateToInteractiveMap = true
            }) {
                HStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(Color(red: 251/255, green: 191/255, blue: 36/255).opacity(0.18))
                            .frame(width: 32, height: 32)
                        
                        Image(systemName: "map.fill")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color(red: 251/255, green: 191/255, blue: 36/255))
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 6) {
                            Text("View Day Route & Dining on Map")
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("MapKit")
                                .font(.system(size: 9.5, weight: .heavy, design: .rounded))
                                .foregroundColor(Color(red: 251/255, green: 191/255, blue: 36/255))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color(red: 251/255, green: 191/255, blue: 36/255).opacity(0.15))
                                .clipShape(Capsule())
                        }
                        
                        Text("Breakfast spots, cafes, attractions, lunch & dinner with Apple Maps navigation")
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .foregroundColor(textMuted)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(red: 148/255, green: 163/255, blue: 184/255))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 9)
                .background(surfaceContainerLow)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color(red: 251/255, green: 191/255, blue: 36/255).opacity(0.25), lineWidth: 1)
                )
            }
            .buttonStyle(PlainButtonStyle())
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
                .lineLimit(1)
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
    
    // MARK: - 5. Timeline Detailed Stops (Section 3 - Dynamic)
    private var timelineStopsSection: some View {
        VStack(spacing: 0) {
            ForEach(0..<currentDay.stops.count, id: \.self) { idx in
                let stop = currentDay.stops[idx]
                let isLast = idx == currentDay.stops.count - 1
                stopCardView(stop: stop, isLast: isLast)
            }
        }
        .padding(.leading, 6)
    }
    
    private func stopCardView(stop: TripStop, isLast: Bool) -> some View {
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
            timeText: stop.time,
            timeColor: skyBlue,
            tagView: {
                Text(stop.estimatedDuration)
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
                            Text(stop.title)
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(textOnSurface)
                            
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 13))
                                .foregroundColor(skyBlue)
                        }
                        
                        Text(stop.description)
                            .font(.system(size: 12.5))
                            .foregroundColor(textMuted)
                            .lineSpacing(2)
                    }
                    
                    HStack(spacing: 8) {
                        HStack(spacing: 5) {
                            Image(systemName: "mappin.and.ellipse")
                                .font(.system(size: 11))
                                .foregroundColor(skyBlue)
                            Text(stop.locationName)
                                .font(.system(size: 11.5, weight: .medium, design: .rounded))
                                .foregroundColor(Color(red: 226/255, green: 232/255, blue: 240/255))
                                .lineLimit(1)
                        }
                        
                        Spacer()
                        
                        Text(stop.costLKR > 0 ? "Rs \(stop.costLKR) / $\(Int(stop.costUSD))" : "Free Entry")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(primaryCyan)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(primaryCyan.opacity(0.12))
                            .clipShape(Capsule())
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
            isLast: isLast
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
                    triggerNotice("📄 Generating high-resolution Sri Lanka Itinerary PDF...")
                }) {
                    utilityButton(icon: "doc.richtext.fill", title: "Share PDF", iconColor: skyBlue)
                }
                
                Button(action: {
                    triggerNotice("🗺️ Offline maps for Sri Lanka (Sigiriya, Ella, Galle) cached (38 MB)")
                }) {
                    utilityButton(icon: "arrow.down.circle.fill", title: "Offline Map", iconColor: skyBlue)
                }
                
                Button(action: {
                    triggerNotice("✨ AI re-optimized scenic route to save 24 mins!")
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
    
    // MARK: - Sheet 2: Sri Lanka Audio Story
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
                        
                        Text("Sigiriya: The Fortress in the Sky")
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
                
                HStack(spacing: 4) {
                    ForEach(0..<24, id: \.self) { i in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(i % 3 == 0 ? skyBlue : (i % 2 == 0 ? primaryCyan : Color.white.opacity(0.2)))
                            .frame(width: 4, height: CGFloat.random(in: 15...55))
                    }
                }
                .frame(height: 70)
                .padding(.vertical, 8)
                
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
                
                Text("Narrated by AI Cultural Storyteller • 3m 45s")
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
                    Text("Reorder Day \(selectedDayIndex + 1) Stops")
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
                    ForEach(Array(currentDay.stops.enumerated()), id: \.element.id) { index, stop in
                        reorderRow(number: "\(index + 1)", title: stop.title, time: stop.time)
                    }
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
                    Text("Add Stop to Day \(selectedDayIndex + 1)")
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
                        TextField("Search places in Sri Lanka...", text: .constant(""))
                            .foregroundColor(.white)
                    }
                    .padding(12)
                    .background(surfaceContainerLowest)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(outlineVariant, lineWidth: 1))
                    
                    Text("POPULAR IN SRI LANKA")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(textMuted)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 8)
                    
                    ForEach(SriLankaDataService.shared.places.prefix(3)) { place in
                        suggestedStopRow(name: place.name, type: "\(place.category.rawValue) • \(place.bestTimeToVisit)")
                    }
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
                triggerNotice("📍 Added '\(name)' to Day \(selectedDayIndex + 1)")
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
                    Text("Day \(selectedDayIndex + 1) Settings")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button("Done") { showDaySettingsModal = false }
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(skyBlue)
                }
                .padding(.horizontal, 20)
                
                VStack(spacing: 12) {
                    Toggle("Monsoon Smart Weather Alert", isOn: .constant(true))
                        .tint(skyBlue)
                        .padding(12)
                        .background(surfaceContainerLowest)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Toggle("Temple Dress Code Warnings", isOn: .constant(true))
                        .tint(tealAccent)
                        .padding(12)
                        .background(surfaceContainerLowest)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Toggle("Safari Permit Auto-Sync", isOn: .constant(true))
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
