import SwiftUI

struct PuzzleListView: View {
    
    @StateObject private var viewModel = PuzzleListViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                AppTheme.Colors.primaryBackground
                    .ignoresSafeArea()
                
                // Content container
                VStack(spacing: 0) {
                    // Top safe area spacing
                    Spacer()
                        .frame(height: 8)
                    
                    // Header with white back button - properly styled
                    HStack(alignment: .center) {
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
                        .buttonStyle(PlainButtonStyle())
                        
                        Spacer()
                    }
                    .padding(.horizontal, AppTheme.Spacing.medium)
                    .padding(.top, 8)
                    
                    // Title with optimal spacing
                    Text("Amazing Volcanoes")
                        .font(.custom("Noteworthy-Bold", size: 32))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 2)
                        .padding(.top, AppTheme.Spacing.large)
                        .padding(.bottom, AppTheme.Spacing.medium)
                    
                    // List of Volcanoes - Optimized spacing for perfect fit
                    VStack(spacing: 10) {
                        ForEach(viewModel.puzzleItems) { puzzle in
                            NavigationLink(destination: PuzzleDetailView(puzzle: puzzle)) {
                                PuzzleRowView(puzzle: puzzle)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.large)
                    .padding(.top, AppTheme.Spacing.medium)
                    
                    // Flexible spacer to push footer down
                    Spacer()
                    
                    // Footer text with proper spacing
                    WritingMoodView()
                        .padding(.horizontal, AppTheme.Spacing.medium)
                        .padding(.bottom, AppTheme.Spacing.medium)
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .ignoresSafeArea()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
