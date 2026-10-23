//
//  BudgetExpensesViewModel.swift
//  TripPilot
//
//  Created for TripPilot - MVVM Architecture
//

import SwiftUI
import Combine

@MainActor
final class BudgetExpensesViewModel: ObservableObject {
    // MARK: - Constants & FX
    let fxRate: Double = 305.00 // 1 USD = 305 LKR
    
    // MARK: - Published UI States
    @Published var selectedTab: AppTab = .budget
    @Published var isUSD: Bool = true
    @Published var showLogExpenseSheet: Bool = false
    @Published var showSplitBillSheet: Bool = false
    @Published var showTripPickerSheet: Bool = false
    @Published var activeNotice: String? = nil
    @Published var isSettledWithMarcus: Bool = false
    @Published var selectedDonutIndex: Int? = nil
    
    // MARK: - Navigation Triggers
    @Published var navigateToHome: Bool = false
    @Published var navigateToItinerary: Bool = false
    @Published var navigateToMap: Bool = false
    @Published var navigateToReceiptScanner: Bool = false
    @Published var navigateToProfile: Bool = false
    
    // MARK: - Dependencies
    let authViewModel: AuthViewModel
    let tripManager: TripManager
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        authViewModel: AuthViewModel = .shared,
        tripManager: TripManager = .shared
    ) {
        self.authViewModel = authViewModel
        self.tripManager = tripManager
        
        authViewModel.objectWillChange
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    func toggleCurrency() {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
            isUSD.toggle()
        }
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
    
    func settleWithMarcus() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            isSettledWithMarcus = true
            triggerNotice("Marcus Vance paid you $78.00 via Apple Pay")
        }
    }
}
