//
//  SignInView.swift
//  TripPilot
//
//  Generated from Stitch Screen: e9cd43944833403f875e23d488998c34
//  Title: TripPilot - Sign In (Dark Mode)
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var isFaceIdEnabled: Bool = true
    @State private var navigateToCreateAccount: Bool = false
    @State private var navigateToHome: Bool = false
    
    // Stitch Theme Colors
    private let darkBackground = Color(red: 15/255, green: 19/255, blue: 28/255)       // #0f131c
    private let containerLow = Color(red: 24/255, green: 28/255, blue: 36/255)         // #181c24
    private let containerHigh = Color(red: 38/255, green: 42/255, blue: 51/255)        // #262a33
    private let primaryCyan = Color(red: 68/255, green: 226/255, blue: 205/255)        // #44e2cd
    private let primaryBlue = Color(red: 142/255, green: 213/255, blue: 255/255)       // #8ed5ff
    private let skyGradientStart = Color(red: 56/255, green: 189/255, blue: 248/255)   // sky-400
    private let skyGradientEnd = Color(red: 2/255, green: 132/255, blue: 199/255)     // sky-600
    
    var body: some View {
        ZStack {
            // Background
            darkBackground
                .ignoresSafeArea()
            
            // Subtle Ambient Glows
            GeometryReader { _ in
                Circle()
                    .fill(primaryBlue.opacity(0.08))
                    .frame(width: 320, height: 320)
                    .blur(radius: 80)
                    .offset(x: -80, y: -100)
                
                Circle()
                    .fill(primaryCyan.opacity(0.06))
                    .frame(width: 300, height: 300)
                    .blur(radius: 70)
                    .offset(x: 180, y: 300)
            }
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // MARK: - Top Navigation Bar
                    HStack {
                        Spacer()
                        
                        Button(action: {}) {
                            Text("Help")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .foregroundColor(primaryBlue)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 7)
                                .background(containerHigh)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 8)
                    
                    // MARK: - Header Section
                    VStack(spacing: 12) {
                        // App Icon Badge
                        ZStack {
                            Circle()
                                .fill(containerHigh)
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                                )
                                .shadow(color: Color.black.opacity(0.4), radius: 10, y: 6)
                            
                            Image(systemName: "airplane.circle.fill")
                                .font(.system(size: 46))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [primaryCyan, primaryBlue],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }
                        .padding(.top, 6)
                        
                        Text("Welcome Back")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Enter your credentials or use biometric security to access your flight itineraries and travel journals.")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(Color(white: 0.65))
                            .multilineTextAlignment(.center)
                            .lineSpacing(3)
                            .padding(.horizontal, 16)
                    }
                    .padding(.bottom, 24)
                    
                    // MARK: - Social SSO Buttons
                    VStack(spacing: 12) {
                        // Apple Sign In Button
                        Button(action: {}) {
                            HStack(spacing: 10) {
                                Image(systemName: "apple.logo")
                                    .font(.system(size: 18))
                                Text("Sign in with Apple")
                                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                            }
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color.white)
                            .clipShape(Capsule())
                            .shadow(color: Color.white.opacity(0.15), radius: 6, y: 2)
                        }
                        
                        // Google Sign In Button
                        Button(action: {}) {
                            HStack(spacing: 10) {
                                Image(systemName: "g.circle.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(primaryBlue)
                                Text("Continue with Google")
                                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(containerLow)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // MARK: - Divider
                    HStack(spacing: 12) {
                        Rectangle()
                            .fill(Color.white.opacity(0.1))
                            .frame(height: 1)
                        
                        Text("or continue with email")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(white: 0.55))
                        
                        Rectangle()
                            .fill(Color.white.opacity(0.1))
                            .frame(height: 1)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                    
                    // MARK: - Input Form
                    VStack(spacing: 16) {
                        // Email Field
                        VStack(alignment: .leading, spacing: 6) {
                            Text("EMAIL ADDRESS")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                                .foregroundColor(Color(white: 0.55))
                                .tracking(0.5)
                                .padding(.horizontal, 4)
                            
                            HStack(spacing: 12) {
                                Image(systemName: "envelope.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(white: 0.5))
                                
                                TextField("name@icloud.com", text: $email)
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                                    #if os(iOS)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                                    .keyboardType(.emailAddress)
                                    #endif
                            }
                            .padding(.horizontal, 16)
                            .frame(height: 52)
                            .background(containerLow)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                        }
                        
                        // Password Field
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("PASSWORD")
                                    .font(.system(size: 11, weight: .bold, design: .rounded))
                                    .foregroundColor(Color(white: 0.55))
                                    .tracking(0.5)
                                
                                Spacer()
                                
                                Button(action: {}) {
                                    Text("Forgot?")
                                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                                        .foregroundColor(primaryBlue)
                                }
                            }
                            .padding(.horizontal, 4)
                            
                            HStack(spacing: 12) {
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(white: 0.5))
                                
                                if isPasswordVisible {
                                    TextField("Enter password", text: $password)
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                        #if os(iOS)
                                        .textInputAutocapitalization(.never)
                                        .autocorrectionDisabled()
                                        #endif
                                } else {
                                    SecureField("Enter password", text: $password)
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                        #if os(iOS)
                                        .textInputAutocapitalization(.never)
                                        .autocorrectionDisabled()
                                        #endif
                                }
                                
                                Button(action: {
                                    isPasswordVisible.toggle()
                                }) {
                                    Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                                        .font(.system(size: 15))
                                        .foregroundColor(isPasswordVisible ? primaryCyan : Color(white: 0.5))
                                }
                            }
                            .padding(.horizontal, 16)
                            .frame(height: 52)
                            .background(containerLow)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                        }
                        
                        // Quick Face ID Biometric Card
                        HStack(spacing: 14) {
                            ZStack {
                                Circle()
                                    .fill(containerHigh)
                                    .frame(width: 42, height: 42)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                    )
                                
                                Image(systemName: "faceid")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(primaryBlue)
                            }
                            
                            VStack(alignment: .leading, spacing: 3) {
                                HStack(spacing: 6) {
                                    Text("Quick Face ID")
                                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                                        .foregroundColor(.white)
                                    
                                    Text("Haptic")
                                        .font(.system(size: 10, weight: .bold, design: .rounded))
                                        .foregroundColor(primaryCyan)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(primaryCyan.opacity(0.15))
                                        .clipShape(Capsule())
                                        .overlay(
                                            Capsule()
                                                .stroke(primaryCyan.opacity(0.3), lineWidth: 0.5)
                                        )
                                }
                                
                                Text("Fast, secure instant bypass")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(white: 0.55))
                            }
                            
                            Spacer()
                            
                            Toggle("", isOn: $isFaceIdEnabled)
                                .labelsHidden()
                                .tint(primaryCyan)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(containerLow.opacity(0.9))
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                        .padding(.top, 4)
                        
                        // Primary Action Button
                        Button(action: {
                            navigateToHome = true
                        }) {
                            HStack(spacing: 8) {
                                Text("Sign In to TripPilot")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 15, weight: .bold))
                            }
                            .foregroundColor(Color(red: 10/255, green: 14/255, blue: 22/255))
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(
                                LinearGradient(
                                    colors: [skyGradientStart, skyGradientEnd],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(Capsule())
                            .shadow(color: skyGradientStart.opacity(0.35), radius: 12, y: 4)
                        }
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 20)
                    
                    // MARK: - Security & Privacy Badge
                    HStack(spacing: 6) {
                        Image(systemName: "shield.fill")
                            .font(.system(size: 12))
                            .foregroundColor(primaryCyan)
                        
                        Text("Secure Enclave 256-bit Encrypted • Privacy First Travel")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(Color(white: 0.55))
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(containerLow)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.06), lineWidth: 1)
                    )
                    .padding(.top, 24)
                    
                    // MARK: - Bottom Account Switch (Linked to CreateAccountView)
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .font(.system(size: 14))
                            .foregroundColor(Color(white: 0.55))
                        
                        Button(action: {
                            navigateToCreateAccount = true
                        }) {
                            Text("Create Account")
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(primaryBlue)
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 36)
                }
            }
        }
        .navigationDestination(isPresented: $navigateToCreateAccount) {
            CreateAccountView()
        }
        .navigationDestination(isPresented: $navigateToHome) {
            HomeDashboardView()
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    NavigationStack {
        SignInView()
    }
}
