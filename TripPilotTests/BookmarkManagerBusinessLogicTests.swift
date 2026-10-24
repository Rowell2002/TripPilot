import Testing
import Foundation
@testable import TripPilot

@Suite("Bookmark & Saved Places Business Logic Suite")
struct BookmarkManagerBusinessLogicTests {
    
    @Test("Persistent Bookmark Toggling by Place and Name")
    @MainActor
    func testBookmarkToggling() {
        let manager = BookmarkManager.shared
        let testPlaceName = "Mirissa Secret Coconut Beach"
        
        let initialIsBookmarked = manager.isBookmarked(name: testPlaceName)
        let initialCount = manager.count
        
        // Toggle on
        manager.toggleBookmark(name: testPlaceName)
        #expect(manager.isBookmarked(name: testPlaceName) != initialIsBookmarked)
        #expect(manager.count == (initialIsBookmarked ? initialCount - 1 : initialCount + 1))
        
        // Toggle back off
        manager.toggleBookmark(name: testPlaceName)
        #expect(manager.isBookmarked(name: testPlaceName) == initialIsBookmarked)
        #expect(manager.count == initialCount)
    }
    
    @Test("Place Object Identification Matches ID and Name")
    @MainActor
    func testPlaceObjectMatching() {
        let manager = BookmarkManager.shared
        guard let place = SriLankaDataService.shared.places.first else { return }
        
        let wasBookmarked = manager.isBookmarked(place: place)
        
        // Toggle
        manager.toggleBookmark(place: place)
        #expect(manager.isBookmarked(place: place) != wasBookmarked)
        #expect(manager.isBookmarked(id: place.id) != wasBookmarked)
        #expect(manager.isBookmarked(name: place.name) != wasBookmarked)
        
        // Restore
        manager.toggleBookmark(place: place)
        #expect(manager.isBookmarked(place: place) == wasBookmarked)
    }
}
