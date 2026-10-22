import SwiftUI

enum AppTab: String, CaseIterable, Identifiable {
    case home = "Home"
    case itinerary = "Itinerary"
    case map = "Map"
    case budget = "Budget"
    case profile = "Profile"
    
    static let trips = AppTab.itinerary
    
    var id: String { rawValue }
    
    var iconName: String {
        switch self {
        case .home: return "house.fill"
        case .itinerary: return "calendar"
        case .map: return "map.fill"
        case .budget: return "wallet.pass.fill"
        case .profile: return "person.crop.circle.fill"
        }
    }
}

struct FloatingBottomNavBar: View {
    @Binding var selectedTab: AppTab
    var onTabSelected: ((AppTab) -> Void)? = nil
    
    // Theme Mode
    @Environment(\.colorScheme) private var systemColorScheme
    @AppStorage("appSelectedTheme") private var appSelectedTheme: String = "Dark"
    
    private var isDarkMode: Bool {
        switch appSelectedTheme {
        case "Light": return false
        case "Auto": return systemColorScheme == .dark
        default: return true
        }
    }
    
    // Theme Colors
    private let skyBlue = Color(red: 56/255, green: 189/255, blue: 248/255)
    private var textMuted: Color {
        isDarkMode ? Color(red: 135/255, green: 146/255, blue: 154/255) : Color(red: 100/255, green: 116/255, blue: 139/255)
    }
    private var surfaceBackground: Color {
        isDarkMode ? Color(red: 10/255, green: 14/255, blue: 22/255) : Color(white: 0.98)
    }
    private var borderOutline: Color {
        isDarkMode ? Color.white.opacity(0.12) : Color.black.opacity(0.08)
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases) { tab in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                    onTabSelected?(tab)
                }) {
                    VStack(spacing: 3) {
                        Image(systemName: tab.iconName)
                            .font(.system(size: selectedTab == tab ? 18 : 16, weight: selectedTab == tab ? .bold : .medium))
                            .foregroundColor(selectedTab == tab ? skyBlue : textMuted)
                        
                        Text(tab.rawValue)
                            .font(.system(size: 10, weight: selectedTab == tab ? .bold : .medium, design: .rounded))
                            .foregroundColor(selectedTab == tab ? skyBlue : textMuted)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                }
            }
        }
        .padding(.horizontal, 8)
        .background(surfaceBackground.opacity(0.88))
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(borderOutline, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.6), radius: 18, y: 8)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        FloatingBottomNavBar(selectedTab: .constant(.home))
            .padding()
    }
}
