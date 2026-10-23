import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct HomeDashboardView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var tripManager = TripManager.shared
    @ObservedObject private var stepTracker = TripStepTrackerService.shared
    @ObservedObject private var polaroidService = PolaroidGalleryService.shared
    @ObservedObject private var authViewModel = AuthViewModel.shared
    
    @State private var selectedTab: AppTab = .home
    @State private var isLivePulsing: Bool = false
    @State private var showFlyoverMapModal: Bool = false
    @State private var showTripWizardModal: Bool = false
    @State private var showPolaroidCaptureSheet: Bool = false
    @State private var selectedPolaroidMoment: PolaroidMoment? = nil
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
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @AppStorage("appSelectedTheme") private var appSelectedTheme: String = "Dark"
    
    private var isRegularLayout: Bool {
        horizontalSizeClass == .regular || DeviceLayout.isIPad
    }
    
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
                        
                        if isRegularLayout {
                            // iPad Two-Column Dashboard Layout
                            HStack(alignment: .top, spacing: 20) {
                                // Left Column
                                VStack(spacing: 20) {
                                    greetingWeatherSection
                                    heroTripCard
                                    todayScheduleWidget
                                }
                                .frame(maxWidth: .infinity, alignment: .top)
                                
                                // Right Column
                                VStack(spacing: 20) {
                                    explorationMapWidget
                                    statsAndBudgetGrid
                                    polaroidGallerySection
                                }
                                .frame(maxWidth: .infinity, alignment: .top)
                            }
                        } else {
                            // iPhone Compact Single-Column Layout
                            greetingWeatherSection
                            heroTripCard
                            todayScheduleWidget
                            explorationMapWidget
                            statsAndBudgetGrid
                            polaroidGallerySection
                        }
                        
                        Spacer()
                            .frame(height: 140)
                    }
                    .padding(.horizontal, 18)
                    .responsiveContentWidth(1100)
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
        .sheet(isPresented: $showPolaroidCaptureSheet) {
            PolaroidCaptureSheet()
        }
        .fullScreenCover(item: $selectedPolaroidMoment) { moment in
            PolaroidDetailModalView(moment: moment)
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
                        
                        Text(authViewModel.userInitials)
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
                Text("Ayubowan, \(authViewModel.userFirstName)! 🇱🇰")
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
            // Left: Trip Budget
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
                                .foregroundColor(slateLight)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Rs. 420k")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(slateLight)
                            
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
            
            // Right: Trip Steps (Compact, matching Trip Budget!)
            Button(action: {
                stepTracker.startTracking()
                triggerNotice("🔄 Original steps: \(stepTracker.todaySteps) recorded")
            }) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("TRIP STEPS")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundColor(slateMuted)
                            .tracking(0.6)
                        
                        Spacer()
                        
                        Image(systemName: "figure.walk.motion")
                            .font(.system(size: 14))
                            .foregroundColor(primaryCyan)
                    }
                    
                    HStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .stroke(slateDark, lineWidth: 4)
                                .frame(width: 44, height: 44)
                            
                            Circle()
                                .trim(from: 0, to: CGFloat(max(0.01, stepTracker.goalProgress)))
                                .stroke(primaryCyan, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                                .frame(width: 44, height: 44)
                                .rotationEffect(.degrees(-90))
                            
                            Text(stepTracker.goalPercentText)
                                .font(.system(size: 9.5, weight: .bold, design: .rounded))
                                .foregroundColor(slateLight)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(stepTracker.todaySteps)")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(slateLight)
                            
                            Text("of \(stepTracker.dailyGoal / 1000)k Goal")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(slateMuted)
                        }
                    }
                    
                    Text(stepTracker.todaySteps > 0 ? "\(String(format: "%.1f", stepTracker.distanceKm)) km explored" : "Original pedometer")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(skyBlue)
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
        }
    }
    
    // MARK: - 7. Special Moments Polaroid Journal Gallery
    private var polaroidGallerySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Section Header
            HStack(alignment: .center) {
                HStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(primaryCyan.opacity(0.16))
                            .frame(width: 32, height: 32)
                            .overlay(Circle().stroke(primaryCyan.opacity(0.3), lineWidth: 1))
                        
                        Image(systemName: "camera.viewfinder")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(primaryCyan)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Special Moments")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                            .foregroundColor(slateLight)
                        
                        Text("Ceylon Polaroid Memories")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(slateMuted)
                    }
                }
                
                Spacer()
                
                // "+ Snap Moment" Button
                Button(action: {
                    showPolaroidCaptureSheet = true
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 12, weight: .bold))
                        Text("+ Snap Moment")
                            .font(.system(size: 11.5, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(Color.black)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(
                        LinearGradient(colors: [primaryCyan, skyBlue], startPoint: .leading, endPoint: .trailing)
                    )
                    .clipShape(Capsule())
                    .shadow(color: primaryCyan.opacity(0.35), radius: 6, y: 2)
                }
            }
            
            // Horizontal Carousel of Polaroids
            if polaroidService.moments.isEmpty {
                Button(action: {
                    showPolaroidCaptureSheet = true
                }) {
                    VStack(spacing: 12) {
                        Image(systemName: "camera.badge.ellipsis")
                            .font(.system(size: 34))
                            .foregroundColor(primaryCyan)
                        
                        VStack(spacing: 3) {
                            Text("No Moments Captured Yet")
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .foregroundColor(slateLight)
                            
                            Text("Tap here with camera access to capture your first Sri Lankan travel polaroid!")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(slateMuted)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 36)
                    .background(surfaceDark)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [6]))
                            .foregroundColor(containerBorder)
                    )
                }
                .buttonStyle(.plain)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(polaroidService.moments) { moment in
                            Button(action: {
                                selectedPolaroidMoment = moment
                            }) {
                                PolaroidCardView(moment: moment, cardWidth: 175)
                                    .rotationEffect(.degrees(moment.rotationDegrees))
                                    .padding(.vertical, 8)
                            }
                            .buttonStyle(.plain)
                        }
                        
                        // Trailing Snap New Slot
                        Button(action: {
                            showPolaroidCaptureSheet = true
                        }) {
                            VStack(spacing: 10) {
                                ZStack {
                                    Circle()
                                        .fill(primaryCyan.opacity(0.12))
                                        .frame(width: 48, height: 48)
                                    
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 26))
                                        .foregroundColor(primaryCyan)
                                }
                                
                                Text("Snap\nNew")
                                    .font(.system(size: 12, weight: .bold, design: .rounded))
                                    .foregroundColor(slateLight)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(width: 140, height: 230)
                            .background(surfaceDark.opacity(0.6))
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [5]))
                                    .foregroundColor(containerBorder)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 4)
                    .padding(.bottom, 6)
                }
            }
        }
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
