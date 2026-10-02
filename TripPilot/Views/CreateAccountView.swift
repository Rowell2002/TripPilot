//
//  CreateAccountView.swift
//  TripPilot
//
//  Generated from Stitch Screen: 83f964fc1e964b0790260621f3c04005
//  Title: TripPilot - Create Account (Dark Mode)
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct CreateAccountView: View {
    @State private var fullName: String = "Elena Vance"
    @State private var email: String = "elena.vance@icloud.com"
    @State private var password: String = "Explorer2025#"
    @State private var isPasswordVisible: Bool = false
    @State private var isBiometricEnabled: Bool = true
    @State private var agreeToTerms: Bool = true
    
    // Stitch Theme Colors
    private let darkBackground = Color(red: 15/255, green: 19/255, blue: 28/255)       // #0f131c
    private let containerLow = Color(red: 24/255, green: 28/255, blue: 36/255)         // #181c24
    private let containerMid = Color(red: 28/255, green: 32/255, blue: 40/255)         // #1c2028
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
            
            // Ambient Atmospheric Glows
            GeometryReader { _ in
                Circle()
                    .fill(primaryBlue.opacity(0.08))
                    .frame(width: 340, height: 340)
                    .blur(radius: 85)
                    .offset(x: -90, y: -120)
                
                Circle()
                    .fill(primaryCyan.opacity(0.06))
                    .frame(width: 320, height: 320)
                    .blur(radius: 75)
                    .offset(x: 190, y: 320)
            }
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // MARK: - Top Navigation Header
                    HStack {
                        Button(action: {}) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                                .background(containerMid)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                )
                        }
                        
                        Spacer()
                        
                        // Glowing Insignia Badge
                        ZStack {
                            Circle()
                                .fill(primaryBlue.opacity(0.12))
                                .frame(width: 44, height: 44)
                                .blur(radius: 4)
                            
                            Circle()
                                .fill(containerMid)
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                                )
                            
                            Image(systemName: "safari.fill")
                                .font(.system(size: 20))
                                .foregroundColor(primaryBlue)
                        }
                        
                        Spacer()
                        
                        Button(action: {}) {
                            Text("Help")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .foregroundColor(primaryBlue)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 7)
                                .background(containerMid)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 16)
                    
                    // MARK: - Title & Header Hook
                    VStack(alignment: .leading, spacing: 8) {
                        // Tag Pill
                        HStack(spacing: 6) {
                            Circle()
                                .fill(primaryBlue)
                                .frame(width: 6, height: 6)
                            
                            Text("FLIGHT & ITINERARY CLOUD")
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .foregroundColor(primaryBlue)
                                .tracking(0.8)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(primaryBlue.opacity(0.12))
                        .clipShape(Capsule())
                        
                        Text("Create Account")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Join TripPilot to unlock AI-powered itineraries, real-time geofence audio tours, and seamless cross-device sync.")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(Color(white: 0.65))
                            .lineSpacing(3)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    
                    // MARK: - Social SSO Stack
                    VStack(spacing: 12) {
                        // Apple Sign Up Button
                        Button(action: {}) {
                            HStack(spacing: 10) {
                                Image(systemName: "apple.logo")
                                    .font(.system(size: 18))
                                Text("Sign up with Apple")
                                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                            }
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.white)
                            .clipShape(Capsule())
                            .shadow(color: Color.white.opacity(0.12), radius: 6, y: 2)
                        }
                        
                        // Google Sign Up Button
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
                            .frame(height: 50)
                            .background(containerMid)
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
                        
                        Text("or sign up with email")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(Color(white: 0.5))
                            .textCase(.uppercase)
                            .tracking(0.6)
                        
                        Rectangle()
                            .fill(Color.white.opacity(0.1))
                            .frame(height: 1)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 18)
                    
                    // MARK: - Form Fields
                    VStack(spacing: 14) {
                        // Full Name Field
                        VStack(alignment: .leading, spacing: 6) {
                            Text("FULL NAME")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                                .foregroundColor(Color(white: 0.55))
                                .tracking(0.5)
                                .padding(.leading, 4)
                            
                            HStack(spacing: 12) {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(white: 0.5))
                                
                                TextField("", text: $fullName)
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 16)
                            .frame(height: 50)
                            .background(containerMid)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                        }
                        
                        // Email Field
                        VStack(alignment: .leading, spacing: 6) {
                            Text("EMAIL ADDRESS")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                                .foregroundColor(Color(white: 0.55))
                                .tracking(0.5)
                                .padding(.leading, 4)
                            
                            HStack(spacing: 12) {
                                Image(systemName: "envelope.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(white: 0.5))
                                
                                TextField("", text: $email)
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                                    #if os(iOS)
                                    .textInputAutocapitalization(.never)
                                    .keyboardType(.emailAddress)
                                    #endif
                                
                                ZStack {
                                    Circle()
                                        .fill(primaryCyan.opacity(0.18))
                                        .frame(width: 24, height: 24)
                                    
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(primaryCyan)
                                }
                            }
                            .padding(.horizontal, 16)
                            .frame(height: 50)
                            .background(containerMid)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                        }
                        
                        // Password Field & Quality Stack
                        VStack(alignment: .leading, spacing: 6) {
                            Text("CREATE PASSWORD")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                                .foregroundColor(Color(white: 0.55))
                                .tracking(0.5)
                                .padding(.leading, 4)
                            
                            HStack(spacing: 12) {
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(white: 0.5))
                                
                                if isPasswordVisible {
                                    TextField("", text: $password)
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                } else {
                                    SecureField("", text: $password)
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                }
                                
                                Button(action: {
                                    isPasswordVisible.toggle()
                                }) {
                                    Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                                        .font(.system(size: 15))
                                        .foregroundColor(Color(white: 0.5))
                                }
                            }
                            .padding(.horizontal, 16)
                            .frame(height: 50)
                            .background(containerMid)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                            
                            // Strength Indicator Meter
                            VStack(spacing: 6) {
                                HStack {
                                    Text("Security Strength")
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundColor(Color(white: 0.6))
                                    
                                    Spacer()
                                    
                                    HStack(spacing: 4) {
                                        Circle()
                                            .fill(primaryCyan)
                                            .frame(width: 5, height: 5)
                                        Text("Strong")
                                            .font(.system(size: 11, weight: .bold, design: .rounded))
                                            .foregroundColor(primaryCyan)
                                    }
                                }
                                
                                // 4-bar meter
                                HStack(spacing: 5) {
                                    ForEach(0..<4) { index in
                                        Capsule()
                                            .fill(index < 3 ? primaryCyan : primaryCyan.opacity(0.75))
                                            .frame(height: 4)
                                    }
                                }
                                
                                // Rule Badges
                                HStack(spacing: 6) {
                                    strengthBadge(text: "8+ chars")
                                    strengthBadge(text: "1 number")
                                    strengthBadge(text: "1 symbol")
                                }
                                .padding(.top, 2)
                            }
                            .padding(.horizontal, 4)
                            .padding(.top, 4)
                        }
                        
                        // iCloud Keychain & Face ID Card
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(primaryBlue.opacity(0.15))
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: "touchid")
                                    .font(.system(size: 20))
                                    .foregroundColor(primaryBlue)
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("iCloud Keychain & Face ID")
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white)
                                
                                Text("Instant biometric sign-in")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(white: 0.55))
                            }
                            
                            Spacer()
                            
                            Toggle("", isOn: $isBiometricEnabled)
                                .labelsHidden()
                                .tint(skyGradientStart)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(containerMid)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                        .padding(.top, 2)
                        
                        // Terms & Policies Consent
                        HStack(alignment: .top, spacing: 10) {
                            Button(action: {
                                agreeToTerms.toggle()
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                                        .fill(agreeToTerms ? skyGradientStart : containerHigh)
                                        .frame(width: 20, height: 20)
                                    
                                    if agreeToTerms {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 11, weight: .bold))
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("I agree to the **Terms of Service** and **Privacy Policy**.")
                                    .foregroundColor(Color(white: 0.65))
                                
                                HStack(spacing: 5) {
                                    Image(systemName: "lock.shield.fill")
                                        .font(.system(size: 11))
                                        .foregroundColor(primaryCyan)
                                    
                                    Text("256-bit Secure Enclave • Zero data selling")
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundColor(Color(white: 0.5))
                                }
                                .padding(.top, 2)
                            }
                            .font(.system(size: 12))
                        }
                        .padding(.horizontal, 4)
                        .padding(.top, 2)
                        
                        // Primary CTA Button
                        Button(action: {}) {
                            HStack(spacing: 8) {
                                Text("Create Free Account")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 15, weight: .bold))
                            }
                            .foregroundColor(Color(red: 10/255, green: 14/255, blue: 22/255))
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(
                                LinearGradient(
                                    colors: [skyGradientStart, skyGradientEnd],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(Capsule())
                            .shadow(color: skyGradientStart.opacity(0.3), radius: 12, y: 4)
                        }
                        .padding(.top, 6)
                    }
                    .padding(.horizontal, 20)
                    
                    // MARK: - Bottom Existing User Link
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .font(.system(size: 14))
                            .foregroundColor(Color(white: 0.55))
                        
                        Button(action: {}) {
                            Text("Sign In")
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(primaryBlue)
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 36)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private func strengthBadge(text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: "checkmark")
                .font(.system(size: 9, weight: .bold))
            Text(text)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
        }
        .foregroundColor(primaryCyan)
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
        .background(containerHigh)
        .clipShape(Capsule())
    }
}

#Preview {
    CreateAccountView()
}
