import Testing
import Foundation
import SwiftUI
@testable import TripPilot

@Suite("Biometric Lock & Face ID App Protection Suite")
struct BiometricLockManagerTests {
    
    @Test("Biometric Lock Manager Setting Persistence and App Lock State")
    func testBiometricLockPersistence() {
        let key = BiometricLockManager.faceIDPrefKey
        let originalValue = UserDefaults.standard.object(forKey: key)
        defer {
            if let originalValue = originalValue {
                UserDefaults.standard.set(originalValue, forKey: key)
            } else {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
        
        let manager = BiometricLockManager.shared
        
        // 1. When Face ID protection is disabled
        manager.setFaceIDProtection(enabled: false) { success in
            #expect(success == true)
        }
        #expect(manager.isFaceIDEnabled == false)
        #expect(UserDefaults.standard.bool(forKey: key) == false)
        #expect(manager.isAppLocked == false)
        
        // Background transition when disabled should NOT lock app
        manager.handleScenePhaseChange(to: .background)
        #expect(manager.isAppLocked == false)
        
        // 2. When Face ID protection is enabled
        manager.setFaceIDProtection(enabled: true) { success in
            #expect(success == true)
        }
        #expect(manager.isFaceIDEnabled == true)
        #expect(UserDefaults.standard.bool(forKey: key) == true)
        
        // Background transition when enabled MUST lock app
        manager.handleScenePhaseChange(to: .background)
        #expect(manager.isAppLocked == true)
        
        // Simulated unlock reset
        manager.isAppLocked = false
        #expect(manager.isAppLocked == false)
        
        // Re-disabling should immediately remove lock
        manager.setFaceIDProtection(enabled: false) { _ in }
        #expect(manager.isFaceIDEnabled == false)
        #expect(manager.isAppLocked == false)
    }
    
    @Test("Scene Phase Background To Foreground Transitions")
    func testScenePhaseTransitions() {
        let manager = BiometricLockManager.shared
        let key = BiometricLockManager.faceIDPrefKey
        let originalValue = UserDefaults.standard.object(forKey: key)
        defer {
            if let originalValue = originalValue {
                UserDefaults.standard.set(originalValue, forKey: key)
            } else {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
        
        // Turn ON Face ID
        UserDefaults.standard.set(true, forKey: key)
        manager.isFaceIDEnabled = true
        manager.isAppLocked = false
        
        // Entering background must lock
        manager.handleScenePhaseChange(to: .background)
        #expect(manager.isAppLocked == true)
        
        // Turning OFF Face ID
        UserDefaults.standard.set(false, forKey: key)
        manager.handleScenePhaseChange(to: .active)
        #expect(manager.isAppLocked == false)
    }
}
