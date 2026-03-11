import Foundation

struct UserStats: Codable {
    var totalFocusTime: TimeInterval = 0
    var sessionsCompleted: Int = 0
    var currentStreak: Int = 0
    var longestStreak: Int = 0
    var lastSessionDate: Date?
    
    static let empty = UserStats()
}
