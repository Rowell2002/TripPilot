import SwiftUI
import Combine

// MARK: - Expense Transaction Model
struct ExpenseTransaction: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var title: String
    var subtitle: String
    var category: String
    var date: Date
    var timeAgo: String
    var location: String
    var amountUSD: Double
    var amountLKR: Int
    var isSplit: Bool = false
    var splitWith: String? = nil
    
    var categoryColor: Color {
        switch category.lowercased() {
        case let c where c.contains("dining") || c.contains("food") || c.contains("restaurant"):
            return Color(red: 245/255, green: 158/255, blue: 11/255) // Amber
        case let c where c.contains("transit") || c.contains("train") || c.contains("transport") || c.contains("tuk-tuk"):
            return Color(red: 37/255, green: 99/255, blue: 235/255) // Royal Blue
        case let c where c.contains("lodging") || c.contains("hotel") || c.contains("resort") || c.contains("villa"):
            return Color(red: 56/255, green: 189/255, blue: 248/255) // Sky Blue
        case let c where c.contains("culture") || c.contains("heritage") || c.contains("pass") || c.contains("unesco"):
            return Color(red: 16/255, green: 185/255, blue: 129/255) // Emerald
        case let c where c.contains("shopping") || c.contains("tea") || c.contains("souvenir") || c.contains("snack"):
            return Color(red: 168/255, green: 85/255, blue: 247/255) // Purple
        default:
            return Color(red: 68/255, green: 226/255, blue: 205/255) // Mint
        }
    }
    
    var categoryIcon: String {
        switch category.lowercased() {
        case let c where c.contains("dining") || c.contains("food") || c.contains("restaurant"):
            return "fork.knife"
        case let c where c.contains("transit") || c.contains("train") || c.contains("transport") || c.contains("tuk-tuk"):
            return "tram.fill"
        case let c where c.contains("lodging") || c.contains("hotel") || c.contains("resort") || c.contains("villa"):
            return "bed.double.fill"
        case let c where c.contains("culture") || c.contains("heritage") || c.contains("pass") || c.contains("unesco"):
            return "ticket.fill"
        case let c where c.contains("shopping") || c.contains("tea") || c.contains("souvenir") || c.contains("snack"):
            return "bag.fill"
        default:
            return "dollarsign.circle.fill"
        }
    }
}

// MARK: - Category Envelope Model
struct BudgetCategoryEnvelope: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let detail: String
    let iconName: String
    let color: Color
    let spentUSD: Double
    let targetUSD: Double
    let spentLKR: Int
    let targetLKR: Int
    
    var progress: Double {
        guard targetUSD > 0 else { return 0 }
        return min(spentUSD / targetUSD, 1.0)
    }
}

// MARK: - Donut Slice Model
struct DonutSlice: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let color: Color
    let percentage: Double
    let amountUSD: Double
    let amountLKR: Int
}

// MARK: - Budget ViewModel
@MainActor
final class BudgetExpensesViewModel: ObservableObject {
    static let shared = BudgetExpensesViewModel()
    
    // MARK: - Constants & FX
    let fxRate: Double = 305.00 // 1 USD = 305 LKR (Central Bank of Sri Lanka)
    
    // MARK: - Published State
    @Published var selectedTab: AppTab = .budget
    @Published var isUSD: Bool = true
    @Published var showLogExpenseSheet: Bool = false
    @Published var showSplitBillSheet: Bool = false
    @Published var showEditBudgetSheet: Bool = false
    @Published var showTripPickerSheet: Bool = false
    @Published var activeNotice: String? = nil
    @Published var isSettledWithMarcus: Bool = false
    @Published var selectedDonutIndex: Int? = nil
    
    // Persistent user budget cap (if customized)
    @Published var customBudgetCapUSD: Double? = nil
    
    // Transactions
    @Published var transactions: [ExpenseTransaction] = []
    
    // MARK: - Navigation Triggers
    @Published var navigateToHome: Bool = false
    @Published var navigateToItinerary: Bool = false
    @Published var navigateToMap: Bool = false
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
        
        loadExpenses()
        
        // React to Trip Changes
        tripManager.objectWillChange
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.loadExpenses()
                    self?.objectWillChange.send()
                }
            }
            .store(in: &cancellables)
            
        authViewModel.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Persistence Keys
    private var storageKey: String {
        "TripPilot_Budget_Transactions_\(tripManager.currentTrip.id.uuidString)"
    }
    
    private var budgetCapKey: String {
        "TripPilot_Budget_Cap_\(tripManager.currentTrip.id.uuidString)"
    }
    
    // MARK: - Load & Save
    func loadExpenses() {
        // Load custom cap if saved
        if let savedCap = UserDefaults.standard.object(forKey: budgetCapKey) as? Double, savedCap > 0 {
            self.customBudgetCapUSD = savedCap
        } else {
            self.customBudgetCapUSD = nil
        }
        
        // Load transactions
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let saved = try? JSONDecoder().decode([ExpenseTransaction].self, from: data) {
            self.transactions = saved
        } else {
            // Populate initial realistic sample transactions for a rich Sri Lanka journey
            let initial = [
                ExpenseTransaction(
                    title: "Ministry of Crab Dinner",
                    subtitle: "Lagoon crab feast & beverage",
                    category: "Dining",
                    date: Date(),
                    timeAgo: "Today, 1:45 PM",
                    location: "Old Dutch Hospital, Colombo",
                    amountUSD: 95.00,
                    amountLKR: 28975
                ),
                ExpenseTransaction(
                    title: "Sigiriya UNESCO Entry Pass",
                    subtitle: "Ancient citadel & museum tickets (x2)",
                    category: "Culture",
                    date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
                    timeAgo: "Yesterday",
                    location: "Sigiriya, Central Province",
                    amountUSD: 72.00,
                    amountLKR: 21960
                ),
                ExpenseTransaction(
                    title: "Ella Scenic Blue Train",
                    subtitle: "Observation Saloon Reserved Seats",
                    category: "Transit",
                    date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
                    timeAgo: "2 days ago",
                    location: "Kandy → Ella Highlands",
                    amountUSD: 36.00,
                    amountLKR: 10980
                ),
                ExpenseTransaction(
                    title: "Heritance Kandalama Villa",
                    subtitle: "Bawa luxury eco-resort deposit",
                    category: "Lodging",
                    date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(),
                    timeAgo: "3 days ago",
                    location: "Dambulla, Cultural Triangle",
                    amountUSD: 450.00,
                    amountLKR: 137250
                ),
                ExpenseTransaction(
                    title: "King Coconut & Ceylon Tea",
                    subtitle: "Golden Thambili & Orange Pekoe gifts",
                    category: "Shopping",
                    date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(),
                    timeAgo: "3 days ago",
                    location: "Galle Fort Ramparts",
                    amountUSD: 14.50,
                    amountLKR: 4420
                )
            ]
            self.transactions = initial
            persistExpenses()
        }
    }
    
    func persistExpenses() {
        if let data = try? JSONEncoder().encode(transactions) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
    
    // MARK: - Computed Budget Metrics
    var totalBudgetUSD: Double {
        if let cap = customBudgetCapUSD, cap > 0 {
            return cap
        }
        let tripEstimate = tripManager.currentTrip.totalEstimatedUSD
        return tripEstimate > 0 ? tripEstimate : 2500.00
    }
    
    var totalBudgetLKR: Int {
        Int(totalBudgetUSD * fxRate)
    }
    
    var totalSpentUSD: Double {
        transactions.reduce(0.0) { $0 + $1.amountUSD }
    }
    
    var totalSpentLKR: Int {
        Int(totalSpentUSD * fxRate)
    }
    
    var remainingSafeToSpendUSD: Double {
        max(totalBudgetUSD - totalSpentUSD, 0)
    }
    
    var remainingSafeToSpendLKR: Int {
        max(totalBudgetLKR - totalSpentLKR, 0)
    }
    
    var utilizationPercentage: Double {
        guard totalBudgetUSD > 0 else { return 0 }
        return min(max(totalSpentUSD / totalBudgetUSD, 0.0), 1.0)
    }
    
    var utilizationPercentFormatted: String {
        "\(Int(utilizationPercentage * 100))%"
    }
    
    var remainingDaysCount: Int {
        max(tripManager.currentTrip.durationDays, 1)
    }
    
    var dailySafePaceUSD: Double {
        remainingSafeToSpendUSD / Double(remainingDaysCount)
    }
    
    var dailySafePaceLKR: Int {
        Int(dailySafePaceUSD * fxRate)
    }
    
    var paceStatus: String {
        if totalSpentUSD > totalBudgetUSD {
            return "Over Budget"
        } else if utilizationPercentage > 0.85 {
            return "Caution"
        } else {
            return "On Track"
        }
    }
    
    // MARK: - Dynamic Category Envelopes
    var categoryEnvelopes: [BudgetCategoryEnvelope] {
        let envelopeConfigs: [(name: String, key: String, ratio: Double, icon: String, color: Color)] = [
            ("Accommodations", "lodging", 0.35, "bed.double.fill", Color(red: 56/255, green: 189/255, blue: 248/255)),
            ("Food & Dining", "dining", 0.25, "fork.knife", Color(red: 245/255, green: 158/255, blue: 11/255)),
            ("Transit & Rail", "transit", 0.20, "tram.fill", Color(red: 37/255, green: 99/255, blue: 235/255)),
            ("Culture & Passes", "culture", 0.12, "ticket.fill", Color(red: 16/255, green: 185/255, blue: 129/255)),
            ("Shopping & Gifts", "shopping", 0.08, "bag.fill", Color(red: 168/255, green: 85/255, blue: 247/255))
        ]
        
        return envelopeConfigs.map { item in
            let categorySpentUSD = transactions
                .filter { $0.category.lowercased().contains(item.key) }
                .reduce(0.0) { $0 + $1.amountUSD }
            let categorySpentLKR = Int(categorySpentUSD * fxRate)
            
            let targetUSD = totalBudgetUSD * item.ratio
            let targetLKR = Int(targetUSD * fxRate)
            
            let detail = isUSD ?
                String(format: "$%.1f spent of $%.0f cap", categorySpentUSD, targetUSD) :
                String(format: "Rs. %d spent of Rs. %d cap", categorySpentLKR, targetLKR)
            
            return BudgetCategoryEnvelope(
                name: item.name,
                detail: detail,
                iconName: item.icon,
                color: item.color,
                spentUSD: categorySpentUSD,
                targetUSD: targetUSD,
                spentLKR: categorySpentLKR,
                targetLKR: targetLKR
            )
        }
    }
    
    // MARK: - Dynamic Donut Slices
    var donutSlices: [DonutSlice] {
        guard totalSpentUSD > 0 else {
            // Default proportional slices for fresh empty view
            return [
                DonutSlice(name: "Accommodations", color: Color(red: 56/255, green: 189/255, blue: 248/255), percentage: 0.35, amountUSD: 0, amountLKR: 0),
                DonutSlice(name: "Food & Dining", color: Color(red: 245/255, green: 158/255, blue: 11/255), percentage: 0.25, amountUSD: 0, amountLKR: 0),
                DonutSlice(name: "Transit & Rail", color: Color(red: 37/255, green: 99/255, blue: 235/255), percentage: 0.20, amountUSD: 0, amountLKR: 0),
                DonutSlice(name: "Culture & Passes", color: Color(red: 16/255, green: 185/255, blue: 129/255), percentage: 0.12, amountUSD: 0, amountLKR: 0),
                DonutSlice(name: "Shopping & Gifts", color: Color(red: 168/255, green: 85/255, blue: 247/255), percentage: 0.08, amountUSD: 0, amountLKR: 0)
            ]
        }
        
        let envelopes = categoryEnvelopes
        var slices: [DonutSlice] = []
        for env in envelopes {
            let percentage = env.spentUSD / totalSpentUSD
            if percentage > 0.005 {
                slices.append(
                    DonutSlice(
                        name: env.name,
                        color: env.color,
                        percentage: percentage,
                        amountUSD: env.spentUSD,
                        amountLKR: env.spentLKR
                    )
                )
            }
        }
        
        if slices.isEmpty {
            return [
                DonutSlice(name: "All Spending", color: Color(red: 56/255, green: 189/255, blue: 248/255), percentage: 1.0, amountUSD: totalSpentUSD, amountLKR: totalSpentLKR)
            ]
        }
        
        return slices
    }
    
    // MARK: - Actions
    func toggleCurrency() {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
            isUSD.toggle()
        }
    }
    
    func addExpense(
        title: String,
        category: String,
        amount: Double,
        inputIsUSD: Bool,
        location: String,
        date: Date = Date()
    ) {
        let amountUSD: Double
        let amountLKR: Int
        
        if inputIsUSD {
            amountUSD = amount
            amountLKR = Int(amount * fxRate)
        } else {
            amountLKR = Int(amount)
            amountUSD = amount / fxRate
        }
        
        let newExpense = ExpenseTransaction(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            subtitle: "Logged manually in Sri Lanka",
            category: category,
            date: date,
            timeAgo: "Just now",
            location: location.isEmpty ? "Sri Lanka" : location,
            amountUSD: amountUSD,
            amountLKR: amountLKR
        )
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            transactions.insert(newExpense, at: 0)
            persistExpenses()
            let formattedAmount = isUSD ? String(format: "$%.2f", amountUSD) : "Rs. \(amountLKR.formatted())"
            triggerNotice("💳 Logged \(newExpense.title) (\(formattedAmount))!")
        }
    }
    
    func deleteExpense(id: UUID) {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            if let index = transactions.firstIndex(where: { $0.id == id }) {
                let deletedTitle = transactions[index].title
                transactions.remove(at: index)
                persistExpenses()
                triggerNotice("🗑️ Removed \(deletedTitle)")
            }
        }
    }
    
    func updateBudgetCap(newCapUSD: Double) {
        guard newCapUSD > 0 else { return }
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            self.customBudgetCapUSD = newCapUSD
            UserDefaults.standard.set(newCapUSD, forKey: budgetCapKey)
            triggerNotice("🎯 Updated Trip Budget Cap to $\(Int(newCapUSD)) (Rs. \(Int(newCapUSD * fxRate).formatted()))")
        }
    }
    
    func resetBudgetCapToTripDefault() {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            self.customBudgetCapUSD = nil
            UserDefaults.standard.removeObject(forKey: budgetCapKey)
            triggerNotice("🔄 Budget cap reset to trip itinerary default")
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
