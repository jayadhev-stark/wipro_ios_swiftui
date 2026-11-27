import SwiftUI

struct RootView: View {
    @EnvironmentObject private var auth: AuthenticationViewModel

    var body: some View {
        Group {
            if auth.isUnlocked {
                MainTabView()
            } else {
                LockView()
            }
        }
        .task { await NotificationManager.shared.requestPermission() }
    }
}
