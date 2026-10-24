# 🌴 TripPilot — Smart AI Sri Lanka Travel Companion

[![iOS](https://img.shields.io/badge/iOS-17.0%2B-blue.svg)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.10%2B-orange.svg)](https://swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-16.0%2B-navy.svg)](https://developer.apple.com/xcode/)
[![Core ML](https://img.shields.io/badge/Core%20ML-Apple%20Neural%20Engine-purple.svg)](https://developer.apple.com/machine-learning/)
[![Tests](https://img.shields.io/badge/Tests-42%20Passing%20(11%20Suites)-success.svg)](https://developer.apple.com/documentation/testing)
[![License](https://img.shields.io/badge/License-MIT-lightgrey.svg)](LICENSE)

**TripPilot** is a production-grade, offline-capable iOS travel companion engineered specifically for exploring **Sri Lanka**. It combines **Apple Intelligence & Core ML**, **MapKit**, **Geofencing & Spatial Audio**, **EventKit Apple Calendar synchronization**, **Core Motion Pedometer**, **LocalAuthentication (Face ID)**, and **WidgetKit** into an ultra-premium glassmorphic interface.

---

## 📸 Overview & Key Features

### 🌟 1. MVP Features

* **Authentication & Onboarding**:
  * 3-step interactive onboarding with travel vibe toggles, companion preference, and pace selection.
  * Multi-provider authentication supporting **Email/Password**, **Google Sign-In**, **Sign in with Apple** (with SHA-256 secure nonce verification), and instant **Guest Exploration Mode**.
* **Settings & Traveler Profile**:
  * Dynamic initials avatar, VIP status badge, and customizable theme mode (**Dark**, **Light**, **System Auto**).
  * Biometric Face ID toggle, CBSL live exchange rate mode (USD/LKR), and downloadable traveler passport QR passes.
* **Home Dashboard**:
  * Context-aware time greetings (*"Ayubowan, Traveler"*).
  * Live unread notification counter, active expedition hero card, quick action toolbar, budget progress ring, and real-time step goals.
* **Firebase Cloud Integration**:
  * Firebase Authentication and session lifecycle management configured in `AppDelegate`.
* **Push Notifications & In-App Alert Center**:
  * Powered by Apple's `UserNotifications` (`UNUserNotificationCenter`).
  * Schedules local stop reminders and arrival announcements with full notification inbox history.
* **Biometric Face ID Protection**:
  * Secure vault lock powered by Apple `LocalAuthentication` (`LAContext`).
  * Enforces Face ID upon cold launch and background-to-foreground transitions (`ScenePhase`), with device passcode fallback.
* **AI Trip Planner Wizard**:
  * Multi-step expedition generator allowing users to specify exact duration (e.g., 4 days, 12 days), exact future start date, traveler type, pace, and vibes.
* **Budget & Expense Manager**:
  * Interactive canvas donut chart with category envelopes (*Stay*, *Food*, *Transport*, *Activities*).
  * Live currency conversion (USD/LKR) and VisionKit-powered receipt scanner.
* **Daily Itinerary & EventKit Calendar Sync**:
  * Chronological day-by-day timeline with stop timings, ticket passes, weather forecasts, and custom stop additions.
  * Full Apple Calendar synchronization via `EventKit` (`EKEventStore`) with smart alarms and direct deep-linking (`calshow:`).

---

### 🚀 2. Advanced Features

* **MapKit 3D Interactive Map**:
  * Custom interactive map annotations for 40+ Sri Lankan landmarks across Cultural, Nature, Beach, and Food categories.
  * Programmatic 3D camera flyovers using `MapCameraPosition.camera(...)` with smooth zoom and pitch transitions.
* **Geofencing & Spatial Audio Guides**:
  * Background boundary monitoring using CoreLocation (`CLCircularRegion`) with automated arrival alerts when within 200m of landmarks.
  * Immersive spatial audio guides powered by `AVFoundation` with interactive audio scrubbing and voice narration.
* **Core ML On-Device Recommendation Engine**:
  * Custom-trained **Boosted Tree Regressor** (`TripMatchRegressor`) and **Classifier** (`TripSlotClassifier`) running natively on the **Apple Neural Engine**.
  * Predicts personalized traveler affinity match percentages (e.g., 94% Match) and optimal time slots (Morning, Midday, Sunset, Evening).

---

### 📄 3. Other Features

* **PDFKit Travel Passport Generator**:
  * Generates high-resolution vector PDF documents using `UIGraphicsPDFRenderer`.
  * Embeds official branding, QR validation codes, passenger details, itinerary timelines, and emergency contacts with native iOS Share Sheet export.

---

### ✨ 4. Extra Features

* **Core Motion Pedometer (`CMPedometer`)**:
  * Live walking step counter, distance in kilometers, active calories burned, and daily milestone goal progress rings.
* **Vintage Polaroid Memories Scrapbook**:
  * Digital instant camera photo album saving compressed memories to app sandbox storage with handwritten captions and location tags.
* **Standalone iOS Home Screen Widget (`WidgetKit`)**:
  * Live Small, Medium, and Large widgets showing today's next scheduled stop, destination region, and live step counts shared via App Groups (`group.NIBM.TripPilot`).

---

## 🏛 Architecture & Tech Stack

TripPilot follows the **MVVM (Model-View-ViewModel)** architectural pattern with dedicated singleton services for Apple hardware and system frameworks:

```
TripPilot/
├── App/
│   ├── TripPilotApp.swift              # Main application entry point & AppDelegate
│   └── ContentView.swift               # Root navigation router & Face ID lock gateway
├── Models/
│   ├── SriLankaModels.swift            # Core trip, stop, day, and landmark data models
│   ├── ThemeAppearanceMode.swift       # Color scheme appearance management
│   ├── PolaroidMoment.swift            # Digital scrapbook data model
│   └── TripWidgetSharedData.swift      # App Group data model for WidgetKit
├── ViewModels/
│   ├── AuthViewModel.swift             # Global session and user state
│   ├── HomeDashboardViewModel.swift    # Dashboard aggregations and greetings
│   ├── DailyItineraryViewModel.swift   # Itinerary timeline state management
│   ├── BudgetExpensesViewModel.swift   # Currency & expense calculations
│   └── TripGeneratorWizardViewModel.swift # AI trip generator state
├── Views/
│   ├── Auth/                           # Sign in, Sign up, Onboarding, AppLockView
│   ├── Dashboard/                      # Home dashboard, notification inbox, analytics
│   ├── Itinerary/                      # Itinerary timeline, Trip Wizard, Calendar View
│   ├── Explore/                        # MapKit view, Audio guide player, Place detail
│   ├── Budget/                         # Expense logger, Donut chart, Receipt scanner
│   ├── Profile/                        # Settings, themes, Face ID toggle, PDF viewer
│   └── Components/                     # Floating bottom nav bar, share sheets, cards
├── Services/
│   ├── BiometricLockManager.swift      # LocalAuthentication (Face ID) lifecycle
│   ├── TripMLRecommenderService.swift  # Core ML on-device inference engine
│   ├── TripCalendarSyncService.swift   # EventKit Apple Calendar synchronization
│   ├── NotificationManager.swift       # UNUserNotificationCenter & Geofencing
│   ├── SpatialAudioGuidePlayer.swift   # AVFoundation audio player engine
│   ├── TripStepTrackerService.swift    # Core Motion pedometer tracking
│   ├── PolaroidGalleryService.swift    # Photo sandbox storage & metadata
│   ├── PDF/PassportPDFGenerator.swift  # PDFKit vector travel document generator
│   └── SriLankaDataService.swift       # Offline database & trip generation logic
├── TripPilotWidget/                    # WidgetKit extension bundle & timeline provider
└── TripPilotTests/                     # Comprehensive unit & integration test suites
```

### Apple Frameworks Utilized

| Framework | Purpose in TripPilot |
| :--- | :--- |
| **SwiftUI** | Modern declarative user interface with glassmorphic design tokens |
| **Core ML / Create ML** | Personalized destination affinity regression and optimal time-slot classification |
| **MapKit** | Interactive 3D vector map, custom annotations, and camera flyovers |
| **CoreLocation** | GPS coordinates, landmark proximity, and circular geofence monitoring |
| **LocalAuthentication** | Biometric Face ID / Touch ID app lock protection and security vaults |
| **EventKit** | Apple Calendar event synchronization, alarms, and `calshow:` deep-linking |
| **Core Motion** | Hardware pedometer step counting, distance estimation, and calorie metrics |
| **PDFKit** | Vector travel passport generation and in-app document viewing |
| **AVFoundation** | Spatial audio guide playback and text-to-speech landmark narration |
| **UserNotifications** | Local push notifications, geofence alerts, and notification inbox |
| **WidgetKit** | Home Screen timeline widgets sharing data via App Groups |

---

## 🧪 Testing & Verification

TripPilot includes **42 automated unit and integration tests** across **11 test suites** using Apple's new **Swift Testing** library and **XCTest**:

```bash
# Run all unit tests on the iOS Simulator via CLI:
xcodebuild test \
  -project TripPilot.xcodeproj \
  -scheme TripPilot \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

### Verified Test Suites:
1. `Biometric Lock & Face ID App Protection Suite` (Lifecycle & ScenePhase transitions)
2. `Trip Calendar Sync & EventKit Integration Suite` (Date ranges & duplicate prevention)
3. `Core ML Recommender & Inference Engine Suite` (Apple Neural Engine prediction bounds)
4. `Explore Map, Push Notifications & PDF Generation Suite` (Map routes & PDF binary data)
5. `Trip Manager Itinerary Engine Logic Suite` (Stop reordering & dynamic day allocation)
6. `Budget & Expenses Business Logic Suite` (CBSL FX conversion & envelope clamps)
7. `Polaroid Memories & Gallery Storage Suite` (Image sandbox lifecycle)
8. `Authentication & User Session Logic Suite` (Guest identity & display names)
9. `Bookmark & Saved Places Business Logic Suite` (Persistent place toggles)
10. `Trip Wizard, Dashboard & Onboarding ViewModels Suite` (Form validation & tags)
11. `Sri Lanka Domain & Hardware Services Suite` (Places database integrity & geocoordinates)

**Result**: `** TEST SUCCEEDED **` (42/42 Tests Passing).

---

## 🚀 Getting Started

### Prerequisites
* **macOS**: Sonoma 14.0 or higher
* **Xcode**: 16.0 or higher
* **Target OS**: iOS 17.0+
* **Dependencies**: Swift Package Manager (managed within `TripPilot.xcodeproj`)

### Setup Instructions
1. **Clone the repository**:
   ```bash
   git clone https://github.com/Rowell2002/TripPilot.git
   cd TripPilot
   ```
2. **Open in Xcode**:
   ```bash
   open TripPilot.xcodeproj
   ```
3. **Select Scheme & Device**:
   * Scheme: `TripPilot`
   * Target: Any iOS 17+ Simulator (e.g., iPhone 17 or iPhone 16 Pro)
4. **Build & Run**:
   * Press `Cmd + R` in Xcode or run:
   ```bash
   xcodebuild build -project TripPilot.xcodeproj -scheme TripPilot -destination 'platform=iOS Simulator,name=iPhone 17'
   ```

---

## 🔒 Permissions & Privacy Entitlements

The application includes user-facing usage descriptions in `Info.plist` / `project.pbxproj`:
* `NSFaceIDUsageDescription`: Required for biometric app lock protection.
* `NSCalendarsFullAccessUsageDescription`: Required for syncing expeditions to Apple Calendar.
* `NSLocationWhenInUseUsageDescription`: Required for interactive map and geofence detection.
* `NSMotionUsageDescription`: Required for pedometer step counting and walking distance.
* `NSCameraUsageDescription`: Required for taking polaroid photos and scanning expense receipts.
* `NSPhotoLibraryUsageDescription`: Required for selecting and saving polaroid scrapbook photos.

---

## 👨‍💻 Author & Acknowledgements

* **Author**: Chethana Rowell
* **Institution**: National Institute of Business Management (NIBM)
* **Project**: Final Year Mobile Application Development Project — *TripPilot iOS*