import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Main Budget & Expenses View
struct BudgetExpensesView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: BudgetExpensesViewModel = .shared
    @ObservedObject private var authViewModel = AuthViewModel.shared
    
    // Theme Colors
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
                .responsiveContentWidth(920)
            }
            
            // MARK: - Fixed Top Translucent Header Bar
            VStack(spacing: 0) {
                topHeaderBar
                    .responsiveContentWidth(920)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .ignoresSafeArea(edges: .top)
            
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .preferredColorScheme(.dark)
        .sheet(isPresented: $viewModel.showLogExpenseSheet) {
            logExpenseModalSheet
        }
        .sheet(isPresented: $viewModel.showSplitBillSheet) {
            splitBillModalSheet
        }
        .sheet(isPresented: $viewModel.showEditBudgetSheet) {
            editBudgetModalSheet
        }
        .overlay(alignment: .top) {
            if let notice = viewModel.activeNotice {
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
            // Top Navigation Row
            HStack {
                Button(action: {
                    AppNavigationRouter.shared.switchTab(to: .home)
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
                
                // Status Chip
                HStack(spacing: 6) {
                    Image(systemName: "banknote.fill")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(primarySky)
                    
                    Text("EXPENSES OVERVIEW")
                        .font(.system(size: 10.5, weight: .bold, design: .rounded))
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
                    viewModel.triggerNotice("🔔 FX alert: LKR stable at ~305 per USD today")
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
                
                // User Avatar
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(red: 56/255, green: 189/255, blue: 248/255), Color(red: 68/255, green: 226/255, blue: 205/255)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 32, height: 32)
                    
                    Text(authViewModel.userInitials)
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
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
                    
                    Text(viewModel.tripManager.currentTrip.title.isEmpty ? "Sri Lanka Island Tour 🇱🇰" : viewModel.tripManager.currentTrip.title)
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(1)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(surfaceContainerLow)
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(outlineBorder, lineWidth: 1)
                )
                
                Spacer()
                
                Text("Active Sri Lanka Journey")
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
                    viewModel.toggleCurrency()
                }) {
                    HStack(spacing: 6) {
                        Text(viewModel.isUSD ? "USD ($)" : "LKR (Rs.)")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundColor(primarySky)
                        
                        Image(systemName: "arrow.left.arrow.right")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(slateMuted)
                        
                        Text(viewModel.isUSD ? "LKR (Rs.)" : "USD ($)")
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
                
                Text("1 USD = 305.00 LKR • Central Bank of Sri Lanka Live FX")
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
                        
                        Text(viewModel.isUSD ? String(format: "$%.2f", viewModel.remainingSafeToSpendUSD) : "Rs. \(viewModel.remainingSafeToSpendLKR.formatted())")
                            .font(.system(size: 34, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(viewModel.utilizationPercentFormatted + " Utilized")
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
                        
                        Text("\(viewModel.remainingDaysCount) Days Remaining")
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                            .foregroundColor(slateMuted)
                    }
                }
                
                // Segmented Multi-Color Progress Bar
                VStack(spacing: 6) {
                    GeometryReader { geo in
                        let width = geo.size.width
                        let slices = viewModel.donutSlices
                        
                        HStack(spacing: 2) {
                            if viewModel.totalSpentUSD <= 0 {
                                Capsule()
                                    .fill(surfaceContainer)
                                    .frame(width: width)
                            } else {
                                ForEach(slices) { slice in
                                    let sliceWidth = max(width * CGFloat(slice.percentage * viewModel.utilizationPercentage), 4)
                                    Capsule()
                                        .fill(slice.color)
                                        .frame(width: sliceWidth)
                                        .shadow(color: slice.color.opacity(0.5), radius: 3)
                                }
                            }
                        }
                    }
                    .frame(height: 10)
                    .background(Color.black.opacity(0.6))
                    .clipShape(Capsule())
                    .overlay(
                        Capsule().stroke(Color.white.opacity(0.08), lineWidth: 1)
                    )
                    
                    // Spent vs Total Label with Edit Cap CTA
                    HStack {
                        HStack(spacing: 2) {
                            Text("Spent:")
                                .foregroundColor(slateMuted)
                            Text(viewModel.isUSD ? String(format: "$%.2f", viewModel.totalSpentUSD) : "Rs. \(viewModel.totalSpentLKR.formatted())")
                                .foregroundColor(.white)
                                .bold()
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Text("Cap:")
                                .foregroundColor(slateMuted)
                            Text(viewModel.isUSD ? String(format: "$%.2f", viewModel.totalBudgetUSD) : "Rs. \(viewModel.totalBudgetLKR.formatted())")
                                .foregroundColor(.white)
                                .bold()
                            
                            Button(action: {
                                viewModel.showEditBudgetSheet = true
                            }) {
                                Image(systemName: "pencil.circle.fill")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(primarySky)
                            }
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
                            Text(viewModel.isUSD ? String(format: "$%.2f", viewModel.dailySafePaceUSD) : "Rs. \(viewModel.dailySafePaceLKR.formatted())")
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("/ day safe pace")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(slateMuted)
                        }
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: viewModel.paceStatus == "On Track" ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                            .font(.system(size: 11, weight: .bold))
                        Text(viewModel.paceStatus)
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(viewModel.paceStatus == "On Track" ? secondaryMint : amberGold)
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
            // Log Expense Primary CTA (Direct manual amount entry)
            Button(action: {
                viewModel.showLogExpenseSheet = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 17, weight: .bold))
                    
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
                viewModel.showSplitBillSheet = true
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
                
                if viewModel.isSettledWithMarcus {
                    Text("Marcus is all settled up 🎉")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(secondaryMint)
                } else {
                    HStack(spacing: 4) {
                        Text("Marcus owes you")
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text(viewModel.isUSD ? "$78.00" : "Rs. 23,790")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundColor(secondaryMint)
                    }
                }
                
                Text("Observation Saloon Train Seats • Ella")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(slateMuted)
            }
            
            Spacer()
            
            // Settle Up Button
            Button(action: {
                withAnimation {
                    viewModel.settleWithMarcus()
                }
            }) {
                Text(viewModel.isSettledWithMarcus ? "Settled" : "Settle Up")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundColor(viewModel.isSettledWithMarcus ? slateMuted : primarySky)
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
                    
                    Text("\(viewModel.categoryEnvelopes.count) Active Allocation Buckets")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(slateMuted)
                }
                
                Spacer()
                
                Button(action: {
                    viewModel.triggerNotice("📊 Exporting PDF Budget Statement...")
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
                DonutChartView(slices: viewModel.donutSlices)
                    .frame(width: 190, height: 190)
                
                // Donut Core Badge
                VStack(spacing: 2) {
                    Text("TOTAL SPENT")
                        .font(.system(size: 9.5, weight: .bold, design: .rounded))
                        .foregroundColor(slateMuted)
                        .tracking(0.8)
                    
                    Text(viewModel.isUSD ? String(format: "$%.0f", viewModel.totalSpentUSD) : "Rs. \(viewModel.totalSpentLKR.formatted())")
                        .font(.system(size: 22, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(viewModel.isUSD ? "LKR \(viewModel.totalSpentLKR.formatted())" : String(format: "USD $%.2f", viewModel.totalSpentUSD))
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(secondaryMint)
                }
            }
            .padding(.vertical, 6)
            
            // Donut Legend Grid (Real Dynamic Slices)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                ForEach(viewModel.donutSlices) { slice in
                    legendItem(
                        title: slice.name,
                        percent: "\(Int(slice.percentage * 100))%",
                        color: slice.color
                    )
                }
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
                    viewModel.showEditBudgetSheet = true
                }) {
                    Text("MANAGE TARGETS")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(primarySky)
                        .tracking(0.6)
                }
            }
            .padding(.horizontal, 2)
            
            VStack(spacing: 10) {
                ForEach(viewModel.categoryEnvelopes) { envelope in
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
                    Text(viewModel.isUSD ? String(format: "$%.2f", envelope.spentUSD) : "Rs. \(envelope.spentLKR.formatted())")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    let leftUSD = max(envelope.targetUSD - envelope.spentUSD, 0)
                    let leftLKR = max(envelope.targetLKR - envelope.spentLKR, 0)
                    let isTight = envelope.progress > 0.95
                    
                    Text(viewModel.isUSD ? String(format: "$%.2f left", leftUSD) : "Rs. \(leftLKR.formatted()) left")
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
                    
                    Text("\(viewModel.transactions.count)")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundColor(slateMuted)
                        .frame(width: 22, height: 22)
                        .background(surfaceContainer)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(outlineBorder, lineWidth: 1)
                        )
                }
                
                Spacer()
                
                Button(action: {
                    viewModel.showLogExpenseSheet = true
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "plus")
                            .font(.system(size: 10, weight: .bold))
                        Text("ADD EXPENSE")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(primarySky)
                    .tracking(0.6)
                }
            }
            .padding(.horizontal, 2)
            
            if viewModel.transactions.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "creditcard.and.123")
                        .font(.system(size: 36))
                        .foregroundColor(slateMuted.opacity(0.7))
                        .padding(.top, 16)
                    
                    Text("No expenses logged yet")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Enter your daily expenses to keep your Sri Lanka journey budget on track.")
                        .font(.system(size: 12))
                        .foregroundColor(slateMuted)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    Button(action: {
                        viewModel.showLogExpenseSheet = true
                    }) {
                        Text("Log First Expense")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(primarySky)
                            .clipShape(Capsule())
                    }
                    .padding(.bottom, 16)
                }
                .frame(maxWidth: .infinity)
                .background(surfaceContainerLow)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(outlineBorder, lineWidth: 1)
                )
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(viewModel.transactions.enumerated()), id: \.element.id) { index, item in
                        transactionRow(item: item)
                        
                        if index < viewModel.transactions.count - 1 {
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
                
                Image(systemName: item.categoryIcon)
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
                .lineLimit(1)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 1) {
                Text(viewModel.isUSD ? String(format: "-$%.2f", item.amountUSD) : "-Rs. \(item.amountLKR.formatted())")
                    .font(.system(size: 13.5, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text(viewModel.isUSD ? "Rs. \(item.amountLKR.formatted())" : String(format: "$%.2f", item.amountUSD))
                    .font(.system(size: 10.5, weight: .medium, design: .rounded))
                    .foregroundColor(slateMuted)
            }
            
            // Delete Action
            Button(action: {
                viewModel.deleteExpense(id: item.id)
            }) {
                Image(systemName: "trash")
                    .font(.system(size: 12))
                    .foregroundColor(slateMuted.opacity(0.6))
                    .frame(width: 24, height: 24)
            }
            .buttonStyle(.plain)
        }
        .padding(14)
    }
    
    // MARK: - 8. Shared Travelers Section
    private var sharedTravelersSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("SHARED EXPENSE GROUP")
                .font(.system(size: 10, weight: .bold, design: .rounded))
                .foregroundColor(slateMuted)
                .tracking(0.8)
                .padding(.horizontal, 2)
            
            HStack(spacing: 12) {
                // User Chip
                HStack(spacing: 8) {
                    Circle()
                        .fill(primarySky)
                        .frame(width: 28, height: 28)
                        .overlay(
                            Text(authViewModel.userInitials)
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.white)
                        )
                    
                    VStack(alignment: .leading, spacing: 1) {
                        Text("You (\(authViewModel.userFirstName))")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Owner • 100%")
                            .font(.system(size: 10))
                            .foregroundColor(secondaryMint)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(surfaceContainerLow)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(outlineBorder, lineWidth: 1)
                )
                
                // Marcus Vance Chip
                HStack(spacing: 8) {
                    AsyncImage(url: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuCrjrvhGFcSJU2Zd4Cz0JAA5kdEEqFJydlEqE1qQMBQIoKF84dHx5EruFawPjn8pH_DS6QLDWFcPTbi0QkJxaj1BR-r1o1xysi2haLa9XHpDAixQZ0FmOEBZwBpHor5o9AH36QAprlWSyKjqb1pfbzXJIjhj1n96OjCDUZj_tkDIxatbXGWrpaRghWBjIVEQ9gb59a0rGkIAYw54dfcdA-LW00mMamEHPm5OuHH6sFZn4IMNy2qZKYSqg")) { phase in
                        if let image = phase.image {
                            image.resizable().aspectRatio(contentMode: .fill)
                        } else {
                            Circle().fill(surfaceContainerHigh)
                        }
                    }
                    .frame(width: 28, height: 28)
                    .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Marcus V.")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Travel Partner")
                            .font(.system(size: 10))
                            .foregroundColor(slateMuted)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(surfaceContainerLow)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(outlineBorder, lineWidth: 1)
                )
                
                Spacer()
                
                // Add Traveler Pill
                Button(action: {
                    viewModel.showSplitBillSheet = true
                }) {
                    Image(systemName: "person.badge.plus")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(primarySky)
                        .frame(width: 40, height: 44)
                        .background(surfaceContainerLow)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(outlineBorder, lineWidth: 1)
                        )
                }
            }
        }
    }
    
    // MARK: - Modals
    private var logExpenseModalSheet: some View {
        LogExpenseSheet(
            fxRate: viewModel.fxRate,
            initialIsUSD: viewModel.isUSD
        ) { title, category, amount, inputIsUSD, location, date in
            viewModel.addExpense(
                title: title,
                category: category,
                amount: amount,
                inputIsUSD: inputIsUSD,
                location: location,
                date: date
            )
        }
    }
    
    private var splitBillModalSheet: some View {
        SplitBillSheet(isUSD: viewModel.isUSD) { amountPerPerson in
            viewModel.triggerNotice("👥 Bill split requested: $\(String(format: "%.2f", amountPerPerson)) per person")
        }
    }
    
    private var editBudgetModalSheet: some View {
        EditBudgetCapSheet(
            currentCapUSD: viewModel.totalBudgetUSD,
            fxRate: viewModel.fxRate,
            isUSD: viewModel.isUSD
        ) { newCapUSD in
            viewModel.updateBudgetCap(newCapUSD: newCapUSD)
        } onReset: {
            viewModel.resetBudgetCapToTripDefault()
        }
    }
}

// MARK: - Donut Chart Helper Shapes
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

// MARK: - Submodal: Log Expense Sheet (No Scanner, Direct Amount Entry)
struct LogExpenseSheet: View {
    @Environment(\.dismiss) private var dismiss
    let fxRate: Double
    @State var inputIsUSD: Bool
    var onSave: (String, String, Double, Bool, String, Date) -> Void
    
    @State private var amountText: String = ""
    @State private var merchantName: String = ""
    @State private var selectedCategory: String = "Dining"
    @State private var location: String = "Colombo, Sri Lanka"
    @State private var selectedDate: Date = Date()
    
    init(
        fxRate: Double = 305.00,
        initialIsUSD: Bool = true,
        onSave: @escaping (String, String, Double, Bool, String, Date) -> Void
    ) {
        self.fxRate = fxRate
        self._inputIsUSD = State(initialValue: initialIsUSD)
        self.onSave = onSave
    }
    
    private let categories: [(name: String, icon: String, color: Color)] = [
        ("Dining", "fork.knife", Color(red: 245/255, green: 158/255, blue: 11/255)),
        ("Transit", "tram.fill", Color(red: 37/255, green: 99/255, blue: 235/255)),
        ("Lodging", "bed.double.fill", Color(red: 56/255, green: 189/255, blue: 248/255)),
        ("Culture", "ticket.fill", Color(red: 16/255, green: 185/255, blue: 129/255)),
        ("Shopping", "bag.fill", Color(red: 168/255, green: 85/255, blue: 247/255))
    ]
    
    private let quickPresets = [
        ("🍽️ Dinner", "Dining"),
        ("🛺 Tuk-Tuk", "Transit"),
        ("🏨 Hotel Stay", "Lodging"),
        ("🏰 Citadel Ticket", "Culture"),
        ("🍵 Ceylon Spices", "Shopping"),
        ("🥥 Fresh Thambili", "Dining")
    ]
    
    private var parsedAmount: Double {
        Double(amountText.replacingOccurrences(of: ",", with: ".")) ?? 0.0
    }
    
    private var convertedAmountString: String {
        guard parsedAmount > 0 else { return "" }
        if inputIsUSD {
            let lkr = Int(parsedAmount * fxRate)
            return "≈ Rs. \(lkr.formatted()) LKR"
        } else {
            let usd = parsedAmount / fxRate
            return String(format: "≈ $%.2f USD", usd)
        }
    }
    
    private var isFormValid: Bool {
        parsedAmount > 0 && !merchantName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Amount Hero Card with Currency Toggle
                        VStack(spacing: 12) {
                            HStack {
                                Text(inputIsUSD ? "AMOUNT IN US DOLLARS" : "AMOUNT IN SRI LANKAN RUPEES")
                                    .font(.system(size: 11, weight: .bold, design: .rounded))
                                    .foregroundColor(Color(red: 148/255, green: 163/255, blue: 184/255))
                                    .tracking(0.8)
                                
                                Spacer()
                                
                                // Currency Switcher Pill
                                Button(action: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                                        inputIsUSD.toggle()
                                    }
                                }) {
                                    HStack(spacing: 4) {
                                        Text(inputIsUSD ? "USD ($)" : "LKR (Rs.)")
                                            .font(.system(size: 11, weight: .bold, design: .rounded))
                                            .foregroundColor(Color(red: 56/255, green: 189/255, blue: 248/255))
                                        
                                        Image(systemName: "arrow.2.squarepath")
                                            .font(.system(size: 10))
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Color(red: 24/255, green: 34/255, blue: 52/255))
                                    .clipShape(Capsule())
                                    .overlay(
                                        Capsule().stroke(Color.white.opacity(0.12), lineWidth: 1)
                                    )
                                }
                            }
                            
                            // Hero Amount Display & TextField
                            HStack(alignment: .firstTextBaseline, spacing: 6) {
                                Text(inputIsUSD ? "$" : "Rs.")
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                                    .foregroundColor(Color(red: 56/255, green: 189/255, blue: 248/255))
                                
                                TextField("0.00", text: $amountText)
                                    .font(.system(size: 46, weight: .heavy, design: .rounded))
                                    .foregroundColor(.white)
                                    .keyboardType(.decimalPad)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            // Live FX Conversion Preview
                            if !convertedAmountString.isEmpty {
                                HStack(spacing: 6) {
                                    Circle()
                                        .fill(Color(red: 68/255, green: 226/255, blue: 205/255))
                                        .frame(width: 6, height: 6)
                                    
                                    Text("\(convertedAmountString) (at 305 FX rate)")
                                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                                        .foregroundColor(Color(red: 68/255, green: 226/255, blue: 205/255))
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            // Quick Amount Increment Chips
                            HStack(spacing: 8) {
                                if inputIsUSD {
                                    quickIncrementButton(label: "+$10", delta: 10)
                                    quickIncrementButton(label: "+$25", delta: 25)
                                    quickIncrementButton(label: "+$50", delta: 50)
                                    quickIncrementButton(label: "+$100", delta: 100)
                                } else {
                                    quickIncrementButton(label: "+1k", delta: 1000)
                                    quickIncrementButton(label: "+2.5k", delta: 2500)
                                    quickIncrementButton(label: "+5k", delta: 5000)
                                    quickIncrementButton(label: "+10k", delta: 10000)
                                }
                                
                                Button(action: {
                                    amountText = ""
                                }) {
                                    Text("Clear")
                                        .font(.system(size: 11, weight: .bold, design: .rounded))
                                        .foregroundColor(Color(red: 248/255, green: 113/255, blue: 113/255))
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(Color.white.opacity(0.06))
                                        .clipShape(Capsule())
                                }
                            }
                            .padding(.top, 4)
                        }
                        .padding(18)
                        .background(Color(red: 17/255, green: 24/255, blue: 39/255))
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                        
                        // Merchant / Description
                        VStack(alignment: .leading, spacing: 8) {
                            Text("MERCHANT / EXPENSE DESCRIPTION")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                                .foregroundColor(Color(red: 148/255, green: 163/255, blue: 184/255))
                                .tracking(0.6)
                            
                            TextField("e.g. Ministry of Crab, Kandy Blue Train...", text: $merchantName)
                                .font(.system(size: 15))
                                .foregroundColor(.white)
                                .padding(14)
                                .background(Color(red: 17/255, green: 24/255, blue: 39/255))
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                    )
                            
                            // Quick Presets
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(quickPresets, id: \.0) { preset in
                                        Button(action: {
                                            merchantName = preset.0.replacingOccurrences(of: "^[\\p{Emoji}\\s]+", with: "", options: .regularExpression)
                                            selectedCategory = preset.1
                                        }) {
                                            Text(preset.0)
                                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 6)
                                                .background(Color(red: 24/255, green: 34/255, blue: 52/255))
                                                .clipShape(Capsule())
                                                .overlay(
                                                    Capsule().stroke(Color.white.opacity(0.08), lineWidth: 1)
                                                )
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Category Selector
                        VStack(alignment: .leading, spacing: 8) {
                            Text("CATEGORY ENVELOPE")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                                .foregroundColor(Color(red: 148/255, green: 163/255, blue: 184/255))
                                .tracking(0.6)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(categories, id: \.name) { cat in
                                        let isSelected = selectedCategory == cat.name
                                        Button(action: {
                                            selectedCategory = cat.name
                                        }) {
                                            HStack(spacing: 6) {
                                                Image(systemName: cat.icon)
                                                    .font(.system(size: 12))
                                                Text(cat.name)
                                                    .font(.system(size: 12, weight: .bold, design: .rounded))
                                                    .lineLimit(1)
                                            }
                                            .foregroundColor(isSelected ? .black : .white)
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 8)
                                            .background(isSelected ? cat.color : Color(red: 24/255, green: 34/255, blue: 52/255))
                                            .clipShape(Capsule())
                                            .overlay(
                                                Capsule().stroke(isSelected ? Color.clear : Color.white.opacity(0.08), lineWidth: 1)
                                            )
                                        }
                                    }
                                }
                                .padding(.horizontal, 1)
                            }
                        }
                        
                        // Location & Date
                        VStack(alignment: .leading, spacing: 12) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("LOCATION")
                                    .font(.system(size: 11, weight: .bold, design: .rounded))
                                    .foregroundColor(Color(red: 148/255, green: 163/255, blue: 184/255))
                                    .tracking(0.6)
                                
                                HStack(spacing: 8) {
                                    Image(systemName: "mappin.circle.fill")
                                        .foregroundColor(Color(red: 56/255, green: 189/255, blue: 248/255))
                                    
                                    TextField("Location in Sri Lanka", text: $location)
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                }
                                .padding(12)
                                .background(Color(red: 17/255, green: 24/255, blue: 39/255))
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                )
                            }
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("DATE")
                                    .font(.system(size: 11, weight: .bold, design: .rounded))
                                    .foregroundColor(Color(red: 148/255, green: 163/255, blue: 184/255))
                                    .tracking(0.6)
                                
                                DatePicker(
                                    "",
                                    selection: $selectedDate,
                                    displayedComponents: [.date]
                                )
                                .datePickerStyle(.compact)
                                .labelsHidden()
                                .colorScheme(.dark)
                            }
                        }
                        
                        // Save Button
                        Button(action: {
                            guard isFormValid else { return }
                            
                            #if canImport(UIKit)
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.impactOccurred()
                            #endif
                            
                            onSave(merchantName, selectedCategory, parsedAmount, inputIsUSD, location, selectedDate)
                            dismiss()
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 17, weight: .bold))
                                Text("Save to Trip Budget")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(
                                isFormValid ?
                                LinearGradient(
                                    colors: [Color(red: 2/255, green: 132/255, blue: 199/255), Color(red: 56/255, green: 189/255, blue: 248/255)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ) :
                                LinearGradient(
                                    colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.3)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(Capsule())
                            .shadow(color: isFormValid ? Color(red: 56/255, green: 189/255, blue: 248/255).opacity(0.35) : .clear, radius: 10, y: 4)
                        }
                        .disabled(!isFormValid)
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
    
    private func quickIncrementButton(label: String, delta: Double) -> some View {
        Button(action: {
            let current = parsedAmount
            let newAmount = current + delta
            if inputIsUSD {
                amountText = String(format: "%.2f", newAmount)
            } else {
                amountText = "\(Int(newAmount))"
            }
        }) {
            Text(label)
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color(red: 24/255, green: 34/255, blue: 52/255))
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        }
    }
}

// MARK: - Submodal: Edit Budget Cap Sheet
struct EditBudgetCapSheet: View {
    @Environment(\.dismiss) private var dismiss
    let currentCapUSD: Double
    let fxRate: Double
    let isUSD: Bool
    var onSave: (Double) -> Void
    var onReset: () -> Void
    
    @State private var capInput: String = ""
    
    init(
        currentCapUSD: Double,
        fxRate: Double,
        isUSD: Bool,
        onSave: @escaping (Double) -> Void,
        onReset: @escaping () -> Void
    ) {
        self.currentCapUSD = currentCapUSD
        self.fxRate = fxRate
        self.isUSD = isUSD
        self.onSave = onSave
        self.onReset = onReset
        self._capInput = State(initialValue: String(format: "%.0f", currentCapUSD))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text("TARGET TRIP BUDGET CAP")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(Color(red: 148/255, green: 163/255, blue: 184/255))
                            .tracking(1)
                        
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text("$")
                                .font(.system(size: 34, weight: .bold, design: .rounded))
                                .foregroundColor(Color(red: 56/255, green: 189/255, blue: 248/255))
                            
                            TextField("2500", text: $capInput)
                                .font(.system(size: 44, weight: .heavy, design: .rounded))
                                .foregroundColor(.white)
                                .keyboardType(.numberPad)
                        }
                        
                        if let capVal = Double(capInput), capVal > 0 {
                            Text("≈ Rs. \(Int(capVal * fxRate).formatted()) LKR at 305 FX")
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                .foregroundColor(Color(red: 68/255, green: 226/255, blue: 205/255))
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 17/255, green: 24/255, blue: 39/255))
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                    
                    // Quick Preset Buttons
                    HStack(spacing: 10) {
                        presetCapButton(label: "$1,500", val: 1500)
                        presetCapButton(label: "$2,500", val: 2500)
                        presetCapButton(label: "$3,500", val: 3500)
                        presetCapButton(label: "$5,000", val: 5000)
                    }
                    
                    // Reset to Trip Defaults
                    Button(action: {
                        onReset()
                        dismiss()
                    }) {
                        Text("Reset to Itinerary Plan Default")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundColor(Color(red: 148/255, green: 163/255, blue: 184/255))
                    }
                    
                    Spacer()
                    
                    // Save Button
                    Button(action: {
                        if let newCap = Double(capInput), newCap > 0 {
                            onSave(newCap)
                            dismiss()
                        }
                    }) {
                        Text("Update Target Budget")
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
                    }
                }
                .padding(20)
            }
            .navigationTitle("Adjust Budget Cap")
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
    
    private func presetCapButton(label: String, val: Double) -> some View {
        Button(action: {
            capInput = "\(Int(val))"
        }) {
            Text(label)
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 38)
                .background(Color(red: 24/255, green: 34/255, blue: 52/255))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        }
    }
}

// MARK: - Submodal: Split Bill Sheet
struct SplitBillSheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var authViewModel = AuthViewModel.shared
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
                        
                        Text(String(format: "LKR Rs. %d per traveler", Int(perPersonAmount * 305.00)))
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
                            Text("\(authViewModel.userFirstName), Marcus + Guests")
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
