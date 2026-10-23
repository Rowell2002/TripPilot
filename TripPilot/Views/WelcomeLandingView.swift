//
//  WelcomeLandingView.swift
//  TripPilot
//
//  Created for TripPilot - Welcome & Onboarding Landing Experience
//

import SwiftUI

public struct WelcomeLandingView: View {
    @ObservedObject private var authViewModel = AuthViewModel.shared
    
    // Navigation Triggers
    @State private var navigateToSignIn: Bool = false
    @State private var navigateToCreateAccount: Bool = false
    @State private var navigateToHome: Bool = false
    
    // Carousel state
    @State private var activeFeatureIndex: Int = 0
    @State private var isPulsing: Bool = false
    
    // Theme Colors
    private let darkBackground = Color(red: 15/255, green: 19/255, blue: 28/255)       // #0f131c
    private let containerLow = Color(red: 24/255, green: 28/255, blue: 36/255)         // #181c24
    private let containerHigh = Color(red: 38/255, green: 42/255, blue: 51/255)        // #262a33
    private let primaryCyan = Color(red: 68/255, green: 226/255, blue: 205/255)        // #44e2cd
    private let skyBlue = Color(red: 56/255, green: 189/255, blue: 248/255)           // #38bdf8
    private let textMuted = Color(red: 148/255, green: 163/255, blue: 184/255)         // slate-400
    
    // Feature Highlights Data
    private struct FeatureItem: Identifiable {
        let id: Int
        let icon: String
        let title: String
        let subtitle: String
        let badge: String
    }
    
    private let features: [FeatureItem] = [
        FeatureItem(
            id: 0,
            icon: "location.viewfinder",
            title: "Geofenced Audio Guides",
            subtitle: "Pulsing radar alerts & spatial voice narration when approaching historic landmarks.",
            badge: "SPATIAL AR"
        ),
        FeatureItem(
            id: 1,
            icon: "sparkles",
            title: "AI Journey Wizard",
            subtitle: "Personalized multi-day Sri Lanka & worldwide itineraries tailored to your style.",
            badge: "MACHINE LEARNING"
        ),
        FeatureItem(
            id: 2,
            icon: "chart.line.uptrend.xyaxis",
            title: "Smart Budget Co-Pilot",
            subtitle: "Real-time expense tracking, receipt scanner, and predictive travel forecasts.",
            badge: "CORE ML"
        )
    ]
    
    public init() {}
    
    public var body: some View {
        ZStack {
            darkBackground.ignoresSafeArea()
            
            // Atmospheric Glows
            GeometryReader { _ in
                Circle()
                    .fill(skyBlue.opacity(0.12))
                    .frame(width: 360, height: 360)
                    .blur(radius: 90)
                    .offset(x: -80, y: -100)
                
                Circle()
                    .fill(primaryCyan.opacity(0.08))
                    .frame(width: 320, height: 320)
                    .blur(radius: 80)
                    .offset(x: 180, y: 350)
            }
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Header Pill
                topHeaderBrand
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // Hero Visual & Typography
                        heroVisualSection
                        
                        // Feature Highlights Carousel Card
                        featureHighlightCard
                        
                        // Action Buttons Section
                        actionButtonsSection
                        
                        // Social Auth & Guest Mode
                        secondaryActionsSection
                        
                        Spacer(minLength: 32)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            isPulsing = true
        }
        .navigationDestination(isPresented: $navigateToCreateAccount) {
            CreateAccountView()
        }
        .navigationDestination(isPresented: $navigateToSignIn) {
            SignInView()
        }
        .navigationDestination(isPresented: $navigateToHome) {
            HomeDashboardView()
        }
    }
    
    // MARK: - Top Header Brand
    private var topHeaderBrand: some View {
        HStack {
            HStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [skyBlue, Color(red: 2/255, green: 132/255, blue: 199/255)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: "safari.fill")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Text("TripPilot")
                    .font(.system(size: 18, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            // Guest Bypass Button
            Button(action: {
                authViewModel.setGuestSession()
                navigateToHome = true
            }) {
                HStack(spacing: 4) {
                    Text("Explore Guest")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                    Image(systemName: "chevron.right")
                        .font(.system(size: 10, weight: .bold))
                }
                .foregroundColor(skyBlue)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.06))
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color.white.opacity(0.1), lineWidth: 1))
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 14)
        .padding(.bottom, 6)
    }
    
    // MARK: - Hero Visual Section
    private var heroVisualSection: some View {
        VStack(spacing: 16) {
            // Hero Icon / Badge with Pulsing Aura
            ZStack {
                Circle()
                    .stroke(skyBlue.opacity(0.25), lineWidth: 2)
                    .frame(width: 100, height: 100)
                    .scaleEffect(isPulsing ? 1.25 : 0.9)
                    .opacity(isPulsing ? 0.0 : 0.8)
                    .animation(
                        Animation.easeOut(duration: 2.2).repeatForever(autoreverses: false),
                        value: isPulsing
                    )
                
                Circle()
                    .fill(containerHigh)
                    .frame(width: 84, height: 84)
                    .overlay(Circle().stroke(Color.white.opacity(0.12), lineWidth: 1.5))
                    .shadow(color: skyBlue.opacity(0.3), radius: 18, y: 4)
                
                Image(systemName: "airplane.circle.fill")
                    .font(.system(size: 52))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [skyBlue, primaryCyan],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .padding(.top, 8)
            
            // Headline & Description
            VStack(spacing: 8) {
                Text("Next-Gen Travel,\nIntelligently Guided.")
                    .font(.system(size: 30, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
                
                Text("Autonomous AI itinerary generation, geofenced spatial voice guides, and real-time traveler intelligence.")
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(textMuted)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 10)
            }
        }
    }
    
    // MARK: - Feature Highlight Card
    private var featureHighlightCard: some View {
        VStack(spacing: 12) {
            let item = features[activeFeatureIndex]
            
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(skyBlue.opacity(0.15))
                        .frame(width: 48, height: 48)
                        .overlay(Circle().stroke(skyBlue.opacity(0.3), lineWidth: 1))
                    
                    Image(systemName: item.icon)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(skyBlue)
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    HStack {
                        Text(item.title)
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text(item.badge)
                            .font(.system(size: 9, weight: .heavy, design: .rounded))
                            .foregroundColor(primaryCyan)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(primaryCyan.opacity(0.12))
                            .clipShape(Capsule())
                    }
                    
                    Text(item.subtitle)
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .foregroundColor(textMuted)
                        .lineLimit(2)
                        .lineSpacing(2)
                }
            }
            .padding(16)
            .background(containerLow)
            .cornerRadius(18)
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            )
            
            // Dot indicators
            HStack(spacing: 6) {
                ForEach(0..<features.count, id: \.self) { idx in
                    Circle()
                        .fill(activeFeatureIndex == idx ? skyBlue : Color.white.opacity(0.2))
                        .frame(width: activeFeatureIndex == idx ? 16 : 6, height: 6)
                        .animation(.easeInOut(duration: 0.2), value: activeFeatureIndex)
                        .onTapGesture {
                            activeFeatureIndex = idx
                        }
                }
            }
            .padding(.top, 2)
        }
    }
    
    // MARK: - Action Buttons Section
    private var actionButtonsSection: some View {
        VStack(spacing: 12) {
            // Get Started (Create Account)
            Button(action: {
                navigateToCreateAccount = true
            }) {
                HStack(spacing: 8) {
                    Text("Get Started")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 15, weight: .bold))
                }
                .foregroundColor(Color(red: 10/255, green: 14/255, blue: 22/255))
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(
                    LinearGradient(
                        colors: [skyBlue, primaryCyan],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(Capsule())
                .shadow(color: skyBlue.opacity(0.35), radius: 12, y: 4)
            }
            
            // Sign In Button
            Button(action: {
                navigateToSignIn = true
            }) {
                Text("I Already Have an Account")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(containerLow)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                    )
            }
        }
        .padding(.top, 6)
    }
    
    // MARK: - Secondary Actions & Social Logins
    private var secondaryActionsSection: some View {
        VStack(spacing: 14) {
            // Divider with text
            HStack(spacing: 12) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(height: 1)
                Text("OR QUICK CONNECT")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(textMuted.opacity(0.7))
                    .tracking(0.8)
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(height: 1)
            }
            .padding(.vertical, 4)
            
            HStack(spacing: 12) {
                // Apple Button
                Button(action: {
                    Task {
                        await authViewModel.signInWithApple()
                        if authViewModel.isAuthenticated {
                            navigateToHome = true
                        }
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "apple.logo")
                            .font(.system(size: 16))
                        Text("Apple")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 46)
                    .background(containerLow)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                }
                
                // Google Button
                Button(action: {
                    Task {
                        await authViewModel.signInWithGoogle()
                        if authViewModel.isAuthenticated {
                            navigateToHome = true
                        }
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "globe.asia.australia.fill")
                            .font(.system(size: 15))
                            .foregroundColor(primaryCyan)
                        Text("Google")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 46)
                    .background(containerLow)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                }
            }
            
            Text("By continuing, you agree to TripPilot Terms of Service and Privacy Policy.")
                .font(.system(size: 11, weight: .regular, design: .rounded))
                .foregroundColor(textMuted.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
                .padding(.top, 4)
        }
    }
}

#Preview {
    WelcomeLandingView()
}
