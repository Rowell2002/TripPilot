//
//  AuthViewModel.swift
//  TripPilot
//

import Foundation
import SwiftUI
import Combine
import FirebaseAuth
import FirebaseCore

@MainActor
public final class AuthViewModel: ObservableObject {
    public static let shared = AuthViewModel()
    
    @Published public var isAuthenticated: Bool = false
    @Published public var currentUser: User? = nil
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String? = nil
    @Published public var showErrorAlert: Bool = false
    @Published public var successMessage: String? = nil
    @Published public var showSuccessAlert: Bool = false
    
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    
    public init() {
        // If Firebase is configured, register auth state listener
        if FirebaseApp.app() != nil {
            self.currentUser = Auth.auth().currentUser
            self.isAuthenticated = Auth.auth().currentUser != nil
            
            self.authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
                Task { @MainActor in
                    self?.currentUser = user
                    self?.isAuthenticated = (user != nil)
                }
            }
        }
    }
    
    deinit {
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    // MARK: - Sign In with Apple
    
    public func signInWithApple() async {
        guard FirebaseApp.app() != nil else {
            setErrorMessage("Firebase is not initialized. Please add GoogleService-Info.plist into the project.")
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await AuthenticationService.shared.signInWithApple()
            self.currentUser = result.user
            self.isAuthenticated = true
            self.isLoading = false
        } catch {
            self.isLoading = false
            let nsError = error as NSError
            // Do not show error alert if user canceled
            if nsError.domain == "com.apple.AuthenticationServices.AuthorizationError" && nsError.code == 1001 {
                return
            }
            setErrorMessage(error.localizedDescription)
        }
    }
    
    // MARK: - Sign In with Google
    
    public func signInWithGoogle() async {
        guard FirebaseApp.app() != nil else {
            setErrorMessage("Firebase is not initialized. Please add GoogleService-Info.plist into the project.")
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await AuthenticationService.shared.signInWithGoogle()
            self.currentUser = result.user
            self.isAuthenticated = true
            self.isLoading = false
        } catch {
            self.isLoading = false
            let nsError = error as NSError
            // Do not show error alert if user canceled Google Sign-In
            if nsError.domain == "com.google.GIDSignIn" && (nsError.code == -5 || nsError.code == 1) {
                return
            }
            setErrorMessage(error.localizedDescription)
        }
    }
    
    // MARK: - Email & Password Sign In
    
    public func signInWithEmail(email: String, password: String) async -> Bool {
        guard FirebaseApp.app() != nil else {
            setErrorMessage("Firebase is not initialized. Please ensure GoogleService-Info.plist is added.")
            return false
        }
        
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard Self.isValidEmail(trimmedEmail) else {
            setErrorMessage("Please enter a valid email address.")
            return false
        }
        
        guard !password.isEmpty else {
            setErrorMessage("Please enter your password.")
            return false
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await AuthenticationService.shared.signInWithEmail(email: trimmedEmail, password: password)
            self.currentUser = result.user
            self.isAuthenticated = true
            self.isLoading = false
            return true
        } catch {
            self.isLoading = false
            setErrorMessage(error.localizedDescription)
            return false
        }
    }
    
    // MARK: - Email & Password Sign Up
    
    public func signUpWithEmail(email: String, password: String, fullName: String) async -> Bool {
        guard FirebaseApp.app() != nil else {
            setErrorMessage("Firebase is not initialized. Please ensure GoogleService-Info.plist is added.")
            return false
        }
        
        let trimmedName = fullName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard Self.isValidName(trimmedName) else {
            setErrorMessage("Please enter your full name (at least 2 characters).")
            return false
        }
        
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard Self.isValidEmail(trimmedEmail) else {
            setErrorMessage("Please enter a valid email address.")
            return false
        }
        
        guard Self.isValidPassword(password) else {
            setErrorMessage("Password must be at least 8 characters.")
            return false
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await AuthenticationService.shared.createUserWithEmail(email: trimmedEmail, password: password, fullName: trimmedName)
            self.currentUser = result.user
            self.isAuthenticated = true
            self.isLoading = false
            return true
        } catch {
            self.isLoading = false
            setErrorMessage(error.localizedDescription)
            return false
        }
    }
    
    // MARK: - Password Reset
    
    public func sendPasswordReset(email: String) async -> Bool {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard Self.isValidEmail(trimmedEmail) else {
            setErrorMessage("Please enter a valid email address to receive password reset instructions.")
            return false
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await AuthenticationService.shared.sendPasswordReset(email: trimmedEmail)
            self.isLoading = false
            self.successMessage = "Password reset instructions sent to \(trimmedEmail). Check your inbox."
            self.showSuccessAlert = true
            return true
        } catch {
            self.isLoading = false
            setErrorMessage(error.localizedDescription)
            return false
        }
    }
    
    // MARK: - Validations
    
    public static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: email.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    public static func isValidPassword(_ password: String) -> Bool {
        return password.count >= 8
    }
    
    public static func isValidName(_ name: String) -> Bool {
        return name.trimmingCharacters(in: .whitespacesAndNewlines).count >= 2
    }
    
    // MARK: - Sign Out
    
    public func signOut() {
        do {
            try AuthenticationService.shared.signOut()
            self.currentUser = nil
            self.isAuthenticated = false
        } catch {
            setErrorMessage(error.localizedDescription)
        }
    }
    
    private func setErrorMessage(_ message: String) {
        self.errorMessage = message
        self.showErrorAlert = true
    }
}
