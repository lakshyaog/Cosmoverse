import SwiftUI

@main
struct CosmoverseApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                Views.ContentView()
                    .preferredColorScheme(.dark)
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
