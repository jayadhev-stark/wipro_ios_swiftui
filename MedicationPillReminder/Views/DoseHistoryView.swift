import SwiftUI

struct DoseHistoryView: View {
    @EnvironmentObject private var store: MedicationStore
    var body: some View {
        NavigationStack {
            List {
                if store.todayRecords.isEmpty {
                    ContentUnavailableView("No dose records", systemImage: "calendar")
                } else {
                    ForEach(store.todayRecords) { record in DoseRow(record: record) }
                }
            }
            .navigationTitle("Dose Tracking")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Refresh") { store.refreshMissedDoses() }
                }
            }
        }
    }
}
