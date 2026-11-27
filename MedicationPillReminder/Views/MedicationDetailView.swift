import SwiftUI

struct MedicationDetailView: View {
    @EnvironmentObject private var store: MedicationStore
    @Environment(\.dismiss) private var dismiss
    let medication: Medication
    @State private var editing = false
    @State private var refillAmount = 10
    @State private var showingRefill = false

    private var current: Medication { store.activeMedications.first(where: { $0.id == medication.id }) ?? medication }

    var body: some View {
        List {
            Section {
                Label(current.name, systemImage: "pills.fill").font(.title2.bold())
                LabeledContent("Dosage", value: current.dosage)
                LabeledContent("Form", value: current.form.rawValue)
                LabeledContent("Schedule", value: current.scheduleDescription)
                LabeledContent("Remaining", value: "\(current.remainingCount)")
                LabeledContent("Start date", value: current.startDate.formatted(date: .abbreviated, time: .omitted))
                if let end = current.endDate { LabeledContent("End date", value: end.formatted(date: .abbreviated, time: .omitted)) }
                LabeledContent("Instructions", value: current.instructions.isEmpty ? "None" : current.instructions)
            }
            Section {
                Button("Refill quantity") { showingRefill = true }
                Button("Edit medication") { editing = true }
            }
        }
        .navigationTitle("Medicine Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $editing) { MedicationFormView(existing: current) }
        .alert("Refill medicine", isPresented: $showingRefill) {
            TextField("Quantity", value: $refillAmount, format: .number).keyboardType(.numberPad)
            Button("Add") { store.refill(current, amount: refillAmount) }
            Button("Cancel", role: .cancel) {}
        } message: { Text("Enter the number of pills or units added.") }
    }
}
