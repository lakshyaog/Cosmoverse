import SwiftUI

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
