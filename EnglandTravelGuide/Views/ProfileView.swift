import SwiftUI

struct ProfileView: View {

    var onSignOut: (() -> Void)?
    var onOpenSettings: (() -> Void)?

    @EnvironmentObject var appState: AppState
    @State private var showDeleteConfirmation = false
    @State private var showDeleteError = false
    @State private var deleteErrorMessage: String?
    @State private var isDeletingAccount = false

    private let headerBackground = Color(r: 19, g: 17, b: 27)
    private let headerShadow = Color(r: 128, g: 115, b: 221)
    private let cardBackground = Color(r: 45, g: 37, b: 104)
    private let resetAccent = Color(r: 230, g: 0, b: 118)

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    profileCard

                    settingsCard

                    resetDataCard

                    privacyCard

                    if onSignOut != nil {
                        Button {
                            onSignOut?()
                        } label: {
                            Text("Sign Out")
                                .font(.interBold(size: 16))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(resetAccent)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                        .disabled(isDeletingAccount)
                        .padding(.top, 8)

                        Button {
                            showDeleteConfirmation = true
                        } label: {
                            Text("Delete account")
                                .font(.interBold(size: 16))
                                .foregroundStyle(resetAccent)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(resetAccent, lineWidth: 1)
                                )
                        }
                        .buttonStyle(.plain)
                        .disabled(isDeletingAccount)
                        .padding(.top, 8)
                    }
                }
                .alert("Delete account?", isPresented: $showDeleteConfirmation) {
                    Button("Cancel", role: .cancel) {}
                    Button("Delete", role: .destructive) {
                        performDeleteAccount()
                    }
                } message: {
                    Text("This will permanently delete your account and cannot be undone.")
                }
                .alert("Error", isPresented: $showDeleteError) {
                    Button("OK") { deleteErrorMessage = nil }
                } message: {
                    Text(deleteErrorMessage ?? "Something went wrong")
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 32)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Image(.mainBackground)
                .resizable()
                .ignoresSafeArea()
        }
    }

    private var header: some View {
        Text("Profile")
            .font(.interBlack(size: 18))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(
                headerBackground
                    .ignoresSafeArea()
                    .shadow(color: headerShadow.opacity(0.5), radius: 8, x: 0, y: 4)
            )
    }

    private var profileCard: some View {
        HStack(spacing: 12) {
            avatarImage
                .font(.system(size: 56))
                .foregroundStyle(.white.opacity(0.8))

            VStack(alignment: .leading, spacing: 10) {
                Text(appState.displayName)
                    .font(.interBold(size: 18))
                    .foregroundStyle(.white)
                Text("Current User")
                    .font(.interRegular(size: 14))
                    .foregroundStyle(.white)
            }
            Spacer()
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var avatarImage: some View {
        let names = ["icon1", "icon2", "icon3", "icon4"]
        let index = Int(appState.avatarId) ?? 0
        let name = names.indices.contains(index) ? names[index] : "icon1"
        return Image(name)
            .resizable()
            .scaledToFit()
            .frame(width: 56, height: 56)
            .clipShape(Circle())
    }

    private var settingsCard: some View {
        Button {
            onOpenSettings?()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "gearshape")
                    .font(.system(size: 22))
                    .foregroundStyle(.white)

                Text("Settings")
                    .font(.interBold(size: 16))
                    .foregroundStyle(.white)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.8))
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .buttonStyle(.plain)
    }

    private var resetDataCard: some View {
        Button {
            appState.resetAllData()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "trash")
                    .font(.system(size: 22))
                    .foregroundStyle(resetAccent)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Reset All Data")
                        .font(.interBold(size: 16))
                        .foregroundStyle(.white)
                    Text("Clear all visits, favorites, and progress")
                        .font(.interRegular(size: 12))
                        .foregroundStyle(.white.opacity(0.5))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.8))
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(resetAccent, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }

    private var privacyCard: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: "person")
                .font(.system(size: 22))
                .foregroundStyle(headerShadow)

            VStack(alignment: .leading, spacing: 10) {
                Text("Privacy First")
                    .font(.interBold(size: 16))
                    .foregroundStyle(.white)
                Text("Your data stays on this device. No analytics. No tracking. No cloud storage. Everything is stored locally and never leaves your device.")
                    .font(.interRegular(size: 12))
                    .foregroundStyle(headerShadow)
            }
            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(headerShadow.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(headerShadow, lineWidth: 1)
        }
    }

    private func performDeleteAccount() {
        guard onSignOut != nil else { return }
        isDeletingAccount = true
        Task {
            do {
                try await AuthService.deleteAccount()
                await MainActor.run {
                    appState.resetAllData()
                    onSignOut?()
                }
            } catch let error as AuthError {
                await MainActor.run {
                    deleteErrorMessage = error.errorDescription ?? error.localizedDescription
                    showDeleteError = true
                }
            } catch {
                await MainActor.run {
                    deleteErrorMessage = error.localizedDescription
                    showDeleteError = true
                }
            }
            await MainActor.run {
                isDeletingAccount = false
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppState())
}
