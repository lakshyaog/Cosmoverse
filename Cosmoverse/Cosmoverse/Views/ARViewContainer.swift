import SwiftUI
import ARKit
import SceneKit

struct ARViewContainer: UIViewRepresentable {
    @Binding var selectedPlanet: Planet?
    @Binding var scaleMode: ARPlanetView.ScaleMode
    @Binding var showingInfo: Bool
    
    // Static method to check if AR is supported on this device
    static func isARSupported() -> Bool {
        return ARWorldTrackingConfiguration.isSupported
    }
    
    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView()
        arView.delegate = context.coordinator
        arView.scene = SCNScene()
        
        // Configure AR session for better performance
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        configuration.isLightEstimationEnabled = true
        
        // Better performance settings
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
        
        // Reduce debug output and improve performance
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
        
        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let selectedPlanet = parent.selectedPlanet else {
                print("❌ NO PLANET SELECTED")
                return
            }
            
            let arView = gesture.view as! ARSCNView
            let location = gesture.location(in: arView)
            
            // Use proper hit test types and coordinate conversion
            let hitTestResults = arView.hitTest(location, types: [.existingPlaneUsingExtent, .estimatedHorizontalPlane])
            
            if let hitResult = hitTestResults.first {
                print("✅ SURFACE FOUND - PLACING PLANET")
                addPlanet(selectedPlanet, at: hitResult, in: arView)
            } else {
                // Better fallback placement using raycast
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
        
        private func addPlanet(_ planet: Planet, at hitResult: ARHitTestResult, in arView: ARSCNView) {
            let planetNode = createPlanetNode(planet)
            
            // Use the transform matrix directly for accurate placement
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
        
        private func addPlanetInFrontOfCamera(_ planet: Planet, in arView: ARSCNView) {
            let planetNode = createPlanetNode(planet)
            
            // Place planet 1 meter in front of camera
            if let currentFrame = arView.session.currentFrame {
                let cameraTransform = currentFrame.camera.transform
                
                // Proper forward vector calculation
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
        
        private func createPlanetNode(_ planet: Planet) -> SCNNode {
            let radius = calculatePlanetRadius(planet)
            let sphere = SCNSphere(radius: CGFloat(radius))
            
            // Reduce geometry complexity for better performance
            sphere.segmentCount = 24 // Reduced from default for better performance
            
            // Create material
            let material = SCNMaterial()
            material.diffuse.contents = UIColor(planet.color)
            material.specular.contents = UIColor.white.withAlphaComponent(0.3)
            material.shininess = 0.1
            
            // Simplified material assignments
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
            
            // Slower rotation for better performance
            let rotation = SCNAction.rotateBy(x: 0, y: CGFloat.pi * 2, z: 0, duration: 20.0)
            let repeatRotation = SCNAction.repeatForever(rotation)
            planetNode.runAction(repeatRotation)
            
            // Add Saturn's rings if needed
            if planet.name == "Saturn" {
                let ringsNode = createSaturnRings(planetRadius: radius)
                planetNode.addChildNode(ringsNode)
            }
            
            // Simplified label creation
            let labelNode = createPlanetLabel(planet.name, color: planet.color)
            labelNode.position = SCNVector3(0, radius + 0.05, 0)
            planetNode.addChildNode(labelNode)
            
            return planetNode
        }
        
        private func calculatePlanetRadius(_ planet: Planet) -> Float {
            let baseRadius: Float = 0.03 // Smaller base size for better performance
            
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
        
        private func createSaturnRings(planetRadius: Float) -> SCNNode {
            let ringGeometry = SCNTorus(ringRadius: CGFloat(planetRadius * 1.8), pipeRadius: CGFloat(planetRadius * 0.05))
            let ringMaterial = SCNMaterial()
            ringMaterial.diffuse.contents = UIColor.systemYellow.withAlphaComponent(0.6)
            ringGeometry.materials = [ringMaterial]
            
            let ringsNode = SCNNode(geometry: ringGeometry)
            ringsNode.rotation = SCNVector4(1, 0, 0, Float.pi / 6)
            
            return ringsNode
        }
        
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
            
            // Very subtle plane visualization
            let planeGeometry = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            let planeMaterial = SCNMaterial()
            planeMaterial.diffuse.contents = UIColor.white.withAlphaComponent(0.05)
            planeGeometry.materials = [planeMaterial]
            
            let planeNode = SCNNode(geometry: planeGeometry)
            planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
            planeNode.rotation = SCNVector4(1, 0, 0, -Float.pi / 2)
            
            node.addChildNode(planeNode)
        }
        
        // Better error handling
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
