import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct CreateAccountView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var authViewModel = AuthViewModel.shared
    
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var agreeToTerms: Bool = true
    @State private var navigateToHome: Bool = false
    
    // Validation States
    @State private var fullNameError: String? = nil
    @State private var emailError: String? = nil
    @State private var passwordError: String? = nil
    @State private var termsError: String? = nil
    
    // Theme Colors
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
                        // Back Button
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 38, height: 38)
                                .background(containerMid)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                                )
                        }
                        
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
                            
                            Text("SMART TRAVEL ITINERARY")
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
                        Button(action: {
                            Task {
                                await authViewModel.signInWithApple()
                                if authViewModel.isAuthenticated {
                                    navigateToHome = true
                                }
                            }
                        }) {
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
                        .disabled(authViewModel.isLoading)
                        
                        // Google Sign Up Button
                        Button(action: {
                            Task {
                                await authViewModel.signInWithGoogle()
                                if authViewModel.isAuthenticated {
                                    navigateToHome = true
                                }
                            }
                        }) {
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
                        .disabled(authViewModel.isLoading)
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
                                .foregroundColor(fullNameError != nil ? Color.red.opacity(0.9) : Color(white: 0.55))
                                .tracking(0.5)
                                .padding(.leading, 4)
                            
                            HStack(spacing: 12) {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(fullNameError != nil ? Color.red.opacity(0.8) : Color(white: 0.5))
                                
                                TextField("First and last name", text: $fullName)
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                                    .onChange(of: fullName) { _ in
                                        if fullNameError != nil { validateFullName() }
                                    }
                                
                                if AuthViewModel.isValidName(fullName) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 14))
                                        .foregroundColor(primaryCyan)
                                }
                            }
                            .padding(.horizontal, 16)
                            .frame(height: 50)
                            .background(containerMid)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(fullNameError != nil ? Color.red.opacity(0.7) : Color.white.opacity(0.1), lineWidth: fullNameError != nil ? 1.5 : 1)
                            )
                            
                            if let error = fullNameError {
                                HStack(spacing: 4) {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .font(.system(size: 11))
                                    Text(error)
                                        .font(.system(size: 11, weight: .medium, design: .rounded))
                                }
                                .foregroundColor(Color.red.opacity(0.9))
                                .padding(.leading, 4)
                            }
                        }
                        
                        // Email Field
                        VStack(alignment: .leading, spacing: 6) {
                            Text("EMAIL ADDRESS")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                                .foregroundColor(emailError != nil ? Color.red.opacity(0.9) : Color(white: 0.55))
                                .tracking(0.5)
                                .padding(.leading, 4)
                            
                            HStack(spacing: 12) {
                                Image(systemName: "envelope.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(emailError != nil ? Color.red.opacity(0.8) : Color(white: 0.5))
                                
                                TextField("name@example.com", text: $email)
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                                    #if os(iOS)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                                    .keyboardType(.emailAddress)
                                    #endif
                                    .onChange(of: email) { _ in
                                        if emailError != nil { validateEmail() }
                                    }
                                
                                if AuthViewModel.isValidEmail(email) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 14))
                                        .foregroundColor(primaryCyan)
                                }
                            }
                            .padding(.horizontal, 16)
                            .frame(height: 50)
                            .background(containerMid)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(emailError != nil ? Color.red.opacity(0.7) : Color.white.opacity(0.1), lineWidth: emailError != nil ? 1.5 : 1)
                            )
                            
                            if let error = emailError {
                                HStack(spacing: 4) {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .font(.system(size: 11))
                                    Text(error)
                                        .font(.system(size: 11, weight: .medium, design: .rounded))
                                }
                                .foregroundColor(Color.red.opacity(0.9))
                                .padding(.leading, 4)
                            }
                        }
                        
                        // Password Field & Quality Stack
                        VStack(alignment: .leading, spacing: 6) {
                            Text("CREATE PASSWORD")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                                .foregroundColor(passwordError != nil ? Color.red.opacity(0.9) : Color(white: 0.55))
                                .tracking(0.5)
                                .padding(.leading, 4)
                            
                            HStack(spacing: 12) {
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(passwordError != nil ? Color.red.opacity(0.8) : Color(white: 0.5))
                                
                                if isPasswordVisible {
                                    TextField("Minimum 8 characters", text: $password)
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                        #if os(iOS)
                                        .textInputAutocapitalization(.never)
                                        .autocorrectionDisabled()
                                        #endif
                                        .onChange(of: password) { _ in
                                            if passwordError != nil { validatePassword() }
                                        }
                                } else {
                                    SecureField("Minimum 8 characters", text: $password)
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                        #if os(iOS)
                                        .textInputAutocapitalization(.never)
                                        .autocorrectionDisabled()
                                        #endif
                                        .onChange(of: password) { _ in
                                            if passwordError != nil { validatePassword() }
                                        }
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
                            .frame(height: 50)
                            .background(containerMid)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(passwordError != nil ? Color.red.opacity(0.7) : Color.white.opacity(0.1), lineWidth: passwordError != nil ? 1.5 : 1)
                            )
                            
                            if let error = passwordError {
                                HStack(spacing: 4) {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .font(.system(size: 11))
                                    Text(error)
                                        .font(.system(size: 11, weight: .medium, design: .rounded))
                                }
                                .foregroundColor(Color.red.opacity(0.9))
                                .padding(.leading, 4)
                            }
                            
                            // Strength Indicator Meter
                            VStack(spacing: 6) {
                                HStack {
                                    Text("Security Strength")
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundColor(Color(white: 0.6))
                                    
                                    Spacer()
                                    
                                    HStack(spacing: 4) {
                                        Circle()
                                            .fill(password.count >= 8 ? primaryCyan : Color.gray)
                                            .frame(width: 5, height: 5)
                                        Text(password.count >= 8 ? "Strong" : (password.isEmpty ? "Enter Password" : "Fair"))
                                            .font(.system(size: 11, weight: .bold, design: .rounded))
                                            .foregroundColor(password.count >= 8 ? primaryCyan : Color(white: 0.6))
                                    }
                                }
                                
                                // 4-bar meter
                                HStack(spacing: 5) {
                                    ForEach(0..<4) { index in
                                        Capsule()
                                            .fill(password.count >= (index + 1) * 2 ? primaryCyan : containerHigh)
                                            .frame(height: 4)
                                    }
                                }
                                
                                // Rule Badges
                                HStack(spacing: 6) {
                                    strengthBadge(text: "8+ chars", isMet: password.count >= 8)
                                    strengthBadge(text: "1 number", isMet: password.contains(where: { $0.isNumber }))
                                    strengthBadge(text: "1 symbol", isMet: password.contains(where: { !$0.isLetter && !$0.isNumber }))
                                }
                                .padding(.top, 2)
                            }
                            .padding(.horizontal, 4)
                            .padding(.top, 4)
                        }
                        
                        // Terms & Policies Consent
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(alignment: .top, spacing: 10) {
                                Button(action: {
                                    agreeToTerms.toggle()
                                    if agreeToTerms { termsError = nil }
                                }) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                                            .fill(agreeToTerms ? skyGradientStart : containerHigh)
                                            .frame(width: 20, height: 20)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                                    .stroke(termsError != nil ? Color.red.opacity(0.8) : Color.white.opacity(0.1), lineWidth: 1)
                                            )
                                        
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
                            
                            if let error = termsError {
                                HStack(spacing: 4) {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .font(.system(size: 11))
                                    Text(error)
                                        .font(.system(size: 11, weight: .medium, design: .rounded))
                                }
                                .foregroundColor(Color.red.opacity(0.9))
                                .padding(.leading, 4)
                            }
                        }
                        .padding(.horizontal, 4)
                        .padding(.top, 2)
                        
                        // Primary CTA Button
                        Button(action: {
                            handleSignUp()
                        }) {
                            HStack(spacing: 8) {
                                if authViewModel.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                } else {
                                    Text("Create Free Account")
                                        .font(.system(size: 16, weight: .bold, design: .rounded))
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 15, weight: .bold))
                                }
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
                        .disabled(authViewModel.isLoading)
                        .padding(.top, 6)
                    }
                    .padding(.horizontal, 20)
                    
                    // MARK: - Bottom Existing User Link (Navigates back to SignIn)
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .font(.system(size: 14))
                            .foregroundColor(Color(white: 0.55))
                        
                        Button(action: {
                            dismiss()
                        }) {
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
        .navigationDestination(isPresented: $navigateToHome) {
            HomeDashboardView()
        }
        .overlay {
            if authViewModel.isLoading {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    VStack(spacing: 12) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: primaryCyan))
                            .scaleEffect(1.2)
                        Text("Creating account...")
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .padding(24)
                    .background(containerLow)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
            }
        }
        .alert("Authentication Error", isPresented: $authViewModel.showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(authViewModel.errorMessage ?? "An unknown authentication error occurred.")
        }
        .navigationBarBackButtonHidden(true)
        .preferredColorScheme(.dark)
    }
    
    private func strengthBadge(text: String, isMet: Bool) -> some View {
        HStack(spacing: 4) {
            Image(systemName: isMet ? "checkmark" : "circle")
                .font(.system(size: 9, weight: .bold))
            Text(text)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
        }
        .foregroundColor(isMet ? primaryCyan : Color(white: 0.5))
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
        .background(containerHigh)
        .clipShape(Capsule())
    }
    
    // MARK: - Validation Helpers
    
    @discardableResult
    private func validateFullName() -> Bool {
        let trimmed = fullName.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            fullNameError = "Please enter your full name."
            return false
        } else if trimmed.count < 2 {
            fullNameError = "Full name must be at least 2 characters."
            return false
        }
        fullNameError = nil
        return true
    }
    
    @discardableResult
    private func validateEmail() -> Bool {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            emailError = "Email address cannot be empty."
            return false
        } else if !AuthViewModel.isValidEmail(trimmed) {
            emailError = "Please enter a valid email (e.g. name@example.com)."
            return false
        }
        emailError = nil
        return true
    }
    
    @discardableResult
    private func validatePassword() -> Bool {
        if password.isEmpty {
            passwordError = "Password cannot be empty."
            return false
        } else if password.count < 8 {
            passwordError = "Password must be at least 8 characters."
            return false
        }
        passwordError = nil
        return true
    }
    
    @discardableResult
    private func validateTerms() -> Bool {
        if !agreeToTerms {
            termsError = "You must agree to the Terms of Service to continue."
            return false
        }
        termsError = nil
        return true
    }
    
    private func handleSignUp() {
        let isNameValid = validateFullName()
        let isEmailValid = validateEmail()
        let isPassValid = validatePassword()
        let isTermsValid = validateTerms()
        
        guard isNameValid && isEmailValid && isPassValid && isTermsValid else { return }
        
        Task {
            let success = await authViewModel.signUpWithEmail(email: email, password: password, fullName: fullName)
            if success {
                navigateToHome = true
            }
        }
    }
}

#Preview {
    NavigationStack {
        CreateAccountView()
    }
}
