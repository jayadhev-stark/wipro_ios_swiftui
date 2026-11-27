import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var store: MedicationStore

    private var lowStock: [Medication] { store.activeMedications.filter { $0.remainingCount <= 5 } }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(Date.now.formatted(date: .complete, time: .omitted)).font(.subheadline).foregroundStyle(.secondary)
                        Text("Today's Overview").font(.largeTitle.bold())
                    }
                    HStack(spacing: 12) {
                        MetricCard(title: "Medicines", value: "\(store.activeMedications.count)", icon: "pills.fill", color: .teal)
                        MetricCard(title: "Taken", value: "\(store.takenCountToday)", icon: "checkmark.circle.fill", color: .green)
                        MetricCard(title: "Missed", value: "\(store.missedCountToday)", icon: "exclamationmark.circle.fill", color: .orange)
                    }
                    if !lowStock.isEmpty {
                        Label("Low stock: " + lowStock.map(\.name).joined(separator: ", "), systemImage: "exclamationmark.triangle.fill")
                            .font(.subheadline).foregroundStyle(.orange)
                            .padding().frame(maxWidth: .infinity, alignment: .leading)
                            .background(.orange.opacity(0.10), in: RoundedRectangle(cornerRadius: 14))
                    }
                    HStack {
                        Text("Today's Schedule").font(.title2.bold())
                        Spacer()
                        Text("\(store.todayRecords.count) doses").foregroundStyle(.secondary).font(.caption)
                    }
                    if store.todayRecords.isEmpty {
                        ContentUnavailableView("No doses scheduled", systemImage: "calendar")
                    } else {
                        ForEach(store.todayRecords) { record in
                            DoseRow(record: record)
                        }
                    }
                }.padding()
            }
            .navigationTitle("Dashboard")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { store.refreshMissedDoses() } label: { Image(systemName: "arrow.clockwise") }
                }
            }
        }
    }
}

private struct MetricCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon).foregroundStyle(color)
            Text(value).font(.title.bold())
            Text(title).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading).padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}
