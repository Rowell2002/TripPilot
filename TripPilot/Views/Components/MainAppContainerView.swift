import SwiftUI

struct MainAppContainerView: View {
    @ObservedObject private var router = AppNavigationRouter.shared
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        appearance.backgroundImage = UIImage()
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Tab Content with State Preservation
            TabView(selection: $router.selectedTab) {
                NavigationStack {
                    HomeDashboardView()
                }
                .tag(AppTab.home)
                
                NavigationStack {
                    DailyItineraryView()
                }
                .tag(AppTab.itinerary)
                
                NavigationStack {
                    InteractiveMapView()
                }
                .tag(AppTab.map)
                
                NavigationStack {
                    BudgetExpensesView()
                }
                .tag(AppTab.budget)
                
                NavigationStack {
                    SettingsProfileView()
                }
                .tag(AppTab.profile)
            }
            .toolbar(.hidden, for: .tabBar)
            .ignoresSafeArea(edges: .bottom)
            
            // Unified Floating Glassmorphic Bottom Navigation Bar
            if router.isBottomBarVisible {
                FloatingBottomNavBar(selectedTab: $router.selectedTab) { tab in
                    router.switchTab(to: tab)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
}

#Preview {
    MainAppContainerView()
}
