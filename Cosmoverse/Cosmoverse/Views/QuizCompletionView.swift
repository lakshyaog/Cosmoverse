import SwiftUI

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
