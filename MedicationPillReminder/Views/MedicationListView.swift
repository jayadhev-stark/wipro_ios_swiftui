import SwiftUI

struct MedicationListView: View {
    @EnvironmentObject private var store: MedicationStore
    @State private var searchText = ""
    @State private var selectedForm: MedicationForm?
    @State private var selectedPeriod: DosePeriod?
    @State private var showingAdd = false

    private var filtered: [Medication] { store.search(searchText, form: selectedForm, period: selectedPeriod) }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker("Form", selection: $selectedForm) {
                        Text("All forms").tag(MedicationForm?.none)
                        ForEach(MedicationForm.allCases) { form in Text(form.rawValue).tag(Optional(form)) }
                    }
                    Picker("Time", selection: $selectedPeriod) {
                        Text("All times").tag(DosePeriod?.none)
                        ForEach(DosePeriod.allCases) { period in Text(period.rawValue).tag(Optional(period)) }
                    }
                }
                ForEach(filtered) { medicine in
                    NavigationLink {
                        MedicationDetailView(medication: medicine)
                    } label: {
                        MedicationRow(medication: medicine)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            NotificationManager.shared.cancel(for: medicine)
                            store.delete(medicine)
                        } label: { Label("Delete", systemImage: "trash") }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search medicines")
            .navigationTitle("Medications")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showingAdd = true } label: { Image(systemName: "plus.circle.fill") }
                }
            }
            .sheet(isPresented: $showingAdd) { MedicationFormView() }
        }
    }
}
