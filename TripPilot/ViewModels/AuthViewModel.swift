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
    @Published public var isGuestSession: Bool = false
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String? = nil
    @Published public var showErrorAlert: Bool = false
    @Published public var successMessage: String? = nil
    @Published public var showSuccessAlert: Bool = false
    
    public static let userDidChangeNotification = Notification.Name("TripPilotUserDidChangeNotification")
    
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    
    // MARK: - Dynamic User Identity Properties
    public var currentUserId: String {
        if let uid = currentUser?.uid, !uid.isEmpty {
            return uid
        }
        if isGuestSession {
            return "guest_user"
        }
        if let saved = UserDefaults.standard.string(forKey: "tripPilot_activeUserId"), !saved.isEmpty {
            return saved
        }
        return "guest_user"
    }
    
    public var userDisplayName: String {
        if let name = currentUser?.displayName, !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return name.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        let uid = currentUserId
        if let customName = UserDefaults.standard.string(forKey: "tripPilot_name_\(uid)"), !customName.isEmpty {
            return customName
        }
        if let email = currentUser?.email, !email.isEmpty {
            let prefix = email.components(separatedBy: "@").first ?? ""
            let parts = prefix.components(separatedBy: CharacterSet(charactersIn: "._-"))
            let formatted = parts.map { $0.capitalized }.joined(separator: " ")
            if !formatted.isEmpty { return formatted }
        }
        if isGuestSession {
            return "Guest Traveler"
        }
        return "Traveler"
    }
    
    public var userFirstName: String {
        let fullName = userDisplayName
        return fullName.components(separatedBy: " ").first ?? fullName
    }
    
    public var userEmail: String {
        if let email = currentUser?.email, !email.isEmpty {
            return email
        }
        if isGuestSession {
            return "guest@trippilot.app"
        }
        return "traveler@trippilot.app"
    }
    
    public var userInitials: String {
        let name = userDisplayName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return "T" }
        let words = name.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
        if words.count >= 2 {
            let first = String(words[0].prefix(1)).uppercased()
            let second = String(words[1].prefix(1)).uppercased()
            return "\(first)\(second)"
        } else if let firstWord = words.first {
            return String(firstWord.prefix(1)).uppercased()
        }
        return "T"
    }
    
    public init() {
        let savedActiveId = UserDefaults.standard.string(forKey: "tripPilot_activeUserId")
        if savedActiveId == "guest_user" {
            self.isGuestSession = true
        } else if let id = savedActiveId, !id.isEmpty {
            self.isAuthenticated = true
        }
        
        // If Firebase is configured, register auth state listener
        if FirebaseApp.app() != nil {
            if let fbUser = Auth.auth().currentUser {
                self.currentUser = fbUser
                self.isAuthenticated = true
                self.isGuestSession = false
                UserDefaults.standard.set(fbUser.uid, forKey: "tripPilot_activeUserId")
            }
            
            self.authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
                Task { @MainActor in
                    if let user = user {
                        self?.currentUser = user
                        self?.isAuthenticated = true
                        self?.isGuestSession = false
                        UserDefaults.standard.set(user.uid, forKey: "tripPilot_activeUserId")
                    } else if self?.isGuestSession != true {
                        if self?.isAuthenticated == true && self?.currentUser != nil {
                            self?.currentUser = nil
                            self?.isAuthenticated = false
                        }
                    }
                    self?.notifyUserChanged()
                }
            }
        }
    }
    
    deinit {
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    public func setGuestSession() {
        self.isGuestSession = true
        self.isAuthenticated = false
        self.currentUser = nil
        UserDefaults.standard.set("guest_user", forKey: "tripPilot_activeUserId")
        notifyUserChanged()
    }
    
    public func continueAsGuest() {
        setGuestSession()
    }
    
    public func notifyUserChanged() {
        NotificationCenter.default.post(name: Self.userDidChangeNotification, object: currentUserId)
        objectWillChange.send()
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
            self.isGuestSession = false
            UserDefaults.standard.set(result.user.uid, forKey: "tripPilot_activeUserId")
            self.isLoading = false
            notifyUserChanged()
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
            self.isGuestSession = false
            UserDefaults.standard.set(result.user.uid, forKey: "tripPilot_activeUserId")
            self.isLoading = false
            notifyUserChanged()
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
            self.isGuestSession = false
            UserDefaults.standard.set(result.user.uid, forKey: "tripPilot_activeUserId")
            self.isLoading = false
            notifyUserChanged()
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
            UserDefaults.standard.set(trimmedName, forKey: "tripPilot_name_\(result.user.uid)")
            UserDefaults.standard.set(result.user.uid, forKey: "tripPilot_activeUserId")
            self.currentUser = result.user
            self.isAuthenticated = true
            self.isGuestSession = false
            self.isLoading = false
            notifyUserChanged()
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
            self.isGuestSession = false
            UserDefaults.standard.removeObject(forKey: "tripPilot_activeUserId")
            notifyUserChanged()
        } catch {
            setErrorMessage(error.localizedDescription)
        }
    }
    
    private func setErrorMessage(_ message: String) {
        self.errorMessage = message
        self.showErrorAlert = true
    }
}
