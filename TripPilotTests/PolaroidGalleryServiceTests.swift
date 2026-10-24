import Testing
import UIKit
import Foundation
@testable import TripPilot

@Suite("Polaroid Memories & Gallery Storage Suite")
struct PolaroidGalleryServiceTests {
    
    @Test("Pre-Seeded Sample Moments Verification")
    @MainActor
    func testSampleMomentsSeeded() {
        let service = PolaroidGalleryService.shared
        #expect(!service.moments.isEmpty)
        
        let captions = service.moments.map { $0.caption }
        #expect(captions.contains(where: { $0.contains("Sigiriya") || $0.contains("Ella") || $0.contains("Galle") }))
        
        for moment in service.moments {
            #expect(!moment.caption.isEmpty)
            #expect(!moment.locationName.isEmpty)
            #expect(moment.rotationDegrees >= -5.0 && moment.rotationDegrees <= 5.0)
        }
    }
    
    @Test("Add, Load and Delete Polaroid Moment Lifecycle")
    @MainActor
    func testMomentLifecycle() {
        let service = PolaroidGalleryService.shared
        let initialCount = service.moments.count
        
        // Generate test image in memory
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 80, height: 80))
        let testImage = renderer.image { ctx in
            UIColor.systemTeal.setFill()
            ctx.fill(CGRect(x: 0, y: 0, width: 80, height: 80))
        }
        
        // Add new moment
        let newMoment = service.addMoment(
            image: testImage,
            caption: "Kandy Esala Perahera",
            location: "Kandy, Central Province"
        )
        
        #expect(newMoment != nil)
        guard let moment = newMoment else { return }
        
        #expect(service.moments.count == initialCount + 1)
        #expect(service.moments.first?.id == moment.id)
        #expect(service.moments.first?.caption == "Kandy Esala Perahera")
        
        // Verify image loads from disk
        let loadedImage = service.loadImage(for: moment)
        #expect(loadedImage != nil)
        
        // Delete moment and verify removal
        service.deleteMoment(id: moment.id)
        #expect(service.moments.count == initialCount)
        #expect(!service.moments.contains(where: { $0.id == moment.id }))
    }
    
    @Test("Polaroid Moment Caption Fallback for Blank Inputs")
    @MainActor
    func testBlankInputFallbacks() {
        let service = PolaroidGalleryService.shared
        let initialCount = service.moments.count
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 40, height: 40))
        let testImage = renderer.image { ctx in
            UIColor.orange.setFill()
            ctx.fill(CGRect(x: 0, y: 0, width: 40, height: 40))
        }
        
        let moment = service.addMoment(
            image: testImage,
            caption: "   ",
            location: "   "
        )
        
        #expect(moment != nil)
        if let moment = moment {
            #expect(moment.caption == "Special Moment")
            #expect(moment.locationName == "Sri Lanka")
            
            // Cleanup
            service.deleteMoment(id: moment.id)
            #expect(service.moments.count == initialCount)
        }
    }
}
