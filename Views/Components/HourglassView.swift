import SwiftUI

struct HourglassView: View {
    @Binding var progress: Double // 1.0 = full top, 0.0 = full bottom
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let bulbHeight = height / 2
            let sandColor = Color.luxuryGold
            
            ZStack {
                // Glass Container
                HourglassShape()
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.8), .white.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 3
                    )
                    .shadow(color: .white.opacity(0.1), radius: 10)
                
                // Glass Reflection/Gloss
                HourglassShape()
                    .fill(
                        LinearGradient(
                            colors: [.white.opacity(0.05), .clear, .white.opacity(0.02)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .clipShape(HourglassShape())
                
                // Content Masked by Glass
                ZStack {
                    // Top Sand
                    VStack {
                        Rectangle()
                            .fill(sandColor)
                            .frame(height: bulbHeight * CGFloat(max(0, progress)))
                            .overlay(SandGrainTexture())
                        Spacer()
                    }
                    .frame(height: bulbHeight)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .mask(
                        // Mask top half only
                        Rectangle()
                            .frame(height: bulbHeight)
                            .frame(maxHeight: .infinity, alignment: .top)
                    )
                    
                    // Bottom Sand
                    VStack {
                        Spacer()
                        SandPileShape(progress: 1.0 - progress)
                            .fill(sandColor)
                            .frame(height: bulbHeight * CGFloat(1.0 - progress))
                            .overlay(SandGrainTexture())
                    }
                    .frame(height: bulbHeight)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .mask(
                        // Mask bottom half only
                        Rectangle()
                            .frame(height: bulbHeight)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                    )
                    
                    // Falling Stream
                    if progress > 0.005 && progress < 0.995 {
                        FallingSandStream(height: height, color: sandColor)
                    }
                }
                .mask(HourglassShape().padding(2)) // Slightly inside glass
            }
        }
        .frame(width: 200, height: 320)
    }
}

struct FallingSandStream: View {
    let height: CGFloat
    let color: Color
    @State private var offset: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Core Stream
            Rectangle()
                .fill(color)
                .frame(width: 2, height: height)
            
            // Particles
            TimelineView(.animation) { timeline in
                Canvas { context, size in
                    let now = timeline.date.timeIntervalSinceReferenceDate
                    for i in 0..<10 {
                        let speed = 150.0 // pixels per second
                        let y = (now * speed + Double(i) * 30).truncatingRemainder(dividingBy: Double(size.height))
                        let x = Double(size.width) / 2 + sin(now * 5 + Double(i)) * 1.5
                        
                        let rect = CGRect(x: x - 1, y: y, width: 2, height: 2)
                        context.fill(Path(ellipseIn: rect), with: .color(color.opacity(0.8)))
                    }
                }
            }
        }
    }
}

struct SandPileShape: Shape {
    var progress: Double // 0 to 1 (full)
    
    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        // A simple mound/pile shape
        // Starts flat-ish, grows into a peak
        path.move(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: width, y: height))
        
        // Curve to peak
        // Peak height is at y=0 (relative to this shape frame)
        // We want a gaussian-like curve: flat at edges, peak in center
        
        // Quadratic bezier to center?
        path.addCurve(
            to: CGPoint(x: width / 2, y: 0),
            control1: CGPoint(x: width * 0.8, y: height), // Control points stay low to make it a pile
            control2: CGPoint(x: width * 0.6, y: 0)
        )
        // No, let's just do a simple triangle with rounded top for stylized look
        // Or actually, simple rectangle works if masked by glass shape!
        // But user wants "realistic".
        // Let's stick to Rectangle for now because the Glass Shape (Hourglass) naturally shapes it at the bottom!
        // Wait, at the bottom of hourglass it's flat. The pile should grow in the middle *first*.
        
        path.addLine(to: CGPoint(x: width/2, y: 0)) // Peak
        
        // Left side
         path.addCurve(
            to: CGPoint(x: 0, y: height),
            control1: CGPoint(x: width * 0.4, y: 0),
            control2: CGPoint(x: width * 0.2, y: height)
        )
         
        path.closeSubpath()
        // Actually, let's revert to simple Rectangle because the mask takes care of the container shape,
        // and a flat level is acceptable for a "liquid-like" sand, or we assume it settles fast.
        // For "pile" effect, we'd need complex physics. A flat level is cleaner for UI.
        
        return Path(roundedRect: rect, cornerRadius: 0)
    }
}

struct SandGrainTexture: View {
    var body: some View {
        Canvas { context, size in
            // Static noise to simulate grain
            // Deterministic random
            var rng = SystemRandomNumberGenerator()
            for _ in 0..<Int(size.width * size.height / 10) {
                let x = Double.random(in: 0...size.width, using: &rng)
                let y = Double.random(in: 0...size.height, using: &rng)
                let rect = CGRect(x: x, y: y, width: 1, height: 1)
                context.fill(Path(ellipseIn: rect), with: .color(.black.opacity(0.1)))
            }
        }
    }
}

struct HourglassShape: Shape {
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        let bulbHeight = height / 2
        let neckWidth = width * 0.15
        
        var path = Path()
        
        // Draw left side
        path.move(to: CGPoint(x: 0, y: 0))
        path.addCurve(
            to: CGPoint(x: width/2 - neckWidth/2, y: bulbHeight),
            control1: CGPoint(x: 0, y: bulbHeight * 0.8),
            control2: CGPoint(x: width/2 - neckWidth/2, y: bulbHeight * 0.8)
        )
        path.addCurve(
            to: CGPoint(x: 0, y: height),
            control1: CGPoint(x: width/2 - neckWidth/2, y: bulbHeight + (height - bulbHeight) * 0.2),
            control2: CGPoint(x: 0, y: height * 0.2)
        )
        
        // Bottom
        path.addLine(to: CGPoint(x: width, y: height))
        
        // Right side (reverse)
        path.addCurve(
            to: CGPoint(x: width/2 + neckWidth/2, y: bulbHeight),
            control1: CGPoint(x: width, y: height * 0.2),
            control2: CGPoint(x: width/2 + neckWidth/2, y: bulbHeight + (height - bulbHeight) * 0.2)
        )
        path.addCurve(
            to: CGPoint(x: width, y: 0),
            control1: CGPoint(x: width/2 + neckWidth/2, y: bulbHeight * 0.8),
            control2: CGPoint(x: width, y: bulbHeight * 0.8)
        )
        
        // Top
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        return path
    }
}

#Preview {
    ZStack {
        Color.midnightBlue.ignoresSafeArea()
        HourglassView(progress: .constant(0.5))
    }
}
