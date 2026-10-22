import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct HomeDashboardView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var tripManager = TripManager.shared
    @ObservedObject private var stepTracker = TripStepTrackerService.shared
    
    @State private var selectedTab: AppTab = .home
    @State private var isLivePulsing: Bool = false
    @State private var showFlyoverMapModal: Bool = false
    @State private var showTripWizardModal: Bool = false
    @State private var activeUtilityNotice: String? = nil
    
    // Navigation Triggers
    @State private var navigateToMyTrips: Bool = false
    @State private var navigateToItinerary: Bool = false
    @State private var navigateToInteractiveMap: Bool = false
    @State private var navigateToPlaceDiscovery: Bool = false
    @State private var navigateToBudget: Bool = false
    @State private var navigateToProfile: Bool = false
    
    // Notifications & Geofence Audio Guide
    @ObservedObject private var notificationManager = NotificationManager.shared
    @State private var showNotificationsSheet: Bool = false
    @State private var showGeofenceAudioGuide: Bool = false
    @State private var selectedGeofenceLandmark: GeofenceLandmarkData = .defaultShibuya
    
    // Theme Mode
    @Environment(\.colorScheme) private var systemColorScheme
    @AppStorage("appSelectedTheme") private var appSelectedTheme: String = "Dark"
    
    private var isDarkMode: Bool {
        switch appSelectedTheme {
        case "Light": return false
        case "Auto": return systemColorScheme == .dark
        default: return true
        }
    }
    
    // Theme Colors
    private var darkBackground: Color {
        isDarkMode ? Color(red: 10/255, green: 14/255, blue: 22/255) : Color(red: 245/255, green: 247/255, blue: 250/255)
    }
    private var surfaceDark: Color {
        isDarkMode ? Color(red: 17/255, green: 24/255, blue: 39/255) : Color(red: 238/255, green: 242/255, blue: 246/255)
    }
    private var surfaceCard: Color {
        isDarkMode ? Color(red: 22/255, green: 31/255, blue: 48/255) : Color.white
    }
    private var containerBorder: Color {
        isDarkMode ? Color.white.opacity(0.08) : Color.black.opacity(0.06)
    }
    private let primaryCyan = Color(red: 68/255, green: 226/255, blue: 205/255)        // #44e2cd
    private let skyBlue = Color(red: 56/255, green: 189/255, blue: 248/255)           // #38bdf8
    private let amberGold = Color(red: 251/255, green: 191/255, blue: 36/255)          // #fbbf24
    private var slateLight: Color {
        isDarkMode ? Color(red: 226/255, green: 232/255, blue: 240/255) : Color(red: 15/255, green: 23/255, blue: 42/255)
    }
    private var slateMuted: Color {
        isDarkMode ? Color(red: 148/255, green: 163/255, blue: 184/255) : Color(red: 100/255, green: 116/255, blue: 139/255)
    }
    private var slateDark: Color {
        isDarkMode ? Color(red: 30/255, green: 41/255, blue: 59/255) : Color(red: 241/255, green: 245/255, blue: 249/255)
    }
    private let coralAccent = Color(red: 251/255, green: 113/255, blue: 133/255)
    
    var body: some View {
        ZStack(alignment: .bottom) {
            darkBackground.ignoresSafeArea()
            
            // Ambient Glows
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
            ScrollViewReader { scrollProxy in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Header
                        navigationHeaderSection
                            .padding(.top, 8)
                        
                        // 2. Personalized Greeting & Local Sri Lanka Weather
                        greetingWeatherSection
                        
                        // 3. Hero Active Trip Card
                        heroTripCard
                        
                        // 4. Today's Live Itinerary Timeline Widget
                        todayScheduleWidget
                        
                        // 5. Interactive Map Preview Widget
                        explorationMapWidget
                        
                        // 6. Travel Statistics & Quick Budget
                        statsAndBudgetGrid
                        
                        // 7. Trip Step Count Tracker & Activity Idea
                        stepCountTrackerSection
                        
                        Spacer().frame(height: 140)
                    }
                    .padding(.horizontal, 18)
                }
            }
            
            // 8. Floating Bottom Tab Bar
            FloatingBottomNavBar(selectedTab: $selectedTab) { tab in
                if tab == .itinerary {
                    navigateToItinerary = true
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
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                isLivePulsing = true
            }
        }
        .sheet(isPresented: $showFlyoverMapModal) {
            flyoverMapModalView
        }
        .sheet(isPresented: $showTripWizardModal) {
            TripGeneratorWizardView()
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
        .navigationDestination(isPresented: $navigateToPlaceDiscovery) {
            PlaceDiscoveryView()
        }
        .navigationDestination(isPresented: $navigateToBudget) {
            BudgetExpensesView()
        }
        .navigationDestination(isPresented: $navigateToProfile) {
            SettingsProfileView()
        }
        .sheet(isPresented: $showNotificationsSheet) {
            NotificationsInboxSheet { landmark in
                selectedGeofenceLandmark = landmark
                showGeofenceAudioGuide = true
            }
        }
        .fullScreenCover(isPresented: $showGeofenceAudioGuide) {
            GeofencedAudioGuideDetailView(landmark: selectedGeofenceLandmark)
        }
        .onChange(of: notificationManager.activeGeofenceAlert) { _, landmark in
            if let landmark = landmark {
                selectedGeofenceLandmark = landmark
                showGeofenceAudioGuide = true
                notificationManager.activeGeofenceAlert = nil
            }
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
                    .overlay(Capsule().stroke(skyBlue.opacity(0.4), lineWidth: 1))
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
                    
                    Image(systemName: "safari.fill")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 1) {
                    Text("TripPilot")
                        .font(.system(size: 19, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("SRI LANKA 🇱🇰")
                        .font(.system(size: 9.5, weight: .bold, design: .rounded))
                        .foregroundColor(primaryCyan)
                        .tracking(1.2)
                }
            }
            
            Spacer()
            
            
            // Notification & Profile
            HStack(spacing: 10) {
                Button(action: {
                    showNotificationsSheet = true
                }) {
                    ZStack(alignment: .topTrailing) {
                        Circle()
                            .fill(surfaceCard)
                            .frame(width: 38, height: 38)
                            .overlay(Circle().stroke(containerBorder, lineWidth: 1))
                        
                        Image(systemName: "bell.fill")
                            .font(.system(size: 14))
                            .foregroundColor(slateLight)
                            .frame(width: 38, height: 38)
                        
                        if notificationManager.unreadCount > 0 {
                            Circle()
                                .fill(skyBlue)
                                .frame(width: 8, height: 8)
                                .overlay(Circle().stroke(Color.black, lineWidth: 1.5))
                                .offset(x: -2, y: 2)
                        }
                    }
                }
                
                Button(action: {
                    navigateToProfile = true
                }) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color(red: 56/255, green: 189/255, blue: 248/255), Color(red: 68/255, green: 226/255, blue: 205/255)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 36, height: 36)
                            .overlay(Circle().stroke(skyBlue.opacity(0.8), lineWidth: 2))
                        
                        Text("C")
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
    
    // MARK: - 2. Greeting & Weather
    private var greetingWeatherSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Ayubowan, Chethana! 🇱🇰")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Your itinerary for \(tripManager.currentTrip.title) is active with \(tripManager.currentTrip.days.count) curated days.")
                    .font(.system(size: 13.5, weight: .regular))
                    .foregroundColor(slateMuted)
            }
            
            // Weather Capsule
            HStack(spacing: 8) {
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 14))
                    .foregroundColor(amberGold)
                
                Text("Colombo 29°C")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Tropical Sunshine")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(slateMuted)
                
                Circle()
                    .fill(Color(white: 0.4))
                    .frame(width: 3, height: 3)
                
                Text("AQI 18 Pristine")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundColor(primaryCyan)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(surfaceCard.opacity(0.9))
            .clipShape(Capsule())
            .overlay(Capsule().stroke(containerBorder, lineWidth: 1))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - 3. Hero Active Trip Card
    private var heroTripCard: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1586861635167-e5223aadc9fe?q=80&w=800&auto=format&fit=crop")) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        ZStack {
                            LinearGradient(
                                colors: [Color(red: 20/255, green: 40/255, blue: 35/255), Color(red: 10/255, green: 20/255, blue: 30/255)],
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
                
                LinearGradient(
                    colors: [Color.clear, surfaceDark.opacity(0.6), surfaceDark],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 190)
                
                // Top Action & Badge
                VStack {
                    HStack {
                        HStack(spacing: 5) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(skyBlue)
                            Text("Active Itinerary")
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .textCase(.uppercase)
                                .tracking(0.6)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.black.opacity(0.65))
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color.white.opacity(0.15), lineWidth: 1))
                        
                        Spacer()
                        
                        // Plan / Regenerate Button
                        Button(action: {
                            showTripWizardModal = true
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "wand.and.stars")
                                    .font(.system(size: 11, weight: .bold))
                                Text("Customize Trip")
                                    .font(.system(size: 11, weight: .bold, design: .rounded))
                            }
                            .foregroundColor(Color.black)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(skyBlue)
                            .clipShape(Capsule())
                            .shadow(color: skyBlue.opacity(0.4), radius: 6)
                        }
                    }
                    .padding(12)
                    
                    Spacer()
                }
                
                // Trip Header
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("\(tripManager.currentTrip.days.count) DAYS • SRI LANKA")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(skyBlue)
                            .tracking(0.6)
                        
                        Spacer()
                    }
                    
                    Text(tripManager.currentTrip.title)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.system(size: 12))
                            .foregroundColor(slateMuted)
                        Text(tripManager.currentTrip.destination)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(slateLight)
                    }
                }
                .padding(14)
            }
            .frame(height: 190)
            
            // Details & Chips
            VStack(spacing: 14) {
                // Quick Badges
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        chipBadge(icon: "airplane", text: "UL 504 Confirmed", iconColor: skyBlue)
                        chipBadge(icon: "bed.double.fill", text: "Heritance Kandalama (3n)", iconColor: primaryCyan)
                        chipBadge(icon: "tram.fill", text: "Ella Scenic Train (1st Class)", iconColor: amberGold)
                    }
                }
            }
            .padding(16)
            .background(surfaceDark)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(containerBorder, lineWidth: 1))
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
        .overlay(Capsule().stroke(Color.white.opacity(0.08), lineWidth: 1))
    }
    
    // MARK: - 4. Today's Live Itinerary Timeline Widget
    private var todayScheduleWidget: some View {
        VStack(spacing: 16) {
            HStack {
                HStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(skyBlue.opacity(0.15))
                            .frame(width: 32, height: 32)
                            .overlay(Circle().stroke(skyBlue.opacity(0.25), lineWidth: 1))
                        
                        Image(systemName: "clock.fill")
                            .font(.system(size: 14))
                            .foregroundColor(skyBlue)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Today's Schedule")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        if let firstDay = tripManager.currentTrip.days.first {
                            Text("Day 1: \(firstDay.theme)")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(slateMuted)
                        }
                    }
                }
                
                Spacer()
                
                Button(action: {
                    navigateToItinerary = true
                }) {
                    HStack(spacing: 3) {
                        Text("Full Schedule")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 10, weight: .bold))
                    }
                    .foregroundColor(skyBlue)
                }
            }
            
            // Timeline Rows
            if let firstDay = tripManager.currentTrip.days.first {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(Array(firstDay.stops.prefix(3))) { stop in
                        timelineItemView(
                            time: stop.time,
                            tag: stop.tag,
                            tagColor: stop.isHighlight ? skyBlue : primaryCyan,
                            title: stop.title,
                            subtitle: stop.description,
                            iconName: stop.categoryIcon,
                            iconBgColor: stop.isHighlight ? skyBlue : slateDark,
                            iconFgColor: stop.isHighlight ? .black : slateLight,
                            showGlow: stop.isHighlight
                        )
                    }
                }
            }
        }
        .padding(16)
        .background(surfaceDark)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(containerBorder, lineWidth: 1))
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
            ZStack {
                Circle()
                    .fill(iconBgColor)
                    .frame(width: 26, height: 26)
                    .overlay(Circle().stroke(surfaceDark, lineWidth: 3))
                    .shadow(color: showGlow ? iconBgColor.opacity(0.6) : Color.clear, radius: 6)
                
                Image(systemName: iconName)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(iconFgColor)
            }
            
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
            .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(containerBorder, lineWidth: 1))
        }
    }
    
    // MARK: - 5. Interactive Map Widget
    private var explorationMapWidget: some View {
        VStack(spacing: 12) {
            HStack {
                HStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(skyBlue.opacity(0.15))
                            .frame(width: 32, height: 32)
                            .overlay(Circle().stroke(skyBlue.opacity(0.25), lineWidth: 1))
                        
                        Image(systemName: "map.fill")
                            .font(.system(size: 14))
                            .foregroundColor(skyBlue)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Exploration Map")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Sri Lanka Island Network")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(slateMuted)
                    }
                }
                
                Spacer()
                
                Text("8 UNESCO & Wildlife Pins")
                    .font(.system(size: 10.5, weight: .bold, design: .rounded))
                    .foregroundColor(slateLight)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 4)
                    .background(Color.white.opacity(0.1))
                    .clipShape(Capsule())
            }
            
            Button(action: {
                navigateToInteractiveMap = true
            }) {
                ZStack(alignment: .bottom) {
                    AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1544735716-392fe2489ffa?q=80&w=800&auto=format&fit=crop")) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else {
                            Rectangle().fill(surfaceCard)
                        }
                    }
                    .frame(height: 160)
                    .clipped()
                    
                    LinearGradient(
                        colors: [Color.clear, Color.black.opacity(0.4), Color.black.opacity(0.85)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    
                    VStack(spacing: 8) {
                        HStack(spacing: 6) {
                            mapTagPill(name: "Sigiriya", dotColor: amberGold)
                            mapTagPill(name: "Ella Bridge", dotColor: primaryCyan)
                            mapTagPill(name: "Galle Fort", dotColor: skyBlue)
                            Spacer()
                        }
                        
                        HStack {
                            Text("Tap to launch Interactive Island Map")
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
                .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(containerBorder, lineWidth: 1))
            }
        }
        .padding(16)
        .background(surfaceDark)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(containerBorder, lineWidth: 1))
        .shadow(color: Color.black.opacity(0.4), radius: 12, y: 4)
    }
    
    private func mapTagPill(name: String, dotColor: Color) -> some View {
        HStack(spacing: 4) {
            Circle()
                .fill(dotColor)
                .frame(width: 6, height: 6)
            Text(name)
                .font(.system(size: 10, weight: .bold, design: .rounded))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(surfaceDark.opacity(0.9))
        .clipShape(Capsule())
    }
    
    // MARK: - 6. Travel Stats & Budget Grid
    private var statsAndBudgetGrid: some View {
        HStack(spacing: 12) {
            Button(action: {
                navigateToBudget = true
            }) {
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
                        ZStack {
                            Circle()
                                .stroke(slateDark, lineWidth: 4)
                                .frame(width: 44, height: 44)
                            
                            Circle()
                                .trim(from: 0, to: 0.65)
                                .stroke(skyBlue, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                                .frame(width: 44, height: 44)
                                .rotationEffect(.degrees(-90))
                            
                            Text("65%")
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Rs. 420k")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("of Rs. 650k Cap")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(slateMuted)
                        }
                    }
                    
                    Text("Rs. 230,000 remaining")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(primaryCyan)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 4)
                        .background(surfaceCard)
                        .clipShape(Capsule())
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(surfaceDark)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(containerBorder, lineWidth: 1))
            }
            .buttonStyle(.plain)
            
            Button(action: {
                navigateToPlaceDiscovery = true
            }) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("SRI LANKA VAULT")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundColor(slateMuted)
                            .tracking(0.6)
                        
                        Spacer()
                        
                        Image(systemName: "bookmark.fill")
                            .font(.system(size: 14))
                            .foregroundColor(primaryCyan)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(SriLankaDataService.shared.places.count)")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Curated Landmarks")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(slateMuted)
                    }
                    
                    HStack(spacing: -6) {
                        emojiPill(emoji: "🦁", color: amberGold)
                        emojiPill(emoji: "🚂", color: primaryCyan)
                        emojiPill(emoji: "🐘", color: skyBlue)
                        
                        Text("+5")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundColor(slateLight)
                            .frame(width: 24, height: 24)
                            .background(slateDark)
                            .clipShape(Circle())
                    }
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(surfaceDark)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(containerBorder, lineWidth: 1))
            }
            .buttonStyle(.plain)
        }
    }
    
    private func emojiPill(emoji: String, color: Color) -> some View {
        Text(emoji)
            .font(.system(size: 11))
            .frame(width: 24, height: 24)
            .background(color.opacity(0.2))
            .clipShape(Circle())
    }
    
    // MARK: - 7. Trip Step Count Tracker
    private var stepCountTrackerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Section Header
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "figure.walk.motion")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(primaryCyan)
                    
                    Text("Trip Step Tracker")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(slateLight)
                }
                
                Spacer()
                
                // Live Motion Indicator
                HStack(spacing: 5) {
                    Circle()
                        .fill(primaryCyan)
                        .frame(width: 7, height: 7)
                        .scaleEffect(isLivePulsing ? 1.3 : 0.8)
                        .opacity(isLivePulsing ? 1.0 : 0.5)
                        .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: isLivePulsing)
                    
                    Text("LIVE MOTION")
                        .font(.system(size: 10, weight: .heavy, design: .rounded))
                        .foregroundColor(primaryCyan)
                }
                .padding(.horizontal, 9)
                .padding(.vertical, 4)
                .background(primaryCyan.opacity(0.12))
                .clipShape(Capsule())
            }
            
            // Primary Glass Card
            VStack(spacing: 14) {
                // Steps Count & Goal Ring
                HStack(alignment: .center) {
                    // Left: Steps count & goal
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(stepTracker.todaySteps.formatted())")
                            .font(.system(size: 34, weight: .heavy, design: .rounded))
                            .foregroundColor(slateLight)
                        
                        Text("Steps Walked Today • Goal: \(stepTracker.dailyGoal.formatted())")
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundColor(slateMuted)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "suitcase.fill")
                                .font(.system(size: 10))
                            Text("Trip Total: \(stepTracker.tripTotalSteps.formatted()) steps (~\(String(format: "%.1f", stepTracker.tripDistanceKm)) km)")
                                .font(.system(size: 11, weight: .semibold, design: .rounded))
                        }
                        .foregroundColor(skyBlue)
                        .padding(.top, 2)
                    }
                    
                    Spacer()
                    
                    // Right: Circular Progress Ring
                    ZStack {
                        // Background track
                        Circle()
                            .stroke(containerBorder, lineWidth: 8)
                            .frame(width: 70, height: 70)
                        
                        // Progress Arc
                        Circle()
                            .trim(from: 0, to: CGFloat(stepTracker.goalProgress))
                            .stroke(
                                LinearGradient(
                                    colors: [primaryCyan, skyBlue],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 8, lineCap: .round)
                            )
                            .frame(width: 70, height: 70)
                            .rotationEffect(.degrees(-90))
                            .animation(.spring(response: 0.6, dampingFraction: 0.7), value: stepTracker.goalProgress)
                        
                        VStack(spacing: 1) {
                            Text(stepTracker.goalPercentText)
                                .font(.system(size: 14, weight: .heavy, design: .rounded))
                                .foregroundColor(slateLight)
                            
                            Text("GOAL")
                                .font(.system(size: 8, weight: .bold, design: .rounded))
                                .foregroundColor(primaryCyan)
                        }
                    }
                }
                
                Divider().background(containerBorder)
                
                // 3 Mini Stat Pills: Distance, Calories, Active Time
                HStack(spacing: 8) {
                    statPill(icon: "figure.walk", label: "Distance", value: "\(String(format: "%.2f", stepTracker.distanceKm)) km", color: primaryCyan)
                    statPill(icon: "flame.fill", label: "Calories", value: "\(stepTracker.activeCalories) kcal", color: coralAccent)
                    statPill(icon: "timer", label: "Active Time", value: "\(stepTracker.activeMinutes) min", color: amberGold)
                }
                
                // "Small Idea" / Travel Activity Insight Box
                let idea = stepTracker.currentTravelIdea
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: idea.icon)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(idea.accentColor)
                        .frame(width: 36, height: 36)
                        .background(idea.accentColor.opacity(0.16))
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 3) {
                        HStack {
                            Text(idea.title)
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                .foregroundColor(slateLight)
                            
                            Spacer()
                            
                            Text(idea.badge)
                                .font(.system(size: 9, weight: .heavy, design: .rounded))
                                .foregroundColor(idea.accentColor)
                                .padding(.horizontal, 7)
                                .padding(.vertical, 2)
                                .background(idea.accentColor.opacity(0.15))
                                .clipShape(Capsule())
                        }
                        
                        Text(idea.description)
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .foregroundColor(slateMuted)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(11)
                .background(isDarkMode ? Color.white.opacity(0.04) : Color.black.opacity(0.03))
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(containerBorder, lineWidth: 1))
                
                // Interactive Controls: Simulate Walk / Sync
                HStack {
                    Button(action: {
                        stepTracker.simulateWalk(steps: 350)
                        triggerNotice("🚶 Logged +350 steps on your Ceylon exploration!")
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 12, weight: .bold))
                            Text("Simulate Walk (+350)")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                        }
                        .foregroundColor(primaryCyan)
                        .padding(.horizontal, 11)
                        .padding(.vertical, 6)
                        .background(primaryCyan.opacity(0.12))
                        .clipShape(Capsule())
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        stepTracker.startTracking()
                        triggerNotice("🔄 Synced with motion pedometer data")
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 11, weight: .semibold))
                            Text(stepTracker.statusMessage)
                                .font(.system(size: 10, weight: .semibold, design: .rounded))
                        }
                        .foregroundColor(slateMuted)
                    }
                }
            }
            .padding(16)
            .background(surfaceCard)
            .cornerRadius(20)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(containerBorder, lineWidth: 1))
            .shadow(color: isDarkMode ? Color.black.opacity(0.3) : Color.black.opacity(0.04), radius: 10, y: 4)
        }
    }
    
    private func statPill(icon: String, label: String, value: String, color: Color) -> some View {
        VStack(spacing: 3) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(color)
                Text(label)
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                    .foregroundColor(slateMuted)
            }
            Text(value)
                .font(.system(size: 12, weight: .heavy, design: .rounded))
                .foregroundColor(slateLight)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(isDarkMode ? Color.white.opacity(0.03) : Color.black.opacity(0.02))
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(containerBorder, lineWidth: 1))
    }
    
    // MARK: - Helper Banner
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
    private var flyoverMapModalView: some View {
        ZStack {
            darkBackground.ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Text("Sri Lanka 3D Flyover Network")
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
                    AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1586861635167-e5223aadc9fe?q=80&w=800&auto=format&fit=crop")) { phase in
                        if let image = phase.image {
                            image.resizable().aspectRatio(contentMode: .fit)
                        } else {
                            Rectangle().fill(surfaceDark).frame(height: 200)
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    Text("Flyover routes between Colombo, Sigiriya, Kandy, Nuwara Eliya, Ella, Yala & Galle are cached offline.")
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
