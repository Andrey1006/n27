import Foundation

struct AppSettings: Codable, Equatable {
    var soundEffectsOn: Bool
    var musicOn: Bool
    var notificationsOn: Bool
    var pushOn: Bool

    static let `default` = AppSettings(
        soundEffectsOn: true,
        musicOn: false,
        notificationsOn: true,
        pushOn: false
    )
}
