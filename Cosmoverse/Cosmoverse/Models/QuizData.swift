import Foundation

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
