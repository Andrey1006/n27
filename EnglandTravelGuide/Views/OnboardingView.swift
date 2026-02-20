import SwiftUI

struct OnboardingView: View {

    var onComplete: (() -> Void)?

    @State private var currentPage = 0

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "map",
            gradientColors: [Color(r: 91, g: 37, b: 104), Color(r: 206, g: 109, b: 73)],
            title: "Welcome to England Offline Guide",
            description: "Explore England's top landmarks, hidden gems, and local culture in one simple app. Everything works offline with content saved on your device."
        ),
        OnboardingPage(
            icon: "book",
            gradientColors: [Color(r: 55, g: 174, b: 229), Color(r: 89, g: 73, b: 206)],
            title: "Map, Pins, and Cards",
            description: "Browse attractions on an offline map and tap pins to open quick details. Use beautiful cards for deeper information, tips, and quick facts."
        ),
        OnboardingPage(
            icon: "chart.line.uptrend.xyaxis",
            gradientColors: [Color(r: 129, g: 255, b: 2), Color(r: 136, g: 194, b: 203)],
            title: "Checklist + Progress",
            description: "Follow the \"Discover England\" checklist step by step and mark places as visited. Track your progress and save favorites—no accounts required."
        )
    ]

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentPage) {
                ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                    onboardingPageView(page: page, isLast: index == pages.count - 1)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Image(.mainBackground)
                .resizable()
                .ignoresSafeArea()
        }
    }

    private func onboardingPageView(page: OnboardingPage, isLast: Bool) -> some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Spacer()

                iconView(icon: page.icon, gradientColors: page.gradientColors)


                Text(page.title)
                    .font(.interBold(size: 24))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 42)
                    .padding(.top, 48)
                
                Text(page.description)
                    .font(.interRegular(size: 14))
                    .foregroundStyle(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 42)
                    .padding(.top, 24)

                Spacer()
            }

            pageIndicator
            
            if isLast {
                button(title: "Get Started") {
                    onComplete?()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 50)
            } else {
                VStack(spacing: 12) {
                    button(title: "Next", filled: true) {
                        withAnimation {
                            currentPage += 1
                        }
                    }
                    button(title: "Skip", filled: false) {
                        onComplete?()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 36)
            }
        }
    }

    private func iconView(icon: String, gradientColors: [Color]) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: gradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 120, height: 120)

            Image(systemName: icon)
                .font(.system(size: 36, weight: .medium))
                .foregroundStyle(.white)
        }
    }

    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(0..<pages.count, id: \.self) { index in
                RoundedRectangle(cornerRadius: 100)
                    .fill(index == currentPage ? Color(r: 255, g: 94, b: 0) : Color.gray.opacity(0.5))
                    .frame(width: index == currentPage ? 30 : 10, height: 8)
            }
        }
        .padding(.bottom, 24)
    }

    private func button(title: String, filled: Bool = true, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.interBold(size: 18))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(filled ? Color(r: 255, g: 94, b: 0) : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 40))
                .overlay {
                    if !filled {
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(.white, lineWidth: 1)
                    }
                }
        }
        .buttonStyle(.plain)
    }
}

private struct OnboardingPage {
    let icon: String
    let gradientColors: [Color]
    let title: String
    let description: String
}

#Preview {
    OnboardingView()
}
