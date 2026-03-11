<div align="center">
  <img src="https://raw.githubusercontent.com/deepakdumka/FocusBuddy/main/Assets/AppIcon.png" width="120" alt="FocusBuddy Icon" onerror="this.style.display='none'">
  <h1>🎯 FocusBuddy</h1>
  <p>An immersive, beautifully designed focus timer built completely in SwiftUI.</p>
  
  [![Swift 6.0](https://img.shields.io/badge/Swift-6.0-orange.svg?style=flat)](https://swift.org)
  [![iOS 16.0](https://img.shields.io/badge/iOS-16.0%2B-blue.svg?style=flat)]()
  [![SwiftUI](https://img.shields.io/badge/UI-SwiftUI-3eb489.svg?style=flat)]()
  
</div>

<br>

**FocusBuddy** is not just another Pomodoro timer; it's a visual companion that helps you stay in the zone. By utilizing custom immersive themes that physically react as your session progresses (like a melting candle or dissolving ice), it turns productivity into a beautiful experience.

## ✨ Features

- **🎨 Interactive Visual Themes:** Stop staring at just numbers. Watch your focus time take physical form with interactive shapes:
  - 🕯️ **Candle:** Gradually melts with dynamic `FlameView` and `WaxDripView`.
  - 🧊 **Ice:** Slowly dissolves as your session progresses.
  - 🌀 **Portal:** An engaging shifting space element.
  - ⏳ **Hourglass:** A classic timekeeper visualizing the sands of time.
- **📈 Productivity Tracking:** Seamlessly track your `total focus time`, `sessions completed`, and `streaks` to stay motivated.
- **🌌 Immersive UI:** A stunning mesh-gradient background (`Color.deepSpace`) combined with custom spatial animations to minimize distractions.
- **📳 Haptic Feedback:** Intelligent Apple Taptic Engine integration giving you physical taps when sessions begin, pause, or end.

---

## 📸 Screenshots

*(Replace these with your actual screenshots)*

<div align="center">
  <img src="https://placehold.co/250x541/111116/FFFFFF.png?text=Main+Timer" alt="Main Timer View" width="200" style="margin: 10px; border-radius: 20px;">
  <img src="https://placehold.co/250x541/111116/FFFFFF.png?text=Select+Theme" alt="Theme Selector" width="200" style="margin: 10px; border-radius: 20px;">
  <img src="https://placehold.co/250x541/111116/FFFFFF.png?text=User+Stats" alt="Statistics View" width="200" style="margin: 10px; border-radius: 20px;">
</div>

---

## 🏗️ Architecture

The app is built using the robust **MVVM (Model-View-ViewModel)** design pattern with robust separation of concerns, ensuring high maintainability and testability:

- **`Views/`**: Contains the visual SwiftUI layer.
  - **`Main/`**: Core interfaces (`ContentView`, `FocusSessionView`, `SessionSetupView`, `StatsView`).
  - **`Components/`**: Reusable micro-components like `MeshBackgroundView`, `TimerView`, `StatsRingView`, and individual theme visuals (`CandleView`, `IceView`, etc.).
- **`ViewModels/`**: Powers the business logic.
  - `SessionViewModel.swift`: Orchestrates the main timer, session states, and configures themes.
  - `StatsViewModel.swift`: Computes statistics, calculates streaks, and logs sessions.
- **`Models/`**: The core data structures powering state (`FocusTheme.swift`, `UserStats.swift`, `FocusSession.swift`).
- **`Services/`**: Background worker singletons like `HapticManager`.

## 🚀 Getting Started

To run this app on your local machine:

### Prerequisites
- **Xcode**. (Tested with modern versions supporting Swift 6.0)
- Target deployment is **iOS 16.0+** or **iPadOS 16.0+**.

### Installation
1. Clone the repository or download the `.swiftpm` package.
2. Double-click `FocusBuddy.swiftpm` to open it in **Swift Playgrounds** (on iPad/Mac) or **Xcode**.
3. Select an iOS/iPadOS Simulator or your physical device.
4. Hit **Run (`⌘R`)** and enter flow state!

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the issues page.

## 📝 License

This project is open-source. Feel free to use and modify it as you see fit.

<div align="center">
  <p>Built with ❤️ by <a href="https://github.com/deepakdumka">Deepak Dumka</a></p>
</div>
