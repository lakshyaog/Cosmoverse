import SwiftUI

struct ImprovedPlanetDetailView: View {
    let planet: Planet
    @State private var rotationAngle: Double = 0
    @State private var currentFactIndex = 0
    @State private var showComparison = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            ImprovedStarField()
            
            ScrollView {
                VStack(spacing: 25) {
                    // Header
                    headerView
                        .padding(.top, 10)
                    
                    // Planet visualization
                    planetVisualization
                    
                    // Planet info cards
                    infoGrid
                    
                    // Description
                    descriptionSection
                    
                    // Fun facts
                    funFactsSection
                    
                    // Size comparison
                    if showComparison {
                        sizeComparisonSection
                    }
                }
                .padding(.bottom, 50)
            }
        }
        .preferredColorScheme(.dark)
        .navigationBarHidden(true)
    }
    
    private var headerView: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Text(planet.name)
                .font(.largeTitle.bold())
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: { showComparison.toggle() }) {
                Image(systemName: "arrow.left.and.right.circle")
                    .font(.title)
                    .foregroundColor(.white)
            }
        }
        .padding()
    }
    
    private var planetVisualization: some View {
        ZStack {
            // Orbital rings animation
            orbitalRings
            
            // Planet
            planetBody
        }
        .frame(height: 350)
        .onAppear {
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                rotationAngle = 360
            }
        }
    }
    
    private var orbitalRings: some View {
        ForEach(0..<3) { i in
            Circle()
                .stroke(planet.color.opacity(0.2), lineWidth: 1)
                .frame(width: 300 + CGFloat(i * 20), height: 300 + CGFloat(i * 20))
                .rotationEffect(.degrees(rotationAngle + Double(i * 120)))
        }
    }
    
    private var planetBody: some View {
        ZStack {
            // Planet glow
            planetGlow
            
            // Planet body
            planetSphere
            
            // Earth continents
            if planet.name == "Earth" {
                earthSymbol
            }
            
            // Saturn rings
            if planet.name == "Saturn" {
                saturnRingsDetail
            }
        }
        .rotationEffect(.degrees(rotationAngle))
    }
    
    private var planetGlow: some View {
        Circle()
            .fill(RadialGradient(
                gradient: Gradient(colors: [
                    planet.color.opacity(0.8),
                    planet.color.opacity(0.3),
                    Color.clear
                ]),
                center: .center,
                startRadius: 80,
                endRadius: 120
            ))
            .frame(width: 240, height: 240)
    }
    
    private var planetSphere: some View {
        Circle()
            .fill(RadialGradient(
                gradient: Gradient(colors: [
                    planet.color,
                    planet.color.opacity(0.7)
                ]),
                center: .topLeading,
                startRadius: 20,
                endRadius: 100
            ))
            .frame(width: 200, height: 200)
    }
    
    private var earthSymbol: some View {
        Image(systemName: planet.symbol)
            .font(.system(size: 80))
            .foregroundColor(.white.opacity(0.8))
            .rotationEffect(.degrees(rotationAngle * 0.5))
    }
    
    private var saturnRingsDetail: some View {
        ForEach(0..<3) { i in
            Ellipse()
                .stroke(planet.color.opacity(0.6), lineWidth: 3)
                .frame(width: 280 + CGFloat(i * 20), height: 60 + CGFloat(i * 5))
        }
    }
    
    private var infoGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
            InfoCard(title: "Diameter", value: "\(Int(planet.diameter)) km", icon: "ruler", color: planet.color)
            InfoCard(title: "Moons", value: "\(planet.moons)", icon: "moon.stars", color: planet.color)
        }
        .padding(.horizontal)
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("About \(planet.name)")
                .font(.title2.bold())
                .foregroundColor(planet.color)
            
            Text(planet.description)
                .font(.body)
                .foregroundColor(.white.opacity(0.9))
                .lineLimit(nil)
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(15)
        .padding(.horizontal)
    }
    
    private var funFactsSection: some View {
        VStack(spacing: 15) {
            Text("Fun Fact")
                .font(.title2.bold())
                .foregroundColor(planet.color)
            
            Text(planet.funFacts[currentFactIndex])
                .font(.body)
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding()
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.5)) {
                    currentFactIndex = (currentFactIndex + 1) % planet.funFacts.count
                }
            }) {
                Text("Next Fact")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(factButtonGradient)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(15)
        .padding(.horizontal)
    }
    
    private var factButtonGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [planet.color, planet.color.opacity(0.7)]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    private var sizeComparisonSection: some View {
        VStack(spacing: 15) {
            Text("Size Comparison")
                .font(.title2.bold())
                .foregroundColor(planet.color)
            
            HStack(spacing: 20) {
                // Earth reference
                VStack {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 30, height: 30)
                    Text("Earth")
                        .font(.caption)
                        .foregroundColor(.white)
                }
                
                // This planet
                VStack {
                    Circle()
                        .fill(planet.color)
                        .frame(
                            width: min(30 * CGFloat(planet.diameter / 12742), 100),
                            height: min(30 * CGFloat(planet.diameter / 12742), 100)
                        )
                    Text(planet.name)
                        .font(.caption)
                        .foregroundColor(.white)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(15)
        .padding(.horizontal)
        .transition(.scale.combined(with: .opacity))
    }
}

// Helper view for planet detail cards
struct InfoCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.headline)
                .foregroundColor(.white)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(10)
    }
}
