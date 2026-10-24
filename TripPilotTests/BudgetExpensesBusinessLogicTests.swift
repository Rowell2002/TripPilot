import Testing
import Foundation
import SwiftUI
@testable import TripPilot

@Suite("Budget & Expenses Business Logic Suite")
struct BudgetExpensesBusinessLogicTests {
    
    @Test("Central Bank of Sri Lanka FX Rate Conversion Accuracy")
    @MainActor
    func testFxRateCalculations() {
        let viewModel = BudgetExpensesViewModel.shared
        #expect(viewModel.fxRate == 305.00)
        
        // $100 USD -> 30,500 LKR
        let usdAmount = 100.0
        let expectedLKR = Int(usdAmount * viewModel.fxRate)
        #expect(expectedLKR == 30500)
        
        // Rs. 61,000 LKR -> $200 USD
        let lkrAmount = 61000.0
        let expectedUSD = lkrAmount / viewModel.fxRate
        #expect(expectedUSD == 200.0)
    }
    
    @Test("Total Spent & Remaining Budget Clamping")
    @MainActor
    func testBudgetCalculations() {
        let viewModel = BudgetExpensesViewModel.shared
        
        // Backup transactions
        let originalTransactions = viewModel.transactions
        defer {
            viewModel.transactions = originalTransactions
            viewModel.persistExpenses()
        }
        
        // Set deterministic transactions
        let tx1 = ExpenseTransaction(
            title: "Test Dinner",
            subtitle: "Test",
            category: "Dining",
            date: Date(),
            timeAgo: "Now",
            location: "Colombo",
            amountUSD: 100.0,
            amountLKR: 30500
        )
        let tx2 = ExpenseTransaction(
            title: "Test Train",
            subtitle: "Test",
            category: "Transit",
            date: Date(),
            timeAgo: "Now",
            location: "Kandy",
            amountUSD: 50.0,
            amountLKR: 15250
        )
        viewModel.transactions = [tx1, tx2]
        
        #expect(viewModel.totalSpentUSD == 150.0)
        #expect(viewModel.totalSpentLKR == Int(150.0 * 305.00))
        
        // Verify remaining safe spend does not drop below zero
        viewModel.updateBudgetCap(newCapUSD: 100.0) // Cap is less than spent
        #expect(viewModel.remainingSafeToSpendUSD == 0.0)
        #expect(viewModel.remainingSafeToSpendLKR == 0)
        #expect(viewModel.paceStatus == "Over Budget")
        
        // Update cap to comfortable amount
        viewModel.updateBudgetCap(newCapUSD: 500.0)
        #expect(viewModel.remainingSafeToSpendUSD == 350.0)
        #expect(viewModel.paceStatus == "On Track")
        
        // Utilization percentage
        #expect(viewModel.utilizationPercentage == 150.0 / 500.0)
        #expect(viewModel.utilizationPercentFormatted == "30%")
    }
    
    @Test("Add Expense Transaction in USD and LKR")
    @MainActor
    func testAddExpense() {
        let viewModel = BudgetExpensesViewModel.shared
        let initialCount = viewModel.transactions.count
        
        // Add expense in USD
        viewModel.addExpense(
            title: "Kottu Roti Feast",
            category: "Food & Dining",
            amount: 25.0,
            inputIsUSD: true,
            location: "Galle Fort"
        )
        
        #expect(viewModel.transactions.count == initialCount + 1)
        let addedUSD = viewModel.transactions.first!
        #expect(addedUSD.title == "Kottu Roti Feast")
        #expect(addedUSD.amountUSD == 25.0)
        #expect(addedUSD.amountLKR == Int(25.0 * 305.0))
        
        // Add expense in LKR
        viewModel.addExpense(
            title: "Tuk-Tuk Safari",
            category: "Transit & Rail",
            amount: 6100.0,
            inputIsUSD: false,
            location: "Ella"
        )
        
        let addedLKR = viewModel.transactions.first!
        #expect(addedLKR.title == "Tuk-Tuk Safari")
        #expect(addedLKR.amountLKR == 6100)
        #expect(addedLKR.amountUSD == 6100.0 / 305.0)
        
        // Cleanup added items
        viewModel.deleteExpense(id: addedLKR.id)
        viewModel.deleteExpense(id: addedUSD.id)
        #expect(viewModel.transactions.count == initialCount)
    }
    
    @Test("Category Envelopes Allocation & Progress Calculation")
    @MainActor
    func testCategoryEnvelopes() {
        let viewModel = BudgetExpensesViewModel.shared
        let envelopes = viewModel.categoryEnvelopes
        
        // Should contain 5 primary categories
        #expect(envelopes.count == 5)
        
        let envelopeNames = envelopes.map { $0.name }
        #expect(envelopeNames.contains("Accommodations"))
        #expect(envelopeNames.contains("Food & Dining"))
        #expect(envelopeNames.contains("Transit & Rail"))
        #expect(envelopeNames.contains("Culture & Passes"))
        #expect(envelopeNames.contains("Shopping & Gifts"))
        
        for env in envelopes {
            #expect(env.targetUSD > 0)
            #expect(env.targetLKR > 0)
            #expect(env.progress >= 0.0 && env.progress <= 1.0)
        }
    }
    
    @Test("Currency Mode Toggle")
    @MainActor
    func testCurrencyToggle() {
        let viewModel = BudgetExpensesViewModel.shared
        let currentMode = viewModel.isUSD
        viewModel.toggleCurrency()
        #expect(viewModel.isUSD != currentMode)
        viewModel.toggleCurrency()
        #expect(viewModel.isUSD == currentMode)
    }
    
    @Test("Donut Slices Proportions")
    @MainActor
    func testDonutSlices() {
        let viewModel = BudgetExpensesViewModel.shared
        let slices = viewModel.donutSlices
        #expect(!slices.isEmpty)
        
        let totalPercent = slices.reduce(0.0) { $0 + $1.percentage }
        #expect(totalPercent > 0.0 && totalPercent <= 1.01)
    }
}
