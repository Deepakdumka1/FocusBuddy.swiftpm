import SwiftUI

struct FocusSessionView: View {
    @ObservedObject var viewModel: SessionViewModel
    @State private var deepFocusMode = false
    @State private var isBreathing = false
    
    var body: some View {
        ZStack {
            // Background
            MeshBackgroundView()
            
            // Main Content
            VStack {
                Spacer()
                
                ZStack {
                    // Back Glow (Dynamic based on theme)
                    Circle()
                        .fill(viewModel.selectedTheme.mainColor.opacity(0.1))
                        .frame(width: 350, height: 350)
                        .blur(radius: isBreathing ? 100 : 80)
                        .opacity(isBreathing ? 0.6 : 0.3)
                        .scaleEffect(isBreathing ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: isBreathing)
                        .onAppear { isBreathing = true }
                    
                    FocusObjectView(theme: viewModel.selectedTheme, progress: $viewModel.progress)
                        .frame(height: 380)
                        .id(viewModel.selectedTheme)
                }
                .padding(.bottom, 20)
                
                if !deepFocusMode {
                    TimerView(timeRemaining: viewModel.remainingTime)
                        .transition(.opacity)
                }
                
                Spacer()
                
                // Controls
                if !deepFocusMode {
                    HStack(spacing: 50) {
                        Button(action: {
                            withAnimation {
                                viewModel.pauseSession()
                            }
                        }) {
                            Image(systemName: viewModel.isPaused ? "play.fill" : "pause.fill")
                                .font(.title)
                                .foregroundColor(.white)
                                .frame(width: 70, height: 70)
                                .background(
                                    viewModel.isPaused
                                    ? .thinMaterial
                                    : .ultraThinMaterial
                                )
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                                .shadow(color: viewModel.isPaused ? Color.white.opacity(0.1) : .clear, radius: 10)
                        }
                        .buttonStyle(BounceButtonStyle())
                        
                        Button(action: {
                            withAnimation {
                                viewModel.stopSession()
                            }
                        }) {
                            Image(systemName: "xmark")
                                .font(.title)
                                .foregroundColor(.white)
                                .frame(width: 70, height: 70)
                                .background(Color.red.opacity(0.2))
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.red.opacity(0.3), lineWidth: 1)
                                )
                        }
                        .buttonStyle(BounceButtonStyle())
                    }
                    .padding(.bottom, 50)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .onTapGesture {
                // Toggle Deep Focus Mode controls opacity
                if viewModel.state == .focus {
                    withAnimation {
                        deepFocusMode.toggle()
                    }
                }
            }
        }
    }
}

#Preview {
    FocusSessionView(viewModel: SessionViewModel())
}

struct BounceButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
