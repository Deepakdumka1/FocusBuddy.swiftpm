import SwiftUI

struct TimerView: View {
    let timeRemaining: TimeInterval
    
    var body: some View {
        Text(timeString(time: timeRemaining))
            .font(.system(size: 80, weight: .light, design: .serif))
            .monospacedDigit() // Prevent jitter
            .foregroundColor(.white.opacity(0.9))
            .shadow(color: .white.opacity(0.3), radius: 10)
            .contentTransition(.numericText())
            .animation(.snappy, value: timeRemaining)
    }
    
    private func timeString(time: TimeInterval) -> String {
        let exactTime = Int(ceil(time))
        let minutes = exactTime / 60
        let seconds = exactTime % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        TimerView(timeRemaining: 1500)
    }
}
