import SwiftUI
import RealityKit
import SceneKit

struct DetailView1: View {
    @ObservedObject var viewModel: PageViewModel
    let pageId: Int
    @StateObject private var historyViewModel = EarthHistoryViewModel()
    @State private var showModelView = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            // Beautiful gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.1, green: 0.0, blue: 0.2),
                    Color(red: 0.3, green: 0.0, blue: 0.1),
                    AppTheme.Colors.primaryBackground,
                    AppTheme.Colors.accent.opacity(0.8)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
                        .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with back button (only one)
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                            Text("Back")
                                .font(.custom("Noteworthy-Bold", size: 17))
                        }
                            .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, AppTheme.Spacing.medium)
                .padding(.top, AppTheme.Spacing.small)
                
                // Educational Section with pagination
                educationalSection
            }
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showModelView) {
            ModelView()
        }
    }
    
    // MARK: - Educational Section
    private var educationalSection: some View {
        VStack(spacing: 0) {
            // Step indicator - centered
            HStack {
                Spacer()
                Text("Step \(historyViewModel.currentStep + 1) of \(historyViewModel.totalSteps)")
                    .font(.custom("Noteworthy-Bold", size: 18))
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.horizontal, AppTheme.Spacing.medium)
                    .padding(.vertical, AppTheme.Spacing.small)
                    .background(
                        Capsule()
                            .fill(Color.black.opacity(0.3))
                    )
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, AppTheme.Spacing.small)
            
            // Progress dots
            HStack(spacing: 8) {
                ForEach(0..<historyViewModel.totalSteps, id: \.self) { index in
                    Circle()
                        .fill(index <= historyViewModel.currentStep ? Color.yellow : Color.white.opacity(0.3))
                        .frame(width: 10, height: 10)
                        .scaleEffect(index == historyViewModel.currentStep ? 1.3 : 1.0)
                        .animation(.spring(response: 0.3), value: historyViewModel.currentStep)
                }
            }
            .padding(.vertical, AppTheme.Spacing.small)
            
            // Main content area with pagination
            TabView(selection: $historyViewModel.currentStep) {
                ForEach(0..<historyViewModel.totalSteps, id: \.self) { step in
                    ScrollView {
                        VStack(spacing: AppTheme.Spacing.large) {
                            // Title
                            Text("History of Earth")
                                .font(.custom("Noteworthy-Bold", size: 38))
                                .foregroundColor(.white)
                                .shadow(color: .black, radius: 10)
                                .padding(.top, AppTheme.Spacing.medium)
                            
                            // Current stage card
                            EarthHistoryCardView(
                                stage: historyViewModel.historyStages[step],
                                stepNumber: step + 1,
                                totalSteps: historyViewModel.totalSteps
                            )
                            .padding(.horizontal)
                            
                            // Fun fact flip card
                            VStack(spacing: AppTheme.Spacing.medium) {
                                Text("💡 Fun Fact!")
                                    .font(.custom("Noteworthy-Bold", size: 22))
                                    .foregroundColor(.yellow)
                                
                                FlipFactCardView(
                                    fact: historyViewModel.historyStages[step].funFact,
                                    emoji: historyViewModel.historyStages[step].emoji
                                )
                            }
                            .padding(.horizontal)
                            
                            // 3D Model button (only on last step)
                            if historyViewModel.isLastStep {
                                Button(action: {
                                    showModelView = true
                                }) {
                                    HStack {
                                        Image(systemName: "cube.box")
                                            .font(.system(size: 24))
                                        Text("See 3D Earth Model")
                                            .font(.custom("Noteworthy-Bold", size: 20))
                                    }
                                    .foregroundColor(.white)
                                    .padding(.horizontal, AppTheme.Spacing.extraLarge)
                                    .padding(.vertical, AppTheme.Spacing.medium)
        .background(
                                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                                            .fill(
                                                LinearGradient(
                                                    colors: [.purple, .blue],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                    )
                                }
                                .padding(.horizontal)
                            }
                            
                            // Mini Quiz - different question for each step
                            let currentQuestion = historyViewModel.getQuizQuestion(for: step)
                            MiniQuizBlockView(
                                question: currentQuestion.question,
                                options: currentQuestion.options,
                                correctAnswer: currentQuestion.correctAnswer,
                                selectedAnswer: Binding(
                                    get: { historyViewModel.currentQuizAnswer },
                                    set: { _ in }
                                ),
                                showResult: $historyViewModel.showQuizResult,
                                isCorrect: $historyViewModel.isQuizCorrect,
                                onAnswerSelected: { index in
                                    historyViewModel.checkQuizAnswer(index, for: currentQuestion)
                                }
                            )
                            .padding(.horizontal)
                            
                            // Next button (only show if not last step)
                            if !historyViewModel.isLastStep {
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        historyViewModel.nextStep()
                                    }) {
                                        HStack {
                                            Text("Next Adventure")
                                            Image(systemName: "chevron.right")
                                        }
                                        .font(.custom("Noteworthy-Bold", size: 18))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, AppTheme.Spacing.large)
                                        .padding(.vertical, AppTheme.Spacing.medium)
                                        .background(
                                            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                                                .fill(
                                                    LinearGradient(
                                                        colors: [.orange, .red],
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    )
                                                )
                                        )
                                    }
                                    Spacer()
                                }
                                .padding(.horizontal)
                                .padding(.bottom, AppTheme.Spacing.extraLarge)
                            } else {
                                Spacer()
                                    .frame(height: AppTheme.Spacing.extraLarge)
                            }
                        }
                    }
                    .tag(step)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

#Preview {
    DetailView1(viewModel: PageViewModel(), pageId: 1)
}
