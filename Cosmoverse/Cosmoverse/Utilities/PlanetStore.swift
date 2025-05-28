import SwiftUI
import Foundation

// MARK: - Planet Store for Shared State
class PlanetStore: ObservableObject {
    @Published var selectedPlanet: Planet?
    
    func selectPlanet(_ planet: Planet) {
        selectedPlanet = planet
        print("✅ Planet selected: \(planet.name)")
    }
    
    func clearSelection() {
        selectedPlanet = nil
        print("🗑️ Planet selection cleared")
    }
}

// MARK: - Notification Extension
extension Notification.Name {
    static let clearARScene = Notification.Name("clearARScene")
}
