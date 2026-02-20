import SwiftUI

struct CustomTabBar: View {

    @Binding var selectedIndex: Int

    private let tabBackground = Color(r: 22, g: 20, b: 40)
    private let accentOrange = Color(r: 255, g: 94, b: 0)

    private let tabs: [(icon: String, title: String)] = [
        ("tab1", "Home"),
        ("tab2", "Explore"),
        ("tab3", "Checklist"),
        ("tab4", "Favorites"),
        ("tab5", "Profile")
    ]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                tabItem(icon: tab.icon, title: tab.title, isSelected: selectedIndex == index) {
                    selectedIndex = index
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.top, 10)
        .padding(.bottom, 1)
        .padding(.horizontal, 20)
        .background(tabBackground.ignoresSafeArea(edges: .bottom))
    }

    private func tabItem(icon: String, title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(isSelected ? accentOrange : .white)

                Text(title)
                    .font(.interRegular(size: 10))
                    .foregroundStyle(isSelected ? accentOrange : .white)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    MainTabView()
}
