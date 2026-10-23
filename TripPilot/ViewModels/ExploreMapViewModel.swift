//
//  ExploreMapViewModel.swift
//  TripPilot
//
//  Created for TripPilot - MVVM Architecture
//

import SwiftUI
import MapKit
import Combine

@MainActor
final class ExploreMapViewModel: ObservableObject {
    // MARK: - Published Map States
    @Published var selectedTab: AppTab = .map
    @Published var selectedFilter: MapFilter = .todayRoute
    @Published var selectedDayIndex: Int = 0
    @Published var selectedTripStop: TripStop? = nil
    @Published var searchText: String = ""
    @Published var is3DEnabled: Bool = false
    @Published var isAudioPlaying: Bool = false
    @Published var isSpotSaved: Bool = false
    @Published var isGpsRadarPulsing: Bool = false
    @Published var isRecenterPressed: Bool = false
    @Published var toastMessage: String? = nil
    @Published var showGeofenceRings: Bool = true
    
    // MARK: - Navigation Triggers
    @Published var navigateToItinerary: Bool = false
    @Published var navigateToPlaceDiscovery: Bool = false
    @Published var navigateToPlaceDetail: Bool = false
    @Published var navigateToBudget: Bool = false
    @Published var navigateToProfile: Bool = false
    
    // MARK: - Map Camera & Selection
    @Published var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 7.9570, longitude: 80.7603), // Central Sri Lanka / Sigiriya
            span: MKCoordinateSpan(latitudeDelta: 1.2, longitudeDelta: 1.2)
        )
    )
    @Published var selectedPlace: SriLankaPlace
    
    let tripManager: TripManager
    let dataService: SriLankaDataService
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        initialDayIndex: Int = 0,
        tripManager: TripManager = .shared,
        dataService: SriLankaDataService = .shared
    ) {
        self.selectedDayIndex = initialDayIndex
        self.tripManager = tripManager
        self.dataService = dataService
        self.selectedPlace = dataService.places[0]
        
        tripManager.objectWillChange
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }
    
    // MARK: - Computed Properties
    var allPlaces: [SriLankaPlace] {
        dataService.places
    }
    
    var activeDay: TripDay? {
        guard !tripManager.currentTrip.days.isEmpty else { return nil }
        let idx = min(max(selectedDayIndex, 0), tripManager.currentTrip.days.count - 1)
        return tripManager.currentTrip.days[idx]
    }
    
    var todayStops: [TripStop] {
        activeDay?.stops ?? []
    }
    
    var displayPlaces: [SriLankaPlace] {
        var list = allPlaces
        
        switch selectedFilter {
        case .allPins:
            break
        case .todayRoute:
            return [] // Routed through todayStops instead
        case .cafes:
            list = list.filter { $0.category == .cafe }
        case .dining:
            list = list.filter { $0.category == .dining || $0.category == .food }
        case .unesco:
            list = list.filter { $0.isUNESCO }
        case .hillCountry:
            list = list.filter { $0.region.contains("Hill") || $0.region.contains("Highland") || $0.region.contains("Ella") }
        case .wildlife:
            list = list.filter { $0.category == .wildlife }
        case .beaches:
            list = list.filter { $0.category == .beach }
        }
        
        if !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let q = searchText.lowercased()
            list = list.filter {
                $0.name.lowercased().contains(q) ||
                $0.district.lowercased().contains(q) ||
                $0.province.lowercased().contains(q)
            }
        }
        
        return list
    }
    
    var todayRouteCoordinates: [CLLocationCoordinate2D] {
        todayStops.compactMap { $0.coordinate }
    }
    
    // MARK: - Actions
    func triggerToast(_ message: String) {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            toastMessage = message
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) { [weak self] in
            withAnimation(.easeOut(duration: 0.25)) {
                if self?.toastMessage == message {
                    self?.toastMessage = nil
                }
            }
        }
    }
    
    func fitCameraToStops(_ stops: [TripStop]) {
        guard !stops.isEmpty else { return }
        let coords = stops.compactMap { $0.coordinate }
        guard !coords.isEmpty else { return }
        
        let avgLat = coords.map { $0.latitude }.reduce(0, +) / Double(coords.count)
        let avgLon = coords.map { $0.longitude }.reduce(0, +) / Double(coords.count)
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            cameraPosition = .region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: avgLat, longitude: avgLon),
                    span: MKCoordinateSpan(latitudeDelta: 0.85, longitudeDelta: 0.85)
                )
            )
        }
    }
}
