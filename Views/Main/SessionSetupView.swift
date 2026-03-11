import SwiftUI

struct SessionSetupView: View {
    @ObservedObject var viewModel: SessionViewModel
    @ObservedObject var statsViewModel: StatsViewModel
    @State private var showStats = false
    
    @State private var showCustomDurationPicker = false
    @State private var customMinutes: Int = 30
    
    // Animation States
    @State private var isAppeared = false
    @State private var pulseStartButton = false
    
    let durations = [15, 25, 45, 60]
    
    var body: some View {
        ZStack {
            // iOS 26 Fluid Background
            MeshBackgroundView()
            
            VStack(spacing: 0) {
                // Header (Stats)
                HStack {
                    Spacer()
                    Button(action: {
                        showStats = true
                    }) {
                        Image(systemName: "chart.bar.fill")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(12)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 1))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .opacity(isAppeared ? 1 : 0)
                .offset(y: isAppeared ? 0 : -20)
                .animation(.easeOut(duration: 0.8).delay(0.1), value: isAppeared)
                
                Spacer()
                
                // Theme Preview (Dynamic)
                ZStack {
                    // Ambient Glow based on theme
                    Circle()
                        .fill(viewModel.selectedTheme.mainColor.opacity(0.2))
                        .frame(width: 350, height: 350)
                        .blur(radius: 60)
                    
                    FocusObjectView(theme: viewModel.selectedTheme, progress: .constant(1.0), isLit: false)
                        .frame(height: 320)
                        .id(viewModel.selectedTheme) // Force transition
                        .transition(.opacity.combined(with: .scale(scale: 0.9)))
                }
                .padding(.bottom, 20)
                
                Text(viewModel.selectedTheme == .portal ? "Enter the Void" : (viewModel.selectedTheme == .ice ? "Cool Your Mind" : "Light Your Focus"))
                    .font(.system(size: 32, weight: .light, design: .serif))
                    .foregroundColor(.white)
                    .padding(.bottom, 30)
                    .animation(.easeInOut, value: viewModel.selectedTheme)
                    .opacity(isAppeared ? 1 : 0)
                    .scaleEffect(isAppeared ? 1 : 0.9)
                    .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.3), value: isAppeared)
                
                // Theme Selector
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(FocusTheme.allCases) { theme in
                            Button(action: {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                    viewModel.setTheme(theme)
                                }
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: theme.icon)
                                    Text(theme.displayName)
                                }
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .padding(.vertical, 12)
                                .padding(.horizontal, 20)
                                .background(
                                    viewModel.selectedTheme == theme
                                    ? .thinMaterial
                                    : .ultraThinMaterial
                                )
                                .foregroundColor(
                                    viewModel.selectedTheme == theme
                                    ? .white
                                    : .white.opacity(0.5)
                                )
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .stroke(
                                            viewModel.selectedTheme == theme ? Color.white.opacity(0.5) : Color.white.opacity(0.1),
                                            lineWidth: 1
                                        )
                                )
                                .scaleEffect(viewModel.selectedTheme == theme ? 1.05 : 1.0)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 30)
                .opacity(isAppeared ? 1 : 0)
                .offset(x: isAppeared ? 0 : 50)
                .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.4), value: isAppeared)
                
                // Duration Selection
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        // Preset Buttons
                        ForEach(durations, id: \.self) { minutes in
                            DurationButton(
                                minutes: minutes,
                                isSelected: viewModel.selectedDuration == TimeInterval(minutes * 60) && !showCustomDurationPicker,
                                action: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        viewModel.setDuration(minutes)
                                        showCustomDurationPicker = false
                                    }
                                }
                            )
                        }
                        
                        // Custom Button
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                showCustomDurationPicker = true
                            }
                        }) {
                            ZStack {
                                // Background Layer (Deep Glass)
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                showCustomDurationPicker ? Color.white.opacity(0.2) : Color.white.opacity(0.05),
                                                showCustomDurationPicker ? Color.white.opacity(0.1) : Color.clear
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .background(.ultraThinMaterial)
                                    .clipShape(Circle())
                                
                                // Active Glow (Inner)
                                if showCustomDurationPicker {
                                    Circle()
                                        .stroke(
                                            LinearGradient(
                                                colors: [.white.opacity(0.8), .white.opacity(0.1)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1
                                        )
                                        .blur(radius: 2)
                                }
                                
                                // Border/Rim
                                Circle()
                                    .stroke(
                                        LinearGradient(
                                            colors: [
                                                showCustomDurationPicker ? .white : .white.opacity(0.3),
                                                showCustomDurationPicker ? .white.opacity(0.5) : .white.opacity(0.05)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
                                
                                // Content
                                VStack(spacing: 4) {
                                    Image(systemName: "slider.horizontal.3")
                                        .font(.system(size: 20, weight: .light))
                                    Text("Custom")
                                        .font(.system(size: 10, weight: .semibold, design: .serif))
                                        .textCase(.uppercase)
                                        .kerning(1)
                                }
                                .foregroundColor(showCustomDurationPicker ? .white : .white.opacity(0.6))
                                .shadow(color: showCustomDurationPicker ? .white.opacity(0.5) : .clear, radius: 8, x: 0, y: 0)
                            }
                            .frame(width: 80, height: 80)
                            .shadow(
                                color: showCustomDurationPicker ? Color.black.opacity(0.2) : Color.black.opacity(0.1),
                                radius: 10, x: 0, y: 5
                            )
                            .scaleEffect(showCustomDurationPicker ? 1.05 : 1.0)
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 20)
                
                // Custom Picker (Conditional)
                if showCustomDurationPicker {
                    VStack(spacing: 0) {
                        Text("Custom Time")
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .textCase(.uppercase)
                            .foregroundColor(.white.opacity(0.5))
                            .kerning(1.2)
                            .padding(.top, 16)
                            
                        HStack(spacing: 4) {
                            Picker("", selection: $customMinutes) {
                                ForEach(1...180, id: \.self) { min in
                                    Text("\(min)").tag(min)
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(width: 80, height: 90)
                            .clipped()
                            
                            Text("min")
                                .font(.system(size: 16, weight: .medium, design: .serif))
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .padding(.bottom, 8)
                        .onChange(of: customMinutes) { newValue in
                            viewModel.setDuration(newValue)
                        }
                    }
                    .frame(width: 180)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                    .padding(.bottom, 25)
                    .colorScheme(.dark)
                    .transition(.move(edge: .bottom).combined(with: .opacity).combined(with: .scale(scale: 0.9)))
                }
                
                // Start Button
                Button(action: {
                    withAnimation {
                        viewModel.startSession()
                    }
                }) {
                    ZStack {
                        // Glow (Pulsing)
                        RoundedRectangle(cornerRadius: 35)
                            .fill(viewModel.selectedTheme.mainColor)
                            .blur(radius: pulseStartButton ? 25 : 15)
                            .opacity(pulseStartButton ? 0.6 : 0.3)
                            .scaleEffect(pulseStartButton ? 1.05 : 1.0)
                            .padding(10)
                            .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: pulseStartButton)
                        
                        // Button
                        HStack(spacing: 12) {
                            if #available(iOS 17.0, *) {
                                Image(systemName: viewModel.selectedTheme.icon)
                                    .font(.system(size: 22))
                                    .symbolEffect(.bounce, value: viewModel.state) // iOS 17 effect
                            } else {
                                Image(systemName: viewModel.selectedTheme.icon)
                                    .font(.system(size: 22))
                            }
                            Text("Begin Session")
                                .font(.system(size: 20, weight: .medium, design: .serif))
                                .kerning(1)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 70)
                        .background(.thinMaterial)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 40)
                .opacity(isAppeared ? 1 : 0)
                .offset(y: isAppeared ? 0 : 50)
                .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.6), value: isAppeared)
            }
        .onAppear {
            isAppeared = true
            pulseStartButton = true
        }
        .sheet(isPresented: $showStats) {
            StatsView(viewModel: statsViewModel)
        }
    }
}
}

struct DurationButton: View {
    let minutes: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Background Layer (Deep Glass)
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                isSelected ? Color.white.opacity(0.2) : Color.white.opacity(0.05),
                                isSelected ? Color.white.opacity(0.1) : Color.clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                
                // Active Glow (Inner)
                if isSelected {
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(0.8), .white.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                        .blur(radius: 2)
                }
                
                // Border/Rim
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [
                                isSelected ? .white : .white.opacity(0.3),
                                isSelected ? .white.opacity(0.5) : .white.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
                
                // Text
                Text("\(minutes)")
                    .font(.system(size: 28, weight: isSelected ? .medium : .light, design: .serif))
                    .foregroundColor(isSelected ? .white : .white.opacity(0.6))
                    .shadow(color: isSelected ? .white.opacity(0.5) : .clear, radius: 8, x: 0, y: 0)
            }
            .frame(width: 80, height: 80) // Slightly larger
            .shadow(
                color: isSelected ? Color.black.opacity(0.2) : Color.black.opacity(0.1),
                radius: 10, x: 0, y: 5
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
        }
    }
}

#Preview {
    SessionSetupView(viewModel: SessionViewModel(), statsViewModel: StatsViewModel())
}
