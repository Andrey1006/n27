import Foundation

enum UserProfileService {
    private static let displayNameKey = "userProfile_displayName"
    private static let avatarIdKey = "userProfile_avatarId"

    static func loadDisplayName() -> String? {
        UserDefaults.standard.string(forKey: displayNameKey)
    }

    static func loadAvatarId() -> String? {
        UserDefaults.standard.string(forKey: avatarIdKey)
    }

    static func save(displayName: String?, avatarId: String?) {
        if let displayName { UserDefaults.standard.set(displayName, forKey: displayNameKey) }
        else { UserDefaults.standard.removeObject(forKey: displayNameKey) }
        if let avatarId { UserDefaults.standard.set(avatarId, forKey: avatarIdKey) }
        else { UserDefaults.standard.removeObject(forKey: avatarIdKey) }
    }

    static func reset() {
        UserDefaults.standard.removeObject(forKey: displayNameKey)
        UserDefaults.standard.removeObject(forKey: avatarIdKey)
    }
}
