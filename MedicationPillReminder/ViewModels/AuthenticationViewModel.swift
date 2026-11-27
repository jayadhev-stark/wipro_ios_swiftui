import Foundation
import LocalAuthentication

@MainActor
final class AuthenticationViewModel: ObservableObject {
    @Published var isUnlocked = false
    @Published var fallbackCode = ""
    @Published var enteredCode = ""
    @Published var errorMessage: String?

    private let codeKey = "local_fallback_code"

    var hasBiometrics: Bool {
        let context = LAContext()
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }

    var hasFallbackCode: Bool {
        UserDefaults.standard.string(forKey: codeKey) != nil
    }

    func authenticate() {
        let context = LAContext()
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            errorMessage = "Biometric authentication is unavailable. Use your local passcode."
            return
        }
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Unlock your medication schedule") { [weak self] success, authError in
            Task { @MainActor in
                if success { self?.isUnlocked = true }
                else { self?.errorMessage = authError?.localizedDescription ?? "Authentication failed." }
            }
        }
    }

    func createFallbackCode(_ code: String) {
        guard code.count >= 4, code.allSatisfy(\.isNumber) else {
            errorMessage = "Enter at least 4 digits."
            return
        }
        UserDefaults.standard.set(code, forKey: codeKey)
        isUnlocked = true
    }

    func unlockWithCode() {
        guard let saved = UserDefaults.standard.string(forKey: codeKey), enteredCode == saved else {
            errorMessage = "Incorrect passcode."
            return
        }
        isUnlocked = true
    }
}
