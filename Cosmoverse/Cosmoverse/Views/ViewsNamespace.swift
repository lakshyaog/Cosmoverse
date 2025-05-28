import SwiftUI

/// Namespace for all Cosmoverse views to avoid naming conflicts
enum Views {
    /// The main container view with tab navigation
    static func ContentView() -> some View {
        _ContentView()
    }
    
    /// Internal implementation of ContentView
    fileprivate struct _ContentView: View {
        @State private var selectedTab = 0
        
        var body: some View {
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
                
                if ARViewContainer.isARSupported() {
                    ARPlanetView()
                        .tabItem {
                            Label("AR", systemImage: "camera")
                        }
                        .tag(3)
                }
            }
        }
    }
}
