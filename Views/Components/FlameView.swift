import SwiftUI

struct FlameView: View {
    @State private var flicker = false
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            // Outer Glow
            Circle()
                .fill(Color.orange.opacity(0.4))
                .frame(width: 40, height: 40)
                .scaleEffect(flicker ? 1.1 : 0.9)
                .blur(radius: 10)
            
            // Inner Flame
            Image(systemName: "flame.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.yellow, .orange, .red],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 30, height: 45)
                .scaleEffect(x: scale, y: scale)
                .offset(y: flicker ? -2 : 2)
        }
        .onAppear {
            withAnimation(
                .easeInOut(duration: 0.15)
                .repeatForever(autoreverses: true)
            ) {
                flicker.toggle()
            }
            
            withAnimation(
                .easeInOut(duration: 0.8)
                .repeatForever(autoreverses: true)
            ) {
                scale = 1.05
            }
        }
    }
}

#Preview {
    FlameView()
        .preferredColorScheme(.dark)
}
