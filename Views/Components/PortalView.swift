import SwiftUI

struct PortalView: View {
    @Binding var progress: Double // 1.0 = unstable core, 0.0 = singularity/stable
    
    @State private var rotation = 0.0
    @State private var pulse = 1.0
    @State private var particleOffsets: [CGSize] = Array(repeating: .zero, count: 8)
    
    var body: some View {
        ZStack {
            // Unstable Energy Core
            // As progress decreases (focus increases), core gets smaller, denser, faster
            
            // Outer Ring
            ForEach(0..<3) { i in
                Circle()
                    .trim(from: 0.0, to: 0.7)
                    .stroke(
                        LinearGradient(
                            colors: [.electricPurple, .neonBlue, .clear],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .frame(width: 250, height: 250)
                    .rotationEffect(.degrees(rotation + Double(i * 120)))
                    .scaleEffect(0.8 + (progress * 0.4)) // shrinks
                    .opacity(0.5 + (1.0 - progress) * 0.5)
            }
            .animation(.linear(duration: 10).repeatForever(autoreverses: false), value: rotation)
            
            // Inner Core
            Circle()
                .fill(
                    RadialGradient(
                        colors: [.white, .electricPurple, .black],
                        center: .center,
                        startRadius: 0,
                        endRadius: 100 * (0.5 + progress * 0.5)
                    )
                )
                .frame(width: 150 * (0.5 + progress * 0.5), height: 150 * (0.5 + progress * 0.5))
                .blur(radius: 20 * progress) // Blur decreases as focused
                .scaleEffect(pulse)
                .onAppear {
                    withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                        pulse = 1.1
                    }
                    withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
                        rotation = 360
                    }
                }
            
            // Particles / Debris (Implosion)
            if progress > 0.0 {
                ForEach(0..<8) { i in
                    Circle()
                        .fill(Color.white)
                        .frame(width: 3, height: 3)
                        .offset(x: particleOffsets[i].width, y: particleOffsets[i].height)
                        .opacity(progress)
                        .animation(
                            Animation.linear(duration: Double.random(in: 2...4))
                                .repeatForever(autoreverses: false),
                            value: particleOffsets[i]
                        )
                }
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                rotation = 360
            }
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                pulse = 1.1
            }
            // Trigger Particle Implosion
            for i in 0..<8 {
                // Start far out immediately
                particleOffsets[i] = CGSize(
                    width: CGFloat.random(in: -150...150),
                    height: CGFloat.random(in: -150...150)
                )
            }
            
            // Animate to center
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                for i in 0..<8 {
                    withAnimation(
                        Animation.easeIn(duration: Double.random(in: 1.5...3.0))
                            .repeatForever(autoreverses: false)
                    ) {
                        particleOffsets[i] = .zero
                    }
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        PortalView(progress: .constant(0.8))
    }
}
