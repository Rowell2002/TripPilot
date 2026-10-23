//
//  SplashScreenView.swift
//  TripPilot
//
//  Cinematic AI Travel Splash Screen Animation
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

public struct SplashScreenView: View {
    var onFinished: () -> Void
    
    // Animation States
    @State private var ringRotation1: Double = 0
    @State private var ringRotation2: Double = 0
    @State private var radarScale: CGFloat = 0.8
    @State private var radarOpacity: Double = 0.8
    @State private var logoScale: CGFloat = 0.65
    @State private var logoOpacity: Double = 0.0
    @State private var textOffset: CGFloat = 20
    @State private var textOpacity: Double = 0.0
    @State private var telemetryOpacity: Double = 0.0
    @State private var telemetryText: String = "Initializing Neural Co-Pilot..."
    @State private var progressValue: CGFloat = 0.0
    @State private var isExiting: Bool = false
    
    // Color Palette
    private let darkBackground = Color(red: 8/255, green: 12/255, blue: 20/255)       // #080c14
    private let deepNavy = Color(red: 15/255, green: 21/255, blue: 35/255)            // #0f1523
    private let primaryCyan = Color(red: 68/255, green: 226/255, blue: 205/255)        // #44e2cd
    private let skyBlue = Color(red: 56/255, green: 189/255, blue: 248/255)           // #38bdf8
    private let amberGold = Color(red: 251/255, green: 191/255, blue: 36/255)          // #fbbf24
    private let textMuted = Color(red: 148/255, green: 163/255, blue: 184/255)         // slate-400
    
    public init(onFinished: @escaping () -> Void = {}) {
        self.onFinished = onFinished
    }
    
    public var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [darkBackground, deepNavy, darkBackground],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Atmospheric Glows
            GeometryReader { geo in
                Circle()
                    .fill(skyBlue.opacity(0.18))
                    .frame(width: 380, height: 380)
                    .blur(radius: 95)
                    .position(x: geo.size.width * 0.5, y: geo.size.height * 0.42)
                
                Circle()
                    .fill(primaryCyan.opacity(0.14))
                    .frame(width: 280, height: 280)
                    .blur(radius: 80)
                    .position(x: geo.size.width * 0.5, y: geo.size.height * 0.46)
            }
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Central Animated Holographic Radar & Emblem
                ZStack {
                    // Pulsing Radar Rings
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [primaryCyan.opacity(0.4), Color.clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                        .frame(width: 240, height: 240)
                        .scaleEffect(radarScale)
                        .opacity(radarOpacity)
                    
                    // Rotating Outer Dial
                    Circle()
                        .stroke(
                            AngularGradient(
                                colors: [
                                    skyBlue.opacity(0.6),
                                    Color.clear,
                                    primaryCyan.opacity(0.8),
                                    Color.clear,
                                    amberGold.opacity(0.5),
                                    Color.clear
                                ],
                                center: .center
                            ),
                            lineWidth: 2
                        )
                        .frame(width: 200, height: 200)
                        .rotationEffect(.degrees(ringRotation1))
                    
                    // Counter-rotating Inner Telemetry Ring
                    Circle()
                        .stroke(
                            Color.white.opacity(0.12),
                            style: StrokeStyle(lineWidth: 1.5, dash: [4, 8])
                        )
                        .frame(width: 165, height: 165)
                        .rotationEffect(.degrees(ringRotation2))
                    
                    // App Logo Artwork
                    Group {
                        if let uiImage = UIImage(named: "AppLogo") {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } else {
                            Image(systemName: "airplane.circle.fill")
                                .resizable()
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [primaryCyan, skyBlue],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    .frame(width: 124, height: 124)
                    .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [primaryCyan.opacity(0.9), skyBlue.opacity(0.4)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
                    .shadow(color: skyBlue.opacity(0.45), radius: 24, y: 6)
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                }
                .frame(height: 260)
                
                // Brand Title & Tagline
                VStack(spacing: 8) {
                    HStack(spacing: 3) {
                        Text("Trip")
                            .font(.system(size: 38, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Pilot")
                            .font(.system(size: 38, weight: .heavy, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [skyBlue, primaryCyan],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    }
                    .tracking(1.2)
                    
                    // Subtitle Capsule
                    HStack(spacing: 6) {
                        Circle()
                            .fill(primaryCyan)
                            .frame(width: 6, height: 6)
                            .shadow(color: primaryCyan, radius: 4)
                        
                        Text("AUTONOMOUS AI TRAVEL CO-PILOT")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(primaryCyan)
                            .tracking(2.0)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 5)
                    .background(Color.white.opacity(0.06))
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color.white.opacity(0.1), lineWidth: 0.8))
                }
                .offset(y: textOffset)
                .opacity(textOpacity)
                .padding(.top, 24)
                
                Spacer()
                
                // Bottom Telemetry Loading Indicator
                VStack(spacing: 12) {
                    // Telemetry Label
                    Text(telemetryText)
                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                        .foregroundColor(textMuted)
                        .animation(.easeInOut(duration: 0.3), value: telemetryText)
                    
                    // Animated Slim Progress Bar
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.08))
                            .frame(width: 180, height: 4)
                        
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [skyBlue, primaryCyan],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: 180 * progressValue, height: 4)
                            .shadow(color: primaryCyan.opacity(0.8), radius: 6)
                    }
                }
                .opacity(telemetryOpacity)
                .padding(.bottom, 50)
            }
        }
        .scaleEffect(isExiting ? 1.08 : 1.0)
        .opacity(isExiting ? 0.0 : 1.0)
        .onAppear {
            startAnimationSequence()
        }
    }
    
    // MARK: - Animation Sequence
    private func startAnimationSequence() {
        // Haptic feedback
        #if canImport(UIKit)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
        #endif
        
        // 1. Logo emergence with spring
        withAnimation(.spring(response: 0.8, dampingFraction: 0.65)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }
        
        // 2. Rotating rings & radar pulse
        withAnimation(.linear(duration: 8.0).repeatForever(autoreverses: false)) {
            ringRotation1 = 360
        }
        withAnimation(.linear(duration: 6.0).repeatForever(autoreverses: false)) {
            ringRotation2 = -360
        }
        withAnimation(.easeOut(duration: 1.6).repeatForever(autoreverses: false)) {
            radarScale = 1.45
            radarOpacity = 0.0
        }
        
        // 3. Title typography slide & fade
        withAnimation(.easeOut(duration: 0.7).delay(0.25)) {
            textOffset = 0
            textOpacity = 1.0
        }
        
        // 4. Telemetry indicator fade in
        withAnimation(.easeIn(duration: 0.5).delay(0.4)) {
            telemetryOpacity = 1.0
        }
        
        // 5. Progress bar advancement
        withAnimation(.easeInOut(duration: 1.8).delay(0.3)) {
            progressValue = 1.0
        }
        
        // Telemetry stage changes
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            telemetryText = "Calibrating Spatial Geofences..."
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            telemetryText = "Syncing Ceylon Itineraries..."
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
            telemetryText = "Ready to Explore 🇱🇰"
        }
        
        // 6. Graceful exit transition
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
            #if canImport(UIKit)
            let exitHaptic = UIImpactFeedbackGenerator(style: .light)
            exitHaptic.impactOccurred()
            #endif
            
            withAnimation(.easeInOut(duration: 0.6)) {
                isExiting = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                onFinished()
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
