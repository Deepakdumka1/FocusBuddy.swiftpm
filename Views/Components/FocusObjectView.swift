import SwiftUI

struct FocusObjectView: View {
    let theme: FocusTheme
    @Binding var progress: Double
    var isLit: Bool = true
    
    var body: some View {
        Group {
            switch theme {
            case .candle:
                CandleView(progress: $progress, isLit: isLit)
            case .ice:
                IceView(progress: $progress)
            case .portal:
                PortalView(progress: $progress)
            case .hourglass:
                HourglassView(progress: $progress)
            }
        }
        .transition(.opacity.combined(with: .scale))
    }
}
