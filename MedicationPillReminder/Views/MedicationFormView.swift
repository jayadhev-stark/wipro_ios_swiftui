import SwiftUI

struct MedicationFormView: View {
    @EnvironmentObject private var store: MedicationStore
    @Environment(\.dismiss) private var dismiss
    var existing: Medication? = nil

    @State private var name = ""
    @State private var dosage = ""
    @State private var form: MedicationForm = .tablet
    @State private var time = Calendar.current.date(from: DateComponents(hour: 8, minute: 0)) ?? Date()
    @State private var times: [Date] = []
    @State private var startDate = Date()
    @State private var hasEndDate = false
    @State private var endDate = Date()
    @State private var count = 10
    @State private var instructions = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Medicine information") {
                    TextField("Medicine name", text: $name)
                    TextField("Dosage (e.g. 500 mg)", text: $dosage)
                    Picker("Form", selection: $form) {
                        ForEach(MedicationForm.allCases) { Text($0.rawValue).tag($0) }
                    }
                }
                Section("Schedule") {
                    DatePicker("Dose time", selection: $time, displayedComponents: .hourAndMinute)
                    Button("Add this time") {
                        if !times.contains(where: { abs($0.timeIntervalSince(time)) < 60 }) { times.append(time) }
                    }
                    ForEach(Array(times.enumerated()), id: \.offset) { index, item in
                        HStack {
                            Text(item.formatted(date: .omitted, time: .shortened))
                            Spacer()
                            Button(role: .destructive) { times.remove(at: index) } label: { Image(systemName: "minus.circle") }
                        }
                    }
                    DatePicker("Start date", selection: $startDate, displayedComponents: .date)
                    Toggle("Set end date", isOn: $hasEndDate)
                    if hasEndDate { DatePicker("End date", selection: $endDate, in: startDate..., displayedComponents: .date) }
                }
                Section("Additional details") {
                    Stepper("Remaining quantity: \(count)", value: $count, in: 0...9999)
                    TextField("Doctor instructions / food notes", text: $instructions, axis: .vertical)
                }
            }
            .navigationTitle(existing == nil ? "Add Medication" : "Edit Medication")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }.disabled(name.trimmingCharacters(in: .whitespaces).isEmpty || dosage.isEmpty || times.isEmpty)
                }
            }
            .onAppear { loadExisting() }
        }
    }

    private func loadExisting() {
        guard let medicine = existing else { return }
        name = medicine.name; dosage = medicine.dosage; form = medicine.form
        times = medicine.times; startDate = medicine.startDate
        count = medicine.remainingCount; instructions = medicine.instructions
        if let end = medicine.endDate { hasEndDate = true; endDate = end }
    }

    private func save() {
        let medicine = Medication(id: existing?.id ?? UUID(), name: name.trimmingCharacters(in: .whitespaces),
                                  dosage: dosage, form: form, times: times, startDate: startDate,
                                  endDate: hasEndDate ? endDate : nil, remainingCount: count,
                                  instructions: instructions, isActive: true)
        if let old = existing { NotificationManager.shared.cancel(for: old); store.update(medicine) }
        else { store.add(medicine) }
        NotificationManager.shared.schedule(for: medicine)
        dismiss()
    }
}
