import SwiftUI
import Combine
import FirebaseAuth

@MainActor
final class HomeDashboardViewModel: ObservableObject {
    // MARK: - Published UI States
    @Published var selectedTab: AppTab = .home
    @Published var isLivePulsing: Bool = false
    @Published var showFlyoverMapModal: Bool = false
    @Published var showTripWizardModal: Bool = false
    @Published var showPolaroidCaptureSheet: Bool = false
    @Published var selectedPolaroidMoment: PolaroidMoment? = nil
    @Published var activeUtilityNotice: String? = nil
    
    // MARK: - Navigation Triggers
    @Published var navigateToMyTrips: Bool = false
    @Published var navigateToItinerary: Bool = false
    @Published var navigateToInteractiveMap: Bool = false
    @Published var navigateToPlaceDiscovery: Bool = false
    @Published var navigateToBudget: Bool = false
    @Published var navigateToProfile: Bool = false
    
    // MARK: - Notifications & Geofence Audio Guide
    @Published var showNotificationsSheet: Bool = false
    @Published var showGeofenceAudioGuide: Bool = false
    @Published var selectedGeofenceLandmark: GeofenceLandmarkData = .defaultShibuya
    
    // MARK: - Service Dependencies
    let tripManager: TripManager
    let stepTracker: TripStepTrackerService
    let polaroidService: PolaroidGalleryService
    let authViewModel: AuthViewModel
    let notificationManager: NotificationManager
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        tripManager: TripManager = .shared,
        stepTracker: TripStepTrackerService = .shared,
        polaroidService: PolaroidGalleryService = .shared,
        authViewModel: AuthViewModel = .shared,
        notificationManager: NotificationManager = .shared
    ) {
        self.tripManager = tripManager
        self.stepTracker = stepTracker
        self.polaroidService = polaroidService
        self.authViewModel = authViewModel
        self.notificationManager = notificationManager
        
        tripManager.objectWillChange
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
            
        stepTracker.objectWillChange
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
            
        polaroidService.objectWillChange
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
            
        authViewModel.objectWillChange
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }
    
    // MARK: - Computed Properties for View
    var activeTrip: GeneratedTrip {
        tripManager.currentTrip
    }
    
    var userNameGreeting: String {
        if let user = authViewModel.currentUser {
            if let name = user.displayName, !name.isEmpty {
                let first = name.components(separatedBy: " ").first ?? name
                return first.isEmpty ? "Traveler" : first
            }
            return "Traveler"
        }
        return "Guest"
    }
    
    var unreadNotificationsCount: Int {
        notificationManager.unreadCount
    }
    
    // MARK: - Actions
    func triggerNotice(_ message: String) {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            activeUtilityNotice = message
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            withAnimation(.easeOut(duration: 0.3)) {
                if self?.activeUtilityNotice == message {
                    self?.activeUtilityNotice = nil
                }
            }
        }
    }
    
    func openGeofenceGuide(for landmark: GeofenceLandmarkData) {
        selectedGeofenceLandmark = landmark
        showGeofenceAudioGuide = true
    }
    
    func selectPolaroidMoment(_ moment: PolaroidMoment) {
        selectedPolaroidMoment = moment
    }
    
    func handleTabSelection(_ tab: AppTab) {
        switch tab {
        case .home:
            selectedTab = .home
        case .itinerary:
            navigateToItinerary = true
        case .map:
            navigateToInteractiveMap = true
        case .budget:
            navigateToBudget = true
        case .profile:
            navigateToProfile = true
        case .trips:
            navigateToMyTrips = true
        }
    }
}
