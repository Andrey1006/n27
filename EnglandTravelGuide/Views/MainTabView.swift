import SwiftUI

enum ExploreRoute: Hashable {
    case attractions
    case myVisits
    case attractionDetail(attractionId: String)
    case progress
}

enum ChecklistRoute: Hashable {
    case allSteps
}

enum ProfileRoute: Hashable {
    case settings
}

struct MainTabView: View {

    var onSignOut: (() -> Void)?

    @State private var selectedTabIndex = 0
    @State private var navigationPath = NavigationPath()
    @State private var mapNavigationPath = NavigationPath()
    @State private var checklistNavigationPath = NavigationPath()
    @State private var profileNavigationPath = NavigationPath()
    @EnvironmentObject var appState: AppState

    private var showTabBar: Bool {
        (selectedTabIndex != 0 || navigationPath.isEmpty)
        && (selectedTabIndex != 1 || mapNavigationPath.isEmpty)
        && (selectedTabIndex != 2 || checklistNavigationPath.isEmpty)
        && (selectedTabIndex != 4 || profileNavigationPath.isEmpty)
    }

    var body: some View {
        VStack(spacing: 0) {
            tabContent
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            if showTabBar {
                CustomTabBar(selectedIndex: $selectedTabIndex)
            }
        }
        .ignoresSafeArea(.keyboard)
    }

    @ViewBuilder
    private var tabContent: some View {
        switch selectedTabIndex {
        case 0:
            exploreNavigationStack
        case 1:
            NavigationStack(path: $mapNavigationPath) {
                ExploreMapView(onSelectAttraction: { mapNavigationPath.append($0) })
                    .environmentObject(appState)
                    .navigationDestination(for: String.self) { attractionId in
                        AttractionDetailView(
                            attractionId: attractionId,
                            onBack: { mapNavigationPath.removeLast() }
                        )
                        .environmentObject(appState)
                        .toolbar(.hidden, for: .navigationBar)
                    }
            }
        case 2:
            NavigationStack(path: $checklistNavigationPath) {
                ChecklistView(onViewAllSteps: { checklistNavigationPath.append(ChecklistRoute.allSteps) })
                    .environmentObject(appState)
                    .navigationDestination(for: ChecklistRoute.self) { _ in
                        AllChecklistStepsView(onBack: { checklistNavigationPath.removeLast() })
                            .environmentObject(appState)
                            .toolbar(.hidden, for: .navigationBar)
                    }
            }
        case 3:
            FavoritesView(
                onExploreAttractions: { selectedTabIndex = 0; navigationPath = NavigationPath(); navigationPath.append(ExploreRoute.attractions) },
                onSelectAttraction: { id in
                    selectedTabIndex = 0
                    navigationPath = NavigationPath()
                    navigationPath.append(ExploreRoute.attractions)
                    navigationPath.append(ExploreRoute.attractionDetail(attractionId: id))
                }
            )
        case 4:
            NavigationStack(path: $profileNavigationPath) {
                ProfileView(onSignOut: onSignOut, onOpenSettings: { profileNavigationPath.append(ProfileRoute.settings) })
                    .environmentObject(appState)
                    .navigationDestination(for: ProfileRoute.self) { _ in
                        SettingsView(onBack: { profileNavigationPath.removeLast() })
                            .environmentObject(appState)
                            .toolbar(.hidden, for: .navigationBar)
                    }
            }
        default:
            exploreNavigationStack
        }
    }

    private var exploreNavigationStack: some View {
        NavigationStack(path: $navigationPath) {
            ExploreView(selectedTabIndex: $selectedTabIndex) { route in
                navigationPath.append(route)
            }
            .navigationDestination(for: ExploreRoute.self) { route in
                Group {
                    switch route {
                    case .attractions:
                        AttractionsView(
                            onBack: { navigationPath.removeLast() },
                            onSelectAttraction: { id in navigationPath.append(ExploreRoute.attractionDetail(attractionId: id)) }
                        )
                    case .myVisits:
                        MyVisitsView(
                            onBack: { navigationPath.removeLast() },
                            onExploreAttractions: { selectedTabIndex = 0; navigationPath.append(ExploreRoute.attractions) }
                        )
                    case .attractionDetail(let attractionId):
                        AttractionDetailView(
                            attractionId: attractionId,
                            onBack: { navigationPath.removeLast() }
                        )
                    case .progress:
                        ProgressView(onBack: { navigationPath.removeLast() })
                    }
                }
                .toolbar(.hidden, for: .navigationBar)
            }
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppState())
}
