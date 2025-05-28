import SwiftUI

struct PlanetCarouselCard: View {
    let planet: Planet
    let isSelected: Bool
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            // Card background
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [
                        planet.color.opacity(0.3),
                        planet.color.opacity(0.1)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(planet.color.opacity(0.5), lineWidth: isSelected ? 2 : 1)
                )
            
            VStack(spacing: 15) {
                // Planet visualization
                ZStack {
                    // Planet glow
                    Circle()
                        .fill(planet.color.opacity(0.6))
                        .frame(width: 120, height: 120)
                        .blur(radius: 10)
                    
                    // Planet body
                    Circle()
                        .fill(RadialGradient(
                            gradient: Gradient(colors: [
                                planet.color,
                                planet.color.opacity(0.7)
                            ]),
                            center: .topLeading,
                            startRadius: 20,
                            endRadius: 50
                        ))
                        .frame(width: 100, height: 100)
                    
                    // Earth symbol
                    if planet.name == "Earth" {
                        Image(systemName: planet.symbol)
                            .font(.system(size: 40))
                            .foregroundColor(.white.opacity(0.8))
                            .rotationEffect(.degrees(rotationAngle))
                    }
                    
                    // Saturn rings
                    if planet.name == "Saturn" {
                        Ellipse()
                            .stroke(planet.color.opacity(0.8), lineWidth: 3)
                            .frame(width: 140, height: 30)
                    }
                }
                .rotationEffect(.degrees(rotationAngle))
                
                // Planet name
                Text(planet.name)
                    .font(.title2.bold())
                    .foregroundColor(.white)
                
                // Planet type indicator
                Text("\(planet.moons) moon\(planet.moons == 1 ? "" : "s")")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding()
        }
        .frame(width: 250, height: 280)
        .onAppear {
            withAnimation(.linear(duration: 30).repeatForever(autoreverses: false)) {
                rotationAngle = 360
            }
        }
    }
}
