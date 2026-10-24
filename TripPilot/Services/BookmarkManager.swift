import SwiftUI
import Combine

public final class BookmarkManager: ObservableObject {
    public static let shared = BookmarkManager()
    
    private let idsKey = "TripPilot_BookmarkedPlaceIds"
    private let namesKey = "TripPilot_BookmarkedPlaceNames"
    
    @Published public private(set) var bookmarkedIds: Set<String> = []
    @Published public private(set) var bookmarkedNames: Set<String> = []
    
    private init() {
        if let savedIds = UserDefaults.standard.stringArray(forKey: idsKey) {
            self.bookmarkedIds = Set(savedIds)
        }
        if let savedNames = UserDefaults.standard.stringArray(forKey: namesKey) {
            self.bookmarkedNames = Set(savedNames)
        }
        
        // Seed initial curated highlights if completely empty
        if bookmarkedIds.isEmpty && bookmarkedNames.isEmpty {
            let initialPlaces = SriLankaDataService.shared.places.prefix(3)
            for p in initialPlaces {
                self.bookmarkedIds.insert(p.id.uuidString)
                self.bookmarkedNames.insert(p.name)
            }
            save()
        }
    }
    
    public func isBookmarked(id: UUID) -> Bool {
        bookmarkedIds.contains(id.uuidString)
    }
    
    public func isBookmarked(name: String) -> Bool {
        bookmarkedNames.contains(name)
    }
    
    public func isBookmarked(place: SriLankaPlace) -> Bool {
        bookmarkedIds.contains(place.id.uuidString) || bookmarkedNames.contains(place.name)
    }
    
    public func toggleBookmark(place: SriLankaPlace) {
        let idStr = place.id.uuidString
        if bookmarkedIds.contains(idStr) || bookmarkedNames.contains(place.name) {
            bookmarkedIds.remove(idStr)
            bookmarkedNames.remove(place.name)
        } else {
            bookmarkedIds.insert(idStr)
            bookmarkedNames.insert(place.name)
        }
        save()
    }
    
    public func toggleBookmark(name: String) {
        if let place = SriLankaDataService.shared.places.first(where: { $0.name == name }) {
            toggleBookmark(place: place)
        } else {
            let synthId = "custom_" + name
            if bookmarkedNames.contains(name) {
                bookmarkedNames.remove(name)
                bookmarkedIds.remove(synthId)
            } else {
                bookmarkedNames.insert(name)
                bookmarkedIds.insert(synthId)
            }
            save()
        }
    }
    
    public var count: Int {
        bookmarkedNames.count
    }
    
    private func save() {
        UserDefaults.standard.set(Array(bookmarkedIds), forKey: idsKey)
        UserDefaults.standard.set(Array(bookmarkedNames), forKey: namesKey)
    }
}
