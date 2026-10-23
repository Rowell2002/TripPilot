import Foundation
import SwiftUI
import Combine

// MARK: - Polaroid Gallery & Storage Service
final class PolaroidGalleryService: ObservableObject {
    static let shared = PolaroidGalleryService()
    
    @Published var moments: [PolaroidMoment] = []
    
    private let rootFolderName = "TripPilotPolaroids"
    private let jsonFileName = "moments_v1.json"
    
    private var currentUserId: String {
        AuthViewModel.shared.currentUserId
    }
    
    private var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private var polaroidsDirectory: URL {
        documentsDirectory
            .appendingPathComponent(rootFolderName, isDirectory: true)
            .appendingPathComponent(currentUserId, isDirectory: true)
    }
    
    private var jsonFileURL: URL {
        polaroidsDirectory.appendingPathComponent(jsonFileName)
    }
    
    private init() {
        createFolderIfNeeded()
        loadMoments()
        
        NotificationCenter.default.addObserver(
            forName: AuthViewModel.userDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.createFolderIfNeeded()
            self?.loadMoments()
        }
    }
    
    private func createFolderIfNeeded() {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: polaroidsDirectory.path) {
            try? fileManager.createDirectory(at: polaroidsDirectory, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    // MARK: - Load & Save
    func loadMoments() {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: jsonFileURL.path),
           let data = try? Data(contentsOf: jsonFileURL),
           let decoded = try? JSONDecoder().decode([PolaroidMoment].self, from: data) {
            self.moments = decoded
        } else {
            // Seed initial iconic Ceylon polaroid moments
            seedSampleMoments()
        }
    }
    
    private func persist() {
        do {
            let data = try JSONEncoder().encode(moments)
            try data.write(to: jsonFileURL, options: .atomic)
        } catch {
            print("Failed to persist polaroid moments: \(error)")
        }
    }
    
    // MARK: - Pre-seeded Sample Moments
    private func seedSampleMoments() {
        let calendar = Calendar.current
        let today = Date()
        let date1 = calendar.date(byAdding: .day, value: -3, to: today) ?? today
        let date2 = calendar.date(byAdding: .day, value: -1, to: today) ?? today
        let date3 = calendar.date(byAdding: .hour, value: -6, to: today) ?? today
        
        self.moments = [
            PolaroidMoment(
                remoteImageUrl: "https://images.unsplash.com/photo-1588598198321-9735fd52455b?auto=format&fit=crop&w=1200&q=80",
                caption: "Sigiriya Lion Rock",
                locationName: "Central Province, Sri Lanka",
                date: date1,
                rotationDegrees: -1.8
            ),
            PolaroidMoment(
                remoteImageUrl: "https://images.unsplash.com/photo-1546708973-b339540b5162?auto=format&fit=crop&w=1200&q=80",
                caption: "Ella Nine Arch",
                locationName: "Demodara Loop, Sri Lanka",
                date: date2,
                rotationDegrees: 2.2
            ),
            PolaroidMoment(
                remoteImageUrl: "https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?auto=format&fit=crop&w=1200&q=80",
                caption: "Galle Fort Lighthouse",
                locationName: "Southern Province, Sri Lanka",
                date: date3,
                rotationDegrees: -1.2
            )
        ]
        persist()
    }
    
    // MARK: - Add New Captured Moment
    @discardableResult
    func addMoment(image: UIImage, caption: String, location: String, date: Date = Date()) -> PolaroidMoment? {
        createFolderIfNeeded()
        let filename = "polaroid_\(UUID().uuidString).jpg"
        let fileURL = polaroidsDirectory.appendingPathComponent(filename)
        
        guard let data = image.jpegData(compressionQuality: 0.88) else { return nil }
        
        do {
            try data.write(to: fileURL)
            let newMoment = PolaroidMoment(
                localImageFilename: filename,
                caption: caption.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Special Moment" : caption,
                locationName: location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Sri Lanka" : location,
                date: date,
                rotationDegrees: Double.random(in: -2.0...2.0)
            )
            withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
                self.moments.insert(newMoment, at: 0)
            }
            persist()
            return newMoment
        } catch {
            print("Failed to save polaroid image: \(error)")
            return nil
        }
    }
    
    // MARK: - Delete Moment
    func deleteMoment(id: UUID) {
        if let index = moments.firstIndex(where: { $0.id == id }) {
            let moment = moments[index]
            if let filename = moment.localImageFilename {
                let fileURL = polaroidsDirectory.appendingPathComponent(filename)
                try? FileManager.default.removeItem(at: fileURL)
            }
            withAnimation(.easeInOut(duration: 0.3)) {
                moments.remove(at: index)
            }
            persist()
        }
    }
    
    // MARK: - Image Loader
    func loadImage(for moment: PolaroidMoment) -> UIImage? {
        if let filename = moment.localImageFilename {
            let fileURL = polaroidsDirectory.appendingPathComponent(filename)
            if let data = try? Data(contentsOf: fileURL) {
                return UIImage(data: data)
            }
        }
        return nil
    }
}
