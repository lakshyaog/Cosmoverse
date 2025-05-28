import Foundation

/**
 # Cosmoverse App Structure
 
 This app is organized with a clean, modular architecture:
 
 ## Models
 - `Planet.swift` - Defines the Planet model with properties like name, description, etc.
 - `SolarSystemData.swift` - Contains the static data for all planets
 - `QuizData.swift` - Contains quiz questions and answers
 
 ## Views 
 - `ViewsNamespace.swift` - Contains the Views namespace with the main ContentView implementation
 - `ImprovedStarField.swift` - Background starfield visualization
 - `ImprovedSolarSystemView.swift` - Interactive solar system view
 - `ImprovedPlanetDetailView.swift` - Detailed planet information view
 - `ImprovedPlanetCarousel.swift` - Main carousel exploration view
 - `PlanetCarouselCard.swift` - Individual planet card for carousel
 - `QuizView.swift` - Interactive quiz about planets
 - `QuizCompletionView.swift` - Quiz results and celebration
 - `ARPlanetView.swift` - Augmented reality planet viewing experience
 - `ARViewContainer.swift` - AR implementation with SceneKit
 - `ARPlanetPickerView.swift` - Selection interface for AR planets
 
 ## Utilities
 - `PlanetStore.swift` - Shared state management for planet selection
 
 ## App Structure
 - `ContentView.swift` - Simple bridge to the Views namespace
 - `CosmoverseApp.swift` - App entry point
 - `AppArchitecture.swift` - Documentation of app architecture
 - `ARPlanetView.swift` - AR experience view for placing planets
 - `ARViewContainer.swift` - AR underlying implementation
 - `ARPlanetPickerView.swift` - Picker for AR planets
 - `ViewsNamespace.swift` - Views namespace to organize view hierarchy
 
 ## Utilities
 - `PlanetStore.swift` - Shared state for planet selection
 
 This modular approach makes the code more maintainable, easier to understand,
 and allows for better separation of concerns.
 */

// This file serves as documentation for the app's architecture
