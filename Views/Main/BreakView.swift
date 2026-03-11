import SwiftUI

struct BreakView: View {
    @ObservedObject var viewModel: SessionViewModel
    @State private var breatheIn = false
    
    var body: some View {
        ZStack {
            Color(red: 0.85, green: 0.92, blue: 1.0).ignoresSafeArea() // Light Blue
            
            VStack(spacing: 40) {
                Text("Rest your mind")
                    .font(.system(.largeTitle, design: .rounded).weight(.bold))
                    .foregroundColor(Color.midnightBlue)
                
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.5))
                        .frame(width: 200, height: 200)
                        .scaleEffect(breatheIn ? 1.2 : 0.8)
                    
                    Circle()
                        .fill(Color.white)
                        .frame(width: 150, height: 150)
                        .scaleEffect(breatheIn ? 1.0 : 0.6)
                    
                    Text(breatheIn ? "Exhale" : "Inhale")
                        .font(.title2)
                        .foregroundColor(Color.midnightBlue)
                        .animation(.none, value: breatheIn) // Text changes instantly or with crossfade? Keep simple.
                }
                .onAppear {
                    withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                        breatheIn.toggle()
                    }
                }
                
                Button(action: {
                    withAnimation {
                        viewModel.state = .idle
                    }
                }) {
                    Text("End Break")
                        .font(.headline)
                        .padding()
                        .background(Color.midnightBlue)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                }
            }
        }
    }
}
