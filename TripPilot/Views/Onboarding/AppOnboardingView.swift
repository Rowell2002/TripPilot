import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

public struct AppOnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var onComplete: (() -> Void)? = nil
    
    // Theme Colors
    private let darkBackground = Color(red: 10/255, green: 14/255, blue: 22/255)
    private let surfaceDark = Color(red: 17/255, green: 24/255, blue: 39/255)
    private let surfaceCard = Color(red: 24/255, green: 32/255, blue: 48/255)
    private let textMuted = Color(red: 148/255, green: 163/255, blue: 184/255)
    private let containerBorder = Color.white.opacity(0.10)
    
    public init(onComplete: (() -> Void)? = nil) {
        self.onComplete = onComplete
    }
    
    public var body: some View {
        ZStack {
            darkBackground
                .ignoresSafeArea()
            
            // Dynamic Ambient Color Glow based on active step
            let step = viewModel.steps[viewModel.currentStep]
            GeometryReader { _ in
                Circle()
                    .fill(step.primaryAccent.opacity(0.12))
                    .frame(width: 380, height: 380)
                    .blur(radius: 90)
                    .offset(x: -80, y: -60)
                
                Circle()
                    .fill(step.secondaryAccent.opacity(0.08))
                    .frame(width: 320, height: 320)
                    .blur(radius: 80)
                    .offset(x: 180, y: 320)
            }
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 0.6), value: viewModel.currentStep)
            
            VStack(spacing: 0) {
                // MARK: - Top Header (Brand + Skip)
                topHeaderSection
                
                // MARK: - Carousel Slides
                TabView(selection: $viewModel.currentStep) {
                    ForEach(viewModel.steps) { stepItem in
                        slideContent(for: stepItem)
                            .tag(stepItem.id)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: viewModel.currentStep)
                
                // MARK: - Bottom Controls (Indicators & CTA)
                bottomControlsSection
            }
            .responsiveContentWidth(620)
        }
        .preferredColorScheme(.dark)
        .onChange(of: viewModel.isCompleted) { completed in
            if completed {
                onComplete?()
            }
        }
    }
    
    // MARK: - Top Header
    private var topHeaderSection: some View {
        HStack {
            // App Brand
            HStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 56/255, green: 189/255, blue: 248/255),
                                    Color(red: 2/255, green: 132/255, blue: 199/255)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: "safari.fill")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 1) {
                    Text("TripPilot")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("SRI LANKA 🇱🇰")
                        .font(.system(size: 9, weight: .heavy, design: .rounded))
                        .foregroundColor(Color(red: 68/255, green: 226/255, blue: 205/255))
                        .tracking(1.2)
                }
            }
            
            Spacer()
            
            // Skip Button
            Button(action: {
                #if canImport(UIKit)
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                #endif
                viewModel.completeOnboarding()
            }) {
                Text("Skip")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(textMuted)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(surfaceDark.opacity(0.8))
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(containerBorder, lineWidth: 1))
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }
    
    // MARK: - Slide Content
    private func slideContent(for step: OnboardingStep) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                // Badge Pill
                HStack(spacing: 6) {
                    Image(systemName: step.badgeIcon)
                        .font(.system(size: 11, weight: .bold))
                    Text(step.badgeText)
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .tracking(0.6)
                }
                .foregroundColor(step.badgeColor)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(step.badgeColor.opacity(0.12))
                .clipShape(Capsule())
                .overlay(Capsule().stroke(step.badgeColor.opacity(0.35), lineWidth: 1))
                .padding(.top, 12)
                
                // Hero Graphic Card
                ZStack {
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    surfaceCard,
                                    surfaceDark
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 200)
                        .overlay(
                            RoundedRectangle(cornerRadius: 28, style: .continuous)
                                .stroke(
                                    LinearGradient(
                                        colors: [step.primaryAccent.opacity(0.4), containerBorder],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1.5
                                )
                        )
                        .shadow(color: step.primaryAccent.opacity(0.15), radius: 20, y: 10)
                    
                    VStack(spacing: 12) {
                        // Glowing Icon Bubble
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [step.primaryAccent, step.secondaryAccent],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 80, height: 80)
                                .shadow(color: step.primaryAccent.opacity(0.4), radius: 16, y: 8)
                            
                            Image(systemName: step.iconName)
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(.black)
                        }
                        
                        Text(step.previewTag)
                            .font(.system(size: 11, weight: .heavy, design: .rounded))
                            .foregroundColor(step.primaryAccent)
                            .tracking(1.4)
                    }
                }
                .padding(.horizontal, 20)
                
                // Headline & Subtitle
                VStack(spacing: 8) {
                    Text(step.title)
                        .font(.system(size: 26, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                    
                    Text(step.subtitle)
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundColor(textMuted)
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)
                        .padding(.horizontal, 16)
                }
                .padding(.top, 4)
                
                // Feature Highlights List
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(step.highlights, id: \.self) { highlight in
                        HStack(spacing: 10) {
                            ZStack {
                                Circle()
                                    .fill(step.primaryAccent.opacity(0.18))
                                    .frame(width: 24, height: 24)
                                Image(systemName: "checkmark")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(step.primaryAccent)
                            }
                            
                            Text(highlight)
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(surfaceDark.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(containerBorder, lineWidth: 1))
                .padding(.horizontal, 20)
                
                // Interactive Vibe Selector on Step 4
                if step.id == 3 {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("SELECT YOUR TRAVEL VIBES")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(step.primaryAccent)
                            .tracking(0.8)
                        
                        FlowLayout(spacing: 8) {
                            ForEach(viewModel.availableVibes, id: \.self) { vibe in
                                let isSelected = viewModel.selectedTravelVibes.contains(vibe)
                                Button(action: {
                                    #if canImport(UIKit)
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    #endif
                                    viewModel.toggleVibe(vibe)
                                }) {
                                    HStack(spacing: 6) {
                                        Text(vibe)
                                            .font(.system(size: 12.5, weight: isSelected ? .bold : .medium, design: .rounded))
                                        if isSelected {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 11, weight: .bold))
                                        }
                                    }
                                    .foregroundColor(isSelected ? .black : .white)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(
                                        isSelected
                                            ? AnyShapeStyle(step.primaryAccent)
                                            : AnyShapeStyle(surfaceCard)
                                    )
                                    .clipShape(Capsule())
                                    .overlay(Capsule().stroke(isSelected ? step.primaryAccent : containerBorder, lineWidth: 1))
                                }
                            }
                        }
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(surfaceDark.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(containerBorder, lineWidth: 1))
                    .padding(.horizontal, 20)
                }
                
                Spacer(minLength: 24)
            }
        }
    }
    
    // MARK: - Bottom Controls
    private var bottomControlsSection: some View {
        VStack(spacing: 16) {
            // Step Indicators
            HStack(spacing: 8) {
                ForEach(0..<viewModel.steps.count, id: \.self) { idx in
                    Capsule()
                        .fill(
                            viewModel.currentStep == idx
                                ? viewModel.steps[viewModel.currentStep].primaryAccent
                                : Color.white.opacity(0.2)
                        )
                        .frame(
                            width: viewModel.currentStep == idx ? 28 : 8,
                            height: 6
                        )
                        .animation(.spring(response: 0.35, dampingFraction: 0.75), value: viewModel.currentStep)
                }
            }
            .padding(.top, 4)
            
            // Buttons Row
            HStack(spacing: 12) {
                // Back Button
                if viewModel.currentStep > 0 {
                    Button(action: {
                        #if canImport(UIKit)
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        #endif
                        viewModel.previousStep()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 52, height: 52)
                            .background(surfaceDark)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(containerBorder, lineWidth: 1))
                    }
                }
                
                // Primary CTA (Continue / Get Started)
                Button(action: {
                    #if canImport(UIKit)
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    #endif
                    viewModel.nextStep()
                }) {
                    HStack(spacing: 8) {
                        Text(viewModel.isLastStep ? "Get Started with TripPilot" : "Continue")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                        Image(systemName: viewModel.isLastStep ? "sparkles" : "arrow.right")
                            .font(.system(size: 15, weight: .bold))
                    }
                    .foregroundColor(Color(red: 10/255, green: 14/255, blue: 22/255))
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(
                        LinearGradient(
                            colors: [
                                viewModel.steps[viewModel.currentStep].primaryAccent,
                                viewModel.steps[viewModel.currentStep].secondaryAccent
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
                    .shadow(
                        color: viewModel.steps[viewModel.currentStep].primaryAccent.opacity(0.4),
                        radius: 12,
                        y: 4
                    )
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
        .background(
            surfaceDark.opacity(0.4)
                .blur(radius: 20)
                .ignoresSafeArea(edges: .bottom)
        )
    }
}
