import SwiftUI

struct ExploreView: View {

    @EnvironmentObject var appState: AppState
    @Binding var selectedTabIndex: Int
    var onSelectRoute: (ExploreRoute) -> Void

    private let headerBackground = Color(r: 19, g: 17, b: 27)
    private let headerShadow = Color(r: 128, g: 115, b: 221)
    private let cellBackground = Color(r: 74, g: 64, b: 150)

    private let exploreItems: [(icon: String, title: String, tabIndex: Int?, route: ExploreRoute?)] = [
        ("explore1", "Explore Map", 1, nil),
        ("explore2", "Attractions", nil, .attractions),
        ("explore3", "Discover", 2, nil),
        ("explore4", "Visits", nil, .myVisits),
        ("explore5", "Favorites", 3, nil),
        ("explore6", "Progress", nil, .progress)
    ]

    var body: some View {
        VStack(spacing: 0) {
            header

            Text("Explore")
                .font(.interBold(size: 24))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 20)

            LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                ForEach(Array(exploreItems.enumerated()), id: \.offset) { _, item in
                    exploreCell(icon: item.icon, title: item.title, tabIndex: item.tabIndex, route: item.route)
                }
            }
            .padding(.horizontal, 20)

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
        HStack(spacing: 12) {
            avatarImage
                .frame(width: 56, height: 56)

            VStack(alignment: .leading, spacing: 2) {
                Text("Welcome back")
                    .font(.interRegular(size: 14))
                    .foregroundStyle(.white)
                Text(appState.displayName)
                    .font(.interBold(size: 18))
                    .foregroundStyle(.white)
            }

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            headerBackground
                .ignoresSafeArea()
                .shadow(color: headerShadow.opacity(0.5), radius: 8, x: 0, y: 4)
        )
    }

    private var avatarImage: some View {
        let names = ["icon1", "icon2", "icon3", "icon4"]
        let index = Int(appState.avatarId) ?? 0
        let name = names.indices.contains(index) ? names[index] : "icon1"
        return Image(name)
            .resizable()
            .scaledToFit()
    }

    private func exploreCell(icon: String, title: String, tabIndex: Int?, route: ExploreRoute?) -> some View {
        Button {
            if let route {
                onSelectRoute(route)
            }
            if let tabIndex {
                selectedTabIndex = tabIndex
            }
        } label: {
            VStack(spacing: 20) {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 52, height: 52)

                Text(title)
                    .font(.interBold(size: 18))
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 28)
            .background(cellBackground)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ExploreView(selectedTabIndex: .constant(0)) { _ in }
        .environmentObject(AppState())
}
