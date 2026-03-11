import SwiftUI

struct WaxDripView: View {
    @State private var dripOffset: CGFloat = 0
    @State private var dripOpacity: Double = 0
    
    var body: some View {
        Circle()
            .fill(Color.candleWax)
            .frame(width: 8, height: 8)
            .offset(y: dripOffset)
            .opacity(dripOpacity)
            .onAppear {
                animateDrip()
            }
    }
    
    private func animateDrip() {
        // Random delay start
        let delay = Double.random(in: 2...10)
        
        withAnimation(.linear(duration: 0).delay(delay)) {
            dripOffset = 0
            dripOpacity = 1
        }
        
        withAnimation(.easeIn(duration: 1.5).delay(delay)) {
            dripOffset = 100 // Drip down distance
        }
        
        withAnimation(.linear(duration: 0.5).delay(delay + 1.0)) {
            dripOpacity = 0
        }
        
        // Loop
        DispatchQueue.main.asyncAfter(deadline: .now() + delay + 2.0) {
            animateDrip()
        }
    }
}
