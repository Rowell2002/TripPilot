import SwiftUI
import LocalAuthentication

public struct AppLockView: View {
    @ObservedObject private var lockManager = BiometricLockManager.shared
    @State private var isPulsing: Bool = false
    
    // Theme Colors
    private let primaryCyan = Color(red: 68/255, green: 226/255, blue: 205/255)
    private let secondaryMint = Color(red: 74/255, green: 222/255, blue: 128/255)
    private let deepNavy = Color(red: 10/255, green: 15/255, blue: 28/255)
    private let cardSurface = Color(red: 17/255, green: 24/255, blue: 39/255)
    private let textSlate = Color(red: 148/255, green: 163/255, blue: 184/255)
    
    public init() {}
    
    public var body: some View {
        ZStack {
            // Background gradient
            deepNavy
                .ignoresSafeArea()
            
            // Atmospheric ambient glow
            Circle()
                .fill(primaryCyan.opacity(0.12))
                .frame(width: 320, height: 320)
                .blur(radius: 70)
                .offset(y: -80)
            
            Circle()
                .fill(secondaryMint.opacity(0.08))
                .frame(width: 280, height: 280)
                .blur(radius: 60)
                .offset(y: 120)
            
            VStack(spacing: 28) {
                Spacer()
                
                // Animated Biometric Glyph
                ZStack {
                    // Outer Pulsing Rings
                    Circle()
                        .stroke(primaryCyan.opacity(isPulsing ? 0.0 : 0.35), lineWidth: 1.5)
                        .frame(width: 136, height: 136)
                        .scaleEffect(isPulsing ? 1.35 : 0.95)
                    
                    Circle()
                        .stroke(secondaryMint.opacity(isPulsing ? 0.0 : 0.2), lineWidth: 1)
                        .frame(width: 164, height: 164)
                        .scaleEffect(isPulsing ? 1.45 : 0.9)
                    
                    // Main Badge
                    Circle()
                        .fill(cardSurface)
                        .frame(width: 110, height: 110)
                        .overlay(
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [primaryCyan.opacity(0.8), secondaryMint.opacity(0.4)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                        )
                        .shadow(color: primaryCyan.opacity(0.25), radius: 20, y: 8)
                    
                    Image(systemName: "faceid")
                        .font(.system(size: 46, weight: .light))
                        .foregroundColor(primaryCyan)
                        .shadow(color: primaryCyan.opacity(0.6), radius: 8)
                }
                .onAppear {
                    withAnimation(.easeInOut(duration: 2.2).repeatForever(autoreverses: false)) {
                        isPulsing = true
                    }
                }
                
                // Titles and Security Status
                VStack(spacing: 8) {
                    Text("TripPilot Locked")
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Face ID Quick Unlock is enabled to protect your travel vault and itineraries.")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(textSlate)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 36)
                }
                
                // Failure Notice
                if lockManager.authenticationFailed, let error = lockManager.lastErrorMessage {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Color(red: 248/255, green: 113/255, blue: 113/255))
                        
                        Text(error)
                            .font(.system(size: 12.5, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color(red: 239/255, green: 68/255, blue: 68/255).opacity(0.18))
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color(red: 239/255, green: 68/255, blue: 68/255).opacity(0.4), lineWidth: 1))
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
                }
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 12) {
                    // Primary Unlock Button
                    Button(action: {
                        lockManager.authenticate(reason: "Unlock TripPilot with Face ID")
                    }) {
                        HStack(spacing: 10) {
                            if lockManager.isAuthenticating {
                                ProgressView()
                                    .tint(.black)
                                    .scaleEffect(0.9)
                            } else {
                                Image(systemName: "faceid")
                                    .font(.system(size: 18, weight: .bold))
                            }
                            
                            Text(lockManager.isAuthenticating ? "Verifying..." : "Unlock with Face ID")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(
                            LinearGradient(
                                colors: [primaryCyan, secondaryMint],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                        .shadow(color: primaryCyan.opacity(0.35), radius: 12, y: 4)
                    }
                    .disabled(lockManager.isAuthenticating)
                    
                    // Secondary Passcode Fallback
                    Button(action: {
                        lockManager.authenticateWithDevicePasscode()
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "lock.shield")
                                .font(.system(size: 14, weight: .semibold))
                            Text("Use Device Passcode")
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                        }
                        .foregroundColor(textSlate)
                        .frame(height: 42)
                    }
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 36)
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    AppLockView()
}
