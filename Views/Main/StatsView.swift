import SwiftUI

struct StatsView: View {
    @ObservedObject var viewModel: StatsViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.midnightBlue.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    // Header
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.down")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Text("Statistics")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                        Spacer()
                        Color.clear.frame(width: 30) // Balance
                    }
                    .padding()
                    
                    // Main Ring
                    ZStack {
                        StatsRingView(progress: calculateDailyProgress(), color: .softOrange, lineWidth: 20)
                            .frame(width: 200, height: 200)
                        
                        VStack {
                            Text("\(viewModel.stats.sessionsCompleted)")
                                .font(.system(size: 50, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            Text("Sessions")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical)
                    
                    // Grid Stats
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        StatCard(title: "Total Time", value: formatTime(viewModel.stats.totalFocusTime))
                        StatCard(title: "Current Streak", value: "\(viewModel.stats.currentStreak) days")
                        StatCard(title: "Longest Streak", value: "\(viewModel.stats.longestStreak) days")
                        StatCard(title: "Last Session", value: formatDate(viewModel.stats.lastSessionDate))
                    }
                    .padding()
                    
                    Spacer()
                }
            }
        }
    }
    
    private func calculateDailyProgress() -> Double {
        // Mock daily goal of 4 hours for visualization
        return min(viewModel.stats.totalFocusTime / (4 * 60 * 60), 1.0)
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        return "\(hours)h \(minutes)m"
    }
    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "-" }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 10) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.title3.bold())
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(15)
    }
}

#Preview {
    StatsView(viewModel: StatsViewModel())
}
