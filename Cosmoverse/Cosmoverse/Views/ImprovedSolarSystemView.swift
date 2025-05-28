import SwiftUI

struct ImprovedSolarSystemView: View {
    @State private var planetAngles: [UUID: Double] = [:]
    @State private var selectedPlanet: Planet? = nil
    @State private var showOrbits = true
    
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ImprovedStarField()
                
                VStack(spacing: 0) {
                    // Top controls
                    topControls
                        .padding(.horizontal)
                        .padding(.top, 10)
                        .padding(.bottom, 20)
                    
                    // Solar system content
                    GeometryReader { contentGeometry in
                        let contentCenter = CGPoint(x: contentGeometry.size.width / 2, y: contentGeometry.size.height / 2)
                        let contentMaxRadius = min(contentGeometry.size.width, contentGeometry.size.height) * 0.4
                        
                        ZStack {
                            // Orbital paths
                            if showOrbits {
                                orbitalPaths(center: contentCenter, maxRadius: contentMaxRadius)
                            }
                            
                            // Sun
                            sunView(at: contentCenter)
                            
                            // Planets
                            planetsView(center: contentCenter, maxRadius: contentMaxRadius)
                            
                            // Planet labels
                            planetLabels(center: contentCenter, maxRadius: contentMaxRadius)
                        }
                    }
                    .padding(.bottom, 100) // Space for tab bar
                }
            }
            .onReceive(timer) { _ in
                updatePlanetPositions()
            }
            .onAppear {
                initializePlanetAngles()
            }
            .sheet(item: $selectedPlanet) { planet in
                ImprovedPlanetDetailView(planet: planet)
            }
        }
        .navigationBarHidden(true)
    }
    
    private var topControls: some View {
        HStack {
            Text("SOLAR SYSTEM")
                .font(.title.bold())
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: { showOrbits.toggle() }) {
                Image(systemName: showOrbits ? "eye.fill" : "eye.slash")
                    .foregroundColor(.white)
                    .font(.title2)
            }
        }
    }
    
    private func orbitalPaths(center: CGPoint, maxRadius: CGFloat) -> some View {
        ForEach(SolarSystemData.planets) { planet in
            let radius = calculateOrbitRadius(planet: planet, maxRadius: maxRadius)
            Circle()
                .stroke(planet.color.opacity(0.3), lineWidth: 1)
                .frame(width: radius * 2, height: radius * 2)
                .position(center)
        }
    }
    
    private func sunView(at center: CGPoint) -> some View {
        ZStack {
            // Sun glow
            Circle()
                .fill(RadialGradient(
                    gradient: Gradient(colors: [Color.yellow.opacity(0.8), Color.clear]),
                    center: .center,
                    startRadius: 5,
                    endRadius: 40
                ))
                .frame(width: 80, height: 80)
            
            // Sun body
            Circle()
                .fill(RadialGradient(
                    gradient: Gradient(colors: [Color.yellow, Color.orange]),
                    center: .center,
                    startRadius: 5,
                    endRadius: 25
                ))
                .frame(width: 50, height: 50)
        }
        .position(center)
    }
    
    private func planetsView(center: CGPoint, maxRadius: CGFloat) -> some View {
        ForEach(SolarSystemData.planets) { planet in
            let radius = calculateOrbitRadius(planet: planet, maxRadius: maxRadius)
            let angle = planetAngles[planet.id] ?? 0
            let planetSize = calculatePlanetSize(planet: planet)
            
            Button(action: {
                selectedPlanet = planet
            }) {
                planetButton(planet: planet, size: planetSize)
            }
            .position(
                x: center.x + cos(angle) * radius,
                y: center.y + sin(angle) * radius
            )
        }
    }
    
    private func planetButton(planet: Planet, size: CGFloat) -> some View {
        ZStack {
            // Planet glow
            Circle()
                .fill(planet.color.opacity(0.6))
                .frame(width: size + 8, height: size + 8)
                .blur(radius: 4)
            
            // Planet body
            Circle()
                .fill(RadialGradient(
                    gradient: Gradient(colors: [
                        planet.color.opacity(0.9),
                        planet.color.opacity(0.6)
                    ]),
                    center: .topLeading,
                    startRadius: 2,
                    endRadius: size / 2
                ))
                .frame(width: size, height: size)
            
            // Planet symbol for Earth
            if planet.name == "Earth" {
                Image(systemName: planet.symbol)
                    .foregroundColor(.white)
                    .font(.system(size: size * 0.4))
            }
            
            // Saturn's rings
            if planet.name == "Saturn" {
                saturnRings(size: size, color: planet.color)
            }
        }
    }
    
    private func saturnRings(size: CGFloat, color: Color) -> some View {
        Ellipse()
            .stroke(color.opacity(0.8), lineWidth: 2)
            .frame(width: size * 1.8, height: size * 0.4)
    }
    
    private func planetLabels(center: CGPoint, maxRadius: CGFloat) -> some View {
        ForEach(SolarSystemData.planets) { planet in
            let radius = calculateOrbitRadius(planet: planet, maxRadius: maxRadius)
            let angle = planetAngles[planet.id] ?? 0
            
            Text(planet.name)
                .font(.caption2)
                .foregroundColor(.white)
                .position(
                    x: center.x + cos(angle) * (radius + 30),
                    y: center.y + sin(angle) * (radius + 30)
                )
                .opacity(0.7)
        }
    }
    
    private func calculateOrbitRadius(planet: Planet, maxRadius: CGFloat) -> CGFloat {
        // Use actual astronomical distances for more realistic proportions
        let minRadius: CGFloat = 60
        let scaleFactor = (maxRadius - minRadius) / 30.0 // Neptune is ~30 AU
        return minRadius + CGFloat(planet.distanceFromSun) * scaleFactor
    }
    
    private func calculatePlanetSize(planet: Planet) -> CGFloat {
        let minSize: CGFloat = 8
        let maxSize: CGFloat = 25
        
        // Use logarithmic scale for better visual representation
        let maxDiameter = SolarSystemData.planets.map { $0.diameter }.max() ?? 1
        let logScale = log(planet.diameter) / log(maxDiameter)
        
        return minSize + (maxSize - minSize) * CGFloat(logScale)
    }
    
    private func initializePlanetAngles() {
        for planet in SolarSystemData.planets {
            planetAngles[planet.id] = Double.random(in: 0...(2 * .pi))
        }
    }
    
    private func updatePlanetPositions() {
        for planet in SolarSystemData.planets {
            let currentAngle = planetAngles[planet.id] ?? 0
            planetAngles[planet.id] = currentAngle + (planet.orbitSpeed * 0.01)
        }
    }
}
