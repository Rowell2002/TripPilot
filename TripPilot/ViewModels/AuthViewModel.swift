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
