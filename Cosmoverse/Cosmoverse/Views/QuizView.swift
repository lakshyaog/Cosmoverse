import SwiftUI

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
