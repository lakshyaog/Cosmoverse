import SwiftUI

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
