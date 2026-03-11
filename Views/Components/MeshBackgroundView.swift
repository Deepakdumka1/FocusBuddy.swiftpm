import SwiftUI

struct MeshBackgroundView: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            Color.deepSpace.ignoresSafeArea()
            
            // Orb 1
            Circle()
                .fill(Color.neonBlue.opacity(0.4))
                .frame(width: 300, height: 300)
                .blur(radius: 80)
                .offset(x: animate ? -100 : 100, y: animate ? -150 : 100)
                .animation(.easeInOut(duration: 10).repeatForever(autoreverses: true), value: animate)
            
            // Orb 2
            Circle()
                .fill(Color.electricPurple.opacity(0.4))
                .frame(width: 350, height: 350)
                .blur(radius: 80)
                .offset(x: animate ? 150 : -100, y: animate ? 100 : -150)
                .animation(.easeInOut(duration: 12).repeatForever(autoreverses: true), value: animate)
            
            // Orb 3
            Circle()
                .fill(Color.vividOrange.opacity(0.2))
                .frame(width: 400, height: 400)
                .blur(radius: 100)
                .offset(x: animate ? -50 : 50, y: animate ? 150 : -50)
                .animation(.easeInOut(duration: 15).repeatForever(autoreverses: true), value: animate)
            
            // Overlay Texture (Grain)
            // Simulating "Materials"
            Color.white.opacity(0.02)
                .blendMode(.overlay)
        }
        .onAppear {
            animate = true
        }
        .ignoresSafeArea()
    }
}

#Preview {
    MeshBackgroundView()
}
