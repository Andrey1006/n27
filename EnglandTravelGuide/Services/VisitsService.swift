import Foundation

enum VisitsService {
    private static let key = "visits_list"

    static func load() -> [Visit] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([Visit].self, from: data) else { return [] }
        return decoded
    }

    static func save(_ visits: [Visit]) {
        guard let data = try? JSONEncoder().encode(visits) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    static func reset() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
