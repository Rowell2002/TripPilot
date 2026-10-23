import WidgetKit
import SwiftUI

// MARK: - Timeline Entry
struct StepWidgetEntry: TimelineEntry {
    let date: Date
    let data: TripWidgetSharedData
}

// MARK: - Timeline Provider
struct StepWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> StepWidgetEntry {
        StepWidgetEntry(date: Date(), data: TripWidgetSharedData.load())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (StepWidgetEntry) -> Void) {
        let entry = StepWidgetEntry(date: Date(), data: TripWidgetSharedData.load())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<StepWidgetEntry>) -> Void) {
        let currentData = TripWidgetSharedData.load()
        let currentDate = Date()
        let entry = StepWidgetEntry(date: currentDate, data: currentData)
        
        // Refresh every 15 minutes
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate) ?? currentDate.addingTimeInterval(900)
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

// MARK: - Widget View (Optimized for 2x2 Small Widget)
struct StepWidgetEntryView: View {
    var entry: StepWidgetProvider.Entry
    
    // Theme Colors
    private let primaryCyan = Color(red: 68/255, green: 226/255, blue: 205/255)
    private let skyBlue = Color(red: 56/255, green: 189/255, blue: 248/255)
    private let amberGold = Color(red: 251/255, green: 191/255, blue: 36/255)
    private let bgDark = Color(red: 7/255, green: 12/255, blue: 24/255)
    private let cardNavy = Color(red: 11/255, green: 20/255, blue: 40/255)
    
    var body: some View {
        VStack(spacing: 5) {
            // Header: Branding & Live Pulse
            HStack(alignment: .center, spacing: 4) {
                Image(systemName: "figure.walk")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(primaryCyan)
                
                Text("TRIPPILOT")
                    .font(.system(size: 9, weight: .heavy, design: .rounded))
                    .foregroundColor(Color.white.opacity(0.85))
                    .tracking(1.0)
                
                Spacer()
                
                Circle()
                    .fill(primaryCyan)
                    .frame(width: 5, height: 5)
                    .shadow(color: primaryCyan.opacity(0.8), radius: 3)
            }
            .padding(.horizontal, 2)
            
            Spacer(minLength: 0)
            
            // Center: Circular Progress Gauge
            ZStack {
                // Background Track
                Circle()
                    .stroke(Color.white.opacity(0.08), lineWidth: 6)
                    .frame(width: 78, height: 78)
                
                // Animated Progress Fill
                Circle()
                    .trim(from: 0.0, to: CGFloat(entry.data.progress))
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [primaryCyan, skyBlue, amberGold, primaryCyan]),
                            center: .center,
                            startAngle: .degrees(-90),
                            endAngle: .degrees(270)
                        ),
                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                    )
                    .frame(width: 78, height: 78)
                    .rotationEffect(.degrees(-90))
                    .shadow(color: primaryCyan.opacity(0.4), radius: 4)
                
                // Inner Stat Display
                VStack(spacing: 0) {
                    Text("\(entry.data.steps)")
                        .font(.system(size: 18, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .minimumScaleFactor(0.7)
                        .lineLimit(1)
                    
                    Text("STEPS")
                        .font(.system(size: 7.5, weight: .bold, design: .rounded))
                        .foregroundColor(Color.white.opacity(0.55))
                        .tracking(0.8)
                }
            }
            
            Spacer(minLength: 0)
            
            // Bottom Info: Distance & Ceylon Milestone
            HStack(spacing: 4) {
                // Distance badge
                HStack(spacing: 2) {
                    Text(String(format: "%.1f", entry.data.distanceKm))
                        .font(.system(size: 9.5, weight: .bold, design: .rounded))
                        .foregroundColor(primaryCyan)
                    Text("km")
                        .font(.system(size: 8, weight: .medium))
                        .foregroundColor(Color.white.opacity(0.6))
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(Color.white.opacity(0.06))
                .clipShape(Capsule())
                
                Spacer()
                
                // Milestone Pill
                HStack(spacing: 3) {
                    Image(systemName: entry.data.milestoneIcon)
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(amberGold)
                    
                    Text(entry.data.milestoneBadge)
                        .font(.system(size: 7.5, weight: .bold, design: .rounded))
                        .foregroundColor(amberGold)
                        .minimumScaleFactor(0.75)
                        .lineLimit(1)
                }
                .padding(.horizontal, 5)
                .padding(.vertical, 3)
                .background(amberGold.opacity(0.12))
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(amberGold.opacity(0.3), lineWidth: 0.5)
                )
            }
        }
        .padding(12)
        .widgetURL(URL(string: "trippilot://steps"))
        .containerBackground(for: .widget) {
            ZStack {
                bgDark
                
                LinearGradient(
                    colors: [cardNavy.opacity(0.95), bgDark],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                // Subtle ambient glow
                RadialGradient(
                    colors: [primaryCyan.opacity(0.15), Color.clear],
                    center: .topTrailing,
                    startRadius: 5,
                    endRadius: 90
                )
            }
        }
    }
}

// MARK: - Widget Declaration
struct TripPilotStepWidget: Widget {
    let kind: String = "TripPilotStepWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: StepWidgetProvider()) { entry in
            StepWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Ceylon Step Tracker")
        .description("Track your live walking steps, distance, and Ceylon exploration milestones on your home screen.")
        .supportedFamilies([.systemSmall])
    }
}

// MARK: - Preview
#Preview(as: .systemSmall) {
    TripPilotStepWidget()
} timeline: {
    StepWidgetEntry(
        date: Date(),
        data: TripWidgetSharedData(
            steps: 7420,
            goal: 10000,
            distanceKm: 5.6,
            calories: 304,
            milestoneTitle: "Sigiriya Rock Conqueror",
            milestoneBadge: "6x Sigiriya",
            milestoneIcon: "mountain.2.fill",
            lastUpdated: Date()
        )
    )
}
