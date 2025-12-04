import SwiftUI

/// Volcano Rocks & Minerals Page
struct DetailView7: View {
    @ObservedObject var viewModel: PageViewModel
    let pageId: Int
    @StateObject private var rocksViewModel = RocksViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        ZStack {
            // Dynamic gradient background based on selected theme
            LinearGradient(
                gradient: Gradient(colors: themeManager.themeColors.backgroundGradient),
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
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onChange(of: rocksViewModel.currentStep) { newStep in
            // Mark page as completed when user reaches the last step
            if rocksViewModel.isLastStep {
                viewModel.completePage(pageId)
            }
        }
    }
    
    // MARK: - Educational Section (Redesigned to match Parts of Volcano)
    private var educationalSection: some View {
        VStack(spacing: 0) {
            // Step indicator - centered
            HStack {
                Spacer()
                Text("Step \(rocksViewModel.currentStep + 1) of \(rocksViewModel.totalSteps)")
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
                ForEach(0..<rocksViewModel.totalSteps, id: \.self) { index in
                    Circle()
                        .fill(index <= rocksViewModel.currentStep ?
                              Color.green :
                              Color.white.opacity(0.3))
                        .frame(width: 10, height: 10)
                        .scaleEffect(index == rocksViewModel.currentStep ? 1.3 : 1.0)
                        .animation(.spring(response: 0.3), value: rocksViewModel.currentStep)
                }
            }
            .padding(.vertical, AppTheme.Spacing.small)
            
            // Main content area with pagination
            TabView(selection: $rocksViewModel.currentStep) {
                ForEach(0..<rocksViewModel.totalSteps, id: \.self) { step in
                    ScrollView {
                        VStack(spacing: AppTheme.Spacing.large) {
                            // Title
                            Text("Volcano Rocks")
                                .font(.custom("Noteworthy-Bold", size: 38))
                                .foregroundColor(.white)
                                .shadow(color: .black, radius: 10)
                                .padding(.top, AppTheme.Spacing.medium)
                            
                            // Current rock card
                            RockCardView(rock: rocksViewModel.rocks[step], viewModel: rocksViewModel)
                                .padding(.horizontal)
                            
                            // Fun fact flip card
                            VStack(spacing: AppTheme.Spacing.medium) {
                                Text("💡 Fun Fact!")
                                    .font(.custom("Noteworthy-Bold", size: 22))
                                    .foregroundColor(.yellow)
                                
                                FlipFactCardView(
                                    fact: rocksViewModel.rocks[step].funFact,
                                    emoji: rocksViewModel.rocks[step].emoji
                                )
                            }
                            .padding(.horizontal)
                            
                            // Mini Quiz - different question for each rock
                            let currentQuestion = rocksViewModel.getQuizQuestion(for: step)
                            MiniQuizBlockView(
                                question: currentQuestion.question,
                                options: currentQuestion.options,
                                correctAnswer: currentQuestion.correctAnswer,
                                selectedAnswer: Binding(
                                    get: { rocksViewModel.currentQuizAnswer },
                                    set: { _ in }
                                ),
                                showResult: $rocksViewModel.showQuizResult,
                                isCorrect: $rocksViewModel.isQuizCorrect,
                                onAnswerSelected: { index in
                                    rocksViewModel.checkQuizAnswer(index, for: currentQuestion)
                                }
                            )
                            .padding(.horizontal)
                            
                            // Next button (only show if not last step)
                            if !rocksViewModel.isLastStep {
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        rocksViewModel.nextStep()
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

// MARK: - Rock Section
struct RockSection: View {
    let rock: VolcanoRock
    @ObservedObject var viewModel: RocksViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
            HStack(spacing: AppTheme.Spacing.medium) {
                Text(rock.emoji)
                    .font(.system(size: 50))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(rock.name)
                        .font(.custom("Noteworthy-Bold", size: 24))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                    
                    Text(rock.description)
                        .font(.custom("Noteworthy-Bold", size: 17))
                        .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            // Micro story box
            VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                HStack {
                    Text("📖")
                        .font(.system(size: 20))
                    Text("Story Time!")
                        .font(.custom("Noteworthy-Bold", size: 18))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                }
                
                Text(rock.microStory)
                    .font(.custom("Noteworthy-Bold", size: 15))
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(AppTheme.Spacing.medium)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .fill(rock.color.opacity(0.1))
            )
            
            // Interactive fact card
            InteractiveFactCardView(
                title: "Did You Know?",
                emoji: "💡",
                fact: rock.funFact,
                isRevealed: viewModel.revealedFacts.contains(rock.id),
                onTap: {
                    viewModel.toggleFactReveal(rock.id)
                }
            )
        }
        .padding(AppTheme.Spacing.large)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

// MARK: - Mineral Card
struct MineralCard: View {
    let mineral: VolcanoMineral
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.medium) {
            Text(mineral.emoji)
                .font(.system(size: 50))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(mineral.name)
                    .font(.custom("Noteworthy-Bold", size: 20))
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                
                Text(mineral.description)
                    .font(.custom("Noteworthy-Bold", size: 16))
                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                    .fixedSize(horizontal: false, vertical: true)
                
                // Fun fact
                HStack {
                    Text("💡")
                        .font(.system(size: 16))
                    Text(mineral.funFact)
                        .font(.custom("Noteworthy-Bold", size: 14))
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        .italic()
                }
                .padding(.top, 4)
            }
            
            Spacer()
        }
        .padding(AppTheme.Spacing.medium)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                .fill(mineral.color.opacity(0.1))
        )
    }
}

#Preview {
    DetailView7(viewModel: PageViewModel(), pageId: 7)
}

