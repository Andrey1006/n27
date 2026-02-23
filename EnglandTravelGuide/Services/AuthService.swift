import Foundation
import FirebaseAuth

enum AuthError: LocalizedError {
    case notConfigured
    case invalidEmail
    case weakPassword
    case userNotFound
    case wrongPassword
    case emailInUse
    case requiresRecentLogin
    case other(Error)

    var errorDescription: String? {
        switch self {
        case .notConfigured:
            return "Firebase is not configured"
        case .invalidEmail:
            return "Invalid email address"
        case .weakPassword:
            return "Password is too weak"
        case .userNotFound:
            return "User not found"
        case .wrongPassword:
            return "Wrong password"
        case .emailInUse:
            return "This email is already in use"
        case .requiresRecentLogin:
            return "Please sign out and sign in again, then try deleting your account"
        case .other(let error):
            return error.localizedDescription
        }
    }
}

enum AuthService {

    private static let auth = Auth.auth()

    static var currentUser: User? {
        auth.currentUser
    }

    static func signUp(email: String, password: String) async throws -> User {
        try await withCheckedThrowingContinuation { continuation in
            auth.createUser(withEmail: email, password: password) { result, error in
                if let error {
                    continuation.resume(throwing: mapFirebaseError(error))
                    return
                }
                guard let result else {
                    continuation.resume(throwing: AuthError.other(NSError(domain: "AuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Sign up failed"])))
                    return
                }
                continuation.resume(returning: result.user)
            }
        }
    }

    static func signIn(email: String, password: String) async throws -> User {
        try await withCheckedThrowingContinuation { continuation in
            auth.signIn(withEmail: email, password: password) { result, error in
                if let error {
                    continuation.resume(throwing: mapFirebaseError(error))
                    return
                }
                guard let result else {
                    continuation.resume(throwing: AuthError.other(NSError(domain: "AuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Sign in failed"])))
                    return
                }
                continuation.resume(returning: result.user)
            }
        }
    }

    static func signInAnonymously() async throws -> User {
        try await withCheckedThrowingContinuation { continuation in
            auth.signInAnonymously { result, error in
                if let error {
                    continuation.resume(throwing: mapFirebaseError(error))
                    return
                }
                guard let result else {
                    continuation.resume(throwing: AuthError.other(NSError(domain: "AuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Anonymous sign in failed"])))
                    return
                }
                continuation.resume(returning: result.user)
            }
        }
    }

    static func signOut() throws {
        try auth.signOut()
    }

    static func deleteAccount() async throws {
        guard let user = auth.currentUser else {
            throw AuthError.userNotFound
        }
        try await user.delete()
    }

    static func mapFirebaseError(_ error: Error) -> AuthError {
        let nsError = error as NSError
        guard let code = AuthErrorCode(rawValue: nsError.code) else {
            return .other(error)
        }
        switch code {
        case .invalidEmail:
            return .invalidEmail
        case .weakPassword:
            return .weakPassword
        case .userNotFound:
            return .userNotFound
        case .wrongPassword:
            return .wrongPassword
        case .emailAlreadyInUse:
            return .emailInUse
        case .requiresRecentLogin:
            return .requiresRecentLogin
        default:
            return .other(error)
        }
    }
}
