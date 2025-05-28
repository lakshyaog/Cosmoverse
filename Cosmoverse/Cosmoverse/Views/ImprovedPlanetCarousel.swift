import SwiftUI

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
