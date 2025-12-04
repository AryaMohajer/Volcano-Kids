import SwiftUI

/// Settings Page
struct DetailView8: View {
    @ObservedObject var viewModel: PageViewModel
    let pageId: Int
    @StateObject private var settingsViewModel = SettingsViewModel()
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
            
            ScrollView {
                VStack(spacing: AppTheme.Spacing.large) {
                    // Header with back button
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
                    
                    // Title
                    Text("⚙️ Settings")
                        .font(.custom("Noteworthy-Bold", size: 42))
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 10)
                        .padding(.top, AppTheme.Spacing.medium)
                    
                    // Settings Sections
                    VStack(spacing: AppTheme.Spacing.large) {
                        // Theme Selection
                        settingsSection(
                            title: "🎨 Theme",
                            content: {
                                VStack(spacing: AppTheme.Spacing.medium) {
                                    ForEach(AppThemeType.allCases, id: \.self) { theme in
                                        themeSelectionRow(
                                            theme: theme,
                                            isSelected: settingsViewModel.selectedTheme == theme
                                        ) {
                                            settingsViewModel.selectedTheme = theme
                                        }
                                    }
                                }
                            }
                        )
                        
                        // App Information
                        settingsSection(
                            title: "ℹ️ App Information",
                            content: {
                                VStack(spacing: AppTheme.Spacing.medium) {
                                    settingsInfoRow(
                                        icon: "info.circle.fill",
                                        title: "Version",
                                        value: settingsViewModel.getAppVersion()
                                    )
                                    
                                    settingsInfoRow(
                                        icon: "book.fill",
                                        title: "Educational Content",
                                        value: "11 Pages"
                                    )
                                }
                            }
                        )
                        
                        // Reset Progress
                        settingsSection(
                            title: "🔄 Reset",
                            content: {
                                VStack(spacing: AppTheme.Spacing.medium) {
                                    Button(action: {
                                        settingsViewModel.showResetConfirmation = true
                                    }) {
                                        HStack {
                                            Image(systemName: "arrow.counterclockwise")
                                                .font(.system(size: 20))
                                            Text("Reset All Progress")
                                                .font(.custom("Noteworthy-Bold", size: 18))
                                            Spacer()
                                        }
                                        .foregroundColor(.white)
                                        .padding(AppTheme.Spacing.medium)
                                        .background(
                                            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                                                .fill(Color.orange.opacity(0.3))
                                        )
                                    }
                                }
                            }
                        )
                        
                        // Contact & Legal
                        settingsSection(
                            title: "📧 Contact & Legal",
                            content: {
                                VStack(spacing: AppTheme.Spacing.medium) {
                                    // Contact Button
                                    Button(action: {
                                        openEmail()
                                    }) {
                                        HStack {
                                            Image(systemName: "envelope.fill")
                                                .font(.system(size: 20))
                                            Text("Contact Us")
                                                .font(.custom("Noteworthy-Bold", size: 18))
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 16))
                                                .foregroundColor(.white.opacity(0.6))
                                        }
                                        .foregroundColor(.white)
                                        .padding(AppTheme.Spacing.medium)
                                        .background(
                                            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                                                .fill(Color.white.opacity(0.05))
                                        )
                                    }
                                    
                                    // Privacy Policy Button
                                    Button(action: {
                                        openURL("https://mercurial-floor-265.notion.site/privacy-policy-Volcano-app-2bf17fca8681800195f2c71e52dda27f")
                                    }) {
                                        HStack {
                                            Image(systemName: "lock.shield.fill")
                                                .font(.system(size: 20))
                                            Text("Privacy Policy")
                                                .font(.custom("Noteworthy-Bold", size: 18))
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 16))
                                                .foregroundColor(.white.opacity(0.6))
                                        }
                                        .foregroundColor(.white)
                                        .padding(AppTheme.Spacing.medium)
                                        .background(
                                            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                                                .fill(Color.white.opacity(0.05))
                                        )
                                    }
                                    
                                    // Terms and Conditions Button
                                    Button(action: {
                                        openURL("https://mercurial-floor-265.notion.site/Terms-Condition-Volcano-app-2bf17fca86818048bce1d0f144dade2a")
                                    }) {
                                        HStack {
                                            Image(systemName: "doc.text.fill")
                                                .font(.system(size: 20))
                                            Text("Terms and Conditions")
                                                .font(.custom("Noteworthy-Bold", size: 18))
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 16))
                                                .foregroundColor(.white.opacity(0.6))
                                        }
                                        .foregroundColor(.white)
                                        .padding(AppTheme.Spacing.medium)
                                        .background(
                                            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                                                .fill(Color.white.opacity(0.05))
                                        )
                                    }
                                }
                            }
                        )
                    }
                    .padding(.horizontal, AppTheme.Spacing.medium)
                    
                    // Credits Section
                    VStack(spacing: AppTheme.Spacing.medium) {
                        Divider()
                            .background(Color.white.opacity(0.3))
                            .padding(.vertical, AppTheme.Spacing.large)
                        
                        Text("Made by")
                            .font(.custom("Noteworthy-Bold", size: 22))
                            .foregroundColor(.white.opacity(0.9))
                        
                        VStack(spacing: 10) {
                            Text("Arya Mohajer")
                                .font(.custom("Noteworthy-Bold", size: 28))
                                .foregroundColor(.white)
                                .bold()
                            
                            Text("and")
                                .font(.custom("Noteworthy-Bold", size: 20))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("Kimia Karbin")
                                .font(.custom("Noteworthy-Bold", size: 28))
                                .foregroundColor(.white)
                                .bold()
                        }
                        .padding(.vertical, AppTheme.Spacing.large)
                        .padding(.horizontal, AppTheme.Spacing.extraLarge)
                        .background(
                            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.white.opacity(0.15), Color.white.opacity(0.1)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                                        .stroke(
                                            LinearGradient(
                                                colors: [Color.white.opacity(0.4), Color.yellow.opacity(0.3)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 3
                                        )
                                )
                                .shadow(color: Color.yellow.opacity(0.3), radius: 10, x: 0, y: 5)
                        )
                        
                        Text("by love ❤️")
                            .font(.custom("Noteworthy-Bold", size: 24))
                            .foregroundColor(.yellow)
                            .bold()
                            .shadow(color: Color.yellow.opacity(0.5), radius: 5)
                            .padding(.top, AppTheme.Spacing.medium)
                    }
                    .padding(.horizontal, AppTheme.Spacing.medium)
                    .padding(.bottom, AppTheme.Spacing.extraLarge)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .alert("Reset Progress", isPresented: $settingsViewModel.showResetConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                settingsViewModel.resetProgress()
                // Reload pages to reflect the reset and clear completion status
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    viewModel.loadPages()
                }
            }
        } message: {
            Text("Are you sure?? ")
        }
    }
    
    // MARK: - Settings Section
    private func settingsSection<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
            Text(title)
                .font(.custom("Noteworthy-Bold", size: 24))
                .foregroundColor(.white)
                .padding(.bottom, AppTheme.Spacing.small)
            
            content()
        }
        .padding(AppTheme.Spacing.large)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    // MARK: - Settings Toggle Row
    private func settingsToggleRow(
        icon: String,
        title: String,
        isOn: Binding<Bool>
    ) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(.white)
                .frame(width: 30)
            
            Text(title)
                .font(.custom("Noteworthy-Bold", size: 18))
                .foregroundColor(.white)
            
            Spacer()
            
            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(.orange)
        }
        .padding(AppTheme.Spacing.medium)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                .fill(Color.white.opacity(0.05))
        )
    }
    
    // MARK: - Settings Info Row
    private func settingsInfoRow(
        icon: String,
        title: String,
        value: String
    ) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(.white)
                .frame(width: 30)
            
            Text(title)
                .font(.custom("Noteworthy-Bold", size: 18))
                .foregroundColor(.white)
            
            Spacer()
            
            Text(value)
                .font(.custom("Noteworthy-Bold", size: 16))
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(AppTheme.Spacing.medium)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                .fill(Color.white.opacity(0.05))
        )
    }
    
    // MARK: - Theme Selection Row
    private func themeSelectionRow(
        theme: AppThemeType,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: {
            action()
        }) {
            HStack(spacing: AppTheme.Spacing.medium) {
                // Theme preview circle
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: theme.colors.backgroundGradient.prefix(2).map { $0 },
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        )
                    
                    Text(theme.emoji)
                        .font(.system(size: 24))
                }
                
                Text(theme.displayName)
                    .font(.custom("Noteworthy-Bold", size: 18))
                    .foregroundColor(.white)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.green)
                } else {
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        .frame(width: 24, height: 24)
                }
            }
            .padding(AppTheme.Spacing.medium)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .fill(isSelected ? Color.white.opacity(0.15) : Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                            .stroke(isSelected ? Color.green.opacity(0.5) : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Helper Functions
    private func openEmail() {
        let email = "ariyamohajer321@gmail.com"
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    DetailView8(viewModel: PageViewModel(), pageId: 8)
}

