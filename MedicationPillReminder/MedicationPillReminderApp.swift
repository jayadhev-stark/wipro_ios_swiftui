import SwiftUI

@main
struct MedicationPillReminderApp: App {
    @StateObject private var store = MedicationStore()
    @StateObject private var auth = AuthenticationViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
                .environmentObject(auth)
                .preferredColorScheme(.light)
        }
    }
}
