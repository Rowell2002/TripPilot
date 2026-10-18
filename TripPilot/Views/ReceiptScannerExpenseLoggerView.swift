//
//  ReceiptScannerExpenseLoggerView.swift
//  TripPilot
//
//  Generated from Stitch Screen: 6285c49dee6f45938eeb09d3dedc0ef7
//  Title: TripPilot - Receipt Scanner & Expense Logger (Dark Mode)
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Category Enum
enum ExpenseCategoryOption: String, CaseIterable, Identifiable {
    case dining = "Dining"
    case lodging = "Lodging"
    case transit = "Transit"
    case culture = "Culture"
    case shopping = "Shopping"
    
    var id: String { rawValue }
    
    var iconName: String {
        switch self {
        case .dining: return "fork.knife"
        case .lodging: return "bed.double.fill"
        case .transit: return "tram.fill"
        case .culture: return "sparkles"
        case .shopping: return "bag.fill"
        }
    }
}

// MARK: - Main View
struct ReceiptScannerExpenseLoggerView: View {
    @Environment(\.dismiss) private var dismiss
    
    // Stitch Dark Theme Tokens
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
    
    private let textOnSurface = Color(red: 223/255, green: 226/255, blue: 238/255)         // #dfe2ee
    private let textVariant = Color(red: 189/255, green: 200/255, blue: 209/255)           // #bdc8d1
    private let outlineVariant = Color(red: 62/255, green: 72/255, blue: 79/255)          // #3e484f
    
    // Interactive State
    @State private var scanLaserOffset: CGFloat = -110
    @State private var isPulsing: Bool = false
    @State private var selectedCategory: ExpenseCategoryOption = .dining
    @State private var isSplitEnabled: Bool = true
    @State private var isAutoHoldActive: Bool = true
    @State private var merchantName: String = "Sushi Yoshitake Ginza"
    @State private var expenseNotes: String = "Omakase celebratory dinner with Marcus • counter seats"
    @State private var isEditingMerchant: Bool = false
    @State private var newMerchantInput: String = "Sushi Yoshitake Ginza"
    @State private var isSaved: Bool = false
    @State private var feedbackBannerText: String? = nil
    
    var body: some View {
        ZStack(alignment: .top) {
            // Background
            darkBackground
                .ignoresSafeArea()
            
            // Atmospheric Glows
            GeometryReader { _ in
                Circle()
                    .fill(primarySky.opacity(0.07))
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
                VStack(spacing: 16) {
                    // Header buffer
                    Spacer()
                        .frame(height: 64)
                    
                    // MARK: - 1. Status & Session Banner
                    statusSessionBanner
                    
                    // MARK: - 2. Live OCR Camera Viewfinder Card
                    cameraViewfinderCard
                    
                    // MARK: - 3. Primary Expense Details Card
                    primaryExpenseDetailsCard
                    
                    // MARK: - 4. Split with Travelers Card
                    splitWithTravelersCard
                    
                    // MARK: - 5. Japan Tax-Free Eligible Card
                    japanTaxFreeCard
                    
                    // MARK: - 6. Trip Notes Card
                    tripNotesCard
                    
                    // MARK: - 7. Action CTA Zone
                    actionCTAZone
                    
                    // Bottom Spacing
                    Spacer()
                        .frame(height: 48)
                }
                .padding(.horizontal, 16)
            }
            
            // MARK: - Fixed Top Translucent Header
            topHeaderBar
            
            // Toast Notification Overlay
            if let banner = feedbackBannerText {
                VStack {
                    Spacer().frame(height: 70)
                    Text(banner)
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(surfaceContainerHigh)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule().stroke(secondaryMint.opacity(0.6), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.7), radius: 12, y: 6)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
                .zIndex(100)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .preferredColorScheme(.dark)
        .onAppear {
            startScanlineAnimation()
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                isPulsing = true
            }
        }
        .alert("Edit Merchant Name", isPresented: $isEditingMerchant) {
            TextField("Merchant", text: $newMerchantInput)
            Button("Save") {
                merchantName = newMerchantInput
                showToast("Merchant updated")
            }
            Button("Cancel", role: .cancel) { }
        }
    }
    
    // MARK: - 1. Top Header Bar
    private var topHeaderBar: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(primaryTint)
                    .frame(width: 40, height: 40)
                    .background(surfaceContainerLow.opacity(0.9))
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.white.opacity(0.08), lineWidth: 1)
                    )
            }
            
            Spacer()
            
            Text("Receipt Scanner")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(textOnSurface)
            
            Spacer()
            
            HStack(spacing: 8) {
                Button(action: {
                    showToast("Receipt export link copied")
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(textVariant)
                        .frame(width: 40, height: 40)
                        .background(surfaceContainerLow.opacity(0.9))
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.white.opacity(0.08), lineWidth: 1)
                        )
                }
                
                // User Profile Avatar
                ZStack {
                    Circle()
                        .fill(surfaceContainerHigh)
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .foregroundColor(primarySky)
                }
                .overlay(
                    Circle().stroke(primarySky.opacity(0.4), lineWidth: 1.5)
                )
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 56)
        .background(
            surfaceContainerLowest.opacity(0.85)
                .background(.ultraThinMaterial)
                .shadow(color: Color.black.opacity(0.45), radius: 8, y: 2)
        )
    }
    
    // MARK: - 2. Status & Session Banner
    private var statusSessionBanner: some View {
        HStack(spacing: 8) {
            // Pulsing dot
            ZStack {
                Circle()
                    .fill(secondaryMint.opacity(isPulsing ? 0.35 : 0.8))
                    .frame(width: isPulsing ? 14 : 10, height: isPulsing ? 14 : 10)
                
                Circle()
                    .fill(secondaryMint)
                    .frame(width: 8, height: 8)
            }
            .frame(width: 16, height: 16)
            
            Text("SMART OCR ACTIVE")
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundColor(secondaryMint)
                .tracking(0.6)
            
            Text("•")
                .foregroundColor(outlineVariant)
            
            Text("Autumn in Japan")
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(textVariant)
                .lineLimit(1)
            
            Spacer()
            
            Button(action: {
                triggerHapticFeedback()
                showToast("Scanner cache refreshed")
                startScanlineAnimation()
            }) {
                Text("Reset")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(primarySky)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(surfaceContainerLow)
        .clipShape(Capsule())
        .overlay(
            Capsule().stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
    }
    
    // MARK: - 3. Live OCR Camera Viewfinder Card
    private var cameraViewfinderCard: some View {
        ZStack {
            // Dark Camera Viewfinder Backdrop
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(surfaceContainerLowest)
                .aspectRatio(4/3, contentMode: .fit)
                .overlay(
                    // Simulated Japanese Restaurant Receipt Pattern
                    ZStack {
                        // Subtle Paper Receipt simulation
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 25/255, green: 30/255, blue: 42/255),
                                        Color(red: 18/255, green: 22/255, blue: 32/255)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .padding(18)
                            .overlay(
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        Text("すきやばし 次郎 銀座店")
                                            .font(.system(size: 13, weight: .bold, design: .monospaced))
                                            .foregroundColor(.white.opacity(0.45))
                                        Spacer()
                                        Text("領収証 No. 8832")
                                            .font(.system(size: 10, weight: .medium, design: .monospaced))
                                            .foregroundColor(.white.opacity(0.35))
                                    }
                                    Divider().background(Color.white.opacity(0.1))
                                    
                                    HStack {
                                        Text("おまかせコース (2名)")
                                            .font(.system(size: 11, weight: .regular, design: .monospaced))
                                            .foregroundColor(.white.opacity(0.4))
                                        Spacer()
                                        Text("¥32,728")
                                            .font(.system(size: 11, weight: .medium, design: .monospaced))
                                            .foregroundColor(.white.opacity(0.4))
                                    }
                                    
                                    HStack {
                                        Text("消費税 10% 対象")
                                            .font(.system(size: 10, weight: .regular, design: .monospaced))
                                            .foregroundColor(.white.opacity(0.3))
                                        Spacer()
                                        Text("¥3,272")
                                            .font(.system(size: 10, weight: .medium, design: .monospaced))
                                            .foregroundColor(.white.opacity(0.3))
                                    }
                                    
                                    HStack {
                                        Text("合計 (税込)")
                                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                                            .foregroundColor(primaryTint.opacity(0.75))
                                        Spacer()
                                        Text("¥36,000")
                                            .font(.system(size: 13, weight: .bold, design: .monospaced))
                                            .foregroundColor(primaryTint.opacity(0.85))
                                    }
                                    Spacer()
                                }
                                .padding(30)
                            )
                        
                        // Scrim gradients
                        LinearGradient(
                            colors: [
                                surfaceContainerLowest.opacity(0.85),
                                Color.clear,
                                surfaceContainerLowest.opacity(0.9)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    }
                )
            
            // Animated Scanning Laser Bar
            GeometryReader { geo in
                VStack {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [Color.clear, primarySky, Color.clear],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 2.5)
                        .shadow(color: primarySky, radius: 10, y: 0)
                        .offset(y: (geo.size.height / 2) + scanLaserOffset)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            
            // Top HUD Overlay: Badges
            VStack {
                HStack {
                    // Location/Line Match
                    HStack(spacing: 5) {
                        Image(systemName: "doc.text.viewfinder")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(secondaryMint)
                        
                        Text("Ginza Omotesando Line")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(textOnSurface)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(surfaceContainerHigh.opacity(0.85))
                    .clipShape(Capsule())
                    .overlay(
                        Capsule().stroke(Color.white.opacity(0.12), lineWidth: 1)
                    )
                    
                    Spacer()
                    
                    // Confidence Match Tag
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Color(red: 0/255, green: 77/255, blue: 68/255))
                        
                        Text("99.4% Match")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(Color(red: 0/255, green: 77/255, blue: 68/255))
                    }
                    .padding(.horizontal, 9)
                    .padding(.vertical, 5)
                    .background(secondaryContainer.opacity(0.95))
                    .clipShape(Capsule())
                }
                .padding(.horizontal, 14)
                .padding(.top, 14)
                
                Spacer()
                
                // Floating Detection Card in Center
                VStack(spacing: 3) {
                    HStack(spacing: 5) {
                        Image(systemName: "fork.knife")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(primarySky)
                        
                        Text(merchantName)
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundColor(textOnSurface)
                    }
                    
                    Text("¥36,000 Total")
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                        .foregroundColor(textOnSurface)
                    
                    Text("Tax 10% (¥3,272) Included • Cash")
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundColor(textVariant)
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .background(surfaceContainerLowest.opacity(0.9))
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(primarySky.opacity(0.4), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.6), radius: 16, y: 6)
                
                Spacer()
                
                // Bottom Camera Control Bar inside viewfinder
                HStack(spacing: 16) {
                    // Photo Library Action
                    Button(action: {
                        triggerHapticFeedback()
                        showToast("Photo library opened")
                    }) {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(textOnSurface)
                            .frame(width: 40, height: 40)
                            .background(surfaceContainerHigh.opacity(0.8))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    // Big Center Shutter Button
                    Button(action: {
                        triggerHapticFeedback()
                        showToast("Receipt captured & re-scanned")
                        startScanlineAnimation()
                    }) {
                        ZStack {
                            Circle()
                                .fill(surfaceContainerLowest)
                                .frame(width: 58, height: 58)
                            
                            Circle()
                                .fill(surfaceContainerHigh)
                                .frame(width: 50, height: 50)
                            
                            Circle()
                                .fill(primarySky)
                                .frame(width: 42, height: 42)
                                .shadow(color: primarySky.opacity(0.6), radius: 8, y: 0)
                            
                            Image(systemName: "camera.viewfinder")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color(red: 0/255, green: 53/255, blue: 74/255))
                        }
                    }
                    
                    Spacer()
                    
                    // Auto-Hold Toggle
                    Button(action: {
                        triggerHapticFeedback()
                        isAutoHoldActive.toggle()
                        showToast(isAutoHoldActive ? "Auto-Hold activated" : "Auto-Hold paused")
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: isAutoHoldActive ? "lock.fill" : "lock.open")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(isAutoHoldActive ? secondaryMint : textVariant)
                            
                            Text("Auto-Hold")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                                .foregroundColor(textOnSurface)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(surfaceContainerHigh.opacity(0.8))
                        .clipShape(Capsule())
                    }
                }
                .padding(.horizontal, 14)
                .padding(.bottom, 12)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.55), radius: 20, y: 8)
    }
    
    // MARK: - 4. Primary Expense Details Card
    private var primaryExpenseDetailsCard: some View {
        VStack(spacing: 16) {
            // Settlement Header & Live FX
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text("SETTLEMENT AMOUNT")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(textVariant)
                            .tracking(0.5)
                        
                        HStack(spacing: 3) {
                            Image(systemName: "bolt.fill")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(secondaryMint)
                            
                            Text("OCR Verified")
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .foregroundColor(secondaryMint)
                        }
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(secondaryMint.opacity(0.15))
                        .clipShape(Capsule())
                    }
                    
                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Text("$236.22")
                            .font(.system(size: 34, weight: .heavy, design: .rounded))
                            .foregroundColor(primarySky)
                        
                        Text("USD")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(textVariant)
                    }
                    
                    Text("Equivalent to **¥36,000 JPY** at spot rate")
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .foregroundColor(textVariant)
                }
                
                Spacer()
                
                // Live FX Badge
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Live FX")
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundColor(textVariant)
                    
                    Text("1$ = 152.40¥")
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(secondaryMint)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(surfaceContainerHigh)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
            }
            
            // Category Pill Selector Grid
            VStack(alignment: .leading, spacing: 8) {
                Text("EXPENSE CATEGORY")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundColor(textVariant)
                    .tracking(0.5)
                
                HStack(spacing: 8) {
                    ForEach(ExpenseCategoryOption.allCases) { category in
                        let isSelected = (selectedCategory == category)
                        Button(action: {
                            triggerHapticFeedback()
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedCategory = category
                            }
                        }) {
                            VStack(spacing: 6) {
                                Image(systemName: category.iconName)
                                    .font(.system(size: 16, weight: isSelected ? .bold : .medium))
                                
                                Text(category.rawValue)
                                    .font(.system(size: 10, weight: isSelected ? .bold : .medium, design: .rounded))
                            }
                            .foregroundColor(isSelected ? Color(red: 0/255, green: 30/255, blue: 44/255) : textVariant)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(
                                isSelected ?
                                primarySky :
                                surfaceContainer
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(isSelected ? primarySky : Color.white.opacity(0.06), lineWidth: 1)
                            )
                        }
                    }
                }
            }
            
            // Metadata Details List (Merchant & Date)
            VStack(spacing: 0) {
                // Merchant Row
                HStack {
                    ZStack {
                        Circle()
                            .fill(surfaceContainerHigh)
                            .frame(width: 32, height: 32)
                        
                        Image(systemName: "storefront.fill")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(primarySky)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("MERCHANT")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundColor(textVariant)
                        
                        Text(merchantName)
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(textOnSurface)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        newMerchantInput = merchantName
                        isEditingMerchant = true
                    }) {
                        ZStack {
                            Circle()
                                .fill(surfaceContainerHigh)
                                .frame(width: 30, height: 30)
                            
                            Image(systemName: "pencil")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(textVariant)
                        }
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                
                Divider()
                    .background(surfaceContainerHighest.opacity(0.5))
                    .padding(.horizontal, 14)
                
                // Date & Log Row
                HStack {
                    ZStack {
                        Circle()
                            .fill(surfaceContainerHigh)
                            .frame(width: 32, height: 32)
                        
                        Image(systemName: "calendar")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(secondaryMint)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("DATE & LOG")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundColor(textVariant)
                        
                        Text("Today • 13:45")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(textOnSurface)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Text("Day 3 • Tokyo")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(primarySky)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(surfaceContainerHigh)
                    .clipShape(Capsule())
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
            }
            .background(surfaceContainer)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.white.opacity(0.06), lineWidth: 1)
            )
        }
        .padding(16)
        .background(surfaceContainerLow)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.4), radius: 14, y: 6)
    }
    
    // MARK: - 5. Split with Travelers Card
    private var splitWithTravelersCard: some View {
        VStack(spacing: 14) {
            // Header with toggle
            HStack {
                HStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(tertiaryBlue.opacity(0.18))
                            .frame(width: 34, height: 34)
                        
                        Image(systemName: "person.2.fill")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(tertiaryBlue)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Split with Travelers")
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(textOnSurface)
                        
                        Text("Divide equally or customized ratio")
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .foregroundColor(textVariant)
                    }
                }
                
                Spacer()
                
                Toggle("", isOn: $isSplitEnabled)
                    .labelsHidden()
                    .tint(primarySky)
                    .onChange(of: isSplitEnabled) { _, newValue in
                        triggerHapticFeedback()
                        showToast(newValue ? "Group split enabled (50/50)" : "Group split disabled")
                    }
            }
            
            if isSplitEnabled {
                VStack(spacing: 10) {
                    // Member 1: Elena (Me)
                    HStack(spacing: 12) {
                        ZStack(alignment: .bottomTrailing) {
                            ZStack {
                                Circle()
                                    .fill(LinearGradient(colors: [primarySky, secondaryMint], startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .frame(width: 42, height: 42)
                                
                                Text("E")
                                    .font(.system(size: 17, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            
                            // Checkmark badge
                            ZStack {
                                Circle()
                                    .fill(secondaryMint)
                                    .frame(width: 16, height: 16)
                                
                                Image(systemName: "checkmark")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundColor(Color(red: 0/255, green: 55/255, blue: 49/255))
                            }
                            .offset(x: 2, y: 2)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            HStack(spacing: 6) {
                                Text("Elena (Me)")
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .foregroundColor(textOnSurface)
                                
                                Text("Paid")
                                    .font(.system(size: 9, weight: .bold, design: .rounded))
                                    .foregroundColor(primarySky)
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 2)
                                    .background(primarySky.opacity(0.18))
                                    .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                            }
                            
                            Text("50% share")
                                .font(.system(size: 11, weight: .medium, design: .rounded))
                                .foregroundColor(textVariant)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("$118.11")
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .foregroundColor(textOnSurface)
                            
                            Text("¥18,000")
                                .font(.system(size: 11, weight: .medium, design: .monospaced))
                                .foregroundColor(textVariant)
                        }
                    }
                    .padding(10)
                    .background(surfaceContainer)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    
                    // Member 2: Marcus Chen
                    HStack(spacing: 12) {
                        ZStack(alignment: .bottomTrailing) {
                            ZStack {
                                Circle()
                                    .fill(LinearGradient(colors: [Color(red: 168/255, green: 85/255, blue: 247/255), Color(red: 99/255, green: 102/255, blue: 241/255)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .frame(width: 42, height: 42)
                                
                                Text("M")
                                    .font(.system(size: 17, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            
                            // Pending hourglass
                            ZStack {
                                Circle()
                                    .fill(surfaceContainerHighest)
                                    .frame(width: 16, height: 16)
                                
                                Image(systemName: "hourglass")
                                    .font(.system(size: 8, weight: .bold))
                                    .foregroundColor(textVariant)
                            }
                            .offset(x: 2, y: 2)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            HStack(spacing: 6) {
                                Text("Marcus Chen")
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .foregroundColor(textOnSurface)
                                
                                Text("Owes")
                                    .font(.system(size: 9, weight: .bold, design: .rounded))
                                    .foregroundColor(textVariant)
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 2)
                                    .background(surfaceContainerHighest)
                                    .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                            }
                            
                            Text("50% share")
                                .font(.system(size: 11, weight: .medium, design: .rounded))
                                .foregroundColor(textVariant)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("+$118.11")
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .foregroundColor(secondaryMint)
                            
                            Text("¥18,000")
                                .font(.system(size: 11, weight: .medium, design: .monospaced))
                                .foregroundColor(textVariant)
                        }
                    }
                    .padding(10)
                    .background(surfaceContainer)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                
                // Quick Settle Action Buttons
                HStack(spacing: 8) {
                    Button(action: {
                        triggerHapticFeedback()
                        showToast("Apple Cash request sent to Marcus")
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "iphone.gen3")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(primarySky)
                            
                            Text("Apple Cash")
                                .font(.system(size: 11, weight: .semibold, design: .rounded))
                                .foregroundColor(textOnSurface)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(surfaceContainer)
                        .clipShape(Capsule())
                    }
                    
                    Button(action: {
                        triggerHapticFeedback()
                        showToast("Exported to Splitwise group")
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "creditcard.fill")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(secondaryMint)
                            
                            Text("Splitwise")
                                .font(.system(size: 11, weight: .semibold, design: .rounded))
                                .foregroundColor(textOnSurface)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(surfaceContainer)
                        .clipShape(Capsule())
                    }
                    
                    Button(action: {
                        triggerHapticFeedback()
                        showToast("Venmo QR code generated")
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "qrcode")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(tertiaryBlue)
                            
                            Text("Venmo")
                                .font(.system(size: 11, weight: .semibold, design: .rounded))
                                .foregroundColor(textOnSurface)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(surfaceContainer)
                        .clipShape(Capsule())
                    }
                }
            }
        }
        .padding(16)
        .background(surfaceContainerLow)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }
    
    // MARK: - 6. Japan Tax-Free Eligible Card
    private var japanTaxFreeCard: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(secondaryContainer.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: "tag.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(secondaryMint)
            }
            
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text("Japan Tax-Free Eligible")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(textOnSurface)
                    
                    Text("10% SAVE")
                        .font(.system(size: 10, weight: .heavy, design: .rounded))
                        .foregroundColor(secondaryMint)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(secondaryMint.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                }
                
                Text("QR export ready for Haneda Airport customs scan")
                    .font(.system(size: 11, weight: .regular, design: .rounded))
                    .foregroundColor(textVariant)
                    .lineLimit(1)
            }
            
            Spacer()
            
            ZStack {
                Circle()
                    .fill(secondaryMint)
                    .frame(width: 24, height: 24)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 11, weight: .heavy))
                    .foregroundColor(Color(red: 0/255, green: 55/255, blue: 49/255))
            }
        }
        .padding(16)
        .background(surfaceContainerLow)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }
    
    // MARK: - 7. Trip Notes Card
    private var tripNotesCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("EXPENSE NOTES & TAGS")
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundColor(textVariant)
                .tracking(0.5)
            
            HStack(spacing: 8) {
                TextField("Add note (e.g. Omakase celebration dinner, Ginza)", text: $expenseNotes)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(textOnSurface)
                
                Image(systemName: "tag")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(textVariant)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(surfaceContainer)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            )
        }
        .padding(16)
        .background(surfaceContainerLow)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }
    
    // MARK: - 8. Action CTA Zone
    private var actionCTAZone: some View {
        VStack(spacing: 8) {
            Button(action: {
                triggerHapticFeedback()
                isSaved = true
                showToast("Expense logged & deducted from budget!")
                
                // Return to previous screen after brief confirmation
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    dismiss()
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: isSaved ? "checkmark.circle.fill" : "square.and.arrow.down.fill")
                        .font(.system(size: 17, weight: .bold))
                    
                    Text(isSaved ? "Saved to Ledger!" : "Save & Deduct from Budget")
                        .font(.system(size: 15, weight: .heavy, design: .rounded))
                        .tracking(0.4)
                }
                .foregroundColor(Color(red: 0/255, green: 30/255, blue: 44/255))
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(
                    LinearGradient(
                        colors: isSaved ?
                            [secondaryMint, secondaryContainer] :
                            [primarySky, Color(red: 14/255, green: 165/255, blue: 233/255)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(Capsule())
                .shadow(color: primarySky.opacity(0.35), radius: 14, y: 5)
            }
            
            HStack(spacing: 6) {
                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(secondaryMint)
                
                Text("Auto-synced with Autumn in Japan ledger • Ledger ID #JP-994")
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundColor(textVariant)
                    .lineLimit(1)
            }
            .padding(.top, 2)
        }
    }
    
    // MARK: - Helper Methods
    private func startScanlineAnimation() {
        scanLaserOffset = -110
        withAnimation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true)) {
            scanLaserOffset = 110
        }
    }
    
    private func triggerHapticFeedback() {
        #if canImport(UIKit)
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        #endif
    }
    
    private func showToast(_ text: String) {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            feedbackBannerText = text
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut(duration: 0.3)) {
                if feedbackBannerText == text {
                    feedbackBannerText = nil
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ReceiptScannerExpenseLoggerView()
}
