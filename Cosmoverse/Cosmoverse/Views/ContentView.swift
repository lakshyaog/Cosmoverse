import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                ImprovedPlanetCarousel()
                    .tabItem {
                        Label("Explore", systemImage: "sparkles")
                    }
                    .tag(0)
                
                ImprovedSolarSystemView()
                    .tabItem {
                        Label("Solar System", systemImage: "globe")
                    }
                    .tag(1)
                
                QuizView()
                    .tabItem {
                        Label("Quiz", systemImage: "lightbulb")
                    }
                    .tag(2)
                
                ARPlanetView()
                    .tabItem {
                        Label("AR", systemImage: "camera")
                    }
                    .tag(3)
            }
            .navigationBarHidden(true)
            .preferredColorScheme(.dark)
        }
    }
}
