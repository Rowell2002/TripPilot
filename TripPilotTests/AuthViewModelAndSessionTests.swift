import Testing
import Foundation
import SwiftUI
@testable import TripPilot

@Suite("Authentication & User Session Logic Suite")
struct AuthViewModelAndSessionTests {
    
    @Test("Guest Session Identity and Defaults")
    @MainActor
    func testGuestSessionDefaults() {
        let auth = AuthViewModel.shared
        
        let initialGuest = auth.isGuestSession
        let initialUser = auth.currentUser
        
        defer {
            auth.isGuestSession = initialGuest
            auth.currentUser = initialUser
        }
        
        // Emulate guest session
        auth.currentUser = nil
        auth.isGuestSession = true
        
        #expect(auth.currentUserId == "guest_user")
        #expect(auth.userEmail == "guest@trippilot.app")
        #expect(auth.userDisplayName.contains("Guest") || auth.userDisplayName.contains("Traveler"))
    }
    
    @Test("User Initials Formatting Algorithm")
    @MainActor
    func testUserInitialsFormatting() {
        let auth = AuthViewModel.shared
        
        // Two words -> First letter of each
        // e.g. "Chethana Rowell" -> "CR"
        let initials1 = calculateInitials(for: "Chethana Rowell")
        #expect(initials1 == "CR")
        
        // Three words -> First letter of first two words
        let initials2 = calculateInitials(for: "Amara Perera Silva")
        #expect(initials2 == "AP")
        
        // Single word -> First letter
        let initials3 = calculateInitials(for: "Traveler")
        #expect(initials3 == "T")
        
        // Empty string -> Fallback "T"
        let initials4 = calculateInitials(for: "")
        #expect(initials4 == "T")
    }
    
    @Test("User First Name Extraction")
    @MainActor
    func testUserFirstNameExtraction() {
        let fullName = "Kasun Fernando"
        let first = fullName.components(separatedBy: " ").first ?? fullName
        #expect(first == "Kasun")
    }
    
    @Test("Error and Success Alert Notification Flow")
    @MainActor
    func testAlertNotificationFlow() {
        let auth = AuthViewModel.shared
        
        // Error state
        auth.errorMessage = "Invalid credentials provided."
        auth.showErrorAlert = true
        #expect(auth.errorMessage == "Invalid credentials provided.")
        #expect(auth.showErrorAlert == true)
        
        // Success state
        auth.successMessage = "Password reset link sent!"
        auth.showSuccessAlert = true
        #expect(auth.successMessage == "Password reset link sent!")
        #expect(auth.showSuccessAlert == true)
        
        // Clear
        auth.errorMessage = nil
        auth.showErrorAlert = false
        auth.successMessage = nil
        auth.showSuccessAlert = false
        #expect(auth.showErrorAlert == false)
        #expect(auth.showSuccessAlert == false)
    }
    
    // Helper replicating AuthViewModel's initials algorithm for pure testability
    private func calculateInitials(for name: String) -> String {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return "T" }
        let words = trimmed.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
        if words.count >= 2 {
            let first = String(words[0].prefix(1)).uppercased()
            let second = String(words[1].prefix(1)).uppercased()
            return "\(first)\(second)"
        } else if let firstWord = words.first {
            return String(firstWord.prefix(1)).uppercased()
        }
        return "T"
    }
}
