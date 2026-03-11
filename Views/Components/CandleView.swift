import SwiftUI

struct CandleView: View {
    @Binding var progress: Double // 1.0 (full) -> 0.0 (empty)
    var isLit: Bool = true
    
    @State private var dripOffset: CGFloat = 0
    @State private var puddleScale: CGFloat = 1.0
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width * 0.45
            let minHeight: CGFloat = 60 // Wick height + base
            let maxHeight = geometry.size.height * 0.7
            let currentHeight = minHeight + (maxHeight - minHeight) * CGFloat(progress)
            
            ZStack(alignment: .bottom) {
                
                // Melted Wax Pool (Base)
                // Grows as candle burns (progress decreases)
                EllipticalPool(progress: progress)
                    .fill(Color.candleWax)
                    .frame(width: width * (1.5 + (1.0 - progress) * 0.8), height: 40 + (1.0 - progress) * 20)
                    .blur(radius: 2)
                    .opacity(1.0 - progress * 0.5) // More visible as it melts
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                    .offset(y: 15) // Slightly below
                
                // Candle Body
                ZStack(alignment: .top) {
                    // Main Body
                    UnevenRoundedRectangle(
                        topLeadingRadius: 10,
                        bottomLeadingRadius: 15,
                        bottomTrailingRadius: 15,
                        topTrailingRadius: 12,
                        style: .continuous
                    )
                    .fill(
                        LinearGradient(
                            colors: [Color.candleWax, Color.candleWax.opacity(0.95)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: width, height: currentHeight)
                    
                    // Uneven Melted Top
                    MeltedTopShape(progress: progress)
                        .fill(Color.candleWax.opacity(0.8)) // Slightly lighter/translucent
                        .frame(width: width, height: 20)
                        
                    // Dripping Wax (Animated)
                    if isLit && progress < 0.95 {
                        ZStack {
                            // Left Drip
                            Capsule()
                                .fill(Color.candleWax)
                                .frame(width: 6, height: 20 + CGFloat(sin(dripOffset)) * 10)
                                .offset(x: -width/2 + 5, y: -5 + dripOffset * 0.5)
                                .opacity(sin(dripOffset) > 0 ? 1 : 0)
                            
                            // Right Drip
                            Capsule()
                                .fill(Color.candleWax)
                                .frame(width: 8, height: 25 + CGFloat(cos(dripOffset)) * 12)
                                .offset(x: width/2 - 8, y: 0 + dripOffset * 0.7)
                                .opacity(cos(dripOffset) > 0 ? 1 : 0)
                            
                             // Front Drip
                            Capsule()
                                .fill(Color.candleWax)
                                .frame(width: 5, height: 15 + CGFloat(sin(dripOffset + 2)) * 8)
                                .offset(x: -10, y: 10 + dripOffset * 0.3)
                        }
                        .mask(Rectangle().frame(width: width, height: currentHeight)) // Clip to body
                    }
                }
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                
                // Flame System
                if progress > 0 && isLit {
                    ZStack {
                        // Halo/Glow
                        Circle()
                            .fill(Color.candleFlame.opacity(0.4))
                            .frame(width: 60, height: 60)
                            .blur(radius: 20)
                            .scaleEffect(1.0 + CGFloat(sin(dripOffset * 5)) * 0.1) // Flicker pulse
                        
                        FlameView()
                            .scaleEffect(0.6 + (progress * 0.8), anchor: .bottom)
                            .opacity(progress > 0.01 ? 1 : 0)
                            .transition(.scale.combined(with: .opacity))
                    }
                    .offset(y: -currentHeight - 25)
                }
                
                // Wick
                Rectangle()
                    .fill(Color.black.opacity(0.8))
                    .frame(width: 2, height: 12)
                    .offset(y: -currentHeight)
                    
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
        }
        .onAppear {
            withAnimation(.linear(duration: 4.0).repeatForever(autoreverses: false)) {
                dripOffset = 60 // Falls down
            }
        }
    }
}

// Shape for the uneven melting top
struct MeltedTopShape: Shape {
    var progress: Double
    
    // Animate shape change slightly?
    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        // A simple wave at the top
        path.move(to: CGPoint(x: 0, y: h))
        path.addLine(to: CGPoint(x: 0, y: h/2))
        
        // Curve 1
        path.addCurve(
            to: CGPoint(x: w * 0.4, y: h * (0.6 + sin(progress * 10) * 0.1)),
            control1: CGPoint(x: w * 0.1, y: h * 0.2),
            control2: CGPoint(x: w * 0.3, y: h * 0.9)
        )
        
        // Curve 2 (Dip for wick)
        path.addCurve(
            to: CGPoint(x: w * 0.6, y: h * (0.5 + cos(progress * 8) * 0.1)),
            control1: CGPoint(x: w * 0.45, y: h * 0.6),
            control2: CGPoint(x: w * 0.55, y: h * 0.6)
        )
        
        // Curve 3
         path.addCurve(
            to: CGPoint(x: w, y: h/2),
            control1: CGPoint(x: w * 0.7, y: h * 0.1),
            control2: CGPoint(x: w * 0.9, y: h * 0.8)
        )
        
        path.addLine(to: CGPoint(x: w, y: h))
        path.closeSubpath()
        return path
    }
}

// Elliptical Pool for the base
struct EllipticalPool: Shape {
    var progress: Double
    
    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        // Irregular ellipse growing as progress decreases
        let xOffset = sin(progress * 5) * 5
        let yOffset = cos(progress * 3) * 2
        
        let poolRect = rect.insetBy(dx: CGFloat(progress * 5), dy: CGFloat(progress * 2))
            .offsetBy(dx: xOffset, dy: yOffset)
        
        path.addEllipse(in: poolRect)
        return path
    }
}

#Preview {
    ZStack {
        Color.midnightBlue.ignoresSafeArea()
        CandleView(progress: .constant(0.6))
    }
}
