import SwiftUI
import ARKit
import SceneKit

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
