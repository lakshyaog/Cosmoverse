import SwiftUI

struct Planet: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String
    let color: Color
    let diameter: Double  // In km
    let funFacts: [String]
    let symbol: String  // SF Symbol name to use
    let orbitSpeed: Double // For animation
    let rotationSpeed: Double // For animation
    let moons: Int // Number of moons
    let distanceFromSun: Double // AU (Astronomical Units)
    
    // Implement Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Implement Equatable (required by Hashable)
    static func == (lhs: Planet, rhs: Planet) -> Bool {
        lhs.id == rhs.id
    }
}
