import SwiftUI

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
