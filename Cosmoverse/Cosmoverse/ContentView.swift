import SwiftUI
import Foundation
import ARKit
import SceneKit

// MARK: - Data Models
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

// Planet data
class SolarSystemData {
    static let planets: [Planet] = [
        Planet(
            name: "Mercury",
            description: "The smallest and closest planet to the Sun in our Solar System.",
            color: Color(red: 0.8, green: 0.8, blue: 0.8),
            diameter: 4879,
            funFacts: [
                "Mercury has no atmosphere, which means it has no weather.",
                "A day on Mercury (176 Earth days) is longer than its year (88 Earth days)!",
                "Mercury's surface is covered in craters, similar to our Moon."
            ],
            symbol: "circle.fill",
            orbitSpeed: 2.0,
            rotationSpeed: 0.8,
            moons: 0,
            distanceFromSun: 0.39
        ),
        Planet(
            name: "Venus",
            description: "The second planet from the Sun and Earth's closest planetary neighbor.",
            color: Color(red: 1.0, green: 0.8, blue: 0.4),
            diameter: 12104,
            funFacts: [
                "Venus spins backward compared to other planets.",
                "It's the hottest planet in our solar system, despite not being closest to the Sun.",
                "A day on Venus is longer than a year on Venus!"
            ],
            symbol: "circle.fill",
            orbitSpeed: 1.8,
            rotationSpeed: 0.9,
            moons: 0,
            distanceFromSun: 0.72
        ),
        Planet(
            name: "Earth",
            description: "Our home planet and the only known place with life in the universe.",
            color: Color(red: 0.2, green: 0.6, blue: 1.0),
            diameter: 12742,
            funFacts: [
                "Earth is the only planet not named after a god or goddess.",
                "Our planet is about 4.5 billion years old.",
                "71% of Earth's surface is covered with water."
            ],
            symbol: "globe.americas.fill",
            orbitSpeed: 1.5,
            rotationSpeed: 1.0,
            moons: 1,
            distanceFromSun: 1.0
        ),
        Planet(
            name: "Mars",
            description: "The fourth planet from the Sun, known as the Red Planet.",
            color: Color(red: 0.9, green: 0.4, blue: 0.2),
            diameter: 6779,
            funFacts: [
                "Mars has the largest volcano in the solar system - Olympus Mons.",
                "Mars has two small moons named Phobos and Deimos.",
                "The red color comes from iron oxide (rust) on its surface."
            ],
            symbol: "circle.fill",
            orbitSpeed: 1.2,
            rotationSpeed: 1.1,
            moons: 2,
            distanceFromSun: 1.52
        ),
        Planet(
            name: "Jupiter",
            description: "The largest planet in our solar system and the fifth from the Sun.",
            color: Color(red: 0.9, green: 0.7, blue: 0.5),
            diameter: 139820,
            funFacts: [
                "Jupiter has the Great Red Spot, a storm that has been raging for at least 400 years.",
                "With 95 known moons, Jupiter has many satellites.",
                "Jupiter is mostly made of hydrogen and helium gases."
            ],
            symbol: "circle.fill",
            orbitSpeed: 0.8,
            rotationSpeed: 1.3,
            moons: 95,
            distanceFromSun: 5.2
        ),
        Planet(
            name: "Saturn",
            description: "The sixth planet from the Sun, famous for its stunning ring system.",
            color: Color(red: 0.9, green: 0.8, blue: 0.6),
            diameter: 116460,
            funFacts: [
                "Saturn's rings are made mostly of ice and rock particles.",
                "Saturn could float in water because it's less dense than water.",
                "Saturn has 146 moons, the most in our solar system."
            ],
            symbol: "circle.fill",
            orbitSpeed: 0.6,
            rotationSpeed: 1.2,
            moons: 146,
            distanceFromSun: 9.5
        ),
        Planet(
            name: "Uranus",
            description: "The seventh planet from the Sun and the first to be discovered using a telescope.",
            color: Color(red: 0.4, green: 0.8, blue: 0.9),
            diameter: 50724,
            funFacts: [
                "Uranus rotates on its side like a rolling ball.",
                "It's the coldest planet in our solar system despite not being the farthest from the Sun.",
                "Uranus has 27 known moons, named after characters from Shakespeare and Pope."
            ],
            symbol: "circle.fill",
            orbitSpeed: 0.4,
            rotationSpeed: 0.9,
            moons: 27,
            distanceFromSun: 19.2
        ),
        Planet(
            name: "Neptune",
            description: "The eighth and most distant planet in our solar system.",
            color: Color(red: 0.2, green: 0.4, blue: 0.9),
            diameter: 49244,
            funFacts: [
                "Neptune has the strongest winds in the solar system, reaching up to 1,200 mph.",
                "It was the first planet located through mathematical calculations rather than observation.",
                "Neptune has 16 known moons, with Triton being the largest."
            ],
            symbol: "circle.fill",
            orbitSpeed: 0.3,
            rotationSpeed: 1.4,
            moons: 16,
            distanceFromSun: 30.1
        )
    ]
}

// MARK: - Improved Star Field
struct ImprovedStarField: View {
    @State private var stars: [(position: CGPoint, size: CGFloat, opacity: Double, twinkle: Bool)] = []
    @State private var animateStars = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Deep space gradient
                backgroundGradient
                
                // Stars
                ForEach(0..<stars.count, id: \.self) { i in
                    starView(for: i)
                }
            }
            .onAppear {
                generateStars(for: geometry.size)
                animateStars = true
            }
        }
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.05, green: 0.05, blue: 0.15),
                Color(red: 0.02, green: 0.02, blue: 0.08),
                Color.black
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
    
    private func starView(for index: Int) -> some View {
        let star = stars[index]
        return Circle()
            .fill(Color.white)
            .frame(width: star.size, height: star.size)
            .position(star.position)
            .opacity(star.twinkle && animateStars ? star.opacity * 0.3 : star.opacity)
            .animation(
                star.twinkle ?
                .easeInOut(duration: Double.random(in: 1...3)).repeatForever(autoreverses: true) :
                .none,
                value: animateStars
            )
    }
    
    private func generateStars(for size: CGSize) {
        stars = (0..<150).map { _ in
            (
                position: CGPoint(
                    x: CGFloat.random(in: 0...size.width),
                    y: CGFloat.random(in: 0...size.height)
                ),
                size: CGFloat.random(in: 1...3),
                opacity: Double.random(in: 0.3...1.0),
                twinkle: Bool.random()
            )
        }
    }
}

// MARK: - Improved Solar System View
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

// MARK: - Improved Planet Detail View
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

// MARK: - Planet Carousel Card
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

// MARK: - Improved Planet Carousel
struct ImprovedPlanetCarousel: View {
    @State private var selectedIndex = 0
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            ImprovedStarField()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Title section
                    titleSection
                        .padding(.top, 20)
                        .padding(.bottom, 30)
                    
                    // Planet carousel
                    carouselSection
                        .padding(.bottom, 20)
                    
                    // Planet details
                    detailsSection
                        .padding(.bottom, 20)
                    
                    // Page indicators
                    pageIndicators
                        .padding(.bottom, 100) // Space for tab bar
                }
            }
        }
        .preferredColorScheme(.dark)
        .navigationBarHidden(true)
    }
    
    private var titleSection: some View {
        VStack(spacing: 10) {
            Text("COSMOVERSE")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .shadow(color: .blue.opacity(0.8), radius: 10)
            
            Text("Explore the Solar System")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
        }
    }
    
    private var carouselSection: some View {
        ZStack {
            ForEach(SolarSystemData.planets.indices, id: \.self) { index in
                let planet = SolarSystemData.planets[index]
                let offset = CGFloat(index - selectedIndex)
                let isSelected = index == selectedIndex
                
                PlanetCarouselCard(planet: planet, isSelected: isSelected)
                    .offset(x: offset * 300 + dragOffset)
                    .scaleEffect(isSelected ? 1.0 : 0.8)
                    .opacity(isSelected ? 1.0 : 0.6)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: selectedIndex)
                    .onTapGesture {
                        if !isSelected {
                            selectedIndex = index
                        }
                    }
            }
        }
        .frame(height: 280)
        .gesture(carouselDragGesture)
    }
    
    private var carouselDragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                dragOffset = value.translation.width
            }
            .onEnded { value in
                let threshold: CGFloat = 50
                if value.translation.width > threshold && selectedIndex > 0 {
                    selectedIndex -= 1
                } else if value.translation.width < -threshold && selectedIndex < SolarSystemData.planets.count - 1 {
                    selectedIndex += 1
                }
                dragOffset = 0
            }
    }
    
    private var detailsSection: some View {
        Group {
            if selectedIndex < SolarSystemData.planets.count {
                let planet = SolarSystemData.planets[selectedIndex]
                
                VStack(spacing: 20) {
                    Text(planet.description)
                        .font(.body)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                    
                    planetStats(for: planet)
                    
                    exploreButton(for: planet)
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(20)
                .padding(.horizontal)
                .transition(.opacity.combined(with: .scale))
                .id(selectedIndex)
            }
        }
    }
    
    private func planetStats(for planet: Planet) -> some View {
        HStack(spacing: 30) {
            VStack {
                Text("\(Int(planet.diameter))")
                    .font(.title2.bold())
                    .foregroundColor(planet.color)
                
                Text("km diameter")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            VStack {
                Text("\(planet.moons)")
                    .font(.title2.bold())
                    .foregroundColor(planet.color)
                
                Text("moons")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            VStack {
                Text("\(planet.distanceFromSun, specifier: "%.1f")")
                    .font(.title2.bold())
                    .foregroundColor(planet.color)
                
                Text("AU from Sun")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
        }
    }
    
    private func exploreButton(for planet: Planet) -> some View {
        NavigationLink(destination: ImprovedPlanetDetailView(planet: planet)) {
            Text("Explore \(planet.name)")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(exploreButtonGradient(for: planet))
                .cornerRadius(15)
                .shadow(color: planet.color.opacity(0.5), radius: 10)
        }
    }
    
    private func exploreButtonGradient(for planet: Planet) -> some View {
        LinearGradient(
            gradient: Gradient(colors: [planet.color, planet.color.opacity(0.7)]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    private var pageIndicators: some View {
        HStack(spacing: 10) {
            ForEach(0..<SolarSystemData.planets.count, id: \.self) { index in
                Circle()
                    .fill(index == selectedIndex ? Color.white : Color.white.opacity(0.3))
                    .frame(width: 10, height: 10)
                    .scaleEffect(index == selectedIndex ? 1.3 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: selectedIndex)
            }
        }
        .padding(.vertical, 20)
    }
}

// MARK: - Quiz Feature
struct QuizQuestion {
    let question: String
    let options: [String]
    let correctAnswer: Int
    let explanation: String
}

class QuizData {
    static let questions: [QuizQuestion] = [
        QuizQuestion(
            question: "Which planet is known as the Red Planet?",
            options: ["Venus", "Mars", "Jupiter", "Saturn"],
            correctAnswer: 1,
            explanation: "Mars is called the Red Planet because of iron oxide (rust) on its surface."
        ),
        QuizQuestion(
            question: "Which planet has the most moons?",
            options: ["Jupiter", "Saturn", "Uranus", "Neptune"],
            correctAnswer: 1,
            explanation: "Saturn has 146 known moons, making it the planet with the most moons in our solar system."
        ),
        QuizQuestion(
            question: "Which planet is closest to the Sun?",
            options: ["Venus", "Mercury", "Earth", "Mars"],
            correctAnswer: 1,
            explanation: "Mercury is the smallest planet and closest to the Sun in our solar system."
        ),
        QuizQuestion(
            question: "Which planet could theoretically float in water?",
            options: ["Jupiter", "Saturn", "Uranus", "Neptune"],
            correctAnswer: 1,
            explanation: "Saturn is less dense than water, so it would theoretically float if there was a body of water large enough!"
        ),
        QuizQuestion(
            question: "Which planet rotates on its side?",
            options: ["Jupiter", "Saturn", "Uranus", "Neptune"],
            correctAnswer: 2,
            explanation: "Uranus rotates on its side like a rolling ball, making it unique among the planets."
        ),
        QuizQuestion(
            question: "Which planet has the strongest winds in the solar system?",
            options: ["Jupiter", "Saturn", "Uranus", "Neptune"],
            correctAnswer: 3,
            explanation: "Neptune has winds reaching up to 1,200 mph, the strongest in our solar system."
        ),
        QuizQuestion(
            question: "Which planet is the hottest in our solar system?",
            options: ["Mercury", "Venus", "Earth", "Mars"],
            correctAnswer: 1,
            explanation: "Venus is the hottest planet due to its thick atmosphere that traps heat, even though it's not closest to the Sun."
        ),
        QuizQuestion(
            question: "How many planets are there in our solar system?",
            options: ["7", "8", "9", "10"],
            correctAnswer: 1,
            explanation: "There are 8 planets in our solar system since Pluto was reclassified as a dwarf planet in 2006."
        )
    ]
}

// MARK: - Quiz Completion View
struct QuizCompletionView: View {
    let score: Int
    let totalQuestions: Int
    let onRestart: () -> Void
    
    @State private var animateElements = false
    @State private var showFireworks = false
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Spacer(minLength: 40)
                
                // Space-themed celebration
                celebrationSection
                
                // Score section
                scoreSection
                    .padding(.top, 30)
                
                // Achievement badge
                achievementBadge
                    .padding(.top, 25)
                
                // Performance message
                performanceMessage
                    .padding(.top, 25)
                
                // Action buttons
                actionButtons
                    .padding(.top, 35)
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                animateElements = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    showFireworks = true
                }
            }
            
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                rotationAngle = 360
            }
        }
    }
    
    private var celebrationSection: some View {
        ZStack {
            // Orbital rings
            ForEach(0..<3) { i in
                Circle()
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                scoreColor.opacity(0.6),
                                scoreColor.opacity(0.2)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(width: 200 + CGFloat(i * 40), height: 200 + CGFloat(i * 40))
                    .rotationEffect(.degrees(rotationAngle + Double(i * 120)))
                    .opacity(animateElements ? 1.0 : 0.0)
            }
            
            // Central achievement
            ZStack {
                // Glow effect
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                scoreColor.opacity(0.8),
                                scoreColor.opacity(0.4),
                                Color.clear
                            ]),
                            center: .center,
                            startRadius: 30,
                            endRadius: 100
                        )
                    )
                    .frame(width: 200, height: 200)
                    .blur(radius: 10)
                    .opacity(animateElements ? 1.0 : 0.0)
                
                // Main circle
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                scoreColor,
                                scoreColor.opacity(0.7)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 160, height: 160)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 3)
                    )
                    .scaleEffect(animateElements ? 1.0 : 0.5)
                
                // Achievement icon
                VStack(spacing: 8) {
                    Image(systemName: achievementIcon)
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("MISSION")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                    
                    Text("COMPLETE")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                }
                .scaleEffect(animateElements ? 1.0 : 0.3)
            }
            
            // Floating particles
            if showFireworks {
                ForEach(0..<12) { i in
                    Image(systemName: "star.fill")
                        .font(.system(size: CGFloat.random(in: 8...16)))
                        .foregroundColor(particleColors.randomElement() ?? .yellow)
                        .offset(
                            x: cos(Double(i) * .pi / 6) * CGFloat.random(in: 120...180),
                            y: sin(Double(i) * .pi / 6) * CGFloat.random(in: 120...180)
                        )
                        .opacity(Double.random(in: 0.6...1.0))
                        .scaleEffect(Double.random(in: 0.5...1.2))
                        .animation(
                            .easeInOut(duration: Double.random(in: 2...4))
                            .repeatForever(autoreverses: true),
                            value: showFireworks
                        )
                }
            }
        }
    }
    
    private var scoreSection: some View {
        VStack(spacing: 15) {
            Text("QUIZ COMPLETE!")
                .font(.system(size: 36, weight: .black, design: .rounded))
                .foregroundColor(.white)
                .opacity(animateElements ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 1.0).delay(0.3), value: animateElements)
            
            Text("Your Final Score")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white.opacity(0.8))
                .opacity(animateElements ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 1.0).delay(0.5), value: animateElements)
            
            // Score display
            HStack(spacing: 10) {
                Text("\(score)")
                    .font(.system(size: 72, weight: .black))
                    .foregroundColor(scoreColor)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("out of")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text("\(totalQuestions)")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .opacity(animateElements ? 1.0 : 0.0)
            .animation(.easeInOut(duration: 1.0).delay(0.7), value: animateElements)
        }
    }
    
    private var achievementBadge: some View {
        VStack(spacing: 12) {
            // Badge background
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            scoreColor.opacity(0.3),
                            scoreColor.opacity(0.1)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 80)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(scoreColor.opacity(0.5), lineWidth: 2)
                )
                .overlay(
                    HStack(spacing: 15) {
                        // Rank icon
                        ZStack {
                            Circle()
                                .fill(scoreColor)
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: rankIcon)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(rankTitle)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(rankDescription)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                )
                .scaleEffect(animateElements ? 1.0 : 0.8)
                .opacity(animateElements ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 1.0).delay(0.9), value: animateElements)
        }
    }
    
    private var performanceMessage: some View {
        VStack(spacing: 15) {
            Text(performanceTitle)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(scoreColor)
                .multilineTextAlignment(.center)
            
            Text(performanceDescription)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
        .padding(.horizontal, 10)
        .opacity(animateElements ? 1.0 : 0.0)
        .animation(.easeInOut(duration: 1.0).delay(1.1), value: animateElements)
    }
    
    private var actionButtons: some View {
        VStack(spacing: 15) {
            // Restart Quiz Button
            Button(action: onRestart) {
                HStack(spacing: 12) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 18, weight: .semibold))
                    
                    Text("Take Quiz Again")
                        .font(.system(size: 18, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.vertical, 16)
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            scoreColor,
                            scoreColor.opacity(0.8)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(15)
                .shadow(color: scoreColor.opacity(0.4), radius: 10, x: 0, y: 5)
            }
            
            // Share Score Button
            Button(action: {
                // Share functionality could be added here
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 18, weight: .semibold))
                    
                    Text("Share Your Score")
                        .font(.system(size: 18, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.vertical, 16)
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity)
                .background(Color.white.opacity(0.2))
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
            }
        }
        .opacity(animateElements ? 1.0 : 0.0)
        .animation(.easeInOut(duration: 1.0).delay(1.3), value: animateElements)
    }
    
    // MARK: - Computed Properties
    private var scorePercentage: Double {
        Double(score) / Double(totalQuestions)
    }
    
    private var scoreColor: Color {
        if scorePercentage >= 0.9 { return .green }
        if scorePercentage >= 0.8 { return .blue }
        if scorePercentage >= 0.7 { return .purple }
        if scorePercentage >= 0.6 { return .orange }
        return .red
    }
    
    private var achievementIcon: String {
        if scorePercentage >= 0.9 { return "crown.fill" }
        if scorePercentage >= 0.8 { return "star.fill" }
        if scorePercentage >= 0.7 { return "flame.fill" }
        if scorePercentage >= 0.6 { return "bolt.fill" }
        return "heart.fill"
    }
    
    private var rankIcon: String {
        if scorePercentage >= 0.9 { return "crown.fill" }
        if scorePercentage >= 0.8 { return "star.circle.fill" }
        if scorePercentage >= 0.7 { return "flame.circle.fill" }
        if scorePercentage >= 0.6 { return "bolt.circle.fill" }
        return "graduationcap.fill"
    }
    
    private var rankTitle: String {
        if scorePercentage == 1.0 { return "Perfect Score!" }
        if scorePercentage >= 0.9 { return "Space Commander" }
        if scorePercentage >= 0.8 { return "Stellar Navigator" }
        if scorePercentage >= 0.7 { return "Cosmic Explorer" }
        if scorePercentage >= 0.6 { return "Space Cadet" }
        return "Future Astronomer"
    }
    
    private var rankDescription: String {
        if scorePercentage == 1.0 { return "Absolutely flawless performance!" }
        if scorePercentage >= 0.9 { return "Outstanding space knowledge!" }
        if scorePercentage >= 0.8 { return "Excellent stellar expertise!" }
        if scorePercentage >= 0.7 { return "Great cosmic understanding!" }
        if scorePercentage >= 0.6 { return "Good space foundation!" }
        return "Keep exploring the cosmos!"
    }
    
    private var performanceTitle: String {
        if scorePercentage == 1.0 { return "🚀 PERFECT MISSION!" }
        if scorePercentage >= 0.9 { return "🌟 OUTSTANDING!" }
        if scorePercentage >= 0.8 { return "⭐ EXCELLENT!" }
        if scorePercentage >= 0.7 { return "🔥 GREAT JOB!" }
        if scorePercentage >= 0.6 { return "👍 GOOD WORK!" }
        return "📚 KEEP LEARNING!"
    }
    
    private var performanceDescription: String {
        if scorePercentage == 1.0 {
            return "Incredible! You've mastered the cosmos with a perfect score. You truly are a space expert! 🌌"
        }
        if scorePercentage >= 0.9 {
            return "Amazing work! Your knowledge of the solar system is truly stellar. You're almost at astronaut level! ⭐"
        }
        if scorePercentage >= 0.8 {
            return "Excellent performance! You have a solid understanding of our cosmic neighborhood. Keep reaching for the stars! 🌟"
        }
        if scorePercentage >= 0.7 {
            return "Great job! You're well on your way to becoming a space expert. The universe awaits your exploration! 🚀"
        }
        if scorePercentage >= 0.6 {
            return "Good effort! You've got a solid foundation about space. Keep studying to unlock more cosmic mysteries! 🌍"
        }
        return "Keep exploring! Every astronomer started somewhere. The wonders of space are waiting for you to discover them! 🔭"
    }
    
    private var particleColors: [Color] {
        [.yellow, .orange, .pink, .purple, .blue, .cyan, .green]
    }
}

struct QuizView: View {
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: Int? = nil
    @State private var showExplanation = false
    @State private var score = 0
    @State private var quizCompleted = false
    @State private var answeredQuestions: Set<Int> = []
    
    var currentQuestion: QuizQuestion {
        QuizData.questions[currentQuestionIndex]
    }
    
    var body: some View {
        ZStack {
            ImprovedStarField()
            
            if quizCompleted {
                QuizCompletionView(
                    score: score,
                    totalQuestions: QuizData.questions.count,
                    onRestart: restartQuiz
                )
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        quizContentView
                    }
                    .padding(.bottom, 100) // Space for tab bar
                }
            }
        }
        .preferredColorScheme(.dark)
        .navigationBarHidden(true)
    }
    
    private var quizContentView: some View {
        VStack(spacing: 25) {
            // Header
            quizHeader
                .padding(.top, 30)
            
            // Progress bar
            progressBar
                .padding(.horizontal)
            
            // Question card
            questionCard
                .padding(.horizontal)
            
            // Answer options
            answerOptions
                .padding(.horizontal)
            
            // Navigation buttons
            navigationButtons
                .padding(.horizontal)
            
            Spacer(minLength: 50)
        }
    }
    
    private var quizHeader: some View {
        VStack(spacing: 10) {
            Text("SPACE QUIZ")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text("Test your knowledge of the solar system!")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
        }
    }
    
    private var progressBar: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Question \(currentQuestionIndex + 1) of \(QuizData.questions.count)")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                
                Spacer()
                
                Text("Score: \(score)/\(answeredQuestions.count)")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            ProgressView(value: Double(currentQuestionIndex + 1), total: Double(QuizData.questions.count))
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                .scaleEffect(y: 2)
        }
    }
    
    private var questionCard: some View {
        VStack(spacing: 20) {
            Text(currentQuestion.question)
                .font(.title2.bold())
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            
            if showExplanation {
                explanationView
            }
        }
        .padding(25)
        .background(Color.white.opacity(0.1))
        .cornerRadius(20)
    }
    
    private var explanationView: some View {
        VStack(spacing: 15) {
            Divider()
                .background(Color.white.opacity(0.3))
            
            HStack {
                Image(systemName: selectedAnswer == currentQuestion.correctAnswer ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(selectedAnswer == currentQuestion.correctAnswer ? .green : .red)
                    .font(.title2)
                
                Text(selectedAnswer == currentQuestion.correctAnswer ? "Correct!" : "Incorrect")
                    .font(.headline.bold())
                    .foregroundColor(selectedAnswer == currentQuestion.correctAnswer ? .green : .red)
                
                Spacer()
            }
            
            Text(currentQuestion.explanation)
                .font(.body)
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    private var answerOptions: some View {
        VStack(spacing: 12) {
            ForEach(0..<currentQuestion.options.count, id: \.self) { index in
                answerButton(for: index)
            }
        }
    }
    
    private func answerButton(for index: Int) -> some View {
        let isSelected = selectedAnswer == index
        let isCorrect = index == currentQuestion.correctAnswer
        let showResult = showExplanation
        
        return Button(action: {
            if !showExplanation {
                selectedAnswer = index
                showExplanation = true
                
                if !answeredQuestions.contains(currentQuestionIndex) {
                    answeredQuestions.insert(currentQuestionIndex)
                    if index == currentQuestion.correctAnswer {
                        score += 1
                    }
                }
            }
        }) {
            HStack {
                Text(currentQuestion.options[index])
                    .font(.body)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
                
                if showResult {
                    Image(systemName: isCorrect ? "checkmark.circle.fill" : (isSelected ? "xmark.circle.fill" : "circle"))
                        .foregroundColor(isCorrect ? .green : (isSelected ? .red : .white.opacity(0.3)))
                }
            }
            .padding()
            .background(answerButtonBackground(isSelected: isSelected, isCorrect: isCorrect, showResult: showResult))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(answerButtonBorder(isSelected: isSelected, isCorrect: isCorrect, showResult: showResult), lineWidth: 2)
            )
        }
        .disabled(showExplanation)
    }
    
    private func answerButtonBackground(isSelected: Bool, isCorrect: Bool, showResult: Bool) -> Color {
        if showResult {
            if isCorrect {
                return Color.green.opacity(0.2)
            } else if isSelected {
                return Color.red.opacity(0.2)
            }
        }
        return Color.white.opacity(isSelected ? 0.15 : 0.1)
    }
    
    private func answerButtonBorder(isSelected: Bool, isCorrect: Bool, showResult: Bool) -> Color {
        if showResult {
            if isCorrect {
                return Color.green
            } else if isSelected {
                return Color.red
            }
        }
        return isSelected ? Color.blue : Color.white.opacity(0.3)
    }

    private var navigationButtons: some View {
        HStack(spacing: 20) {
            if currentQuestionIndex > 0 {
                Button(action: previousQuestion) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Previous")
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                }
            }
            
            if showExplanation {
                Button(action: nextQuestion) {
                    HStack {
                        Text(currentQuestionIndex < QuizData.questions.count - 1 ? "Next" : "Finish")
                        if currentQuestionIndex < QuizData.questions.count - 1 {
                            Image(systemName: "chevron.right")
                        } else {
                            Image(systemName: "flag.checkered")
                        }
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                }
            }
        }
    }
    private func nextQuestion() {
        if currentQuestionIndex < QuizData.questions.count - 1 {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentQuestionIndex += 1
                selectedAnswer = nil
                showExplanation = false
            }
        } else {
            withAnimation(.easeInOut(duration: 0.5)) {
                quizCompleted = true
            }
        }
    }

    private func previousQuestion() {
        if currentQuestionIndex > 0 {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentQuestionIndex -= 1
                selectedAnswer = nil
                showExplanation = false
            }
        }
    }

    private func restartQuiz() {
        withAnimation(.easeInOut(duration: 0.5)) {
            currentQuestionIndex = 0
            selectedAnswer = nil
            showExplanation = false
            score = 0
            quizCompleted = false
            answeredQuestions.removeAll()
        }
    }
}

// MARK: - AR Planet View

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

// MARK: - AR Planet View (Main AR Interface)
struct ARPlanetView: View {
    @StateObject private var planetStore = PlanetStore()
    @State private var scaleMode: ScaleMode = .realistic
    @State private var showingInfo = false
    @State private var showingPicker = false
    
    enum ScaleMode: CaseIterable {
        case realistic, uniform, exaggerated
        
        var displayName: String {
            switch self {
            case .realistic: return "Realistic"
            case .uniform: return "Uniform"
            case .exaggerated: return "Exaggerated"
            }
        }
    }
    
    var body: some View {
        ZStack {
            // AR View
            ARViewContainer(
                selectedPlanet: $planetStore.selectedPlanet,
                scaleMode: $scaleMode,
                showingInfo: $showingInfo
            )
            .edgesIgnoringSafeArea(.all)
            
            // UI Overlay
            VStack {
                // Top Controls
                HStack {
                    // Planet Picker Button
                    Button(action: { showingPicker = true }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Select Planet")
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                    }
                    
                    Spacer()
                    
                    // Scale Mode Picker
                    Menu {
                        ForEach(ScaleMode.allCases, id: \.self) { mode in
                            Button(mode.displayName) {
                                scaleMode = mode
                            }
                        }
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .padding(12)
                            .background(Color.black.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    // Clear Scene Button
                    Button(action: {
                        NotificationCenter.default.post(name: .clearARScene, object: nil)
                    }) {
                        Image(systemName: "trash")
                            .padding(12)
                            .background(Color.red.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
                
                Spacer()
                
                // Bottom Info
                if let planet = planetStore.selectedPlanet {
                    VStack(spacing: 8) {
                        Text("Selected: \(planet.name)")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text("Tap on detected surface to place planet")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text("Scale: \(scaleMode.displayName)")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(15)
                    .padding(.bottom, 100)
                } else {
                    VStack(spacing: 8) {
                        Text("No Planet Selected")
                            .font(.headline)
                            .foregroundColor(.orange)
                        
                        Text("Tap 'Select Planet' to choose one")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(15)
                    .padding(.bottom, 100)
                }
            }
        }
        .navigationTitle("AR Planets")
        .navigationBarHidden(true)
        .sheet(isPresented: $showingPicker) {
            ARPlanetPickerView(selectedPlanet: $planetStore.selectedPlanet)
        }
        .environmentObject(planetStore)
    }
}

// MARK: - AR View Container (FIXED PLACEMENT ISSUE)
struct ARViewContainer: UIViewRepresentable {
    @Binding var selectedPlanet: Planet?
    @Binding var scaleMode: ARPlanetView.ScaleMode
    @Binding var showingInfo: Bool
    
    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView()
        arView.delegate = context.coordinator
        arView.scene = SCNScene()
        
        // Configure AR session for better performance
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        configuration.isLightEstimationEnabled = true
        
        // FIXED: Better performance settings
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth) {
            configuration.frameSemantics.insert(.sceneDepth)
        }
        
        // Only run if AR is supported
        guard ARWorldTrackingConfiguration.isSupported else {
            print("❌ AR World Tracking not supported on this device")
            return arView
        }
        
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        arView.addGestureRecognizer(tapGesture)
        
        // Listen for notifications
        NotificationCenter.default.addObserver(
            context.coordinator,
            selector: #selector(Coordinator.clearScene),
            name: .clearARScene,
            object: nil
        )
        
        // FIXED: Reduce debug output and improve performance
        arView.showsStatistics = false
        arView.debugOptions = []
        arView.antialiasingMode = .none // Better performance
        
        return arView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        context.coordinator.scaleMode = scaleMode
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, ARSCNViewDelegate {
        var parent: ARViewContainer
        var scaleMode: ARPlanetView.ScaleMode = .realistic
        var placedPlanets: [SCNNode] = []
        
        init(_ parent: ARViewContainer) {
            self.parent = parent
            super.init()
        }
        
        // FIXED: Proper planet placement
        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let selectedPlanet = parent.selectedPlanet else {
                print("❌ NO PLANET SELECTED")
                return
            }
            
            let arView = gesture.view as! ARSCNView
            let location = gesture.location(in: arView)
            
            // FIXED: Use proper hit test types and coordinate conversion
            let hitTestResults = arView.hitTest(location, types: [.existingPlaneUsingExtent, .estimatedHorizontalPlane])
            
            if let hitResult = hitTestResults.first {
                print("✅ SURFACE FOUND - PLACING PLANET")
                addPlanet(selectedPlanet, at: hitResult, in: arView)
            } else {
                // FIXED: Better fallback placement using raycast
                if let query = arView.raycastQuery(from: location, allowing: .estimatedPlane, alignment: .horizontal),
                   let raycastResult = arView.session.raycast(query).first {
                    addPlanetFromRaycast(selectedPlanet, at: raycastResult, in: arView)
                } else {
                    print("⚠️ NO SURFACE - PLACING IN FRONT OF CAMERA")
                    addPlanetInFrontOfCamera(selectedPlanet, in: arView)
                }
            }
        }
        
        @objc func clearScene() {
            print("🗑️ CLEARING ALL PLANETS")
            for planet in placedPlanets {
                planet.removeFromParentNode()
            }
            placedPlanets.removeAll()
        }
        
        // FIXED: Correct planet placement using hit test result
        private func addPlanet(_ planet: Planet, at hitResult: ARHitTestResult, in arView: ARSCNView) {
            let planetNode = createPlanetNode(planet)
            
            // FIXED: Use the transform matrix directly for accurate placement
            let transform = hitResult.worldTransform
            let position = SCNVector3(
                transform.columns.3.x,
                transform.columns.3.y,
                transform.columns.3.z
            )
            
            planetNode.position = position
            
            arView.scene.rootNode.addChildNode(planetNode)
            placedPlanets.append(planetNode)
            print("🪐 PLANET PLACED: \(planet.name) at \(position)")
        }
        
        // FIXED: New method for raycast placement
        private func addPlanetFromRaycast(_ planet: Planet, at raycastResult: ARRaycastResult, in arView: ARSCNView) {
            let planetNode = createPlanetNode(planet)
            
            let transform = raycastResult.worldTransform
            let position = SCNVector3(
                transform.columns.3.x,
                transform.columns.3.y,
                transform.columns.3.z
            )
            
            planetNode.position = position
            
            arView.scene.rootNode.addChildNode(planetNode)
            placedPlanets.append(planetNode)
            print("🪐 PLANET PLACED VIA RAYCAST: \(planet.name) at \(position)")
        }
        
        // FIXED: Better camera-relative placement
        private func addPlanetInFrontOfCamera(_ planet: Planet, in arView: ARSCNView) {
            let planetNode = createPlanetNode(planet)
            
            // Place planet 1 meter in front of camera
            if let currentFrame = arView.session.currentFrame {
                let cameraTransform = currentFrame.camera.transform
                
                // FIXED: Proper forward vector calculation
                let forwardVector = SCNVector3(
                    -cameraTransform.columns.2.x,
                    -cameraTransform.columns.2.y,
                    -cameraTransform.columns.2.z
                )
                
                let cameraPosition = SCNVector3(
                    cameraTransform.columns.3.x,
                    cameraTransform.columns.3.y,
                    cameraTransform.columns.3.z
                )
                
                planetNode.position = SCNVector3(
                    cameraPosition.x + forwardVector.x * 1.0,
                    cameraPosition.y + forwardVector.y * 1.0,
                    cameraPosition.z + forwardVector.z * 1.0
                )
            } else {
                // Fallback position
                planetNode.position = SCNVector3(0, 0, -1)
            }
            
            arView.scene.rootNode.addChildNode(planetNode)
            placedPlanets.append(planetNode)
            print("🪐 PLANET PLACED IN FRONT: \(planet.name)")
        }
        
        // FIXED: Optimized planet creation for better performance
        private func createPlanetNode(_ planet: Planet) -> SCNNode {
            let radius = calculatePlanetRadius(planet)
            let sphere = SCNSphere(radius: CGFloat(radius))
            
            // FIXED: Reduce geometry complexity for better performance
            sphere.segmentCount = 24 // Reduced from default for better performance
            
            // Create material
            let material = SCNMaterial()
            material.diffuse.contents = UIColor(planet.color)
            material.specular.contents = UIColor.white.withAlphaComponent(0.3)
            material.shininess = 0.1
            
            // FIXED: Simplified material assignments
            switch planet.name {
            case "Earth":
                material.diffuse.contents = UIColor.systemBlue
                material.shininess = 0.5
            case "Mars":
                material.diffuse.contents = UIColor.systemRed
            case "Jupiter":
                material.diffuse.contents = UIColor.systemOrange
            case "Venus":
                material.diffuse.contents = UIColor.systemYellow
            case "Saturn":
                material.diffuse.contents = UIColor.systemYellow
            case "Mercury":
                material.diffuse.contents = UIColor.systemGray
            case "Uranus":
                material.diffuse.contents = UIColor.systemTeal
            case "Neptune":
                material.diffuse.contents = UIColor.systemBlue
            default:
                break
            }
            
            sphere.materials = [material]
            let planetNode = SCNNode(geometry: sphere)
            
            // FIXED: Slower rotation for better performance
            let rotation = SCNAction.rotateBy(x: 0, y: CGFloat.pi * 2, z: 0, duration: 20.0)
            let repeatRotation = SCNAction.repeatForever(rotation)
            planetNode.runAction(repeatRotation)
            
            // Add Saturn's rings if needed
            if planet.name == "Saturn" {
                let ringsNode = createSaturnRings(planetRadius: radius)
                planetNode.addChildNode(ringsNode)
            }
            
            // FIXED: Simplified label creation
            let labelNode = createPlanetLabel(planet.name, color: planet.color)
            labelNode.position = SCNVector3(0, radius + 0.05, 0)
            planetNode.addChildNode(labelNode)
            
            return planetNode
        }
        
        private func calculatePlanetRadius(_ planet: Planet) -> Float {
            let baseRadius: Float = 0.03 // FIXED: Smaller base size for better performance
            
            switch scaleMode {
            case .realistic:
                let maxDiameter = SolarSystemData.planets.map { $0.diameter }.max() ?? 1
                let logScale = log(planet.diameter) / log(maxDiameter)
                return baseRadius * (0.5 + Float(logScale) * 0.5)
                
            case .uniform:
                return baseRadius
                
            case .exaggerated:
                let scaleFactor = Float(planet.diameter / 12742)
                return baseRadius * max(0.5, min(scaleFactor * 1.5, 2.0))
            }
        }
        
        // FIXED: Simplified rings for better performance
        private func createSaturnRings(planetRadius: Float) -> SCNNode {
            let ringGeometry = SCNTorus(ringRadius: CGFloat(planetRadius * 1.8), pipeRadius: CGFloat(planetRadius * 0.05))
            let ringMaterial = SCNMaterial()
            ringMaterial.diffuse.contents = UIColor.systemYellow.withAlphaComponent(0.6)
            ringGeometry.materials = [ringMaterial]
            
            let ringsNode = SCNNode(geometry: ringGeometry)
            ringsNode.rotation = SCNVector4(1, 0, 0, Float.pi / 6)
            
            return ringsNode
        }
        
        // FIXED: Simplified label for better performance
        private func createPlanetLabel(_ text: String, color: Color) -> SCNNode {
            let textGeometry = SCNText(string: text, extrusionDepth: 0.005)
            textGeometry.font = UIFont.systemFont(ofSize: 0.05)
            textGeometry.firstMaterial?.diffuse.contents = UIColor.white
            
            let textNode = SCNNode(geometry: textGeometry)
            textNode.scale = SCNVector3(0.3, 0.3, 0.3)
            
            // Center the text
            let (min, max) = textNode.boundingBox
            let dx = min.x + (max.x - min.x) / 2
            textNode.pivot = SCNMatrix4MakeTranslation(dx, 0, 0)
            
            return textNode
        }
        
        // MARK: - ARSCNViewDelegate
        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
            
            // FIXED: Very subtle plane visualization
            let planeGeometry = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            let planeMaterial = SCNMaterial()
            planeMaterial.diffuse.contents = UIColor.white.withAlphaComponent(0.05)
            planeGeometry.materials = [planeMaterial]
            
            let planeNode = SCNNode(geometry: planeGeometry)
            planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
            planeNode.rotation = SCNVector4(1, 0, 0, -Float.pi / 2)
            
            node.addChildNode(planeNode)
        }
        
        // FIXED: Better error handling
        func session(_ session: ARSession, didFailWithError error: Error) {
            print("AR Session error: \(error.localizedDescription)")
        }
        
        func sessionWasInterrupted(_ session: ARSession) {
            print("AR Session interrupted")
        }
        
        func sessionInterruptionEnded(_ session: ARSession) {
            print("AR Session resumed")
        }
    }
}

// MARK: - AR Planet Picker (FIXED)
struct ARPlanetPickerView: View {
    @Binding var selectedPlanet: Planet?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 20) {
                        ForEach(SolarSystemData.planets) { planet in
                            planetCard(planet)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Choose Planet")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .preferredColorScheme(.dark)
        }
    }
    
    private func planetCard(_ planet: Planet) -> some View {
        Button(action: {
            selectedPlanet = planet
            print("🪐 Selected planet: \(planet.name)")
            dismiss()
        }) {
            VStack(spacing: 15) {
                // Planet visualization
                ZStack {
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
                    
                    if planet.name == "Earth" {
                        Image(systemName: planet.symbol)
                            .font(.system(size: 40))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    if planet.name == "Saturn" {
                        Ellipse()
                            .stroke(planet.color.opacity(0.8), lineWidth: 3)
                            .frame(width: 140, height: 30)
                    }
                }
                
                Text(planet.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("\(Int(planet.diameter)) km")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(
                        selectedPlanet?.id == planet.id ? planet.color : Color.clear,
                        lineWidth: 3
                    )
            )
        }
    }
}

// MARK: - Notification Extension
extension Notification.Name {
    static let clearARScene = Notification.Name("clearARScene")
}

// MARK: - Main Content View (COMPLETELY FIXED)
struct ContentView: View {
    @State private var selectedTab = 0
    @StateObject private var planetStore = PlanetStore()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                ImprovedPlanetCarousel()
                    .environmentObject(planetStore)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Image(systemName: "sparkles")
                Text("Planets")
            }
            .tag(0)
            
            NavigationView {
                ImprovedSolarSystemView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Image(systemName: "globe.europe.africa.fill")
                Text("Solar System")
            }
            .tag(1)
            
            // FIXED: AR Tab with correct view
            NavigationView {
                ARPlanetView()
                    .environmentObject(planetStore)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Image(systemName: "arkit")
                Text("AR Planets")
            }
            .tag(2)
            
            NavigationView {
                QuizView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Image(systemName: "brain.head.profile")
                Text("Quiz")
            }
            .tag(3)
        }
        .accentColor(.white)
        .preferredColorScheme(.dark)
        .environmentObject(planetStore)
        .onAppear {
            // Customize tab bar appearance for better spacing
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(white: 0.1, alpha: 0.9)
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
