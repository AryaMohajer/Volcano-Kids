import SwiftUI

struct PuzzleListView: View {
    
    @StateObject private var viewModel = PuzzleListViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.Colors.primaryBackground
                    .ignoresSafeArea()
                Rectangle()
                    .fill(Color.black.opacity(0.1))
                    .cornerRadius(AppTheme.CornerRadius.medium)
                    .shadow(radius: AppTheme.Shadows.small)
                    .frame(width: 370, height: 750)
                
                VStack {
                    Text("Amazing Volcanoes")
                        .font(AppTheme.Typography.pageTitleFont)
                        .foregroundColor(AppTheme.Colors.textPrimary)
                        .padding(.top, AppTheme.Spacing.medium)
                    
                    Spacer()
                    
                    // List of Volcanoes
                    List(viewModel.puzzleItems) { puzzle in
                        NavigationLink(destination: PuzzleDetailView(puzzle: puzzle)) {
                            PuzzleRowView(puzzle: puzzle)
                        }
                        .listRowBackground(Color.clear) // Makes row background transparent
                    }
                    .listStyle(PlainListStyle()) // Removes default styling
                    .scrollContentBackground(.hidden) // Hides default white background
                    .frame(maxHeight: 450) // Controls list expansion
                    
                    Spacer()
                    
                    WritingMoodView()
                }
                .padding()
            }
            .navigationBarBackButtonHidden(true)
            .ignoresSafeArea()
        }
    }
}
