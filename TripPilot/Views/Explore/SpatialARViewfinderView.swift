import SwiftUI

public struct SpatialARViewfinderView: View {
    @Environment(\.dismiss) private var dismiss
    public let landmark: GeofenceLandmarkData
    
    @State private var compassHeading: Double = 18.0
    @State private var distanceMetres: Int = 45
    @State private var pulseBeacon: Bool = false
    @State private var isBeaconLocked: Bool = false
    @State private var showCapturedNotice: Bool = false
    
    // Theme Colors
    private let primaryCyan = Color(red: 56/255, green: 189/255, blue: 248/255)
    private let secondaryMint = Color(red: 68/255, green: 226/255, blue: 205/255)
    
    public init(landmark: GeofenceLandmarkData = .defaultShibuya) {
        self.landmark = landmark
    }
    
    public var body: some View {
        ZStack {
            // Simulated AR Camera Feed Background with dynamic subtle grid
            Color.black.ignoresSafeArea()
            
            // Atmospheric camera bokeh / dark camera background
            LinearGradient(
                colors: [
                    Color(red: 10/255, green: 18/255, blue: 30/255).opacity(0.85),
                    Color(red: 5/255, green: 8/255, blue: 15/255)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // AR Horizon / Perspective Grid
            GeometryReader { geo in
                Path { path in
                    let midY = geo.size.height * 0.55
                    path.move(to: CGPoint(x: 0, y: midY))
                    path.addLine(to: CGPoint(x: geo.size.width, y: midY))
                    
                    // Grid lines radiating to horizon
                    for i in 0..<8 {
                        let startX = CGFloat(i) * (geo.size.width / 7)
                        path.move(to: CGPoint(x: geo.size.width / 2, y: midY))
                        path.addLine(to: CGPoint(x: startX, y: geo.size.height))
                    }
                }
                .stroke(primaryCyan.opacity(0.12), lineWidth: 1)
            }
            .ignoresSafeArea()
            
            // Center Floating AR Beacon Object
            VStack(spacing: 8) {
                // Pulsing rings around beacon pin
                ZStack {
                    Circle()
                        .stroke(primaryCyan.opacity(0.3), lineWidth: 2)
                        .frame(width: 80, height: 80)
                        .scaleEffect(pulseBeacon ? 1.5 : 0.8)
                        .opacity(pulseBeacon ? 0.0 : 0.8)
                        .animation(
                            Animation.easeOut(duration: 1.5).repeatForever(autoreverses: false),
                            value: pulseBeacon
                        )
                    
                    Circle()
                        .fill(primaryCyan.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [primaryCyan, secondaryMint],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 32, height: 32)
                        .shadow(color: primaryCyan.opacity(0.8), radius: 12)
                    
                    Image(systemName: "arkit")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                }
                
                // Floating Holographic Tag
                VStack(spacing: 4) {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(secondaryMint)
                            .frame(width: 6, height: 6)
                        
                        Text(landmark.name)
                            .font(.system(size: 13, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                    }
                    
                    Text("\(distanceMetres)m Ahead • Bearing 018° NNE")
                        .font(.system(size: 11, weight: .semibold, design: .monospaced))
                        .foregroundColor(primaryCyan)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color.black.opacity(0.75))
                .clipShape(Capsule())
                .overlay(Capsule().stroke(primaryCyan.opacity(0.6), lineWidth: 1.5))
                .shadow(color: primaryCyan.opacity(0.4), radius: 10)
            }
            .offset(y: -40)
            
            // Top HUD Bar
            VStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 38, height: 38)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    // Compass Pill
                    HStack(spacing: 6) {
                        Image(systemName: "location.north.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(primaryCyan)
                        Text("HDG 018° NNE")
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.black.opacity(0.6))
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color.white.opacity(0.15), lineWidth: 1))
                    
                    Spacer()
                    
                    Button(action: {
                        showCapturedNotice = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showCapturedNotice = false
                        }
                    }) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                            .frame(width: 38, height: 38)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                
                Spacer()
                
                // Bottom Spatial AR Control Dock
                VStack(spacing: 12) {
                    if showCapturedNotice {
                        Text("📸 Spatial AR Screenshot Saved to Photos")
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundColor(secondaryMint)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(Color.black.opacity(0.8))
                            .clipShape(Capsule())
                            .transition(.opacity)
                    }
                    
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("SPATIAL AR TRACKER ACTIVE")
                                .font(.system(size: 10, weight: .heavy, design: .rounded))
                                .foregroundColor(primaryCyan)
                                .tracking(0.8)
                            Text(landmark.locationName)
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            isBeaconLocked.toggle()
                        }) {
                            HStack(spacing: 5) {
                                Image(systemName: isBeaconLocked ? "lock.fill" : "lock.open.fill")
                                    .font(.system(size: 12))
                                Text(isBeaconLocked ? "LOCKED" : "LOCK BEACON")
                                    .font(.system(size: 11, weight: .heavy, design: .rounded))
                            }
                            .foregroundColor(isBeaconLocked ? .black : .white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(isBeaconLocked ? secondaryMint : Color.white.opacity(0.12))
                            .clipShape(Capsule())
                        }
                    }
                    .padding(14)
                    .background(Color(red: 24/255, green: 28/255, blue: 36/255).opacity(0.95))
                    .cornerRadius(18)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                    )
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
        .onAppear {
            pulseBeacon = true
        }
    }
}
