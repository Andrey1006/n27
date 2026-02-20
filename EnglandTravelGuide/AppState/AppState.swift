import Foundation
import Combine

@MainActor
final class AppState: ObservableObject {
    @Published var displayName: String
    @Published var avatarId: String
    @Published var favoriteIds: Set<String>
    @Published var visits: [Visit]
    @Published var completedChecklistStepIds: Set<String>
    @Published var settings: AppSettings

    init() {
        self.displayName = UserProfileService.loadDisplayName() ?? "Guest"
        self.avatarId = UserProfileService.loadAvatarId() ?? "0"
        self.favoriteIds = FavoritesService.load()
        self.visits = VisitsService.load()
        self.completedChecklistStepIds = ChecklistProgressService.loadCompletedStepIds()
        self.settings = SettingsService.load()
    }

    func updateProfile(displayName: String?, avatarId: String?) {
        self.displayName = displayName ?? self.displayName
        self.avatarId = avatarId ?? self.avatarId
        UserProfileService.save(displayName: self.displayName, avatarId: self.avatarId)
    }

    func toggleFavorite(_ attractionId: String) {
        if favoriteIds.contains(attractionId) {
            favoriteIds.remove(attractionId)
        } else {
            favoriteIds.insert(attractionId)
        }
        FavoritesService.save(favoriteIds)
    }

    func isFavorite(_ attractionId: String) -> Bool {
        favoriteIds.contains(attractionId)
    }

    func markVisited(_ attractionId: String) {
        visits.append(Visit(attractionId: attractionId, date: Date()))
        VisitsService.save(visits)
    }

    func isVisited(_ attractionId: String) -> Bool {
        visits.contains { $0.attractionId == attractionId }
    }

    var visitsTotalCount: Int { visits.count }
    var visitsThisMonthCount: Int {
        let calendar = Calendar.current
        let now = Date()
        return visits.filter { calendar.isDate($0.date, equalTo: now, toGranularity: .month) }.count
    }
    var visitedRegionsCount: Int {
        var regions = Set<String>()
        for visit in visits {
            if let detail = AttractionDetailService.detail(for: visit.attractionId) {
                regions.insert(detail.region)
            }
        }
        return regions.count
    }

    func toggleChecklistStep(_ stepId: String) {
        if completedChecklistStepIds.contains(stepId) {
            completedChecklistStepIds.remove(stepId)
        } else {
            completedChecklistStepIds.insert(stepId)
        }
        ChecklistProgressService.save(completedChecklistStepIds)
    }

    func isChecklistStepCompleted(_ stepId: String) -> Bool {
        completedChecklistStepIds.contains(stepId)
    }

    var completedChecklistCount: Int { completedChecklistStepIds.count }

    func updateSettings(_ settings: AppSettings) {
        self.settings = settings
        SettingsService.save(settings)
    }

    func resetAllData() {
        displayName = "Guest"
        avatarId = "0"
        UserProfileService.reset()
        favoriteIds = []
        FavoritesService.reset()
        visits = []
        VisitsService.reset()
        completedChecklistStepIds = []
        ChecklistProgressService.reset()
        settings = .default
        SettingsService.save(settings)
    }
}
