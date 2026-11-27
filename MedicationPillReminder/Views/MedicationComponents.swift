import SwiftUI

struct MedicationRow: View {
    let medication: Medication
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "pills.fill").font(.title2).foregroundStyle(.teal)
                .frame(width: 44, height: 44).background(.teal.opacity(0.10), in: RoundedRectangle(cornerRadius: 12))
            VStack(alignment: .leading, spacing: 4) {
                Text(medication.name).font(.headline)
                Text("\(medication.dosage) • \(medication.form.rawValue)").font(.subheadline).foregroundStyle(.secondary)
                Text(medication.scheduleDescription).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Text("\(medication.remainingCount) left").font(.caption).foregroundStyle(medication.remainingCount <= 5 ? .orange : .secondary)
        }.padding(.vertical, 4)
    }
}

struct DoseRow: View {
    @EnvironmentObject private var store: MedicationStore
    let record: DoseRecord
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(record.medicationName).font(.headline)
                Text(record.scheduledAt.formatted(date: .omitted, time: .shortened)).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Text(record.status.rawValue).font(.caption.bold())
                .foregroundStyle(record.status == .taken ? .green : record.status == .missed ? .red : .blue)
            if record.status == .upcoming {
                Button("Taken") { store.mark(record, as: .taken) }.buttonStyle(.borderedProminent).tint(.teal).font(.caption)
            }
        }
        .padding().background(.thinMaterial, in: RoundedRectangle(cornerRadius: 14))
    }
}
