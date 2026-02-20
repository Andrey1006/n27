import SwiftUI

struct SettingsView: View {

    var onBack: (() -> Void)?

    @EnvironmentObject var appState: AppState
    @State private var soundEffectsOn = true
    @State private var musicOn = false
    @State private var notificationsOn = true
    @State private var pushOn = false

    private let headerBackground = Color(r: 19, g: 17, b: 27)
    private let headerShadow = Color(r: 128, g: 115, b: 221)
    private let cardBackground = Color(r: 45, g: 37, b: 104)

    var body: some View {
        VStack(spacing: 0) {
            header

            VStack(spacing: 16) {
                settingsRow(icon: "speaker.wave.2", title: "Sound Effects", isOn: $soundEffectsOn)
                settingsRow(icon: "music.note", title: "Music", isOn: $musicOn)
                settingsRow(icon: "bell", title: "Notifications", isOn: $notificationsOn)
                settingsRow(icon: "bell.badge", title: "Push", isOn: $pushOn)
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
        .onAppear {
            soundEffectsOn = appState.settings.soundEffectsOn
            musicOn = appState.settings.musicOn
            notificationsOn = appState.settings.notificationsOn
            pushOn = appState.settings.pushOn
        }
        .onChange(of: soundEffectsOn) { _ in syncSettings() }
        .onChange(of: musicOn) { _ in syncSettings() }
        .onChange(of: notificationsOn) { _ in syncSettings() }
        .onChange(of: pushOn) { _ in syncSettings() }
    }

    private func syncSettings() {
        appState.updateSettings(AppSettings(
            soundEffectsOn: soundEffectsOn,
            musicOn: musicOn,
            notificationsOn: notificationsOn,
            pushOn: pushOn
        ))
    }

    private var header: some View {
        HStack(spacing: 20) {
            Button {
                onBack?()
            } label: {
                Image(.backButton)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
            }
            .buttonStyle(.plain)

            Text("Settings")
                .font(.interBlack(size: 18))
                .foregroundStyle(.white)
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

    private func settingsRow(icon: String, title: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundStyle(.white)

            Text(title)
                .font(.interBold(size: 16))
                .foregroundStyle(.white)

            Spacer()

            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(.green)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppState())
}
