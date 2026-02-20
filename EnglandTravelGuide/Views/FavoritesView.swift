import SwiftUI

struct FavoritesView: View {

    var onExploreAttractions: (() -> Void)?
    var onSelectAttraction: ((String) -> Void)?

    @EnvironmentObject var appState: AppState
    @State private var selectedSegment = 0

    private let headerBackground = Color(r: 19, g: 17, b: 27)
    private let headerShadow = Color(r: 128, g: 115, b: 221)
    private let segmentBackground = Color(r: 45, g: 37, b: 104)
    private let segmentSelectedBackground = Color(r: 128, g: 115, b: 221)
    private let accentOrange = Color(r: 255, g: 94, b: 0)

    var body: some View {
        VStack(spacing: 0) {
            header

            VStack(spacing: 24) {
                segmentedControl

                if selectedSegment == 0 {
                    if appState.favoriteIds.isEmpty {
                        emptyStateSection
                    } else {
                        ScrollView(showsIndicators: false) {
                            favoriteAttractionsList
                                .padding(.bottom, 32)
                        }
                    }
                } else {
                    emptyChecklistSegment
                }
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
        VStack(alignment: .leading, spacing: 12) {
            Text("Favorites")
                .font(.interBlack(size: 18))
                .foregroundStyle(.white)
            Text("\(appState.favoriteIds.count) saved items")
                .font(.interRegular(size: 12))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            headerBackground
                .ignoresSafeArea()
                .shadow(color: headerShadow.opacity(0.5), radius: 8, x: 0, y: 4)
        )
    }

    private var segmentedControl: some View {
        HStack(spacing: 0) {
            segmentButton(title: "Attractions (\(appState.favoriteIds.count))", isSelected: selectedSegment == 0) {
                selectedSegment = 0
            }
            segmentButton(title: "Checklist Steps (\(appState.completedChecklistCount))", isSelected: selectedSegment == 1) {
                selectedSegment = 1
            }
        }
        .padding(10)
        .background(segmentBackground)
        .clipShape(RoundedRectangle(cornerRadius: 100))
    }

    private func segmentButton(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.interRegular(size: 14))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(isSelected ? segmentSelectedBackground : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 100))
        }
        .buttonStyle(.plain)
    }

    private var favoriteAttractionsList: some View {
        let ids = Array(appState.favoriteIds)
        return LazyVStack(spacing: 16) {
            ForEach(ids, id: \.self) { id in
                if let detail = AttractionDetailService.detail(for: id) {
                    Button {
                        onSelectAttraction?(id)
                    } label: {
                        favoriteCard(title: detail.title, imageName: detail.imageName, attractionId: id)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func favoriteCard(title: String, imageName: String, attractionId: String) -> some View {
        HStack(spacing: 12) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 72, height: 72)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            Text(title)
                .font(.interBold(size: 16))
                .foregroundStyle(.white)
            Spacer()
        }
        .padding(16)
        .background(segmentBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var emptyStateSection: some View {
        VStack(spacing: 36) {
            Image(systemName: "heart")
                .font(.system(size: 48, weight: .light))
                .foregroundStyle(.white.opacity(0.8))

            Text("No favorite attractions yet")
                .font(.interRegular(size: 18))
                .foregroundStyle(.white)

            Button {
                onExploreAttractions?()
            } label: {
                Text("Browse Attractions")
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

    private var emptyChecklistSegment: some View {
        VStack(spacing: 36) {
            Text("Checklist steps appear here when completed")
                .font(.interRegular(size: 16))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
    }
}

#Preview {
    FavoritesView()
        .environmentObject(AppState())
}
