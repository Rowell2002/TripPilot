//
//  SpatialAudioGuidePlayer.swift
//  TripPilot
//
//  Native TTS & Spatial Audio Guide Engine powered by AVFoundation
//

import Foundation
import AVFoundation
import Combine

@MainActor
public final class SpatialAudioGuidePlayer: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    public static let shared = SpatialAudioGuidePlayer()
    
    @Published public var isPlaying: Bool = false
    @Published public var progress: Double = 0.0 // 0.0 to 1.0
    @Published public var currentTimeString: String = "00:00"
    @Published public var totalDurationSeconds: Double = 222.0 // 3 min 42 sec
    @Published public var spokenWordRange: NSRange? = nil
    @Published public var currentChapterIndex: Int = 1 // Chapter 2 of 4 (0-indexed: 1)
    
    private let synthesizer = AVSpeechSynthesizer()
    private var currentText: String = ""
    private var speechRateMultiplier: Float = 1.0
    private var timer: Timer? = nil
    private var elapsedSeconds: Double = 74.0 // starts at 01:14
    
    // Chapters definition
    public struct AudioChapter: Identifiable, Hashable {
        public let id: Int
        public let title: String
        public let duration: String
        public let startSecond: Double
    }
    
    public let chapters: [AudioChapter] = [
        AudioChapter(id: 0, title: "1. The Professor & His Akita Pup", duration: "01:14", startSecond: 0),
        AudioChapter(id: 1, title: "2. The 9-Year Vigil at Shibuya Ticket Barrier", duration: "01:18", startSecond: 74),
        AudioChapter(id: 2, title: "3. Wartime Melting & The 1948 Rebirth", duration: "00:45", startSecond: 152),
        AudioChapter(id: 3, title: "4. A Global Symbol of Eternal Devotion", duration: "00:25", startSecond: 197)
    ]
    
    override private init() {
        super.init()
        synthesizer.delegate = self
        updateTimeString()
        configureAudioSession()
    }
    
    private func configureAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .spokenAudio, options: [.duckOthers])
            try session.setActive(true)
        } catch {
            print("⚠️ AVAudioSession configuration error: \(error.localizedDescription)")
        }
    }
    
    public func loadGuide(title: String, narrator: String, narrativeText: String) {
        self.currentText = narrativeText
        self.progress = elapsedSeconds / totalDurationSeconds
        updateTimeString()
    }
    
    public func togglePlayPause() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    public func play() {
        configureAudioSession()
        
        if synthesizer.isPaused {
            synthesizer.continueSpeaking()
            isPlaying = true
            startTimer()
            return
        }
        
        synthesizer.stopSpeaking(at: .immediate)
        
        let textToSpeak = currentText.isEmpty
            ? "Every afternoon at precisely 3:00 PM, Hachiko would sit patiently outside Shibuya Station's ticket barrier, waiting through Tokyo rain and snow for Professor Ueno's evening commute train. A silent, loyal vigil he kept for nine long years."
            : currentText
        
        let utterance = AVSpeechUtterance(string: textToSpeak)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * speechRateMultiplier
        utterance.pitchMultiplier = 1.05
        utterance.volume = 1.0
        
        // Use high quality English or Japanese voice
        if let voice = AVSpeechSynthesisVoice(language: "en-US") {
            utterance.voice = voice
        }
        
        synthesizer.speak(utterance)
        isPlaying = true
        startTimer()
    }
    
    public func pause() {
        if synthesizer.isSpeaking {
            synthesizer.pauseSpeaking(at: .immediate)
        }
        isPlaying = false
        stopTimer()
    }
    
    public func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        isPlaying = false
        stopTimer()
    }
    
    public func setSpeedMultiplier(_ multiplier: Float) {
        self.speechRateMultiplier = multiplier
        if isPlaying {
            // Restart with updated rate smoothly
            synthesizer.stopSpeaking(at: .immediate)
            play()
        }
    }
    
    public func seek(to normalizedProgress: Double) {
        let clamped = max(0.0, min(1.0, normalizedProgress))
        self.progress = clamped
        self.elapsedSeconds = clamped * totalDurationSeconds
        updateTimeString()
        updateChapterFromElapsed()
        
        if isPlaying {
            synthesizer.stopSpeaking(at: .immediate)
            play()
        }
    }
    
    public func skip(seconds: Double) {
        let newElapsed = max(0.0, min(totalDurationSeconds, elapsedSeconds + seconds))
        seek(to: newElapsed / totalDurationSeconds)
    }
    
    public func jumpToChapter(_ chapter: AudioChapter) {
        self.currentChapterIndex = chapter.id
        self.elapsedSeconds = chapter.startSecond
        self.progress = chapter.startSecond / totalDurationSeconds
        updateTimeString()
        
        if isPlaying {
            synthesizer.stopSpeaking(at: .immediate)
            play()
        }
    }
    
    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            guard let self = self, self.isPlaying else { return }
            let step = 0.5 * Double(self.speechRateMultiplier)
            self.elapsedSeconds = min(self.totalDurationSeconds, self.elapsedSeconds + step)
            self.progress = self.elapsedSeconds / self.totalDurationSeconds
            self.updateTimeString()
            self.updateChapterFromElapsed()
            
            if self.elapsedSeconds >= self.totalDurationSeconds {
                self.elapsedSeconds = 0
                self.progress = 0
                self.pause()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateTimeString() {
        let mins = Int(elapsedSeconds) / 60
        let secs = Int(elapsedSeconds) % 60
        currentTimeString = String(format: "%02d:%02d", mins, secs)
    }
    
    private func updateChapterFromElapsed() {
        if elapsedSeconds < 74 {
            currentChapterIndex = 0
        } else if elapsedSeconds < 152 {
            currentChapterIndex = 1
        } else if elapsedSeconds < 197 {
            currentChapterIndex = 2
        } else {
            currentChapterIndex = 3
        }
    }
    
    // MARK: - AVSpeechSynthesizerDelegate
    nonisolated public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        Task { @MainActor in
            self.isPlaying = false
            self.stopTimer()
        }
    }
    
    nonisolated public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        Task { @MainActor in
            self.spokenWordRange = characterRange
        }
    }
}
