import Foundation
import CreateML

let csvPath = URL(fileURLWithPath: "/Users/chethanarowell/TripPilot/TripPilot/ML/SriLankaTravelTrainingData.csv")
print("📂 Loading dataset from: \(csvPath.path)...")

do {
    let dataTable = try MLDataTable(contentsOf: csvPath)
    print("✅ Loaded \(dataTable.rows.count) rows with columns: \(dataTable.columnNames)")
    
    let (trainingData, testingData) = dataTable.randomSplit(by: 0.8, seed: 42)
    print("📊 Training set: \(trainingData.rows.count) rows, Testing set: \(testingData.rows.count) rows")
    
    // 1. Train Match Score Regressor (Boosted Tree Regressor for high accuracy and small footprint)
    print("🤖 Training TripMatchRegressor...")
    let matchRegressor = try MLBoostedTreeRegressor(
        trainingData: trainingData,
        targetColumn: "matchScore",
        featureColumns: [
            "travelPurpose",
            "travelPace",
            "budgetTier",
            "durationDays",
            "travelerType",
            "destinationName",
            "destinationCategory"
        ]
    )
    
    let matchMetrics = matchRegressor.evaluation(on: testingData)
    print("🎯 Match Regressor RMSE: \(matchMetrics.rootMeanSquaredError), Max Error: \(matchMetrics.maximumError)")
    
    // Save Match Regressor
    let outputModelUrl = URL(fileURLWithPath: "/Users/chethanarowell/TripPilot/TripPilot/ML/TripMatchRegressor.mlpackage")
    let metadata = MLModelMetadata(
        author: "TripPilot AI Team",
        shortDescription: "Predicts personalized traveler affinity match score for Sri Lankan destinations",
        version: "1.0"
    )
    try matchRegressor.write(to: outputModelUrl, metadata: metadata)
    print("💾 Saved TripMatchRegressor to: \(outputModelUrl.path)")
    
    // 2. Train Time Slot Classifier
    print("🤖 Training TripSlotClassifier...")
    let slotClassifier = try MLClassifier(
        trainingData: trainingData,
        targetColumn: "optimalTimeSlot",
        featureColumns: [
            "travelPurpose",
            "travelPace",
            "destinationName",
            "destinationCategory"
        ]
    )
    
    let slotMetrics = slotClassifier.evaluation(on: testingData)
    print("🎯 Slot Classifier Accuracy: \(1.0 - slotMetrics.classificationError)")
    
    let slotModelUrl = URL(fileURLWithPath: "/Users/chethanarowell/TripPilot/TripPilot/ML/TripSlotClassifier.mlpackage")
    try slotClassifier.write(to: slotModelUrl, metadata: MLModelMetadata(author: "TripPilot AI Team", shortDescription: "Predicts best time of day for destination visits", version: "1.0"))
    print("💾 Saved TripSlotClassifier to: \(slotModelUrl.path)")
    
    print("🎉 Core ML Model Training Complete!")
} catch {
    print("❌ Training failed: \(error)")
    exit(1)
}
