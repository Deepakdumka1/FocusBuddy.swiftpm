import SwiftUI

@main
struct FocusBuddyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark) // Force dark mode for now as per design
        }
    }
}
