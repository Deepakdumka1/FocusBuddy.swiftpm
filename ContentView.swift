import SwiftUI

struct ContentView: View {
    @StateObject private var sessionViewModel = SessionViewModel()
    @StateObject private var statsViewModel = StatsViewModel()
    
    var body: some View {
        ZStack {
            Color.deepSpace.ignoresSafeArea()
            
            switch sessionViewModel.state {
            case .idle:
                SessionSetupView(viewModel: sessionViewModel, statsViewModel: statsViewModel)
                    .transition(.opacity)
                    .zIndex(1)
            case .focus:
                FocusSessionView(viewModel: sessionViewModel)
                    .transition(.opacity)
                    .zIndex(1)
            case .breakTime:
                BreakView(viewModel: sessionViewModel)
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: sessionViewModel.state)
        .onAppear {
            sessionViewModel.statsViewModel = statsViewModel
        }
    }
}

#Preview {
    ContentView()
}
