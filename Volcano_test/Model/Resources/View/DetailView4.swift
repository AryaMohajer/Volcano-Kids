import SwiftUI

struct DetailView4: View {
    @ObservedObject var viewModel: PageViewModel
    let pageId: Int
    @StateObject private var typesViewModel = VolcanoTypesViewModel()
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
                // Header
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
        .onChange(of: typesViewModel.currentStep) { newStep in
            // Mark page as completed when user reaches the last step
            if typesViewModel.isLastStep {
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
                Text("Step \(typesViewModel.currentStep + 1) of \(typesViewModel.totalSteps)")
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
                ForEach(0..<typesViewModel.totalSteps, id: \.self) { index in
                    Circle()
                        .fill(index <= typesViewModel.currentStep ?
                              Color.green :
                              Color.white.opacity(0.3))
                        .frame(width: 10, height: 10)
                        .scaleEffect(index == typesViewModel.currentStep ? 1.3 : 1.0)
                        .animation(.spring(response: 0.3), value: typesViewModel.currentStep)
                }
            }
            .padding(.vertical, AppTheme.Spacing.small)
            
            // Main content area with pagination
            TabView(selection: $typesViewModel.currentStep) {
                ForEach(0..<typesViewModel.totalSteps, id: \.self) { step in
                    ScrollView {
                        VStack(spacing: AppTheme.Spacing.large) {
                            // Title
                            Text("Types of Volcanoes")
                                .font(.custom("Noteworthy-Bold", size: 38))
                                .foregroundColor(.white)
                                .shadow(color: .black, radius: 10)
                                .padding(.top, AppTheme.Spacing.medium)
                            
                            // Current type card
                            VolcanoTypeCardView(
                                volcanoType: typesViewModel.volcanoTypes[step],
                                stepNumber: step + 1,
                                totalSteps: typesViewModel.totalSteps
                            )
                            .padding(.horizontal)
                            
                            // Fun fact flip card
                            VStack(spacing: AppTheme.Spacing.medium) {
                                Text("💡 Fun Fact!")
                                    .font(.custom("Noteworthy-Bold", size: 22))
                                    .foregroundColor(.yellow)
                                
                                FlipFactCardView(
                                    fact: typesViewModel.volcanoTypes[step].funFact,
                                    emoji: typesViewModel.volcanoTypes[step].emoji
                                )
                            }
                            .padding(.horizontal)
                            
                            // Next button (only show if not last step)
                            if !typesViewModel.isLastStep {
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        typesViewModel.nextStep()
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
                                // Last step - just add spacing
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
    DetailView4(viewModel: PageViewModel(), pageId: 4)
}
