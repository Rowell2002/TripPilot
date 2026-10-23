//
//  GeofencedAudioGuideDetailView.swift
//  TripPilot
//
//  Created for Stitch Screen ID: fdbc81d9199c40118b04f43c0fde063f
//  Geofenced Landmark Alert & Audio Guide (Fully Functional)
//

import SwiftUI
import MapKit
import AVFoundation

public struct GeofencedAudioGuideDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    // Landmark data
    public var landmark: GeofenceLandmarkData = .defaultShibuya
    
    // Real Audio Voice Engine
    @ObservedObject private var audioPlayer = SpatialAudioGuidePlayer.shared
    @State private var selectedSpeedIndex: Int = 0
    private let speedMultipliers: [Float] = [1.0, 1.25, 1.5, 2.0]
    private let speedLabels: [String] = ["1.0x", "1.25x", "1.5x", "2.0x"]
    
    // Sheets & Modals
    @State private var showARViewSheet: Bool = false
    @State private var showShareSheet: Bool = false
    @State private var showChaptersSheet: Bool = false
    @State private var showTranscriptNotesSheet: Bool = false
    
    // Offline Cache Toggle & Bookmark
    @State private var isOfflineCached: Bool = true
    @ObservedObject private var bookmarkManager = BookmarkManager.shared
    
    // Feedback alerts
    @State private var toastMessage: String? = nil
    
    // Radar pulse animation
    @State private var radarPulse: Bool = false
    
    // Waveform bar heights (25 sample bars)
    private let waveformBars: [CGFloat] = [
        12, 20, 32, 40, 24, 36, 44, 28, 16, 32, 40, 20, 48,
        28, 40, 24, 36, 16, 28, 44, 20, 12, 24, 32, 16
    ]
    
    // Theme Colors matching Stitch specification
    private let bgCanvas = Color(red: 15/255, green: 19/255, blue: 28/255)       // #0f131c
    private let cardSurface = Color(red: 24/255, green: 28/255, blue: 36/255)     // #181c24
    private let darkDock = Color(red: 10/255, green: 14/255, blue: 22/255)       // #0a0e16
    private let primaryCyan = Color(red: 56/255, green: 189/255, blue: 248/255)  // #38bdf8
    private let secondaryMint = Color(red: 68/255, green: 226/255, blue: 205/255)// #44e2cd
    private let borderStroke = Color.white.opacity(0.08)
    private let slateMuted = Color(red: 148/255, green: 163/255, blue: 184/255)  // #94a3b8
    
    public init(landmark: GeofenceLandmarkData = .defaultShibuya) {
        self.landmark = landmark
    }
    
    public var body: some View {
        ZStack {
            bgCanvas.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header Bar
                navigationHeader
                
                // Scrollable Content
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        // 1. Geofence Dynamic Radar Trigger Banner
                        geofenceRadarBanner
                        
                        // 2. Hero Landmark Photography & Visual Framing
                        heroPhotographyCard
                        
                        // 3. Immersive Audio Guide Player Module
                        immersiveAudioPlayerCard
                        
                        // 4. Curated Insights Bento (Trivia & Etiquette)
                        curatedInsightsBento
                        
                        // 5. Offline Cache Status & Utility Dock
                        offlineCacheAndUtilityDock
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                }
            }
            
            // Floating Toast Notice
            if let toastMessage = toastMessage {
                VStack {
                    Spacer()
                    HStack(spacing: 10) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(secondaryMint)
                            .font(.system(size: 16))
                        Text(toastMessage)
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.black.opacity(0.88))
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(borderStroke, lineWidth: 1))
                    .shadow(color: Color.black.opacity(0.4), radius: 10, y: 5)
                    .padding(.bottom, 24)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .zIndex(10)
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            radarPulse = true
            let fullNarrative = "\(landmark.quoteHighlight) \(landmark.quoteText) \(landmark.factDetail) Please remember: \(landmark.etiquetteDetail)"
            audioPlayer.loadGuide(
                title: landmark.audioTitle,
                narrator: landmark.narratorName,
                narrativeText: fullNarrative
            )
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: [
                "🎧 Listening to the geofenced spatial audio guide for \(landmark.name) on TripPilot!",
                URL(string: "https://trippilot.app/landmark/\(landmark.id)") ?? URL(string: "https://trippilot.app")!
            ])
        }
        .fullScreenCover(isPresented: $showARViewSheet) {
            SpatialARViewfinderView(landmark: landmark)
        }
        .sheet(isPresented: $showChaptersSheet) {
            chaptersSelectionSheet
        }
        .sheet(isPresented: $showTranscriptNotesSheet) {
            transcriptNotesSheet
        }
    }
    
    // MARK: - Navigation Header
    private var navigationHeader: some View {
        HStack(spacing: 12) {
            Button(action: {
                audioPlayer.stop()
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Color.white.opacity(0.06))
                    .clipShape(Circle())
            }
            
            HStack(spacing: 6) {
                Image(systemName: "location.north.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(primaryCyan)
                
                Text("TripPilot")
                    .font(.system(size: 17, weight: .heavy, design: .rounded))
                    .foregroundColor(primaryCyan)
            }
            
            Text("Geofenced Landmark Alert")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .lineLimit(1)
                .truncationMode(.tail)
            
            Spacer()
            
            Button(action: {
                showShareSheet = true
            }) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(slateMuted)
                    .frame(width: 38, height: 38)
                    .background(Color.white.opacity(0.06))
                    .clipShape(Circle())
            }
            
            // User Avatar
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [primaryCyan, secondaryMint],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 32, height: 32)
                Text("C")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
            }
            .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 1.5))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(bgCanvas.opacity(0.95))
        .overlay(
            Rectangle()
                .fill(borderStroke)
                .frame(height: 1),
            alignment: .bottom
        )
    }
    
    // MARK: - 1. Geofence Dynamic Radar Trigger Banner
    private var geofenceRadarBanner: some View {
        ZStack(alignment: .trailing) {
            RoundedRectangle(cornerRadius: 16)
                .fill(cardSurface.opacity(0.95))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(borderStroke, lineWidth: 1)
                )
            
            Circle()
                .fill(primaryCyan.opacity(0.12))
                .frame(width: 100, height: 100)
                .blur(radius: 20)
                .offset(x: 20, y: -20)
                .allowsHitTesting(false)
            
            HStack(spacing: 12) {
                // Pulsing Radar Beacon
                ZStack {
                    Circle()
                        .stroke(primaryCyan.opacity(0.25), lineWidth: 1.5)
                        .frame(width: 36, height: 36)
                        .scaleEffect(radarPulse ? 1.4 : 0.8)
                        .opacity(radarPulse ? 0.0 : 0.8)
                        .animation(
                            Animation.easeOut(duration: 1.8).repeatForever(autoreverses: false),
                            value: radarPulse
                        )
                    
                    Circle()
                        .fill(primaryCyan.opacity(0.2))
                        .frame(width: 32, height: 32)
                    
                    Circle()
                        .fill(primaryCyan)
                        .frame(width: 10, height: 10)
                        .shadow(color: primaryCyan, radius: 6)
                }
                .frame(width: 38, height: 38)
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text("GEOFENCE TRIGGERED")
                            .font(.system(size: 11, weight: .heavy, design: .rounded))
                            .foregroundColor(primaryCyan)
                            .tracking(0.6)
                        
                        Text("•  \(landmark.distanceAway)")
                            .font(.system(size: 12, weight: .semibold, design: .monospaced))
                            .foregroundColor(slateMuted)
                    }
                    
                    Text(landmark.locationName)
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundColor(Color.white.opacity(0.9))
                        .lineLimit(1)
                }
                
                Spacer()
                
                // AirPods Ready Pill
                if landmark.isAirPodsReady {
                    Button(action: {
                        showToast("Spatial Audio Output active on Connected Headphones")
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "airpodspro")
                                .font(.system(size: 13))
                                .foregroundColor(primaryCyan)
                            
                            Text("AirPods Ready")
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .foregroundColor(Color.white.opacity(0.85))
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.08))
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(borderStroke, lineWidth: 1))
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
        }
        .shadow(color: Color.black.opacity(0.3), radius: 12, y: 4)
    }
    
    // MARK: - 2. Hero Landmark Photography & Visual Framing
    private var heroPhotographyCard: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                // Photo Image
                AsyncImage(url: URL(string: landmark.imageURLString)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 240)
                            .clipped()
                    case .failure, .empty:
                        ZStack {
                            LinearGradient(
                                colors: [Color(red: 26/255, green: 32/255, blue: 44/255), Color(red: 15/255, green: 19/255, blue: 28/255)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            Image(systemName: "photo.artframe")
                                .font(.system(size: 40))
                                .foregroundColor(slateMuted.opacity(0.4))
                        }
                        .frame(height: 240)
                    @unknown default:
                        EmptyView()
                    }
                }
                
                // Gradient Overlays
                LinearGradient(
                    colors: [
                        Color.black.opacity(0.4),
                        Color.clear,
                        bgCanvas.opacity(0.6),
                        bgCanvas
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                // Top Overlay Micro Chips
                VStack {
                    HStack {
                        HStack(spacing: 5) {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 12))
                                .foregroundColor(primaryCyan)
                            
                            Text(landmark.historicBadge.uppercased())
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .tracking(0.4)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.black.opacity(0.65))
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color.white.opacity(0.12), lineWidth: 1))
                        
                        Spacer()
                        
                        HStack(spacing: 5) {
                            Image(systemName: "photo.stack")
                                .font(.system(size: 11))
                                .foregroundColor(.white)
                            
                            Text(landmark.photoCount)
                                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.black.opacity(0.65))
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color.white.opacity(0.12), lineWidth: 1))
                    }
                    .padding(14)
                    
                    Spacer()
                }
                
                // Bottom Overlay Context
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 8) {
                        Text(landmark.estYear)
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundColor(primaryCyan)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(primaryCyan.opacity(0.18))
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(primaryCyan.opacity(0.4), lineWidth: 1))
                        
                        HStack(spacing: 4) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 12))
                                .foregroundColor(primaryCyan)
                            
                            Text(landmark.ward)
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .foregroundColor(Color.white.opacity(0.85))
                        }
                    }
                    
                    Text(landmark.name)
                        .font(.system(size: 24, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(0.5), radius: 3)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
            }
            .frame(height: 240)
            
            // Quick Micro Info Strip
            HStack(spacing: 12) {
                HStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(primaryCyan.opacity(0.12))
                            .frame(width: 38, height: 38)
                            .overlay(Circle().stroke(primaryCyan.opacity(0.25), lineWidth: 1))
                        
                        Image(systemName: "waveform.badge.magnifyingglass")
                            .font(.system(size: 16))
                            .foregroundColor(primaryCyan)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Spatial Audio Tour")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("\(landmark.audioDuration) • Curated by \(landmark.narratorOrg)")
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .foregroundColor(slateMuted)
                    }
                }
                
                Spacer()
                
                // AR Beacon Button
                Button(action: {
                    showARViewSheet = true
                }) {
                    HStack(spacing: 5) {
                        Image(systemName: "arkit")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(primaryCyan)
                        
                        Text("AR BEACON")
                            .font(.system(size: 10, weight: .heavy, design: .rounded))
                            .foregroundColor(primaryCyan)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(Color.white.opacity(0.08))
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color.white.opacity(0.12), lineWidth: 1))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(cardSurface)
            .overlay(
                Rectangle()
                    .fill(borderStroke)
                    .frame(height: 1),
                alignment: .top
            )
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(borderStroke, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.35), radius: 14, y: 6)
    }
    
    // MARK: - 3. Immersive Audio Guide Player Module
    private var immersiveAudioPlayerCard: some View {
        VStack(spacing: 16) {
            // Title & Narrator Details + Speed Toggle
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("OFFICIAL AUDIO GUIDE")
                        .font(.system(size: 10, weight: .heavy, design: .rounded))
                        .foregroundColor(primaryCyan)
                        .tracking(1.2)
                    
                    Text(landmark.audioTitle)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .lineSpacing(2)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "person.wave.2.fill")
                            .font(.system(size: 12))
                            .foregroundColor(secondaryMint)
                        
                        Text("\(landmark.narratorName) • \(landmark.narratorOrg)")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundColor(slateMuted)
                    }
                    .padding(.top, 2)
                }
                
                Spacer()
                
                // Speed Toggle Button
                Button(action: {
                    selectedSpeedIndex = (selectedSpeedIndex + 1) % speedMultipliers.count
                    audioPlayer.setSpeedMultiplier(speedMultipliers[selectedSpeedIndex])
                    showToast("Playback Speed: \(speedLabels[selectedSpeedIndex])")
                }) {
                    Text(speedLabels[selectedSpeedIndex])
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.08))
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color.white.opacity(0.12), lineWidth: 1))
                }
            }
            
            // Live Synced Waveform Scrubber
            VStack(spacing: 8) {
                GeometryReader { geo in
                    let totalWidth = geo.size.width
                    let barCount = waveformBars.count
                    let spacing: CGFloat = 3
                    let barWidth = max(2, (totalWidth - CGFloat(barCount - 1) * spacing) / CGFloat(barCount))
                    let currentProgressX = totalWidth * CGFloat(audioPlayer.progress)
                    
                    ZStack(alignment: .leading) {
                        // Background track container
                        RoundedRectangle(cornerRadius: 10)
                            .fill(darkDock.opacity(0.8))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.06), lineWidth: 1))
                        
                        // Audio Bars
                        HStack(spacing: spacing) {
                            ForEach(0..<barCount, id: \.self) { index in
                                let barHeight = waveformBars[index]
                                let barX = CGFloat(index) * (barWidth + spacing) + barWidth / 2
                                let isPlayed = barX <= currentProgressX
                                
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(
                                        isPlayed
                                        ? LinearGradient(colors: [primaryCyan, secondaryMint], startPoint: .top, endPoint: .bottom)
                                        : LinearGradient(colors: [Color.white.opacity(0.2), Color.white.opacity(0.1)], startPoint: .top, endPoint: .bottom)
                                    )
                                    .frame(width: barWidth, height: barHeight)
                                    .shadow(color: isPlayed ? primaryCyan.opacity(0.6) : .clear, radius: 4)
                            }
                        }
                        .padding(.horizontal, 8)
                        
                        // Playhead Indicator
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.white)
                            .frame(width: 3, height: 42)
                            .shadow(color: primaryCyan, radius: 8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 2)
                                    .stroke(primaryCyan, lineWidth: 1.5)
                            )
                            .offset(x: max(8, min(totalWidth - 12, currentProgressX)))
                    }
                    .frame(height: 48)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                let newProgress = max(0.0, min(1.0, value.location.x / totalWidth))
                                audioPlayer.seek(to: Double(newProgress))
                            }
                    )
                }
                .frame(height: 48)
                
                // Timestamps & Chapter
                HStack {
                    Text(audioPlayer.currentTimeString)
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(primaryCyan)
                    
                    Spacer()
                    
                    Button(action: {
                        showChaptersSheet = true
                    }) {
                        Text("CHAPTER \(audioPlayer.currentChapterIndex + 1) OF 4")
                            .font(.system(size: 10, weight: .heavy, design: .rounded))
                            .foregroundColor(primaryCyan)
                            .tracking(0.8)
                    }
                    
                    Spacer()
                    
                    Text("03:42")
                        .font(.system(size: 12, weight: .medium, design: .monospaced))
                        .foregroundColor(slateMuted)
                }
            }
            .padding(.top, 4)
            
            // Playback Controls
            HStack(spacing: 36) {
                // Notes / Transcript Button
                Button(action: {
                    showTranscriptNotesSheet = true
                }) {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(slateMuted)
                        .frame(width: 44, height: 44)
                        .background(Color.white.opacity(0.06))
                        .clipShape(Circle())
                }
                
                // Central Glowing Play/Pause Voice Narration Button
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        audioPlayer.togglePlayPause()
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 14/255, green: 165/255, blue: 233/255), // sky-500
                                        primaryCyan
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 64, height: 64)
                            .shadow(color: primaryCyan.opacity(0.6), radius: 18, y: 0)
                        
                        Image(systemName: audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(Color(red: 10/255, green: 14/255, blue: 22/255))
                            .offset(x: audioPlayer.isPlaying ? 0 : 2)
                    }
                }
                .buttonStyle(ScaleButtonStyle())
                
                // Chapters / Grid Button
                Button(action: {
                    showChaptersSheet = true
                }) {
                    Image(systemName: "square.grid.2x2")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(slateMuted)
                        .frame(width: 44, height: 44)
                        .background(Color.white.opacity(0.06))
                        .clipShape(Circle())
                }
            }
            .padding(.vertical, 4)
            
            // Dynamic Synced Live Transcript Card
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(audioPlayer.isPlaying ? secondaryMint : primaryCyan)
                            .frame(width: 6, height: 6)
                            .shadow(color: primaryCyan, radius: 4)
                        
                        Text("LIVE SYNCED TRANSCRIPT")
                            .font(.system(size: 10, weight: .heavy, design: .rounded))
                            .foregroundColor(primaryCyan)
                            .tracking(0.6)
                    }
                    
                    Spacer()
                    
                    Text("EN / JA Subtitles")
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundColor(slateMuted)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(landmark.quoteHighlight)
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(primaryCyan.opacity(0.18))
                        .cornerRadius(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(primaryCyan.opacity(0.3), lineWidth: 1)
                        )
                    
                    Text(landmark.quoteText)
                        .font(.system(size: 13, weight: .regular, design: .rounded))
                        .foregroundColor(slateMuted)
                        .lineSpacing(4)
                }
            }
            .padding(14)
            .background(darkDock.opacity(0.85))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderStroke, lineWidth: 1)
            )
        }
        .padding(16)
        .background(cardSurface.opacity(0.95))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(borderStroke, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.4), radius: 16, y: 6)
    }
    
    // MARK: - 4. Curated Insights Bento (Trivia & Etiquette)
    private var curatedInsightsBento: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Curated Insights")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("2 HIGHLIGHTS")
                    .font(.system(size: 10, weight: .heavy, design: .rounded))
                    .foregroundColor(primaryCyan)
                    .tracking(0.8)
            }
            
            VStack(spacing: 10) {
                // Fact Card 1: Did You Know?
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 6) {
                        Image(systemName: "lightbulb.fill")
                            .font(.system(size: 14))
                            .foregroundColor(secondaryMint)
                        
                        Text("DID YOU KNOW?")
                            .font(.system(size: 10, weight: .heavy, design: .rounded))
                            .foregroundColor(secondaryMint)
                            .tracking(0.6)
                    }
                    
                    Text(landmark.factTitle)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(landmark.factDetail)
                        .font(.system(size: 13, weight: .regular, design: .rounded))
                        .foregroundColor(Color.white.opacity(0.85))
                        .lineSpacing(3)
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(cardSurface.opacity(0.9))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(borderStroke, lineWidth: 1)
                )
                
                // Etiquette Card 2: Local Etiquette Note
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 6) {
                        Image(systemName: "book.closed.fill")
                            .font(.system(size: 14))
                            .foregroundColor(primaryCyan)
                        
                        Text("LOCAL ETIQUETTE NOTE")
                            .font(.system(size: 10, weight: .heavy, design: .rounded))
                            .foregroundColor(primaryCyan)
                            .tracking(0.6)
                    }
                    
                    Text(landmark.etiquetteTitle)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(landmark.etiquetteDetail)
                        .font(.system(size: 13, weight: .regular, design: .rounded))
                        .foregroundColor(Color.white.opacity(0.85))
                        .lineSpacing(3)
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(cardSurface.opacity(0.9))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(borderStroke, lineWidth: 1)
                )
            }
        }
    }
    
    // MARK: - 5. Offline Cache Status & Utility Dock
    private var offlineCacheAndUtilityDock: some View {
        VStack(spacing: 14) {
            // Offline Cache Toggle Row
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(primaryCyan.opacity(0.12))
                        .frame(width: 36, height: 36)
                        .overlay(Circle().stroke(primaryCyan.opacity(0.25), lineWidth: 1))
                    
                    Image(systemName: "arrow.down.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(primaryCyan)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Available Offline")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(landmark.cachedSizeMB)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(slateMuted)
                }
                
                Spacer()
                
                Toggle("", isOn: $isOfflineCached)
                    .labelsHidden()
                    .tint(primaryCyan)
                    .onChange(of: isOfflineCached) { _, newValue in
                        showToast(newValue ? "Audio & 3D AR Assets Cached Locally" : "Offline Cache Cleared")
                    }
            }
            .padding(.bottom, 2)
            
            // Quick Action Buttons
            HStack(spacing: 10) {
                // Save Highlight
                Button(action: {
                    bookmarkManager.toggleBookmark(name: landmark.name)
                    let isSaved = bookmarkManager.isBookmarked(name: landmark.name)
                    showToast(isSaved ? "Saved to Travel Highlights" : "Removed from Highlights")
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: bookmarkManager.isBookmarked(name: landmark.name) ? "bookmark.fill" : "bookmark")
                            .font(.system(size: 14))
                            .foregroundColor(primaryCyan)
                        
                        Text(bookmarkManager.isBookmarked(name: landmark.name) ? "Saved" : "Save Highlight")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(darkDock.opacity(0.9))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(borderStroke, lineWidth: 1)
                    )
                }
                
                // Walk 45m - Opens Apple Maps Walking Navigation
                Button(action: {
                    openWalkingDirections()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 14))
                            .foregroundColor(primaryCyan)
                        
                        Text("Walk \(landmark.distanceAway)")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(darkDock.opacity(0.9))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(borderStroke, lineWidth: 1)
                    )
                }
            }
            
            // Primary Full-Width Spatial AR CTA
            Button(action: {
                showARViewSheet = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "arkit")
                        .font(.system(size: 18, weight: .bold))
                    
                    Text("Launch Spatial AR View")
                        .font(.system(size: 15, weight: .heavy, design: .rounded))
                }
                .foregroundColor(Color(red: 10/255, green: 14/255, blue: 22/255))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(
                        colors: [
                            Color(red: 56/255, green: 189/255, blue: 248/255), // sky-400
                            primaryCyan,
                            secondaryMint
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(Capsule())
                .shadow(color: primaryCyan.opacity(0.5), radius: 14, y: 4)
            }
            .buttonStyle(ScaleButtonStyle())
        }
        .padding(16)
        .background(cardSurface.opacity(0.95))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(borderStroke, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.35), radius: 14, y: 6)
    }
    
    // MARK: - Chapters Selection Sheet
    private var chaptersSelectionSheet: some View {
        NavigationStack {
            ZStack {
                bgCanvas.ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("LANDMARK CHAPTERS")
                                .font(.system(size: 11, weight: .heavy, design: .rounded))
                                .foregroundColor(primaryCyan)
                                .tracking(0.8)
                            Text(landmark.name)
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            showChaptersSheet = false
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(slateMuted)
                                .frame(width: 32, height: 32)
                                .background(Color.white.opacity(0.08))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.top, 16)
                    
                    VStack(spacing: 10) {
                        ForEach(audioPlayer.chapters) { chapter in
                            Button(action: {
                                audioPlayer.jumpToChapter(chapter)
                                showChaptersSheet = false
                                showToast("Jumped to Chapter \(chapter.id + 1)")
                            }) {
                                HStack(spacing: 12) {
                                    ZStack {
                                        Circle()
                                            .fill(audioPlayer.currentChapterIndex == chapter.id ? primaryCyan : Color.white.opacity(0.08))
                                            .frame(width: 32, height: 32)
                                        
                                        Image(systemName: audioPlayer.currentChapterIndex == chapter.id ? "speaker.wave.2.fill" : "play.fill")
                                            .font(.system(size: 12))
                                            .foregroundColor(audioPlayer.currentChapterIndex == chapter.id ? .black : .white)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(chapter.title)
                                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                                            .foregroundColor(audioPlayer.currentChapterIndex == chapter.id ? primaryCyan : .white)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(chapter.duration)
                                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                        .foregroundColor(slateMuted)
                                }
                                .padding(14)
                                .background(cardSurface)
                                .cornerRadius(14)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(audioPlayer.currentChapterIndex == chapter.id ? primaryCyan.opacity(0.5) : borderStroke, lineWidth: 1)
                                )
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Transcript Notes Sheet
    private var transcriptNotesSheet: some View {
        NavigationStack {
            ZStack {
                bgCanvas.ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("AUDIO GUIDE TRANSCRIPT")
                                .font(.system(size: 11, weight: .heavy, design: .rounded))
                                .foregroundColor(primaryCyan)
                                .tracking(0.8)
                            Text(landmark.audioTitle)
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            showTranscriptNotesSheet = false
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(slateMuted)
                                .frame(width: 32, height: 32)
                                .background(Color.white.opacity(0.08))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.top, 16)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 14) {
                            Text(landmark.quoteHighlight)
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .foregroundColor(primaryCyan)
                                .padding(12)
                                .background(primaryCyan.opacity(0.12))
                                .cornerRadius(10)
                            
                            Text(landmark.quoteText)
                                .font(.system(size: 14, weight: .regular, design: .rounded))
                                .foregroundColor(.white)
                                .lineSpacing(6)
                            
                            Text("Historical Note:")
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                                .foregroundColor(secondaryMint)
                                .padding(.top, 6)
                            
                            Text(landmark.factDetail)
                                .font(.system(size: 13, weight: .regular, design: .rounded))
                                .foregroundColor(slateMuted)
                                .lineSpacing(4)
                            
                            Button(action: {
                                UIPasteboard.general.string = "\(landmark.quoteHighlight) \(landmark.quoteText)\n\n\(landmark.factDetail)"
                                showTranscriptNotesSheet = false
                                showToast("Copied full transcript to clipboard")
                            }) {
                                HStack(spacing: 6) {
                                    Image(systemName: "doc.on.doc")
                                    Text("Copy Transcript to Clipboard")
                                }
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(12)
                            }
                            .padding(.top, 10)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Walking Navigation
    private func openWalkingDirections() {
        let lat: Double = landmark.id == "sigiriya_rock" ? 7.9570 : 35.6591
        let lon: Double = landmark.id == "sigiriya_rock" ? 80.7603 : 139.7006
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = landmark.name
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking
        ])
    }
    
    private func showToast(_ message: String) {
        withAnimation(.easeInOut(duration: 0.25)) {
            toastMessage = message
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut(duration: 0.25)) {
                if toastMessage == message {
                    toastMessage = nil
                }
            }
        }
    }
}

// MARK: - Scale Button Style
private struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

#Preview {
    GeofencedAudioGuideDetailView(landmark: .defaultShibuya)
}
