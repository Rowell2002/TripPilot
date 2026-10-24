import Testing
import Foundation
@testable import TripPilot

@Suite("Core ML Recommender & Inference Engine Suite")
struct TripMLRecommenderServiceTests {
    
    @Test("Core ML Prediction Score Within Valid Bounds")
    func testMLPredictionScoreBounds() {
        let service = TripMLRecommenderService.shared
        
        // Predict for Cultural Sigiriya
        let result = service.predict(
            for: "Sigiriya Rock Fortress",
            category: "Culture",
            purpose: "UNESCO Heritage & History",
            pace: "Balanced",
            budget: "Comfort",
            durationDays: 7,
            travelerType: "Couple"
        )
        
        #expect(result.matchScore >= 0.45 && result.matchScore <= 1.0)
        #expect(result.matchPercentage >= 45 && result.matchPercentage <= 100)
        #expect(result.matchPercentage == Int(result.matchScore * 100.0))
        #expect(!result.optimalSlot.isEmpty)
        #expect(result.isMLEnhanced == true)
    }
    
    @Test("Pace-Based Recommended Hours Allocation")
    func testPaceRecommendedHours() {
        let service = TripMLRecommenderService.shared
        
        // Relaxed pace should recommend ~3.5 hours per key site
        let relaxedResult = service.predict(
            for: "Mirissa Beach",
            category: "Beach",
            purpose: "Relaxation & Sun",
            pace: "Relaxed",
            budget: "Comfort",
            durationDays: 5
        )
        #expect(relaxedResult.recommendedHours == 3.5)
        
        // Packed / Fast pace should recommend ~1.5 hours
        let packedResult = service.predict(
            for: "Colombo Street Food",
            category: "Food",
            purpose: "Fast Tasting",
            pace: "Packed & Fast",
            budget: "Budget",
            durationDays: 3
        )
        #expect(packedResult.recommendedHours == 1.5)
        
        // Moderate / Balanced pace should recommend ~2.5 hours
        let balancedResult = service.predict(
            for: "Nine Arch Bridge",
            category: "Scenic",
            purpose: "Photography",
            pace: "Moderate",
            budget: "Luxury",
            durationDays: 5
        )
        #expect(balancedResult.recommendedHours == 2.5)
    }
    
    @Test("Category and Purpose Diversity Predictions")
    func testCategoryDiversity() {
        let service = TripMLRecommenderService.shared
        
        let categories = ["Nature", "Beach", "Culture", "Food", "Adventure"]
        for cat in categories {
            let res = service.predict(
                for: "\(cat) Test Spot",
                category: cat,
                purpose: cat,
                pace: "Moderate",
                budget: "Comfort",
                durationDays: 4
            )
            #expect(res.matchScore > 0.5)
            #expect(!res.optimalSlot.isEmpty)
        }
    }
    
    @Test("MLPredictionResult Default Value Integrity")
    func testPredictionResultDefaultValues() {
        let defaultResult = MLPredictionResult()
        #expect(defaultResult.matchScore == 0.90)
        #expect(defaultResult.matchPercentage == 90)
        #expect(defaultResult.optimalSlot == "Morning")
        #expect(defaultResult.recommendedHours == 2.5)
        #expect(defaultResult.isMLEnhanced == true)
    }
}
