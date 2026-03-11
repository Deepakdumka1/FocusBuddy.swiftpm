import Foundation

enum SessionStatus: String, Codable {
    case completed
    case interrupted
    case inProgress
}

struct FocusSession: Identifiable, Codable {
    var id: UUID = UUID()
    var startTime: Date
    var duration: TimeInterval
    var status: SessionStatus
}
