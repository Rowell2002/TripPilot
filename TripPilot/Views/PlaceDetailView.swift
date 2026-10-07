//
//  PlaceDetailView.swift
//  TripPilot
//
//  Generated from Stitch Screen: a063f37918b24f258bfd8fe61eb19c7a
//  Title: TripPilot - Place Detail & Booking (Dark Mode)
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Models
struct HeroSlide: Identifiable {
    let id: Int
    let imageUrl: String
    let caption: String
}

enum BookingDate: String, CaseIterable, Identifiable {
    case today = "Today"
    case tomorrow = "Tomorrow"
    case sunday = "Sunday"
    
    var id: String { rawValue }
    
    var dateString: String {
        switch self {
        case .today: return "Oct 18"
        case .tomorrow: return "Oct 19"
        case .sunday: return "Oct 20"
        }
    }
    
    var statusText: String {
        switch self {
        case .today: return "Sold Out"
        case .tomorrow: return "Available"
        case .sunday: return "Selling Fast"
        }
    }
    
    var isSoldOut: Bool {
        self == .today
    }
}

enum BookingTimeSlot: String, CaseIterable, Identifiable {
    case slot1530 = "15:30"
    case slot1700 = "17:00"
    case slot1830 = "18:30"
    case slot1945 = "19:45"
    
    var id: String { rawValue }
    
    var tag: String {
        switch self {
        case .slot1530: return "3 passes left"
        case .slot1700: return "Sunset Special"
        case .slot1830: return "Optimal flow"
        case .slot1945: return "Night silence"
        }
    }
}

struct PlaceDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    // Stitch Theme Palette
    private let darkBackground = Color(red: 15/255, green: 19/255, blue: 28/255)            // #0f131c
    private let surfaceContainerLowest = Color(red: 10/255, green: 14/255, blue: 22/255)  // #0a0e16
    private let surfaceContainerLow = Color(red: 24/255, green: 28/255, blue: 36/255)   // #181c24
    private let surfaceContainer = Color(red: 28/255, green: 32/255, blue: 40/255)      // #1c2028
    private let surfaceContainerHigh = Color(red: 38/255, green: 42/255, blue: 51/255)  // #262a33
    private let surfaceCard = Color(red: 30/255, green: 35/255, blue: 46/255)           // #1e232e
    private let primaryCyan = Color(red: 142/255, green: 213/255, blue: 255/255)         // #8ed5ff
    private let primaryContainer = Color(red: 56/255, green: 189/255, blue: 248/255)    // #38bdf8
    private let secondaryMint = Color(red: 68/255, green: 226/255, blue: 205/255)       // #44e2cd
    private let errorCoral = Color(red: 255/255, green: 180/255, blue: 171/255)         // #ffb4ab
    private let textOnSurface = Color(red: 255/255, green: 255/255, blue: 255/255)      // #ffffff
    private let textOnSurfaceVariant = Color(red: 148/255, green: 163/255, blue: 184/255) // #94a3b8
    private let textDim = Color(red: 100/255, green: 116/255, blue: 139/255)            // #64748b
    private let outlineVariant = Color.white.opacity(0.08)
    
    // Interactive State
    @State private var currentSlide: Int = 0
    @State private var selectedDate: BookingDate = .tomorrow
    @State private var selectedSlot: BookingTimeSlot = .slot1700
    @State private var adultCount: Int = 2
    @State private var youthCount: Int = 0
    @State private var includeAudioGuide: Bool = true
    @State private var isAddedToItinerary: Bool = false
    @State private var isBooked: Bool = false
    @State private var isBookingProcessing: Bool = false
    @State private var toastNotice: String? = nil
    @State private var show360PreviewModal: Bool = false
    
    // Price Constants
    private let adultPrice: Double = 38.0
    private let youthPrice: Double = 24.0
    private let guidePrice: Double = 4.0
    
    private var totalPrice: Double {
        let base = (Double(adultCount) * adultPrice) + (Double(youthCount) * youthPrice)
        let guide = includeAudioGuide ? guidePrice : 0.0
        return base + guide
    }
    
    private var ticketSummaryText: String {
        let totalPasses = adultCount + youthCount
        let passLabel = totalPasses == 1 ? "Pass" : "Passes"
        let guideLabel = includeAudioGuide ? " + Guide" : ""
        return "(\(totalPasses) \(passLabel)\(guideLabel))"
    }
    
    // Hero Slides Data
    private let heroSlides: [HeroSlide] = [
        HeroSlide(
            id: 0,
            imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuDGOXwGg1nV_y2QI0DAPD29_mlK1_JjcunlrCGDx8PNbLu0qAdtJ3JkHkKuwudt97F0eqpVEOGfbD-6MgiMnkFFExTFlqkAKZ0xKf3ITgH6JG_7NF73S5_qlBf_O6NG-dg69H4cluvbjcOkBju3YxYPg_VAgn3tFcqJKwIVUJsVJFeGg6hiUQPvDSCBKdDTAu6KpTNEgrVPObDoEctn5vo9oZeBjYuA3wmQePAQw3vkoW5JQvED-pJlPA",
            caption: "Cascading digital water falls & crystal refractions"
        ),
        HeroSlide(
            id: 1,
            imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuDPv2JsNk_xDLNB41can2LS2FznBhFI-I_MtFrlA5NTM1eWrNJNQk_oSifHmGy3fBS76FdzKPY1zXpZdIPlRlwbPxEIxPMcb1VTNWXxjiYIHAH4Zjv3SRQFsmIMSFenaOXmfXNhRhN2lUbKtteSna8QdQnJe9WgEFmjSH2Tty0VJK1BHNRUqZ0Xu6JvY9q0PdP_xZ4jUtGqzpZt3DXVqN-05pLW9AgQBPDuqcCy-JzAKiscI_Mquf82Qg",
            caption: "Forest of Resonating Lamps infinity mirrors"
        ),
        HeroSlide(
            id: 2,
            imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuAtV_eNuDPP9Uj6mxytoEXKENrQfrBenvwwAZVPVXgmAhXI0RDYiN6iJQEhB6QRHwANjRMfai_rwH4R4lruhz6eggMJfu2JOpbU0xLZj2wL1oBiHBKWut-MXxo3I6NM8Vluz_4gsAbh9d9KLz04jpu_59tWZNARnBk9FUayk-fcqTZyvyTsss2bJcQLOr3GG9tzXxme-JIkAjvbPbWYtim7J4J3KblWKyfB-PY4iP26IBw28dXSUdgnhw",
            caption: "EN TEA HOUSE blooming digital matcha tea"
        )
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background
            darkBackground
                .ignoresSafeArea()
            
            // Scrollable Content
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Spacer for top translucent header
                    Spacer()
                        .frame(height: 60)
                    
                    // MARK: - 1. Hero Experience Carousel
                    heroCarouselSection
                    
                    // Content Sections in Card Layout
                    VStack(alignment: .leading, spacing: 20) {
                        // MARK: - 2. Place Header & Status Badges
                        placeHeaderSection
                        
                        // MARK: - 3. Visitor Intelligence Matrix
                        visitorIntelligenceSection
                        
                        // MARK: - 4. Editorial Overview & Highlight Chambers
                        editorialExperienceSection
                        
                        // MARK: - 5. Ticket & Booking Engine
                        ticketBookingSection
                        
                        // MARK: - 6. Transit & Arrival Section
                        transitArrivalSection
                        
                        // Bottom buffer for sticky checkout bar
                        Spacer()
                            .frame(height: 120)
                    }
                    .frame(width: UIScreen.main.bounds.width - 32, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
                .frame(width: UIScreen.main.bounds.width)
            }
            
            // MARK: - Fixed Top Translucent Header
            VStack(spacing: 0) {
                topHeaderBar
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .ignoresSafeArea(edges: .top)
            
            // MARK: - Sticky Instant Checkout Bar (Bottom)
            stickyCheckoutBar
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .preferredColorScheme(.dark)
        .alert("360° LiDAR Spatial Preview", isPresented: $show360PreviewModal) {
            Button("Launch Full VR", role: .none) {
                triggerToast("Launching 360° LiDAR chamber preview...")
            }
            Button("Dismiss", role: .cancel) { }
        } message: {
            Text("Experience the Borderless Crystal Chamber in immersive spatial 3D audio and real-time ray-traced lighting.")
        }
        .overlay(alignment: .top) {
            if let toast = toastNotice {
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
                    .padding(.top, 74)
                    .zIndex(100)
            }
        }
    }
    
    // MARK: - Top Header Bar
    private var topHeaderBar: some View {
        HStack(spacing: 12) {
            // Back Button
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(surfaceContainerHigh.opacity(0.6))
                    .clipShape(Circle())
            }
            
            // Brand Logo & Screen Title
            HStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(primaryContainer.opacity(0.2))
                        .frame(width: 30, height: 30)
                    Image(systemName: "airplane")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(primaryContainer)
                }
                
                VStack(alignment: .leading, spacing: 1) {
                    Text("TripPilot")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(primaryCyan)
                    Text("Place Detail & Booking")
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundColor(textOnSurfaceVariant)
                }
            }
            
            Spacer()
            
            // Share Action
            Button(action: {
                triggerToast("Place booking link copied to clipboard")
            }) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(textOnSurfaceVariant)
                    .frame(width: 40, height: 40)
                    .background(surfaceContainerHigh.opacity(0.6))
                    .clipShape(Circle())
            }
            
            // Avatar
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
                Circle().stroke(primaryContainer.opacity(0.4), lineWidth: 1.5)
            )
        }
        .padding(.horizontal, 16)
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
    
    // MARK: - 1. Hero Carousel Section
    private var heroCarouselSection: some View {
        ZStack(alignment: .bottom) {
            // Paging Image Container
            TabView(selection: $currentSlide) {
                ForEach(heroSlides) { slide in
                    ZStack(alignment: .bottom) {
                        AsyncImage(url: URL(string: slide.imageUrl)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } else {
                                Color.gray.opacity(0.3)
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width, height: 330)
                        .clipped()
                        
                        // Scrim Gradients
                        LinearGradient(
                            colors: [darkBackground, darkBackground.opacity(0.3), Color.black.opacity(0.6)],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    }
                    .tag(slide.id)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(width: UIScreen.main.bounds.width, height: 330)
            
            // Top Badges Over Scrim
            VStack {
                HStack {
                    // Live Availability Pill
                    HStack(spacing: 6) {
                        Circle()
                            .fill(primaryContainer)
                            .frame(width: 7, height: 7)
                            .shadow(color: primaryContainer, radius: 4)
                        Text("LIVE AVAILABILITY")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .tracking(0.6)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(darkBackground.opacity(0.75))
                    .clipShape(Capsule())
                    .overlay(
                        Capsule().stroke(outlineVariant, lineWidth: 1)
                    )
                    
                    Spacer()
                    
                    // 360° Preview Button
                    Button(action: {
                        show360PreviewModal = true
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "view.3d")
                                .font(.system(size: 13, weight: .bold))
                            Text("360° Preview")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                        }
                        .foregroundColor(primaryContainer)
                        .padding(.horizontal, 11)
                        .padding(.vertical, 5)
                        .background(darkBackground.opacity(0.75))
                        .clipShape(Capsule())
                        .overlay(
                            Capsule().stroke(outlineVariant, lineWidth: 1)
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 14)
                
                Spacer()
            }
            
            // Bottom Controls: Pagination Dots + Curated Angles
            HStack {
                // Carousel dots
                HStack(spacing: 5) {
                    ForEach(0..<heroSlides.count, id: \.self) { idx in
                        Capsule()
                            .fill(currentSlide == idx ? primaryContainer : Color.white.opacity(0.3))
                            .frame(width: currentSlide == idx ? 16 : 6, height: 6)
                            .animation(.spring(response: 0.3), value: currentSlide)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(surfaceContainerLowest.opacity(0.85))
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(outlineVariant, lineWidth: 1)
                )
                
                Spacer()
                
                // Angle badge
                HStack(spacing: 4) {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.system(size: 11))
                        .foregroundColor(primaryContainer)
                    Text("32 Curated Angles")
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundColor(textOnSurfaceVariant)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(surfaceContainerLowest.opacity(0.85))
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(outlineVariant, lineWidth: 1)
                )
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
        }
        .frame(width: UIScreen.main.bounds.width, height: 330)
    }
    
    // MARK: - 2. Place Header & Status Badges
    private var placeHeaderSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Badges row
            HStack(spacing: 8) {
                // Star Rating
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 11))
                        .foregroundColor(Color(red: 251/255, green: 191/255, blue: 36/255))
                    Text("4.9")
                        .font(.system(size: 13, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                    Text("(42k)")
                        .font(.system(size: 11))
                        .foregroundColor(textDim)
                }
                .padding(.horizontal, 9)
                .padding(.vertical, 4)
                .background(surfaceContainerLow)
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(outlineVariant, lineWidth: 1)
                )
                
                // AI Editor's Choice
                HStack(spacing: 4) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 11))
                        .foregroundColor(primaryContainer)
                    Text("AI Editor's Choice")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundColor(primaryCyan)
                }
                .padding(.horizontal, 9)
                .padding(.vertical, 4)
                .background(primaryContainer.opacity(0.15))
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(primaryContainer.opacity(0.3), lineWidth: 1)
                )
                
                // UNESCO Partner
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 11))
                        .foregroundColor(secondaryMint)
                    Text("UNESCO Digital")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundColor(secondaryMint)
                }
                .padding(.horizontal, 9)
                .padding(.vertical, 4)
                .background(secondaryMint.opacity(0.15))
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(secondaryMint.opacity(0.3), lineWidth: 1)
                )
            }
            
            // Title & Location
            VStack(alignment: .leading, spacing: 4) {
                Text("teamLab Borderless")
                    .font(.system(size: 28, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                
                Text("MORI Building Digital Art Museum • Azabudai Hills, Minato City, Tokyo")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(textOnSurfaceVariant)
            }
        }
    }
    
    // MARK: - 3. Visitor Intelligence Matrix
    private var visitorIntelligenceSection: some View {
        VStack(spacing: 12) {
            // Header
            HStack {
                HStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(secondaryMint.opacity(0.15))
                            .frame(width: 32, height: 32)
                        Image(systemName: "chart.xyaxis.line")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(secondaryMint)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Visitor Intelligence")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        Text("Live telemetry powered by TripPilot Radar")
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .foregroundColor(textDim)
                    }
                }
                
                Spacer()
                
                Text("LIVE")
                    .font(.system(size: 10, weight: .heavy, design: .rounded))
                    .foregroundColor(secondaryMint)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 3)
                    .background(secondaryMint.opacity(0.2))
                    .clipShape(Capsule())
                    .overlay(
                        Capsule().stroke(secondaryMint.opacity(0.4), lineWidth: 1)
                    )
            }
            
            // Metric Cards Grid
            HStack(spacing: 10) {
                // Optimal Window
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 5) {
                        Image(systemName: "sun.horizon.fill")
                            .font(.system(size: 14))
                            .foregroundColor(primaryContainer)
                        Text("OPTIMAL WINDOW")
                            .font(.system(size: 9, weight: .bold, design: .rounded))
                            .foregroundColor(textDim)
                    }
                    Text("17:00 – 19:30")
                        .font(.system(size: 15, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                    Text("Lowest queue lag")
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundColor(secondaryMint)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(surfaceCard)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12).stroke(outlineVariant, lineWidth: 1)
                )
                
                // Climate Factor
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 5) {
                        Image(systemName: "umbrella.fill")
                            .font(.system(size: 14))
                            .foregroundColor(secondaryMint)
                        Text("CLIMATE FACTOR")
                            .font(.system(size: 9, weight: .bold, design: .rounded))
                            .foregroundColor(textDim)
                    }
                    Text("100% Rainproof")
                        .font(.system(size: 15, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                    Text("Subterranean climate")
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundColor(textOnSurfaceVariant)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(surfaceCard)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12).stroke(outlineVariant, lineWidth: 1)
                )
            }
            
            // Crowd Forecast Bar Graph
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Hourly Density Flow")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Circle()
                            .fill(errorCoral)
                            .frame(width: 5, height: 5)
                        Text("Peak at 16:30")
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                            .foregroundColor(errorCoral)
                    }
                }
                
                // Bars
                HStack(alignment: .bottom, spacing: 10) {
                    densityBar(label: "10h", heightPercent: 0.40, color: primaryContainer.opacity(0.35))
                    densityBar(label: "12h", heightPercent: 0.65, color: primaryContainer.opacity(0.50))
                    densityBar(label: "14h", heightPercent: 0.80, color: primaryContainer.opacity(0.75))
                    densityBar(label: "16h", heightPercent: 0.98, color: errorCoral, isPeak: true)
                    densityBar(label: "18h", heightPercent: 0.50, color: secondaryMint, isTarget: true)
                    densityBar(label: "20h", heightPercent: 0.30, color: primaryContainer.opacity(0.30))
                }
                .frame(height: 70)
            }
            .padding(12)
            .background(surfaceCard)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12).stroke(outlineVariant, lineWidth: 1)
            )
        }
        .padding(14)
        .background(surfaceContainerLow)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18).stroke(outlineVariant, lineWidth: 1)
        )
    }
    
    private func densityBar(label: String, heightPercent: CGFloat, color: Color, isPeak: Bool = false, isTarget: Bool = false) -> some View {
        VStack(spacing: 4) {
            ZStack(alignment: .bottom) {
                Capsule()
                    .fill(Color.white.opacity(0.06))
                    .frame(height: 52)
                
                Capsule()
                    .fill(color)
                    .frame(height: 52 * heightPercent)
                    .shadow(color: isPeak ? errorCoral.opacity(0.5) : (isTarget ? secondaryMint.opacity(0.4) : .clear), radius: 6)
            }
            .frame(maxWidth: .infinity)
            
            Text(label)
                .font(.system(size: 9, weight: isPeak || isTarget ? .bold : .medium, design: .rounded))
                .foregroundColor(isPeak ? errorCoral : (isTarget ? secondaryMint : textDim))
        }
    }
    
    // MARK: - 4. Editorial Overview & Highlight Chambers
    private var editorialExperienceSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("The Experience")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("AI Overview")
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundColor(textOnSurfaceVariant)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.white.opacity(0.08))
                    .clipShape(Capsule())
            }
            
            Text("Relocated to Azabudai Hills, teamLab Borderless is an interconnected universe of boundary-free digital art installations. Artworks transcend physical rooms, communicating with other creations, intertwining, and transforming in reaction to continuous visitor presence.")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(textOnSurfaceVariant)
                .lineSpacing(4)
            
            // 3 Curated Highlight Chambers
            VStack(alignment: .leading, spacing: 8) {
                Text("CURATED HIGHLIGHT CHAMBERS")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .tracking(0.6)
                    .foregroundColor(.white)
                
                HStack(spacing: 8) {
                    chamberCard(icon: "diamond.fill", iconColor: primaryContainer, title: "Infinite Crystal", subtitle: "Mirror refraction")
                    chamberCard(icon: "lightbulb.fill", iconColor: secondaryMint, title: "Forest of Lamps", subtitle: "Murano glass")
                    chamberCard(icon: "cup.and.saucer.fill", iconColor: primaryCyan, title: "EN Tea House", subtitle: "Digital bloom bowl")
                }
            }
            
            // Pro Planning Tips
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "lightbulb.max.fill")
                    .font(.system(size: 16))
                    .foregroundColor(primaryContainer)
                    .padding(.top, 2)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Pro Planning Tips")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("Pants and flat footwear are highly advised due to reflective mirrored floors. Free on-site luggage lockers handle daypacks.")
                        .font(.system(size: 12))
                        .foregroundColor(textOnSurfaceVariant)
                        .lineSpacing(2)
                }
            }
            .padding(12)
            .background(surfaceCard)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12).stroke(outlineVariant, lineWidth: 1)
            )
        }
        .padding(14)
        .background(surfaceContainerLow)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18).stroke(outlineVariant, lineWidth: 1)
        )
    }
    
    private func chamberCard(icon: String, iconColor: Color, title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(iconColor)
            Text(title)
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .lineLimit(1)
            Text(subtitle)
                .font(.system(size: 9, weight: .medium, design: .rounded))
                .foregroundColor(textDim)
                .lineLimit(1)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10).stroke(outlineVariant, lineWidth: 1)
        )
    }
    
    // MARK: - 5. Ticket & Booking Engine
    private var ticketBookingSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Select Entry & Tickets")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("Direct pass with instantaneous mobile sync")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(textOnSurfaceVariant)
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(primaryContainer.opacity(0.15))
                        .frame(width: 32, height: 32)
                    Image(systemName: "ticket.fill")
                        .font(.system(size: 14))
                        .foregroundColor(primaryContainer)
                }
            }
            
            // Schedule Window
            VStack(alignment: .leading, spacing: 8) {
                Text("SCHEDULE WINDOW")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .tracking(0.6)
                    .foregroundColor(textDim)
                
                HStack(spacing: 8) {
                    ForEach(BookingDate.allCases) { date in
                        Button(action: {
                            if !date.isSoldOut {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedDate = date
                                }
                            }
                        }) {
                            VStack(spacing: 2) {
                                Text(date.rawValue.uppercased())
                                    .font(.system(size: 9, weight: .bold, design: .rounded))
                                    .foregroundColor(selectedDate == date ? Color(red: 0/255, green: 40/255, blue: 60/255) : textDim)
                                Text(date.dateString)
                                    .font(.system(size: 14, weight: .heavy, design: .rounded))
                                    .foregroundColor(selectedDate == date ? Color(red: 0/255, green: 40/255, blue: 60/255) : .white)
                                Text(date.statusText)
                                    .font(.system(size: 9, weight: .bold, design: .rounded))
                                    .foregroundColor(
                                        date.isSoldOut ? errorCoral : (selectedDate == date ? Color(red: 0/255, green: 40/255, blue: 60/255) : primaryContainer)
                                    )
                            }
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background(
                                selectedDate == date ? primaryContainer : surfaceCard
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10).stroke(selectedDate == date ? primaryContainer : outlineVariant, lineWidth: 1)
                            )
                            .shadow(color: selectedDate == date ? primaryContainer.opacity(0.35) : .clear, radius: 8)
                        }
                        .disabled(date.isSoldOut)
                        .opacity(date.isSoldOut ? 0.6 : 1.0)
                    }
                }
            }
            
            // Time Slot Selector
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("ENTRY TIME SLOT")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .tracking(0.6)
                        .foregroundColor(textDim)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Circle()
                            .fill(secondaryMint)
                            .frame(width: 5, height: 5)
                        Text("4 slots open")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundColor(secondaryMint)
                    }
                }
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    ForEach(BookingTimeSlot.allCases) { slot in
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedSlot = slot
                            }
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(slot.rawValue)
                                        .font(.system(size: 14, weight: .heavy, design: .rounded))
                                        .foregroundColor(selectedSlot == slot ? Color(red: 0/255, green: 40/255, blue: 60/255) : .white)
                                    Text(slot.tag)
                                        .font(.system(size: 9, weight: .semibold, design: .rounded))
                                        .foregroundColor(selectedSlot == slot ? Color(red: 0/255, green: 40/255, blue: 60/255).opacity(0.8) : textDim)
                                }
                                
                                Spacer()
                                
                                Image(systemName: selectedSlot == slot ? "checkmark.circle.fill" : "clock")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(selectedSlot == slot ? Color(red: 0/255, green: 40/255, blue: 60/255) : textDim)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 8)
                            .background(selectedSlot == slot ? primaryContainer : surfaceCard)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10).stroke(selectedSlot == slot ? primaryContainer : outlineVariant, lineWidth: 1)
                            )
                            .shadow(color: selectedSlot == slot ? primaryContainer.opacity(0.3) : .clear, radius: 6)
                        }
                    }
                }
            }
            
            // Pass Quantities
            VStack(spacing: 8) {
                // Adult
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 5) {
                            Text("Adult Pass")
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            Text("18+ yrs")
                                .font(.system(size: 9, weight: .bold, design: .rounded))
                                .foregroundColor(textOnSurfaceVariant)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 2)
                                .background(Color.white.opacity(0.08))
                                .clipShape(Capsule())
                        }
                        Text("$38.00 / ¥5,800")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundColor(textOnSurfaceVariant)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 12) {
                        Button(action: {
                            if adultCount > 1 {
                                adultCount -= 1
                            }
                        }) {
                            Image(systemName: "minus")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                                .background(Color.white.opacity(0.1))
                                .clipShape(Circle())
                        }
                        
                        Text("\(adultCount)")
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(width: 20)
                        
                        Button(action: {
                            adultCount += 1
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Color(red: 0/255, green: 40/255, blue: 60/255))
                                .frame(width: 30, height: 30)
                                .background(primaryContainer)
                                .clipShape(Circle())
                                .shadow(color: primaryContainer.opacity(0.4), radius: 6)
                        }
                    }
                }
                .padding(10)
                .background(surfaceCard)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                // Youth
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 5) {
                            Text("Youth Pass")
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            Text("13–17 yrs")
                                .font(.system(size: 9, weight: .bold, design: .rounded))
                                .foregroundColor(textOnSurfaceVariant)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 2)
                                .background(Color.white.opacity(0.08))
                                .clipShape(Capsule())
                        }
                        Text("$24.00")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundColor(textOnSurfaceVariant)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 12) {
                        Button(action: {
                            if youthCount > 0 {
                                youthCount -= 1
                            }
                        }) {
                            Image(systemName: "minus")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                                .background(Color.white.opacity(0.1))
                                .clipShape(Circle())
                        }
                        
                        Text("\(youthCount)")
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(width: 20)
                        
                        Button(action: {
                            youthCount += 1
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                                .background(Color.white.opacity(0.1))
                                .clipShape(Circle())
                        }
                    }
                }
                .padding(10)
                .background(surfaceCard)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                // Audio Guide Add-on
                Toggle(isOn: $includeAudioGuide) {
                    HStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(secondaryMint.opacity(0.15))
                                .frame(width: 28, height: 28)
                            Image(systemName: "headphones")
                                .font(.system(size: 12))
                                .foregroundColor(secondaryMint)
                        }
                        
                        VStack(alignment: .leading, spacing: 1) {
                            Text("Smart Audio Spatial Guide")
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            Text("Binaural story narration (+$4.00)")
                                .font(.system(size: 11))
                                .foregroundColor(textOnSurfaceVariant)
                        }
                    }
                }
                .tint(primaryContainer)
                .padding(10)
                .background(surfaceCard)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding(14)
        .background(surfaceContainerLow)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18).stroke(outlineVariant, lineWidth: 1)
        )
    }
    
    // MARK: - 6. Transit & Arrival Section
    private var transitArrivalSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Transit & Arrival")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("Minato City")
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundColor(textOnSurfaceVariant)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.white.opacity(0.08))
                    .clipShape(Capsule())
            }
            
            // Map Box
            ZStack(alignment: .bottom) {
                AsyncImage(url: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuDQ4HJ1XVN5KJCd-FOpVGGCvyw_ERMYd2DhZ0QdEmeUZB2FW2pmqc999GDZ0YsymB9UnMKTNWEgS-vItz9QL9rAWOhhTsZ5zBCOOK5HCYf8n_07JtXQoxrpPAWLpZyafArQc_vBY9rS2tY84B7MYT5Yhpes1JsxkowYYyvD76sD-fXsqgVkvpP7jDHUUvLKkzo77fetBCpMi2eUJr1VsPciP9NPiw7_E0Wgvf4GHsDWh_DGa5RIHZtL7g")) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        Color(red: 20/255, green: 28/255, blue: 45/255)
                    }
                }
                .frame(height: 120)
                .clipped()
                
                // Overlay Tag
                HStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(secondaryMint)
                            .frame(width: 24, height: 24)
                        Image(systemName: "tram.fill")
                            .font(.system(size: 11))
                            .foregroundColor(Color(red: 0/255, green: 40/255, blue: 30/255))
                    }
                    
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Kamiyacho Station (Hibiya Line)")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        Text("Exit 5 provides direct subterranean concourse access")
                            .font(.system(size: 10))
                            .foregroundColor(textOnSurfaceVariant)
                    }
                    Spacer()
                }
                .padding(8)
                .background(surfaceContainerLowest.opacity(0.92).background(.ultraThinMaterial))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(6)
            }
            .frame(height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14).stroke(outlineVariant, lineWidth: 1)
            )
            
            // Commute detail + Add to Day button
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "figure.walk")
                        .font(.system(size: 14))
                        .foregroundColor(primaryContainer)
                    Text("8 min sheltered walk from station")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(textOnSurfaceVariant)
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        isAddedToItinerary.toggle()
                    }
                    triggerToast(isAddedToItinerary ? "Added to Day 3 itinerary!" : "Removed from Day 3")
                }) {
                    HStack(spacing: 5) {
                        Image(systemName: isAddedToItinerary ? "checkmark" : "calendar.badge.plus")
                            .font(.system(size: 12, weight: .bold))
                        Text(isAddedToItinerary ? "Added to Day 3" : "Add to Day 3")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(isAddedToItinerary ? Color(red: 0/255, green: 40/255, blue: 30/255) : secondaryMint)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(isAddedToItinerary ? secondaryMint : secondaryMint.opacity(0.18))
                    .clipShape(Capsule())
                    .overlay(
                        Capsule().stroke(secondaryMint.opacity(0.4), lineWidth: 1)
                    )
                }
            }
        }
        .padding(14)
        .background(surfaceContainerLow)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18).stroke(outlineVariant, lineWidth: 1)
        )
    }
    
    // MARK: - Sticky Instant Checkout Bar
    private var stickyCheckoutBar: some View {
        VStack(spacing: 0) {
            Divider().background(outlineVariant)
            
            HStack(spacing: 14) {
                // Price & Breakdown
                VStack(alignment: .leading, spacing: 2) {
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text(String(format: "$%.2f", totalPrice))
                            .font(.system(size: 20, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                        Text(ticketSummaryText)
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .foregroundColor(textOnSurfaceVariant)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "bolt.fill")
                            .font(.system(size: 9))
                            .foregroundColor(secondaryMint)
                        Text("Instant QR Pass in Wallet")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundColor(secondaryMint)
                    }
                }
                
                Spacer()
                
                // Apple Pay Button
                Button(action: {
                    handleApplePay()
                }) {
                    HStack(spacing: 5) {
                        if isBookingProcessing {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                .scaleEffect(0.8)
                        } else if isBooked {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 15))
                                .foregroundColor(Color(red: 0/255, green: 100/255, blue: 60/255))
                            Text("Pass Issued")
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(.black)
                        } else {
                            Text("Book with")
                                .font(.system(size: 11, weight: .semibold, design: .rounded))
                                .foregroundColor(.black.opacity(0.7))
                            Text("Pay")
                                .font(.system(size: 16, weight: .heavy, design: .rounded))
                                .foregroundColor(.black)
                        }
                    }
                    .frame(height: 48)
                    .padding(.horizontal, 22)
                    .background(Color.white)
                    .clipShape(Capsule())
                    .shadow(color: Color.white.opacity(0.2), radius: 10)
                }
                .disabled(isBookingProcessing || isBooked)
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 28)
            .background(
                surfaceContainerLowest.opacity(0.95)
                    .background(.ultraThinMaterial)
            )
        }
    }
    
    // MARK: - Actions
    private func handleApplePay() {
        isBookingProcessing = true
        triggerToast("Authorizing Apple Pay with Face ID...")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            isBookingProcessing = false
            isBooked = true
            triggerToast("Booking confirmed! Apple Wallet Pass generated.")
        }
    }
    
    private func triggerToast(_ message: String) {
        withAnimation {
            toastNotice = message
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation {
                if toastNotice == message {
                    toastNotice = nil
                }
            }
        }
    }
}

#Preview {
    PlaceDetailView()
}
