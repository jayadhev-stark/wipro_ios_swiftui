import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView().tabItem { Label("Home", systemImage: "house.fill") }
            MedicationListView().tabItem { Label("Medicines", systemImage: "pills.fill") }
            DoseHistoryView().tabItem { Label("Dose Log", systemImage: "checkmark.circle") }
        }
        .tint(.teal)
    }
}
