import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Theme Mode Enum
enum ThemeAppearanceMode: String, CaseIterable, Identifiable {
    case light = "Light"
    case dark = "Dark"
    case auto = "Auto"
    
    var id: String { rawValue }
}

// MARK: - Main View
struct SettingsProfileView: View {
    @Environment(\.dismiss) private var dismiss
    
    // Theme Colors
    private let darkBackground = Color(red: 15/255, green: 19/255, blue: 28/255)            // #0f131c
    private let surfaceContainerLowest = Color(red: 10/255, green: 14/255, blue: 22/255)   // #0a0e16
    private let surfaceContainerLow = Color(red: 24/255, green: 28/255, blue: 36/255)      // #181c24
    private let surfaceContainer = Color(red: 28/255, green: 32/255, blue: 40/255)         // #1c2028
    private let surfaceContainerHigh = Color(red: 38/255, green: 42/255, blue: 51/255)     // #262a33
    private let surfaceContainerHighest = Color(red: 49/255, green: 53/255, blue: 62/255)  // #31353e
    
    private let primarySky = Color(red: 56/255, green: 189/255, blue: 248/255)             // #38bdf8
    private let primaryTint = Color(red: 142/255, green: 213/255, blue: 255/255)          // #8ed5ff
    private let secondaryMint = Color(red: 68/255, green: 226/255, blue: 205/255)          // #44e2cd
    private let secondaryContainer = Color(red: 3/255, green: 198/255, blue: 178/255)      // #03c6b2
    private let tertiaryBlue = Color(red: 175/255, green: 207/255, blue: 255/255)          // #afcfff
    private let errorRed = Color(red: 255/255, green: 180/255, blue: 171/255)              // #ffb4ab
    
    private let textOnSurface = Color(red: 223/255, green: 226/255, blue: 238/255)         // #dfe2ee
    private let textVariant = Color(red: 189/255, green: 200/255, blue: 209/255)           // #bdc8d1
    private let outlineVariant = Color(red: 62/255, green: 72/255, blue: 79/255)          // #3e484f
    
    // Interactive State
    @State private var selectedTab: AppTab = .profile
    @State private var isVIPIndicatorPulsing: Bool = false
    @State private var selectedTheme: ThemeAppearanceMode = .dark
    
    // Toggles
    @State private var isFaceIDEnabled: Bool = true
    @State private var isSecureEnclaveSyncEnabled: Bool = true
    @State private var isFlightAlertsEnabled: Bool = true
    @State private var isGeofencedAudioEnabled: Bool = true
    @State private var isHapticFeedbackEnabled: Bool = true
    
    // Modals & Feedback
    @State private var showPassportQRSheet: Bool = false
    @State private var showSignOutAlert: Bool = false
    @State private var feedbackNotice: String? = nil
    
    // Navigation destinations
    @State private var navigateToHome: Bool = false
    @State private var navigateToItinerary: Bool = false
    @State private var navigateToMap: Bool = false
    @State private var navigateToBudget: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background
            darkBackground
                .ignoresSafeArea()
            
            // Atmospheric Ambient Glows
            GeometryReader { _ in
                Circle()
                    .fill(primarySky.opacity(0.06))
                    .frame(width: 320, height: 320)
                    .blur(radius: 80)
                    .offset(x: -60, y: -40)
                
                Circle()
                    .fill(secondaryMint.opacity(0.05))
                    .frame(width: 300, height: 300)
                    .blur(radius: 70)
                    .offset(x: 180, y: 350)
            }
            .ignoresSafeArea()
            
            // Main Scrollable Content
            ScrollView(showsIndicators: false) {
                VStack(spacing: 22) {
                    // Header buffer
                    Spacer()
                        .frame(height: 64)
                    
                    // MARK: - 1. Profile Header Card & Stats
                    profileHeaderCard
                    
                    // MARK: - 2. Group 1: Travel Preferences & AI Engine
                    travelPreferencesSection
                    
                    // MARK: - 3. Group 2: Security & Biometrics
                    securityBiometricsSection
                    
                    // MARK: - 4. Group 3: Live Notifications & Geofencing
                    notificationsGeofencingSection
                    
                    // MARK: - 5. Group 4: System & Accessibility
                    systemAccessibilitySection
                    
                    // MARK: - 6. Group 5: Data & Privacy
                    dataPrivacySection
                    
                    // MARK: - 7. Sign Out Action
                    signOutButton
                    
                    // MARK: - 8. Footer Credential & Accolades
                    footerCredentials
                    
                    // Bottom Spacing for Floating Tab Bar
                    Spacer()
                        .frame(height: 110)
                }
                .padding(.horizontal, 16)
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
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .preferredColorScheme(.dark)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.3).repeatForever(autoreverses: true)) {
                isVIPIndicatorPulsing = true
            }
        }
        .sheet(isPresented: $showPassportQRSheet) {
            passportQRModalSheet
        }
        .confirmationDialog("Sign Out of TripPilot?", isPresented: $showSignOutAlert, titleVisibility: .visible) {
            Button("Sign Out", role: .destructive) {
                showToast("Signed out successfully")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    dismiss()
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Your offline guides and encrypted itineraries will remain securely backed up to iCloud.")
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
            // Brand Logo & Screen Title
            HStack(spacing: 8) {
                // Back Button
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
            
            // Header Action Buttons
            HStack(spacing: 8) {
                Button(action: {
                    triggerHapticFeedback()
                    showToast("No new system alerts")
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
                            .frame(width: 8, height: 8)
                            .offset(x: -8, y: 8)
                    }
                }
                
                // User Avatar Pill
                ZStack {
                    Circle()
                        .fill(surfaceContainerHigh)
                        .frame(width: 36, height: 36)
                    
                    Text("EV")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(primarySky)
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
    
    // MARK: - 1. Profile Header Card
    private var profileHeaderCard: some View {
        VStack(spacing: 16) {
            HStack(alignment: .center, spacing: 14) {
                // User Avatar with Verified Badge
                ZStack(alignment: .bottomTrailing) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color(red: 24/255, green: 76/255, blue: 120/255), Color(red: 14/255, green: 40/255, blue: 70/255)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 64, height: 64)
                        
                        Text("EV")
                            .font(.system(size: 24, weight: .heavy, design: .rounded))
                            .foregroundColor(primaryTint)
                    }
                    .shadow(color: Color.black.opacity(0.4), radius: 8, y: 3)
                    
                    // Checkmark badge
                    ZStack {
                        Circle()
                            .fill(primarySky)
                            .frame(width: 20, height: 20)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Color(red: 0/255, green: 30/255, blue: 44/255))
                    }
                    .offset(x: 2, y: 2)
                }
                
                // Name & VIP Status
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 5) {
                        Text("Elena Vance")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(textOnSurface)
                        
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(primarySky)
                    }
                    
                    Text("elena.vance@icloud.com")
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .foregroundColor(textVariant)
                    
                    // VIP Badge
                    HStack(spacing: 5) {
                        Circle()
                            .fill(primarySky)
                            .frame(width: 6, height: 6)
                            .opacity(isVIPIndicatorPulsing ? 1.0 : 0.4)
                            .scaleEffect(isVIPIndicatorPulsing ? 1.2 : 0.9)
                        
                        Text("FOUNDER VIP • LIFETIME")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundColor(primarySky)
                            .tracking(0.6)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(primarySky.opacity(0.16))
                    .clipShape(Capsule())
                    .padding(.top, 2)
                }
                
                Spacer()
                
                // Passport QR Code Button
                Button(action: {
                    triggerHapticFeedback()
                    showPassportQRSheet = true
                }) {
                    ZStack {
                        Circle()
                            .fill(surfaceContainerHigh)
                            .frame(width: 44, height: 44)
                        
                        Image(systemName: "qrcode")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(primarySky)
                    }
                    .shadow(color: Color.black.opacity(0.3), radius: 6, y: 2)
                }
            }
            
            // Travel Stats Row
            HStack(spacing: 0) {
                // Trips
                VStack(spacing: 2) {
                    Text("8")
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                        .foregroundColor(textOnSurface)
                    
                    Text("TRIPS")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(textVariant)
                        .tracking(0.6)
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                    .background(surfaceContainerHighest.opacity(0.5))
                    .frame(height: 28)
                
                // Countries
                VStack(spacing: 2) {
                    Text("18")
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                        .foregroundColor(secondaryMint)
                    
                    Text("COUNTRIES")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(textVariant)
                        .tracking(0.6)
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                    .background(surfaceContainerHighest.opacity(0.5))
                    .frame(height: 28)
                
                // Saved
                VStack(spacing: 2) {
                    Text("324")
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                        .foregroundColor(primarySky)
                    
                    Text("SAVED")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(textVariant)
                        .tracking(0.6)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.vertical, 12)
            .background(surfaceContainerLow.opacity(0.7))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .padding(18)
        .background(surfaceContainer)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.4), radius: 16, y: 6)
    }
    
    // MARK: - 2. Group 1: Travel Preferences & AI Engine
    private var travelPreferencesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("TRAVEL PREFERENCES & AI ENGINE")
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundColor(textVariant)
                .tracking(0.6)
                .padding(.horizontal, 4)
            
            VStack(spacing: 0) {
                // AI Travel Persona
                settingRowButton(
                    icon: "sparkles",
                    iconColor: primarySky,
                    iconBg: primarySky.opacity(0.18),
                    title: "AI Travel Persona",
                    value: "Balanced Explorer"
                ) {
                    showToast("Persona: Balanced Explorer (Cultural + Culinary)")
                }
                
                rowDivider
                
                // Home Hub Airport
                settingRowButton(
                    icon: "airplane.departure",
                    iconColor: secondaryMint,
                    iconBg: secondaryMint.opacity(0.18),
                    title: "Home Hub Airport",
                    value: "SFO (San Francisco)"
                ) {
                    showToast("Home Hub set to San Francisco Intl (SFO)")
                }
                
                rowDivider
                
                // Airline Loyalty
                settingRowButton(
                    icon: "star.fill",
                    iconColor: tertiaryBlue,
                    iconBg: tertiaryBlue.opacity(0.18),
                    title: "Airline Loyalty",
                    value: "Star & Oneworld"
                ) {
                    showToast("Linked to United MileagePlus & JAL Mileage")
                }
                
                rowDivider
                
                // Currency & Metric Units
                settingRowButton(
                    icon: "dollarsign.circle.fill",
                    iconColor: textOnSurface,
                    iconBg: surfaceContainerHighest,
                    title: "Currency & Metric Units",
                    value: "USD ($) • km, °C"
                ) {
                    showToast("Currency USD • Distance km • Temp °C")
                }
            }
            .background(surfaceContainer)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.white.opacity(0.06), lineWidth: 1)
            )
        }
    }
    
    // MARK: - 3. Group 2: Security & Biometrics
    private var securityBiometricsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("SECURITY & BIOMETRICS")
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundColor(textVariant)
                .tracking(0.6)
                .padding(.horizontal, 4)
            
            VStack(spacing: 0) {
                // Face ID Toggle
                settingToggleRow(
                    icon: "faceid",
                    iconColor: secondaryMint,
                    iconBg: secondaryMint.opacity(0.18),
                    title: "Face ID Quick Unlock",
                    subtitle: "Authenticate instant wallet and vault",
                    isOn: $isFaceIDEnabled,
                    tintColor: secondaryMint
                )
                
                rowDivider
                
                // Secure Enclave Sync
                settingToggleRow(
                    icon: "icloud.fill",
                    iconColor: primarySky,
                    iconBg: primarySky.opacity(0.18),
                    title: "Secure Enclave Sync",
                    subtitle: "End-to-end encrypted iCloud",
                    isOn: $isSecureEnclaveSyncEnabled,
                    tintColor: primarySky
                )
                
                rowDivider
                
                // Passcode & Recovery Key
                settingRowButton(
                    icon: "key.fill",
                    iconColor: textOnSurface,
                    iconBg: surfaceContainerHighest,
                    title: "Passcode & Recovery Key",
                    value: "Configured"
                ) {
                    showToast("Recovery key active in Apple Keychain")
                }
            }
            .background(surfaceContainer)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.white.opacity(0.06), lineWidth: 1)
            )
        }
    }
    
    // MARK: - 4. Group 3: Live Notifications & Geofencing
    private var notificationsGeofencingSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("LIVE NOTIFICATIONS & GEOFENCING")
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundColor(textVariant)
                .tracking(0.6)
                .padding(.horizontal, 4)
            
            VStack(spacing: 0) {
                // Flight Status & Gate Alerts
                settingToggleRow(
                    icon: "airplane.circle.fill",
                    iconColor: primarySky,
                    iconBg: primarySky.opacity(0.18),
                    title: "Flight Status & Gate Alerts",
                    subtitle: "Real-time terminal push triggers",
                    isOn: $isFlightAlertsEnabled,
                    tintColor: primarySky
                )
                
                rowDivider
                
                // Geofenced Audio Guides
                settingToggleRow(
                    icon: "headphones",
                    iconColor: secondaryMint,
                    iconBg: secondaryMint.opacity(0.18),
                    title: "Geofenced Audio Guides",
                    subtitle: "Auto-play nearby landmark stories",
                    isOn: $isGeofencedAudioEnabled,
                    tintColor: secondaryMint
                )
                
                rowDivider
                
                // Expense Settle Alerts
                settingRowButton(
                    icon: "doc.text.fill",
                    iconColor: textOnSurface,
                    iconBg: surfaceContainerHighest,
                    title: "Expense Settle Alerts",
                    value: "Immediate"
                ) {
                    showToast("Instant alerts for split bills enabled")
                }
            }
            .background(surfaceContainer)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.white.opacity(0.06), lineWidth: 1)
            )
        }
    }
    
    // MARK: - 5. Group 4: System & Accessibility
    private var systemAccessibilitySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("SYSTEM & ACCESSIBILITY")
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundColor(textVariant)
                .tracking(0.6)
                .padding(.horizontal, 4)
            
            VStack(spacing: 0) {
                // Appearance Segmented Control
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(surfaceContainerHighest)
                                .frame(width: 32, height: 32)
                            
                            Image(systemName: "paintpalette.fill")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(primarySky)
                        }
                        
                        Text("Appearance")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(textOnSurface)
                    }
                    
                    // Segmented Pills
                    HStack(spacing: 4) {
                        ForEach(ThemeAppearanceMode.allCases) { mode in
                            let isSelected = (selectedTheme == mode)
                            Button(action: {
                                triggerHapticFeedback()
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                                    selectedTheme = mode
                                }
                                showToast("Theme set to \(mode.rawValue)")
                            }) {
                                Text(mode.rawValue)
                                    .font(.system(size: 12, weight: isSelected ? .bold : .medium, design: .rounded))
                                    .foregroundColor(isSelected ? primarySky : textVariant)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 7)
                                    .background(
                                        isSelected ?
                                        surfaceContainerHighest :
                                        Color.clear
                                    )
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(3)
                    .background(surfaceContainerLowest)
                    .clipShape(Capsule())
                }
                .padding(14)
                
                rowDivider
                
                // Dynamic Type
                settingRowButton(
                    icon: "textformat.size",
                    iconColor: textOnSurface,
                    iconBg: surfaceContainerHighest,
                    title: "Dynamic Type & Text",
                    value: "Default (Large)"
                ) {
                    showToast("Dynamic type set to Default")
                }
                
                rowDivider
                
                // Haptic Feedback
                settingToggleRow(
                    icon: "iphone.radiowaves.left.and.right",
                    iconColor: secondaryMint,
                    iconBg: secondaryMint.opacity(0.18),
                    title: "Haptic Engine Feedback",
                    subtitle: "Tactile taps on boarding pass scans",
                    isOn: $isHapticFeedbackEnabled,
                    tintColor: secondaryMint
                )
                
                rowDivider
                
                // Offline Guides & Maps
                settingRowButton(
                    icon: "arrow.down.circle.fill",
                    iconColor: tertiaryBlue,
                    iconBg: tertiaryBlue.opacity(0.18),
                    title: "Offline Guides & Vector Maps",
                    value: "4.8 GB Used"
                ) {
                    showToast("Offline package: Japan, France & Italy downloaded")
                }
            }
            .background(surfaceContainer)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.white.opacity(0.06), lineWidth: 1)
            )
        }
    }
    
    // MARK: - 6. Group 5: Data & Privacy
    private var dataPrivacySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("DATA & PRIVACY")
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundColor(textVariant)
                .tracking(0.6)
                .padding(.horizontal, 4)
            
            VStack(spacing: 0) {
                // Export Travel History
                settingRowButton(
                    icon: "square.and.arrow.up.fill",
                    iconColor: textOnSurface,
                    iconBg: surfaceContainerHighest,
                    title: "Export Travel History",
                    value: "JSON / PDF"
                ) {
                    showToast("Exporting journey archive...")
                }
                
                rowDivider
                
                // Privacy Policy & GDPR
                settingRowButton(
                    icon: "shield.lefthalf.filled",
                    iconColor: textOnSurface,
                    iconBg: surfaceContainerHighest,
                    title: "Privacy Policy & GDPR",
                    value: ""
                ) {
                    showToast("TripPilot is Zero-Tracker & GDPR certified")
                }
            }
            .background(surfaceContainer)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.white.opacity(0.06), lineWidth: 1)
            )
        }
    }
    
    // MARK: - 7. Sign Out Button
    private var signOutButton: some View {
        Button(action: {
            triggerHapticFeedback()
            showSignOutAlert = true
        }) {
            HStack(spacing: 8) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 15, weight: .bold))
                
                Text("Sign Out of TripPilot")
                    .font(.system(size: 15, weight: .bold, design: .rounded))
            }
            .foregroundColor(errorRed)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color(red: 147/255, green: 0/255, blue: 10/255).opacity(0.25))
            .clipShape(Capsule())
            .overlay(
                Capsule().stroke(errorRed.opacity(0.3), lineWidth: 1)
            )
        }
        .padding(.top, 4)
    }
    
    // MARK: - 8. Footer Credentials
    private var footerCredentials: some View {
        VStack(spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "laurel.leading")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(primarySky)
                
                Text("Apple Design Award Finalist")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundColor(textOnSurface)
                
                Image(systemName: "laurel.trailing")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(primarySky)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 5)
            .background(surfaceContainerHigh.opacity(0.7))
            .clipShape(Capsule())
            
            Text("TripPilot iOS v2.6.4 (Build 4180)\nDesigned with care in Cupertino & San Francisco")
                .font(.system(size: 11, weight: .regular, design: .rounded))
                .foregroundColor(textVariant.opacity(0.7))
                .multilineTextAlignment(.center)
                .lineSpacing(3)
        }
        .padding(.vertical, 12)
    }
    
    // MARK: - Passport QR Code Modal Sheet
    private var passportQRModalSheet: some View {
        ZStack {
            surfaceContainerLowest.ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Text("Passport Digital QR")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(textOnSurface)
                    
                    Spacer()
                    
                    Button(action: {
                        showPassportQRSheet = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(textVariant)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                
                // Simulated QR Code Card
                VStack(spacing: 16) {
                    Image(systemName: "qrcode")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 180)
                        .foregroundColor(primarySky)
                        .padding(20)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    
                    VStack(spacing: 4) {
                        Text("Elena Vance • USA Passport")
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(textOnSurface)
                        
                        Text("Hash: #TP-8832-US • Offline Verified")
                            .font(.system(size: 12, weight: .medium, design: .monospaced))
                            .foregroundColor(secondaryMint)
                    }
                }
                .padding(24)
                .background(surfaceContainer)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
    
    // MARK: - Row Components & Dividers
    private var rowDivider: some View {
        Divider()
            .background(surfaceContainerHighest.opacity(0.4))
            .padding(.leading, 56)
    }
    
    private func settingRowButton(
        icon: String,
        iconColor: Color,
        iconBg: Color,
        title: String,
        value: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: {
            triggerHapticFeedback()
            action()
        }) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(iconBg)
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: icon)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(textOnSurface)
                
                Spacer()
                
                if !value.isEmpty {
                    Text(value)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(textVariant)
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(outlineVariant)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
        }
    }
    
    private func settingToggleRow(
        icon: String,
        iconColor: Color,
        iconBg: Color,
        title: String,
        subtitle: String,
        isOn: Binding<Bool>,
        tintColor: Color
    ) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(iconBg)
                    .frame(width: 32, height: 32)
                
                Image(systemName: icon)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(iconColor)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(textOnSurface)
                
                Text(subtitle)
                    .font(.system(size: 11, weight: .regular, design: .rounded))
                    .foregroundColor(textVariant)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(tintColor)
                .onChange(of: isOn.wrappedValue) { _, newValue in
                    triggerHapticFeedback()
                    showToast("\(title): \(newValue ? "Enabled" : "Disabled")")
                }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
    }
    
    // MARK: - Helper Methods
    private func triggerHapticFeedback() {
        #if canImport(UIKit)
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        #endif
    }
    
    private func showToast(_ text: String) {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            feedbackNotice = text
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut(duration: 0.3)) {
                if feedbackNotice == text {
                    feedbackNotice = nil
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    SettingsProfileView()
}
