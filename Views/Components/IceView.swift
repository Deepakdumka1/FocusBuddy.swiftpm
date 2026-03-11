import SwiftUI

struct IceView: View {
    @Binding var progress: Double // 1.0 = full cube, 0.0 = melted puddle
    
    @State private var glisten = false
    @State private var vapor = false
    
    var body: some View {
        ZStack {
            // Puddle (Base)
            // Grows as progress decreases
            Ellipse()
                .fill(
                    LinearGradient(colors: [.white.opacity(0.6), .cyan.opacity(0.3)], startPoint: .center, endPoint: .bottom)
                )
                .frame(width: 200 + (1.0 - progress) * 100, height: 40 + (1.0 - progress) * 40)
                .blur(radius: 10)
                .offset(y: 120)
                .opacity(1.0 - progress)
            
            // Ice Cube
            GeometryReader { geometry in
                let size = geometry.size
                let height = size.height * 0.6 // Max height of cube
                let currentHeight = height * max(0.1, progress) // Shrinks but keeps some base
                
                ZStack {
                    // Main Cube Body
                    RoundedRectangle(cornerRadius: 30)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.9),
                                    Color.cyan.opacity(0.4),
                                    Color.blue.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: size.width * 0.6, height: currentHeight)
                        .overlay(
                            // Glisten Effect
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        colors: [.clear, .white.opacity(0.4), .clear],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 50)
                                .offset(x: glisten ? 200 : -200)
                                .mask(RoundedRectangle(cornerRadius: 30))
                        )
                    
                    // Internal Reflections/Cracks
                    Path { path in
                        path.move(to: CGPoint(x: size.width * 0.3, y: size.height * 0.3))
                        path.addLine(to: CGPoint(x: size.width * 0.4, y: size.height * 0.4))
                        path.addLine(to: CGPoint(x: size.width * 0.35, y: size.height * 0.5))
                    }
                    .stroke(Color.white.opacity(0.4), lineWidth: 2)
                    .offset(y: -(height - currentHeight) / 2) // Move down as it melts
                    
                    // Cold Vapor / Mist (Animated)
                    if progress < 0.95 {
                        ForEach(0..<3) { i in
                            Circle()
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 10 + CGFloat(i * 5), height: 10 + CGFloat(i * 5))
                                .blur(radius: 5)
                                .offset(y: -currentHeight / 2 - 20 - (vapor ? 30 : 0))
                                .opacity(vapor ? 0 : 0.5)
                                .animation(
                                    Animation.easeInOut(duration: 2.0)
                                        .repeatForever(autoreverses: false)
                                        .delay(Double(i) * 0.5),
                                    value: vapor
                                )
                        }
                    }
                }
                .position(x: size.width / 2, y: size.height - (currentHeight / 2) - 40) // Anchor to bottom
                .onAppear {
                    withAnimation(.linear(duration: 3).repeatForever(autoreverses: false).delay(1)) {
                        glisten = true
                    }
                    withAnimation {
                        vapor = true
                    }
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        IceView(progress: .constant(0.5))
            .frame(width: 300, height: 400)
    }
}
