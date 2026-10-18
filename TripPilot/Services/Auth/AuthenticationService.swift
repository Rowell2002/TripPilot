//
//  AuthenticationService.swift
//  TripPilot
//

import Foundation
import UIKit
import CryptoKit
import AuthenticationServices
import FirebaseAuth
import GoogleSignIn

public final class AuthenticationService: NSObject {
    public static let shared = AuthenticationService()
    
    // Stored raw nonce for Sign in with Apple verification
    private var currentNonce: String?
    private var appleSignInContinuation: CheckedContinuation<AuthDataResult, Error>?
    
    private override init() {
        super.init()
    }
    
    // MARK: - Sign In with Apple
    
    @MainActor
    public func signInWithApple() async throws -> AuthDataResult {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            throw NSError(domain: "AuthenticationService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to find key window root view controller"])
        }
        
        let nonce = randomNonceString()
        currentNonce = nonce
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        
        return try await withCheckedThrowingContinuation { continuation in
            self.appleSignInContinuation = continuation
            authorizationController.performRequests()
        }
    }
    
    // MARK: - Sign In with Google
    
    @MainActor
    public func signInWithGoogle() async throws -> AuthDataResult {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            throw NSError(domain: "AuthenticationService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to find key window root view controller"])
        }
        
        let signInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        
        guard let idToken = signInResult.user.idToken?.tokenString else {
            throw NSError(domain: "AuthenticationService", code: -2, userInfo: [NSLocalizedDescriptionKey: "Google Sign-In failed to retrieve ID token."])
        }
        
        let accessToken = signInResult.user.accessToken.tokenString
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        return try await Auth.auth().signIn(with: credential)
    }
    
    // MARK: - Sign Out
    
    public func signOut() throws {
        GIDSignIn.sharedInstance.signOut()
        try Auth.auth().signOut()
    }
    
    // MARK: - Nonce Utilities for Apple Sign In
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }
        
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }
        return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        return hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
    }
}

// MARK: - ASAuthorizationControllerDelegate

extension AuthenticationService: ASAuthorizationControllerDelegate {
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                appleSignInContinuation?.resume(throwing: NSError(domain: "AuthenticationService", code: -3, userInfo: [NSLocalizedDescriptionKey: "Invalid state: missing raw nonce for Apple Sign In."]))
                appleSignInContinuation = nil
                return
            }
            
            guard let appleIDToken = appleIDCredential.identityToken,
                  let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                appleSignInContinuation?.resume(throwing: NSError(domain: "AuthenticationService", code: -4, userInfo: [NSLocalizedDescriptionKey: "Unable to retrieve Apple identity token string."]))
                appleSignInContinuation = nil
                return
            }
            
            let credential = OAuthProvider.appleCredential(
                withIDToken: idTokenString,
                rawNonce: nonce,
                fullName: appleIDCredential.fullName
            )
            
            Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                if let error = error {
                    self?.appleSignInContinuation?.resume(throwing: error)
                } else if let authResult = authResult {
                    self?.appleSignInContinuation?.resume(returning: authResult)
                } else {
                    self?.appleSignInContinuation?.resume(throwing: NSError(domain: "AuthenticationService", code: -5, userInfo: [NSLocalizedDescriptionKey: "Firebase Apple authentication returned empty result."]))
                }
                self?.appleSignInContinuation = nil
                self?.currentNonce = nil
            }
        }
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        appleSignInContinuation?.resume(throwing: error)
        appleSignInContinuation = nil
        currentNonce = nil
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

extension AuthenticationService: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return UIWindow()
        }
        return window
    }
}
