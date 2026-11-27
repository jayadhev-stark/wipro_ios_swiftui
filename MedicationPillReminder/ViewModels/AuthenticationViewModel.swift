import Foundation
import Combine
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

        return context.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            error: &error
        )
    }

    var hasFallbackCode: Bool {
        UserDefaults.standard.string(forKey: codeKey) != nil
    }

    // Face ID / Touch ID authentication
    func authenticate() {
        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(
            .deviceOwnerAuthentication,
            error: &error
        ) else {
            errorMessage = "Authentication is unavailable."
            return
        }

        context.evaluatePolicy(
            .deviceOwnerAuthentication,
            localizedReason: "Unlock your medication schedule"
        ) { [weak self] success, authError in

            Task { @MainActor in
                if success {
                    self?.isUnlocked = true
                    self?.errorMessage = nil
                } else {
                    self?.errorMessage =
                        authError?.localizedDescription ?? "Authentication failed."
                }
            }
        }
    }

    // Create local fallback passcode
    func createFallbackCode(_ code: String) {
        guard code.count >= 4,
              code.allSatisfy(\.isNumber) else {
            errorMessage = "Enter at least 4 digits."
            return
        }

        UserDefaults.standard.set(code, forKey: codeKey)
        isUnlocked = true
        errorMessage = nil
    }

    // Unlock with passcode
    func unlockWithCode() {
        guard let savedCode =
                UserDefaults.standard.string(forKey: codeKey),
              enteredCode == savedCode else {

            errorMessage = "Incorrect passcode."
            return
        }

        isUnlocked = true
        errorMessage = nil
    }
}
