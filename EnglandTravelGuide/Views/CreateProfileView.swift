import SwiftUI

struct CreateProfileView: View {

    @EnvironmentObject var appState: AppState
    var onDidSignIn: (() -> Void)?

    @State private var selectedAvatarIndex = 0
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage: String?

    private let cardBackground = Color(r: 35, g: 31, b: 61)
    private let accentOrange = Color(r: 255, g: 94, b: 0)
    private let avatarNames = ["icon1", "icon2", "icon3", "icon4"]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                header

                avatarSection

                emailSection

                passwordSection

                infoBox

                buttonsSection
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Image(.mainBackground)
                .resizable()
                .ignoresSafeArea()
        }
    }

    private var header: some View {
        VStack(spacing: 8) {
            Text("Create Profile")
                .font(.interBold(size: 24))
                .foregroundStyle(.white)
            Text("Set up your personal travel profile")
                .font(.interRegular(size: 14))
                .foregroundStyle(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 32)
    }

    private var avatarSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Choose Avatar")
                .font(.interBold(size: 12))
                .foregroundStyle(.white)

            HStack(spacing: 16) {
                ForEach(Array(avatarNames.enumerated()), id: \.offset) { index, name in
                    Button {
                        selectedAvatarIndex = index
                    } label: {
                        Image(name)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 72, height: 72)
                            .shadow(color: selectedAvatarIndex == index ? accentOrange : Color.clear, radius: 10, x: 0, y: 0)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.bottom, 28)
    }

    private var emailSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Email")
                .font(.interBold(size: 12))
                .foregroundStyle(.white)

            TextField("", text: $email, prompt:
                Text("Enter your email")
                    .font(.interRegular(size: 16))
                    .foregroundColor(.white.opacity(0.5))
            )
            .font(.interRegular(size: 16))
            .foregroundStyle(.white)
            .keyboardType(.emailAddress)
            .textInputAutocapitalization(.never)
            .padding(20)
            .background(cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding(.bottom, 20)
    }

    private var passwordSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Password")
                .font(.interBold(size: 12))
                .foregroundStyle(.white)

            SecureField("", text: $password, prompt:
                Text("Lock your profile")
                    .font(.interRegular(size: 16))
                    .foregroundColor(.white.opacity(0.5))
            )
            .font(.interRegular(size: 16))
            .foregroundStyle(.white)
            .padding(20)
            .background(cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            Text("Add a password to lock app settings")
                .font(.interRegular(size: 10))
                .foregroundStyle(.white.opacity(0.6))
        }
        .padding(.bottom, 24)
    }

    private var infoBox: some View {
        HStack(spacing: 12) {
            Image(systemName: "info.circle")
                .font(.system(size: 22))
                .foregroundStyle(Color(r: 76, g: 64, b: 150))

            Text("Your data stays on this device. No internet required")
                .font(.interRegular(size: 14))
                .foregroundStyle(.white)
            Spacer(minLength: 0)
        }
        .padding(24)
        .background(Color(r: 76, g: 64, b: 150, a: 0.2))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(content: {
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(r: 76, g: 64, b: 150), lineWidth: 1)
        })
        .padding(.bottom, 32)
    }

    private var buttonsSection: some View {
        VStack(spacing: 12) {
            if let errorMessage {
                Text(errorMessage)
                    .font(.interRegular(size: 14))
                    .foregroundStyle(.red)
            }

            Button {
                Task { await createProfile() }
            } label: {
                Text(isLoading ? "..." : "Create Profile")
                    .font(.interBold(size: 18))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(accentOrange)
                    .clipShape(RoundedRectangle(cornerRadius: 100))
            }
            .buttonStyle(.plain)
            .disabled(isLoading)

            Button {
                Task { await logIn() }
            } label: {
                Text(isLoading ? "..." : "Log In")
                    .font(.interBold(size: 18))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(accentOrange)
                    .clipShape(RoundedRectangle(cornerRadius: 100))
            }
            .buttonStyle(.plain)
            .disabled(isLoading)
            
            Button {
                Task { await continueAsGuest() }
            } label: {
                Text("Continue as Guest")
                    .font(.interBold(size: 18))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .overlay {
                        RoundedRectangle(cornerRadius: 100)
                            .stroke(.white, lineWidth: 1)
                    }
            }
            .buttonStyle(.plain)
            .disabled(isLoading)
        }
    }

    private func createProfile() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Enter email and password"
            return
        }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            _ = try await AuthService.signUp(email: email, password: password)
            let name = String(email.prefix(upTo: email.firstIndex(of: "@") ?? email.endIndex))
            await MainActor.run {
                appState.updateProfile(displayName: name.isEmpty ? "User" : name, avatarId: "\(selectedAvatarIndex)")
                onDidSignIn?()
            }
        } catch let error as AuthError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func logIn() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Enter email and password"
            return
        }
        
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            _ = try await AuthService.signIn(email: email, password: password)
            
            await MainActor.run {
                onDidSignIn?()
            }
            
        } catch let error as AuthError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func continueAsGuest() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            _ = try await AuthService.signInAnonymously()
            await MainActor.run {
                appState.updateProfile(displayName: "Guest", avatarId: "\(selectedAvatarIndex)")
                onDidSignIn?()
            }
        } catch let error as AuthError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    CreateProfileView()
        .environmentObject(AppState())
}
