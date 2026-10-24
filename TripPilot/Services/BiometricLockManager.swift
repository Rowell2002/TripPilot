import Foundation
import SwiftUI
import Combine
import LocalAuthentication

@MainActor
public final class BiometricLockManager: ObservableObject {
    public static let shared = BiometricLockManager()
    
    public static let faceIDPrefKey = "isFaceIDQuickUnlockEnabled"
    
    @Published public var isFaceIDEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isFaceIDEnabled, forKey: Self.faceIDPrefKey)
        }
    }
    
    @Published public var isAppLocked: Bool = false
    @Published public var isAuthenticating: Bool = false
    @Published public var authenticationFailed: Bool = false
    @Published public var lastErrorMessage: String? = nil
    
    private var hasPerformedInitialCheck: Bool = false
    
    private init() {
        // Read directly from UserDefaults; if not present, default to false (opt-in protection)
        let savedVal = UserDefaults.standard.object(forKey: Self.faceIDPrefKey) as? Bool ?? false
        self.isFaceIDEnabled = savedVal
        
        // If Face ID is enabled, start in locked state
        if savedVal {
            self.isAppLocked = true
        }
    }
    
    // MARK: - Lifecycle Handlers
    
    /// Called when the app root view appears on cold start
    public func checkAndLockOnLaunch() {
        guard !hasPerformedInitialCheck else { return }
        hasPerformedInitialCheck = true
        
        // Re-read preference to ensure latest state
        let enabled = UserDefaults.standard.bool(forKey: Self.faceIDPrefKey)
        self.isFaceIDEnabled = enabled
        
        if enabled {
            self.isAppLocked = true
            self.authenticationFailed = false
            // Prompt for Face ID immediately on app launch
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.authenticate(reason: "Unlock TripPilot travel vault with Face ID")
            }
        } else {
            self.isAppLocked = false
        }
    }
    
    /// Handles app transitions between active, inactive, and background phases
    public func handleScenePhaseChange(to newPhase: ScenePhase) {
        let enabled = UserDefaults.standard.bool(forKey: Self.faceIDPrefKey)
        self.isFaceIDEnabled = enabled
        
        guard enabled else {
            if isAppLocked {
                withAnimation(.easeOut(duration: 0.25)) {
                    isAppLocked = false
                }
            }
            return
        }
        
        switch newPhase {
        case .background:
            // Lock the app immediately when going into background
            self.isAppLocked = true
            self.authenticationFailed = false
            self.lastErrorMessage = nil
            
        case .active:
            // When returning to foreground, if locked, auto-prompt Face ID
            if isAppLocked && !isAuthenticating {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                    self?.authenticate(reason: "Authenticate with Face ID to resume your session")
                }
            }
            
        case .inactive:
            break
            
        @unknown default:
            break
        }
    }
    
    // MARK: - Authentication
    
    /// Prompts the user with Face ID / Touch ID (or Passcode fallback)
    public func authenticate(reason: String = "Unlock TripPilot with Face ID", allowPasscodeFallback: Bool = true) {
        guard !isAuthenticating else { return }
        
        self.isAuthenticating = true
        self.lastErrorMessage = nil
        
        let context = LAContext()
        context.localizedCancelTitle = "Cancel"
        if allowPasscodeFallback {
            context.localizedFallbackTitle = "Use Passcode"
        }
        
        var authError: NSError?
        let policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics
        
        if context.canEvaluatePolicy(policy, error: &authError) {
            context.evaluatePolicy(policy, localizedReason: reason) { [weak self] success, evalError in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.isAuthenticating = false
                    
                    if success {
                        self.triggerHaptic(success: true)
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            self.isAppLocked = false
                            self.authenticationFailed = false
                            self.lastErrorMessage = nil
                        }
                    } else {
                        self.triggerHaptic(success: false)
                        let nsError = evalError as? NSError
                        if nsError?.code == LAError.userFallback.rawValue && allowPasscodeFallback {
                            // User clicked "Use Passcode"
                            self.authenticateWithDevicePasscode(reason: "Enter device passcode to unlock TripPilot")
                        } else {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                self.isAppLocked = true
                                self.authenticationFailed = true
                                self.lastErrorMessage = nsError?.localizedDescription ?? "Face ID verification failed"
                            }
                        }
                    }
                }
            }
        } else {
            // Biometrics hardware unavailable or not enrolled
            if allowPasscodeFallback && context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
                // Device has passcode set up, evaluate passcode
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { [weak self] success, evalError in
                    DispatchQueue.main.async {
                        guard let self = self else { return }
                        self.isAuthenticating = false
                        if success {
                            self.triggerHaptic(success: true)
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                self.isAppLocked = false
                                self.authenticationFailed = false
                                self.lastErrorMessage = nil
                            }
                        } else {
                            self.triggerHaptic(success: false)
                            withAnimation(.easeInOut(duration: 0.25)) {
                                self.isAppLocked = true
                                self.authenticationFailed = true
                                self.lastErrorMessage = evalError?.localizedDescription ?? "Passcode verification failed"
                            }
                        }
                    }
                }
            } else {
                // Simulator environment without biometric enrollment or preview mode
                #if targetEnvironment(simulator)
                self.isAuthenticating = false
                self.triggerHaptic(success: true)
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    self.isAppLocked = false
                    self.authenticationFailed = false
                    self.lastErrorMessage = nil
                }
                #else
                self.isAuthenticating = false
                self.triggerHaptic(success: false)
                withAnimation(.easeInOut(duration: 0.25)) {
                    self.isAppLocked = true
                    self.authenticationFailed = true
                    self.lastErrorMessage = "Biometrics are not set up on this device."
                }
                #endif
            }
        }
    }
    
    /// Authenticate using device passcode fallback directly
    public func authenticateWithDevicePasscode(reason: String = "Unlock TripPilot with your device passcode") {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            self.isAuthenticating = true
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { [weak self] success, evalError in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.isAuthenticating = false
                    if success {
                        self.triggerHaptic(success: true)
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            self.isAppLocked = false
                            self.authenticationFailed = false
                            self.lastErrorMessage = nil
                        }
                    } else {
                        self.triggerHaptic(success: false)
                        withAnimation(.easeInOut(duration: 0.25)) {
                            self.isAppLocked = true
                            self.authenticationFailed = true
                            self.lastErrorMessage = evalError?.localizedDescription ?? "Passcode authentication failed"
                        }
                    }
                }
            }
        } else {
            // Simulated fallback
            #if targetEnvironment(simulator)
            self.triggerHaptic(success: true)
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                self.isAppLocked = false
                self.authenticationFailed = false
            }
            #endif
        }
    }
    
    // MARK: - Toggle from Settings
    
    /// Toggles Face ID protection with biometric verification before enabling
    public func setFaceIDProtection(enabled: Bool, completion: @escaping (Bool) -> Void) {
        if enabled {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Authenticate with Face ID to enable app lock protection for TripPilot"
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, _ in
                    DispatchQueue.main.async {
                        guard let self = self else { return }
                        if success {
                            self.isFaceIDEnabled = true
                            UserDefaults.standard.set(true, forKey: Self.faceIDPrefKey)
                            self.triggerHaptic(success: true)
                            completion(true)
                        } else {
                            self.isFaceIDEnabled = false
                            UserDefaults.standard.set(false, forKey: Self.faceIDPrefKey)
                            self.triggerHaptic(success: false)
                            completion(false)
                        }
                    }
                }
            } else {
                // If on simulator or biometrics not enrolled, enable directly
                self.isFaceIDEnabled = true
                UserDefaults.standard.set(true, forKey: Self.faceIDPrefKey)
                self.triggerHaptic(success: true)
                completion(true)
            }
        } else {
            self.isFaceIDEnabled = false
            self.isAppLocked = false
            UserDefaults.standard.set(false, forKey: Self.faceIDPrefKey)
            self.triggerHaptic(success: true)
            completion(true)
        }
    }
    
    private func triggerHaptic(success: Bool) {
        #if canImport(UIKit)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(success ? .success : .error)
        #endif
    }
}
