//
//  DailyItineraryViewModel.swift
//  TripPilot
//
//  Created for TripPilot - MVVM Architecture
//

import SwiftUI
import Combine

@MainActor
final class DailyItineraryViewModel: ObservableObject {
    // MARK: - Published UI States
    @Published var selectedTab: AppTab = .itinerary
    @Published var selectedDateIndex: Int = 0
    @Published var showAudioStoryModal: Bool = false
    @Published var showReorderModal: Bool = false
    @Published var showAddStopModal: Bool = false
    @Published var showDaySettingsModal: Bool = false
    @Published var activeNotice: String? = nil
    @Published var isAudioPlaying: Bool = true
    
    // MARK: - Navigation Triggers
    @Published var navigateToInteractiveMap: Bool = false
    @Published var navigateToBudget: Bool = false
    @Published var navigateToProfile: Bool = false
    
    // MARK: - Dependencies
    let tripManager: TripManager
    let audioPlayer: SpatialAudioGuidePlayer
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        tripManager: TripManager = .shared,
        audioPlayer: SpatialAudioGuidePlayer = .shared
    ) {
        self.tripManager = tripManager
        self.audioPlayer = audioPlayer
        
        tripManager.objectWillChange
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }
    
    // MARK: - Computed Properties
    var currentDay: TripDay {
        let days = tripManager.currentTrip.days
        if days.indices.contains(selectedDateIndex) {
            return days[selectedDateIndex]
        }
        return days.first ?? SriLankaDataService.shared.generateCustomTrip(
            destination: "Sigiriya & Ella",
            durationDays: 3,
            companion: "Couple",
            pace: "Balanced",
            budget: "Comfort",
            tags: []
        ).days[0]
    }
    
    var totalDaysCount: Int {
        tripManager.currentTrip.days.count
    }
    
    var totalStopsCount: Int {
        currentDay.stops.count
    }
    
    // MARK: - Actions
    func selectDay(at index: Int) {
        guard tripManager.currentTrip.days.indices.contains(index) else { return }
        selectedDateIndex = index
    }
    
    func triggerNotice(_ message: String) {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            activeNotice = message
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) { [weak self] in
            withAnimation(.easeOut(duration: 0.25)) {
                if self?.activeNotice == message {
                    self?.activeNotice = nil
                }
            }
        }
    }
    
    func toggleAudioPlayback() {
        isAudioPlaying.toggle()
        if isAudioPlaying {
            audioPlayer.play()
        } else {
            audioPlayer.pause()
        }
    }
}
