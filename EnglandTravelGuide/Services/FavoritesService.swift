import Foundation

enum FavoritesService {
    private static let key = "favorites_attractionIds"

    static func load() -> Set<String> {
        guard let array = UserDefaults.standard.array(forKey: key) as? [String] else { return [] }
        return Set(array)
    }

    static func save(_ ids: Set<String>) {
        UserDefaults.standard.set(Array(ids), forKey: key)
    }

    static func reset() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
