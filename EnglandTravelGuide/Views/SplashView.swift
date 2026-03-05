import SwiftUI

struct SplashView: View {
    @State private var logoScale: CGFloat = 0.6
    @State private var logoOpacity: Double = 0
    @State private var titleOpacity: Double = 0
    @State private var subtitleOpacity: Double = 0
    @State private var ringScale: CGFloat = 0.8
    @State private var ringOpacity: Double = 0.6
    @State private var pulseScale: CGFloat = 1

    private let headerBackground = Color(r: 19, g: 17, b: 27)
    private let headerShadow = Color(r: 128, g: 115, b: 221)
    private let cardBackground = Color(r: 45, g: 37, b: 104)
    private let accentOrange = Color(r: 255, g: 94, b: 0)

    var body: some View {
        ZStack {
            Image(.mainBackground)
                .resizable()
                .ignoresSafeArea()

            LinearGradient(
                colors: [
                    headerBackground.opacity(0.4),
                    headerBackground.opacity(0.1),
                    .clear
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                ZStack {
                    Circle()
                        .stroke(headerShadow.opacity(ringOpacity), lineWidth: 2)
                        .frame(width: 120, height: 120)
                        .scaleEffect(ringScale)

                    Circle()
                        .fill(cardBackground.opacity(0.9))
                        .frame(width: 100, height: 100)
                        .overlay {
                            Circle()
                                .stroke(headerShadow.opacity(0.5), lineWidth: 1)
                        }
                        .shadow(color: headerShadow.opacity(0.4), radius: 12, x: 0, y: 4)
                        .scaleEffect(logoScale * pulseScale)

                    Image(systemName: "map.fill")
                        .font(.system(size: 44))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [accentOrange, headerShadow],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .scaleEffect(logoScale)
                }
                .frame(height: 140)

                VStack(spacing: 8) {
                    Text("Travel Guide")
                        .font(.interBlack(size: 28))
                        .foregroundStyle(.white)
                        .opacity(titleOpacity)
                }

                HStack(spacing: 6) {
                    ForEach(0..<3, id: \.self) { index in
                        SplashDotView(delay: Double(index) * 0.15, color: accentOrange)
                    }
                }
                .padding(.top, 32)
            }
            .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                logoScale = 1
                logoOpacity = 1
                ringScale = 1.15
                ringOpacity = 0.3
            }
            withAnimation(.easeOut(duration: 0.5).delay(0.25)) {
                titleOpacity = 1
            }
            withAnimation(.easeOut(duration: 0.5).delay(0.4)) {
                subtitleOpacity = 1
            }
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true).delay(0.8)) {
                pulseScale = 1.05
            }
            withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
                ringScale = 1.25
                ringOpacity = 0
            }
        }
    }
}

private struct SplashDotView: View {
    let delay: Double
    let color: Color

    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 8, height: 8)
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true).delay(delay)) {
                    scale = 1.2
                    opacity = 1
                }
            }
    }
}

#Preview {
    SplashView()
}
