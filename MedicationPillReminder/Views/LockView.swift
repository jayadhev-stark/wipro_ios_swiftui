import SwiftUI

struct LockView: View {
    @EnvironmentObject private var auth: AuthenticationViewModel
    @State private var newCode = ""

    var body: some View {
        VStack(spacing: 22) {
            Image(systemName: "pills.fill").font(.system(size: 54)).foregroundStyle(.teal)
            Text("Pill Reminder").font(.largeTitle.bold())
            Text("Your medication schedule is protected").foregroundStyle(.secondary).multilineTextAlignment(.center)

            if auth.hasFallbackCode {
                SecureField("Enter local passcode", text: $auth.enteredCode)
                    .keyboardType(.numberPad).textFieldStyle(.roundedBorder).padding(.horizontal, 32)
                Button("Unlock with Passcode") { auth.unlockWithCode() }
                    .buttonStyle(.borderedProminent).tint(.teal)
            } else {
                SecureField("Create a 4+ digit passcode", text: $newCode)
                    .keyboardType(.numberPad).textFieldStyle(.roundedBorder).padding(.horizontal, 32)
                Button("Set Passcode & Continue") { auth.createFallbackCode(newCode) }
                    .buttonStyle(.borderedProminent).tint(.teal)
            }

            Button {
                auth.authenticate()
            } label: {
                Label("Use Face ID / Touch ID", systemImage: "faceid")
            }
            .buttonStyle(.bordered)

            if let error = auth.errorMessage {
                Text(error).font(.footnote).foregroundStyle(.red).multilineTextAlignment(.center).padding(.horizontal)
            }
        }
        .padding()
    }
}
