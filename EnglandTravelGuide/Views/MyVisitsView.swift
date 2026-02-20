import SwiftUI

struct MyVisitsView: View {

    var onBack: (() -> Void)?
    var onExploreAttractions: (() -> Void)?

    @EnvironmentObject var appState: AppState

    private let headerBackground = Color(r: 19, g: 17, b: 27)
    private let headerShadow = Color(r: 128, g: 115, b: 221)
    private let cardBackground = Color(r: 45, g: 37, b: 104)
    private let accentOrange = Color(r: 255, g: 94, b: 0)
    private let accentPink = Color(r: 243, g: 58, b: 150)
    private let accentPurple = Color(r: 128, g: 115, b: 221)
    private let emptyStateBackground = Color(r: 45, g: 37, b: 104)

    var body: some View {
        VStack(spacing: 0) {
            header

            VStack(spacing: 24) {

                emptyStateSection
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Image(.mainBackground)
                .resizable()
                .ignoresSafeArea()
        }
    }

    private var header: some View {
        VStack(spacing: 16) {
            HStack(spacing: 20) {
                Button {
                    onBack?()
                } label: {
                    Image(.backButton)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
                }
                .buttonStyle(.plain)

                Text("My Visits")
                    .font(.interBlack(size: 18))
                    .foregroundStyle(.white)
                Spacer()
            }
            
            summaryCards
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            headerBackground
                .ignoresSafeArea()
                .shadow(color: headerShadow.opacity(0.5), radius: 8, x: 0, y: 4)
        )
    }

    private var summaryCards: some View {
        HStack(spacing: 20) {
            summaryCard(number: "\(appState.visitsTotalCount)", label: "Total Visits", numberColor: accentPink)
            summaryCard(number: "\(appState.visitsThisMonthCount)", label: "This Month", numberColor: accentOrange)
            summaryCard(number: "\(appState.visitedRegionsCount)", label: "Regions", numberColor: accentPurple)
        }
    }

    private func summaryCard(number: String, label: String, numberColor: Color) -> some View {
        VStack(spacing: 40) {
            Text(number)
                .font(.interBold(size: 24))
                .foregroundStyle(numberColor)
            Text(label)
                .font(.interRegular(size: 12))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var emptyStateSection: some View {
        VStack(spacing: 64) {
            Text("No visits yet")
                .font(.interRegular(size: 18))
                .foregroundStyle(.white)

            Button {
                onExploreAttractions?()
            } label: {
                Text("Explore Attractions")
                    .font(.interBold(size: 18))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(accentOrange)
                    .clipShape(RoundedRectangle(cornerRadius: 100))
            }
            .buttonStyle(.plain)
        }
        .padding(50)
        .frame(maxWidth: .infinity)
        .background(.white.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(headerShadow, lineWidth: 1)
        }
    }
}

#Preview {
    MyVisitsView()
        .environmentObject(AppState())
}
