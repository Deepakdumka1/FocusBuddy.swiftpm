import SwiftUI
import Combine

enum SessionState {
    case idle
    case focus
    case breakTime
}

@MainActor
class SessionViewModel: ObservableObject {
    @Published var state: SessionState = .idle
    @Published var remainingTime: TimeInterval = 25 * 60
    @Published var totalDuration: TimeInterval = 25 * 60
    @Published var progress: Double = 1.0 // 1.0 = full candle, 0.0 = melted
    @Published var isPaused: Bool = false
    
    private var timer: AnyCancellable?
    private var targetEndTime: Date?
    
    var statsViewModel: StatsViewModel?
    
    // Config
    @Published var selectedDuration: TimeInterval = 25 * 60
    @Published var selectedTheme: FocusTheme = .candle
    
    func setTheme(_ theme: FocusTheme) {
        selectedTheme = theme
    }
    
    func startSession() {
        state = .focus
        remainingTime = selectedDuration
        totalDuration = selectedDuration
        progress = 1.0
        isPaused = false
        targetEndTime = Date().addingTimeInterval(selectedDuration)
        
        startTimer()
        HapticManager.shared.notification(type: .success)
    }
    
    func pauseSession() {
        isPaused.toggle()
        if isPaused {
            timer?.cancel()
        } else {
            targetEndTime = Date().addingTimeInterval(remainingTime)
            startTimer()
        }
        HapticManager.shared.impact(style: .medium)
    }
    
    func stopSession() {
        state = .idle
        timer?.cancel()
        targetEndTime = nil
        remainingTime = selectedDuration
        progress = 1.0
        HapticManager.shared.impact(style: .heavy)
    }
    
    private func startTimer() {
        // Run timer every 0.1s for smoother background resumption UI updates, but 1.0s is fine too
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }
    
    private func tick() {
        guard let target = targetEndTime else { return }
        let now = Date()
        
        if now < target {
            remainingTime = target.timeIntervalSince(now)
            withAnimation(.linear(duration: 1)) {
                progress = remainingTime / totalDuration
            }
        } else {
            remainingTime = 0
            completeSession()
        }
    }
    
    private func completeSession() {
        timer?.cancel()
        targetEndTime = nil
        state = .breakTime
        HapticManager.shared.notification(type: .success)
        statsViewModel?.logSession(duration: totalDuration)
    }
    
    func setDuration(_ minutes: Int) {
        selectedDuration = TimeInterval(minutes * 60)
        remainingTime = selectedDuration
    }
}
