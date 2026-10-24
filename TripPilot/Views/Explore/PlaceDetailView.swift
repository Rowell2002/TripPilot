import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct PlaceDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    // Injected Sri Lanka place data
    let place: SriLankaPlace
    
    init(place: SriLankaPlace = SriLankaDataService.shared.places[0]) {
        self.place = place
    }
    
    // Theme Colors
    private let darkBackground = Color(red: 15/255, green: 19/255, blue: 28/255)            // #0f131c
    private let surfaceContainerLowest = Color(red: 10/255, green: 14/255, blue: 22/255)  // #0a0e16
    private let surfaceContainerLow = Color(red: 24/255, green: 28/255, blue: 36/255)   // #181c24
    private let surfaceContainer = Color(red: 28/255, green: 32/255, blue: 40/255)      // #1c2028
    private let surfaceContainerHigh = Color(red: 38/255, green: 42/255, blue: 51/255)  // #262a33
    private let surfaceCard = Color(red: 30/255, green: 35/255, blue: 46/255)           // #1e232e
    private let primaryCyan = Color(red: 142/255, green: 213/255, blue: 255/255)         // #8ed5ff
    private let primaryContainer = Color(red: 56/255, green: 189/255, blue: 248/255)    // #38bdf8
    private let secondaryMint = Color(red: 68/255, green: 226/255, blue: 205/255)       // #44e2cd
    private let amberGold = Color(red: 251/255, green: 191/255, blue: 36/255)          // #fbbf24
    private let errorCoral = Color(red: 255/255, green: 180/255, blue: 171/255)         // #ffb4ab
    private let textOnSurface = Color(red: 255/255, green: 255/255, blue: 255/255)      // #ffffff
    private let textOnSurfaceVariant = Color(red: 148/255, green: 163/255, blue: 184/255) // #94a3b8
    private let textDim = Color(red: 100/255, green: 116/255, blue: 139/255)            // #64748b
    private let outlineVariant = Color.white.opacity(0.08)
    
    // Interactive State
    @ObservedObject private var bookmarkManager = BookmarkManager.shared
    @State private var currentSlide: Int = 0
    @State private var includeAudioGuide: Bool = true
    @State private var isAddedToItinerary: Bool = false
    @State private var toastNotice: String? = nil
    @State private var show360PreviewModal: Bool = false
    @State private var showCurrencyInLKR: Bool = false
    
    // Google Places Live Reviews State
    @State private var googlePlaceDetails: GooglePlaceDetailsResult? = nil
    @State private var isLoadingReviews: Bool = true
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background
            darkBackground
                .ignoresSafeArea()
            
            // Scrollable Content
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    Spacer().frame(height: 60)
                    
                    // 1. Hero Experience Carousel
                    heroCarouselSection
                    
                    // Content Sections
                    VStack(alignment: .leading, spacing: 20) {
                        // 2. Place Header & Status Badges
                        placeHeaderSection
                        
                        // 3. Visitor Intelligence Matrix
                        visitorIntelligenceSection
                        
                        // 4. Experience Overview & Highlights
                        editorialExperienceSection
                        
                        // 5. Authentic Reviews & Ratings
                        reviewsSection
                        

                        // 7. Transit & Arrival Directions
                        transitArrivalSection
                        
                        Spacer().frame(height: 120)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .responsiveContentWidth(900)
                }
                .frame(maxWidth: .infinity)
            }
            
            // Fixed Top Header
            VStack(spacing: 0) {
                topHeaderBar
                    .responsiveContentWidth(900)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .ignoresSafeArea(edges: .top)
            
            // Sticky Instant Checkout Bar
            stickyCheckoutBar
                .responsiveContentWidth(900)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .preferredColorScheme(.dark)
        .alert("360° Island Panorama", isPresented: $show360PreviewModal) {
            Button("Launch Full View", role: .none) {
                triggerToast("Launching 360° LiDAR view for \(place.name)...")
            }
            Button("Dismiss", role: .cancel) { }
        } message: {
            Text("Immerse yourself in aerial drone captures and spatial surround nature audio of \(place.name).")
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
        .task {
            await loadLiveReviews()
        }
    }
    
    // MARK: - Top Header Bar
    private var topHeaderBar: some View {
        HStack(spacing: 12) {
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
            
            HStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(primaryContainer.opacity(0.2))
                        .frame(width: 30, height: 30)
                    Image(systemName: "safari.fill")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(primaryContainer)
                }
                
                VStack(alignment: .leading, spacing: 1) {
                    Text("TripPilot Sri Lanka 🇱🇰")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(primaryCyan)
                    Text(place.region)
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundColor(textOnSurfaceVariant)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                // Bookmark Toggle Button
                Button(action: {
                    bookmarkManager.toggleBookmark(place: place)
                    let isSaved = bookmarkManager.isBookmarked(place: place)
                    triggerToast(isSaved ? "Saved \(place.name) to Travel Vault" : "Removed \(place.name) from saved")
                }) {
                    Image(systemName: bookmarkManager.isBookmarked(place: place) ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(bookmarkManager.isBookmarked(place: place) ? primaryContainer : textOnSurfaceVariant)
                        .frame(width: 40, height: 40)
                        .background(surfaceContainerHigh.opacity(0.6))
                        .clipShape(Circle())
                }
                
                // Share Button
                Button(action: {
                    triggerToast("Place details & map coordinates copied")
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(textOnSurfaceVariant)
                        .frame(width: 40, height: 40)
                        .background(surfaceContainerHigh.opacity(0.6))
                        .clipShape(Circle())
                }
            }
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
            TabView(selection: $currentSlide) {
                ForEach(0..<place.imageUrls.count, id: \.self) { idx in
                    ZStack(alignment: .bottom) {
                        AsyncImage(url: URL(string: place.imageUrls[idx])) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } else {
                                Color.gray.opacity(0.3)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: DeviceLayout.isIPad ? 460 : 330)
                        .clipped()
                        
                        LinearGradient(
                            colors: [darkBackground, darkBackground.opacity(0.2), Color.black.opacity(0.6)],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    }
                    .tag(idx)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(maxWidth: .infinity)
            .frame(height: DeviceLayout.isIPad ? 460 : 330)
            
            // Top Badges
            VStack {
                HStack {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(secondaryMint)
                            .frame(width: 7, height: 7)
                            .shadow(color: secondaryMint, radius: 4)
                        Text(place.isUNESCO ? "UNESCO HERITAGE SITE" : "VERIFIED SRI LANKA")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .tracking(0.6)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(darkBackground.opacity(0.75))
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(outlineVariant, lineWidth: 1))
                    
                    Spacer()
                    
                    Button(action: {
                        show360PreviewModal = true
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "view.3d")
                                .font(.system(size: 13, weight: .bold))
                            Text("360° Drone")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                        }
                        .foregroundColor(primaryContainer)
                        .padding(.horizontal, 11)
                        .padding(.vertical, 5)
                        .background(darkBackground.opacity(0.75))
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(outlineVariant, lineWidth: 1))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 14)
                
                Spacer()
            }
            
            // Carousel Dots
            HStack {
                HStack(spacing: 5) {
                    ForEach(0..<place.imageUrls.count, id: \.self) { idx in
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
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 11))
                        .foregroundColor(primaryContainer)
                    Text("\(place.imageUrls.count) Verified Photos")
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundColor(textOnSurfaceVariant)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(surfaceContainerLowest.opacity(0.85))
                .clipShape(Capsule())
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
        }
        .frame(maxWidth: .infinity)
        .frame(height: DeviceLayout.isIPad ? 460 : 330)
    }
    
    // MARK: - 2. Place Header
    private var placeHeaderSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                // Star Rating & Review Count (Synced with Google Places)
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 11))
                        .foregroundColor(amberGold)
                    Text(String(format: "%.1f", googlePlaceDetails?.rating ?? place.rating))
                        .font(.system(size: 13, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                    Text("(\(googlePlaceDetails?.formattedReviewCount ?? place.reviewCount))")
                        .font(.system(size: 11))
                        .foregroundColor(textDim)
                    
                    if googlePlaceDetails?.source == .googlePlacesLive {
                        Text("Google")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(primaryCyan)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 1.5)
                            .background(primaryCyan.opacity(0.15))
                            .clipShape(Capsule())
                    }
                }
                .padding(.horizontal, 9)
                .padding(.vertical, 4)
                .background(surfaceContainerLow)
                .clipShape(Capsule())
                
                // Category Chip
                Text(place.category.rawValue)
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundColor(primaryCyan)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 4)
                    .background(primaryContainer.opacity(0.15))
                    .clipShape(Capsule())
                
                if place.isUNESCO {
                    Text("UNESCO World Heritage")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundColor(secondaryMint)
                        .padding(.horizontal, 9)
                        .padding(.vertical, 4)
                        .background(secondaryMint.opacity(0.15))
                        .clipShape(Capsule())
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(place.name)
                    .font(.system(size: 26, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                
                Text(place.region)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(textOnSurfaceVariant)
            }
        }
    }
    
    // MARK: - 3. Visitor Intelligence
    private var visitorIntelligenceSection: some View {
        VStack(spacing: 12) {
            HStack {
                HStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(secondaryMint.opacity(0.15))
                            .frame(width: 32, height: 32)
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(secondaryMint)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Visitor Intelligence")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        Text("Live Sri Lanka seasonal telemetry")
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .foregroundColor(textDim)
                    }
                }
                
                Spacer()
                
                Text("OPTIMAL")
                    .font(.system(size: 10, weight: .heavy, design: .rounded))
                    .foregroundColor(secondaryMint)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 3)
                    .background(secondaryMint.opacity(0.2))
                    .clipShape(Capsule())
            }
            
            HStack(spacing: 10) {
                // Best Time
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 5) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 13))
                            .foregroundColor(primaryContainer)
                        Text("BEST TIME")
                            .font(.system(size: 9, weight: .bold, design: .rounded))
                            .foregroundColor(textDim)
                    }
                    Text(place.bestTimeToVisit)
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(2)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(surfaceCard)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Duration
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 5) {
                        Image(systemName: "hourglass")
                            .font(.system(size: 13))
                            .foregroundColor(secondaryMint)
                        Text("DURATION")
                            .font(.system(size: 9, weight: .bold, design: .rounded))
                            .foregroundColor(textDim)
                    }
                    Text(place.recommendedDuration)
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(surfaceCard)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            // Dress Code & Etiquette Notice
            if let dressCode = place.dressCode {
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "tshirt.fill")
                        .font(.system(size: 14))
                        .foregroundColor(amberGold)
                        .padding(.top, 2)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Dress Code & Local Etiquette")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        Text(dressCode)
                            .font(.system(size: 11.5))
                            .foregroundColor(textOnSurfaceVariant)
                    }
                }
                .padding(12)
                .background(surfaceCard)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(14)
        .background(surfaceContainerLow)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(outlineVariant, lineWidth: 1))
    }
    
    // MARK: - 4. Editorial Overview
    private var editorialExperienceSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("About This Destination")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text(place.description)
                .font(.system(size: 13.5, weight: .regular))
                .foregroundColor(textOnSurfaceVariant)
                .lineSpacing(4)
            
            // Key Highlights
            VStack(alignment: .leading, spacing: 8) {
                Text("KEY HIGHLIGHTS")
                    .font(.system(size: 10.5, weight: .bold, design: .rounded))
                    .tracking(0.6)
                    .foregroundColor(.white)
                
                ForEach(place.highlights, id: \.self) { highlight in
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 13))
                            .foregroundColor(secondaryMint)
                        Text(highlight)
                            .font(.system(size: 12.5, weight: .medium, design: .rounded))
                            .foregroundColor(textOnSurface)
                    }
                }
            }
            .padding(12)
            .background(surfaceCard)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Visitor Tips
            if !place.visitorTips.isEmpty {
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 15))
                        .foregroundColor(amberGold)
                        .padding(.top, 2)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Insider Travel Tips")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        ForEach(place.visitorTips, id: \.self) { tip in
                            Text("• \(tip)")
                                .font(.system(size: 12))
                                .foregroundColor(textOnSurfaceVariant)
                                .lineSpacing(2)
                        }
                    }
                }
                .padding(12)
                .background(surfaceCard)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(14)
        .background(surfaceContainerLow)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(outlineVariant, lineWidth: 1))
    }
    
    // MARK: - 5. Authentic Reviews & Ratings
    private var reviewsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Visitor Reviews & Ratings")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 5) {
                        if isLoadingReviews {
                            ProgressView()
                                .scaleEffect(0.65)
                                .tint(primaryCyan)
                            Text("Syncing Google Places...")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(textDim)
                        } else if googlePlaceDetails?.source == .googlePlacesLive {
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(secondaryMint)
                                    .frame(width: 6, height: 6)
                                Text("Google Places API (Live)")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(secondaryMint)
                            }
                        } else {
                            Text("Verified travelers & local explorers")
                                .font(.system(size: 11.5, weight: .medium))
                                .foregroundColor(textDim)
                        }
                    }
                }
                
                Spacer()
                
                HStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 13))
                            .foregroundColor(amberGold)
                        Text(String(format: "%.1f", googlePlaceDetails?.rating ?? place.rating))
                            .font(.system(size: 16, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                    }
                    
                    Button(action: {
                        Task { await loadLiveReviews() }
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(primaryCyan)
                            .frame(width: 28, height: 28)
                            .background(surfaceCard)
                            .clipShape(Circle())
                    }
                }
            }
            
            if isLoadingReviews {
                VStack(spacing: 10) {
                    reviewSkeletonCard
                    reviewSkeletonCard
                }
            } else {
                let reviews = googlePlaceDetails?.reviews ?? []
                if reviews.isEmpty {
                    VStack(spacing: 8) {
                        Image(systemName: "text.bubble")
                            .font(.system(size: 24))
                            .foregroundColor(textDim)
                        Text("No reviews fetched yet")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white)
                        Text("Tap the refresh button above to sync with Google Places")
                            .font(.system(size: 11))
                            .foregroundColor(textDim)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                    .background(surfaceCard)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    VStack(spacing: 10) {
                        ForEach(reviews) { review in
                            VStack(alignment: .leading, spacing: 6) {
                                HStack(spacing: 10) {
                                    ZStack {
                                        Circle()
                                            .fill(primaryContainer.opacity(0.2))
                                            .frame(width: 30, height: 30)
                                        Text(review.userAvatar)
                                            .font(.system(size: 12, weight: .bold, design: .rounded))
                                            .foregroundColor(primaryCyan)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(review.userName)
                                            .font(.system(size: 13.5, weight: .bold, design: .rounded))
                                            .foregroundColor(.white)
                                        Text(review.userCountry)
                                            .font(.system(size: 10))
                                            .foregroundColor(textDim)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(review.date)
                                        .font(.system(size: 11))
                                        .foregroundColor(textDim)
                                }
                                
                                HStack(spacing: 2) {
                                    ForEach(0..<5) { starIndex in
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 10))
                                            .foregroundColor(Double(starIndex + 1) <= review.rating ? amberGold : Color.white.opacity(0.2))
                                    }
                                }
                                
                                Text(review.comment)
                                    .font(.system(size: 12.5))
                                    .foregroundColor(textOnSurfaceVariant)
                                    .lineSpacing(2)
                                
                                HStack {
                                    Spacer()
                                    HStack(spacing: 4) {
                                        Image(systemName: "hand.thumbsup.fill")
                                            .font(.system(size: 10))
                                        Text("\(review.helpfulCount) found helpful")
                                            .font(.system(size: 10.5))
                                    }
                                    .foregroundColor(textDim)
                                }
                            }
                            .padding(12)
                            .background(surfaceCard)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
            }
            
            // Attribution
            HStack(spacing: 6) {
                Image(systemName: "globe.badge.chevron.backward")
                    .font(.system(size: 10))
                    .foregroundColor(textDim)
                Text(googlePlaceDetails?.attribution ?? "Reviews via Google Places API (New)")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(textDim)
                Spacer()
            }
            .padding(.top, 4)
        }
        .padding(14)
        .background(surfaceContainerLow)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(outlineVariant, lineWidth: 1))
    }
    
    private var reviewSkeletonCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Circle()
                    .fill(Color.white.opacity(0.08))
                    .frame(width: 28, height: 28)
                VStack(alignment: .leading, spacing: 4) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.12))
                        .frame(width: 120, height: 12)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.06))
                        .frame(width: 80, height: 10)
                }
                Spacer()
            }
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.white.opacity(0.08))
                .frame(maxWidth: .infinity)
                .frame(height: 12)
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.white.opacity(0.08))
                .frame(width: 180, height: 12)
        }
        .padding(12)
        .background(surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: - 6. Transit & Arrival
    private var transitArrivalSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Location & Transit Access")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            HStack(spacing: 8) {
                Image(systemName: "mappin.and.ellipse")
                    .font(.system(size: 16))
                    .foregroundColor(secondaryMint)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(place.name)
                        .font(.system(size: 13.5, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text(String(format: "GPS: %.4f° N, %.4f° E", place.latitude, place.longitude))
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundColor(textDim)
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring(response: 0.3)) {
                        isAddedToItinerary.toggle()
                    }
                    if isAddedToItinerary {
                        TripManager.shared.addCustomStop(
                            title: place.name,
                            category: place.category.rawValue,
                            notes: place.highlights.first ?? "Must-visit Sri Lanka landmark",
                            entranceFeeLKR: place.entranceFeeLKR
                        )
                        triggerToast("Added \(place.name) to your active trip!")
                    } else {
                        triggerToast("Removed \(place.name) from itinerary")
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: isAddedToItinerary ? "checkmark" : "plus.circle.fill")
                            .font(.system(size: 12, weight: .bold))
                        Text(isAddedToItinerary ? "In Itinerary" : "Add to Trip")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(isAddedToItinerary ? Color(red: 0/255, green: 40/255, blue: 30/255) : secondaryMint)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(isAddedToItinerary ? secondaryMint : secondaryMint.opacity(0.18))
                    .clipShape(Capsule())
                }
            }
            .padding(12)
            .background(surfaceCard)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(14)
        .background(surfaceContainerLow)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(outlineVariant, lineWidth: 1))
    }
    
    // MARK: - Sticky Action Bar
    private var stickyCheckoutBar: some View {
        VStack(spacing: 0) {
            Divider().background(outlineVariant)
            
            HStack(spacing: 14) {
                VStack(alignment: .leading, spacing: 3) {
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        if showCurrencyInLKR {
                            Text("Rs. \(place.entranceFeeLKR.formatted())")
                                .font(.system(size: 18, weight: .heavy, design: .rounded))
                                .foregroundColor(.white)
                        } else {
                            Text(String(format: "$%.0f USD", place.entranceFeeUSD))
                                .font(.system(size: 19, weight: .heavy, design: .rounded))
                                .foregroundColor(.white)
                        }
                        
                        Button(action: {
                            showCurrencyInLKR.toggle()
                        }) {
                            Text(showCurrencyInLKR ? "LKR" : "USD")
                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                                .foregroundColor(secondaryMint)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(secondaryMint.opacity(0.15))
                                .clipShape(Capsule())
                        }
                    }
                    
                    Text("Official sanctuary / entry info")
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundColor(textOnSurfaceVariant)
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        isAddedToItinerary.toggle()
                        if isAddedToItinerary {
                            triggerToast("Added \(place.name) to your active trip!")
                        } else {
                            triggerToast("Removed from active trip")
                        }
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: isAddedToItinerary ? "checkmark.circle.fill" : "plus.circle.fill")
                            .font(.system(size: 14, weight: .bold))
                        Text(isAddedToItinerary ? "In Itinerary" : "Add to Trip")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(isAddedToItinerary ? .black : .white)
                    .frame(height: 46)
                    .padding(.horizontal, 20)
                    .background(
                        isAddedToItinerary ?
                        LinearGradient(colors: [secondaryMint, Color(red: 45/255, green: 212/255, blue: 191/255)], startPoint: .leading, endPoint: .trailing) :
                        LinearGradient(colors: [Color(red: 56/255, green: 189/255, blue: 248/255), Color(red: 2/255, green: 132/255, blue: 199/255)], startPoint: .leading, endPoint: .trailing)
                    )
                    .clipShape(Capsule())
                    .shadow(color: (isAddedToItinerary ? secondaryMint : Color(red: 56/255, green: 189/255, blue: 248/255)).opacity(0.3), radius: 8, y: 3)
                }
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
    private func loadLiveReviews() async {
        isLoadingReviews = true
        let result = await GooglePlacesService.shared.fetchPlaceDetails(for: place)
        withAnimation(.easeInOut(duration: 0.35)) {
            self.googlePlaceDetails = result
            self.isLoadingReviews = false
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
