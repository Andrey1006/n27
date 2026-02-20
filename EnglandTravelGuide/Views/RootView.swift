import SwiftUI

private enum RootStep {
    case createProfile
    case onboarding
    case mainTab
}

private let hasCompletedOnboardingKey = "hasCompletedOnboarding"

struct RootView: View {

    @StateObject private var appState = AppState()
    @State private var step: RootStep = RootView.resolveStep()

    var body: some View {
        Group {
            switch step {
            case .createProfile:
                CreateProfileView(
                    onDidSignIn: {
                        step = .onboarding
                    }
                )
            case .onboarding:
                OnboardingView(
                    onComplete: {
                        UserDefaults.standard.set(true, forKey: hasCompletedOnboardingKey)
                        step = .mainTab
                    }
                )
            case .mainTab:
                MainTabView(onSignOut: {
                    try? AuthService.signOut()
                    UserDefaults.standard.set(false, forKey: hasCompletedOnboardingKey)
                    step = .createProfile
                })
            }
        }
        .environmentObject(appState)
        .onAppear {
            step = RootView.resolveStep()
        }
    }

    private static func resolveStep() -> RootStep {
        if AuthService.currentUser == nil {
            return .createProfile
        }
        if !UserDefaults.standard.bool(forKey: hasCompletedOnboardingKey) {
            return .onboarding
        }
        return .mainTab
    }
}

#Preview {
    RootView()
}
