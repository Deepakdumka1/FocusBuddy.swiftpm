import SwiftUI
import Combine

@MainActor
class StatsViewModel: ObservableObject {
    @Published var stats: UserStats = UserStats.empty
    private let storageKey = "focusbuddy_stats"
    
    init() {
        loadStats()
    }
    
    func loadStats() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode(UserStats.self, from: data) {
            stats = decoded
        }
    }
    
    func saveStats() {
        if let encoded = try? JSONEncoder().encode(stats) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    func logSession(duration: TimeInterval) {
        stats.totalFocusTime += duration
        stats.sessionsCompleted += 1
        
        let calendar = Calendar.current
        if let lastDate = stats.lastSessionDate {
            if calendar.isDateInYesterday(lastDate) {
                stats.currentStreak += 1
            } else if !calendar.isDateInToday(lastDate) {
                stats.currentStreak = 1
            }
        } else {
            stats.currentStreak = 1
        }
        
        if stats.currentStreak > stats.longestStreak {
            stats.longestStreak = stats.currentStreak
        }
        
        stats.lastSessionDate = Date()
        saveStats()
    }
}
