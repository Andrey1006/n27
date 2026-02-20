import Foundation

struct ChecklistStepInfo: Identifiable {
    var id: String { "\(sectionIndex)_\(itemIndex)" }
    let sectionIndex: Int
    let itemIndex: Int
    let title: String
    let attractionsCount: Int
}

struct ChecklistSectionInfo: Identifiable {
    var id: Int { sectionIndex }
    let sectionIndex: Int
    let title: String
    let steps: [ChecklistStepInfo]
}

enum ChecklistProgressService {
    private static let key = "checklist_completedStepIds"

    static let totalStepCount = 40

    static let sections: [ChecklistSectionInfo] = [
        ChecklistSectionInfo(sectionIndex: 0, title: "Royal & Heritage", steps: [
            ChecklistStepInfo(sectionIndex: 0, itemIndex: 0, title: "Visit a Royal residence", attractionsCount: 2),
            ChecklistStepInfo(sectionIndex: 0, itemIndex: 1, title: "Explore a medieval castle", attractionsCount: 2),
            ChecklistStepInfo(sectionIndex: 0, itemIndex: 2, title: "See a UNESCO World Heritage Site", attractionsCount: 3),
            ChecklistStepInfo(sectionIndex: 0, itemIndex: 3, title: "Visit an ancient cathedral", attractionsCount: 2),
            ChecklistStepInfo(sectionIndex: 0, itemIndex: 4, title: "Walk through Roman history", attractionsCount: 1),
            ChecklistStepInfo(sectionIndex: 0, itemIndex: 5, title: "See ancient standing stones", attractionsCount: 1),
            ChecklistStepInfo(sectionIndex: 0, itemIndex: 6, title: "Tour a stately home", attractionsCount: 2)
        ]),
        ChecklistSectionInfo(sectionIndex: 1, title: "Museums & Culture", steps: [
            ChecklistStepInfo(sectionIndex: 1, itemIndex: 0, title: "Explore a world-class museum", attractionsCount: 1),
            ChecklistStepInfo(sectionIndex: 1, itemIndex: 1, title: "Explore a medieval castle", attractionsCount: 1),
            ChecklistStepInfo(sectionIndex: 1, itemIndex: 2, title: "Attend a traditional ceremony", attractionsCount: 1),
            ChecklistStepInfo(sectionIndex: 1, itemIndex: 3, title: "Discover medieval manuscripts", attractionsCount: 2),
            ChecklistStepInfo(sectionIndex: 1, itemIndex: 4, title: "Visit a literary landmark", attractionsCount: 1),
            ChecklistStepInfo(sectionIndex: 1, itemIndex: 5, title: "Experience Victorian engineering", attractionsCount: 1),
            ChecklistStepInfo(sectionIndex: 1, itemIndex: 6, title: "See medieval armor and weapons", attractionsCount: 2)
        ]),
        ChecklistSectionInfo(sectionIndex: 2, title: "Cities & Neighborhoods", steps: [
            ChecklistStepInfo(sectionIndex: 2, itemIndex: 0, title: "Explore London's historic heart", attractionsCount: 3),
            ChecklistStepInfo(sectionIndex: 2, itemIndex: 1, title: "Experience a vibrant market", attractionsCount: 1),
            ChecklistStepInfo(sectionIndex: 2, itemIndex: 2, title: "Visit a historic university city", attractionsCount: 1),
            ChecklistStepInfo(sectionIndex: 2, itemIndex: 3, title: "Discover a Georgian spa town", attractionsCount: 1),
            ChecklistStepInfo(sectionIndex: 2, itemIndex: 4, title: "Walk medieval city walls", attractionsCount: 1),
            ChecklistStepInfo(sectionIndex: 2, itemIndex: 5, title: "Ride the London Underground", attractionsCount: 2)
        ]),
        ChecklistSectionInfo(sectionIndex: 3, title: "Nature & Coast", steps: [
            ChecklistStepInfo(sectionIndex: 3, itemIndex: 0, title: "Hike in a National Park", attractionsCount: 2),
            ChecklistStepInfo(sectionIndex: 3, itemIndex: 1, title: "Walk along dramatic coastline", attractionsCount: 1),
            ChecklistStepInfo(sectionIndex: 3, itemIndex: 2, title: "Visit botanical gardens", attractionsCount: 1),
            ChecklistStepInfo(sectionIndex: 3, itemIndex: 3, title: "Climb to a scenic viewpoint", attractionsCount: 2),
            ChecklistStepInfo(sectionIndex: 3, itemIndex: 4, title: "Go fossil hunting", attractionsCount: 1),
            ChecklistStepInfo(sectionIndex: 3, itemIndex: 5, title: "Walk through ancient woodland", attractionsCount: 1),
            ChecklistStepInfo(sectionIndex: 3, itemIndex: 6, title: "Watch birds of prey", attractionsCount: 1)
        ]),
        ChecklistSectionInfo(sectionIndex: 4, title: "Food & Traditions", steps: [
            ChecklistStepInfo(sectionIndex: 4, itemIndex: 0, title: "Have traditional afternoon tea", attractionsCount: 1),
            ChecklistStepInfo(sectionIndex: 4, itemIndex: 1, title: "Try a local specialty food", attractionsCount: 2),
            ChecklistStepInfo(sectionIndex: 4, itemIndex: 2, title: "Visit a historic pub", attractionsCount: 1),
            ChecklistStepInfo(sectionIndex: 4, itemIndex: 3, title: "Explore an English garden", attractionsCount: 2),
            ChecklistStepInfo(sectionIndex: 4, itemIndex: 4, title: "Attend a traditional event", attractionsCount: 1),
            ChecklistStepInfo(sectionIndex: 4, itemIndex: 5, title: "Shop at a farmers' market", attractionsCount: 1)
        ]),
        ChecklistSectionInfo(sectionIndex: 5, title: "Hidden Gems", steps: [
            ChecklistStepInfo(sectionIndex: 5, itemIndex: 0, title: "Discover a picturesque village", attractionsCount: 1),
            ChecklistStepInfo(sectionIndex: 5, itemIndex: 1, title: "Walk a scenic canal path", attractionsCount: 1),
            ChecklistStepInfo(sectionIndex: 5, itemIndex: 2, title: "Visit at sunrise or sunset", attractionsCount: 1),
            ChecklistStepInfo(sectionIndex: 5, itemIndex: 3, title: "Explore underground spaces", attractionsCount: 2),
            ChecklistStepInfo(sectionIndex: 5, itemIndex: 4, title: "Find a secret viewpoint", attractionsCount: 2),
            ChecklistStepInfo(sectionIndex: 5, itemIndex: 5, title: "Cross a historic bridge", attractionsCount: 1),
            ChecklistStepInfo(sectionIndex: 5, itemIndex: 6, title: "Discover an artist's inspiration", attractionsCount: 2)
        ])
    ]

    static func loadCompletedStepIds() -> Set<String> {
        guard let array = UserDefaults.standard.array(forKey: key) as? [String] else { return [] }
        return Set(array)
    }

    static func save(_ ids: Set<String>) {
        UserDefaults.standard.set(Array(ids), forKey: key)
    }

    static func reset() {
        UserDefaults.standard.removeObject(forKey: key)
    }

    static func allSteps() -> [ChecklistStepInfo] {
        sections.flatMap { $0.steps }
    }
}
