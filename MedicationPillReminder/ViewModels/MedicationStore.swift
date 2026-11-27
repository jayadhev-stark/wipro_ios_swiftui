
import Foundation
import SwiftUI
import Combine

@MainActor
final class MedicationStore: ObservableObject {

    @Published private(set) var medications: [Medication] = []
    @Published private(set) var doseRecords: [DoseRecord] = []

    private let medicationKey = "saved_medications_v1"
    private let doseKey = "saved_doses_v1"

    init() {
        load()

        if medications.isEmpty {
            addSampleMedication()
        }

        refreshMissedDoses()
    }

    // MARK: - Active Medicines

    var activeMedications: [Medication] {
        medications.filter { $0.isActive }
    }

    // MARK: - Today's Dose Records

    var todayRecords: [DoseRecord] {
        doseRecords
            .filter { Calendar.current.isDateInToday($0.scheduledAt) }
            .sorted { $0.scheduledAt < $1.scheduledAt }
    }

    var takenCountToday: Int {
        todayRecords.filter { $0.status == .taken }.count
    }

    var missedCountToday: Int {
        todayRecords.filter { $0.status == .missed }.count
    }

    // MARK: - CREATE

    func add(_ medication: Medication) {
        medications.append(medication)
        createDoseRecords(for: medication)
        save()
    }

    // MARK: - UPDATE

    func update(_ medication: Medication) {

        guard let index = medications.firstIndex(
            where: { $0.id == medication.id }
        ) else {
            return
        }

        medications[index] = medication

        doseRecords.removeAll {
            $0.medicationID == medication.id &&
            !Calendar.current.isDateInToday($0.scheduledAt)
        }

        createDoseRecords(for: medication)
        save()
    }

    // MARK: - DELETE

    func delete(_ medication: Medication) {

        medications.removeAll {
            $0.id == medication.id
        }

        doseRecords.removeAll {
            $0.medicationID == medication.id
        }

        save()
    }

    // MARK: - MARK DOSE

    func mark(_ record: DoseRecord, as status: DoseStatus) {

        guard let index = doseRecords.firstIndex(
            where: { $0.id == record.id }
        ) else {
            return
        }

        guard doseRecords[index].status == .upcoming else {
            return
        }

        doseRecords[index].status = status

        if status == .taken,
           let medicineIndex = medications.firstIndex(
                where: { $0.id == record.medicationID }
           ) {

            medications[medicineIndex].remainingCount = max(
                0,
                medications[medicineIndex].remainingCount - 1
            )
        }

        save()
    }

    // MARK: - REFILL

    func refill(_ medication: Medication, amount: Int) {

        guard let index = medications.firstIndex(
            where: { $0.id == medication.id }
        ) else {
            return
        }

        medications[index].remainingCount += max(0, amount)

        save()
    }

    // MARK: - SEARCH AND FILTER

    func search(
        _ query: String,
        form: MedicationForm?,
        period: DosePeriod?
    ) -> [Medication] {

        activeMedications.filter { medicine in

            let matchesName =
                query.isEmpty ||
                medicine.name.localizedCaseInsensitiveContains(query)

            let matchesForm =
                form == nil || medicine.form == form

            let matchesPeriod: Bool

            if let selectedPeriod = period {

                matchesPeriod = medicine.times.contains { time in

                    let hour = Calendar.current.component(
                        .hour,
                        from: time
                    )

                    switch selectedPeriod {

                    case .morning:
                        return hour < 12

                    case .afternoon:
                        return hour >= 12 && hour < 17

                    case .night:
                        return hour >= 17
                    }
                }

            } else {
                matchesPeriod = true
            }

            return matchesName &&
                   matchesForm &&
                   matchesPeriod
        }
    }

    // MARK: - MISSED DOSES

    func refreshMissedDoses() {

        let now = Date()

        for index in doseRecords.indices {

            if doseRecords[index].status == .upcoming &&
               doseRecords[index].scheduledAt < now {

                doseRecords[index].status = .missed
            }
        }

        save()
    }

    // MARK: - CREATE DOSE SCHEDULE

    private func createDoseRecords(for medication: Medication) {

        guard medication.isActive else {
            return
        }

        let calendar = Calendar.current

        for dayOffset in 0..<14 {

            guard let day = calendar.date(
                byAdding: .day,
                value: dayOffset,
                to: calendar.startOfDay(for: Date())
            ) else {
                continue
            }

            for time in medication.times {

                let components = calendar.dateComponents(
                    [.hour, .minute],
                    from: time
                )

                guard let scheduled = calendar.date(
                    bySettingHour: components.hour ?? 8,
                    minute: components.minute ?? 0,
                    second: 0,
                    of: day
                ) else {
                    continue
                }

                guard scheduled >= medication.startDate else {
                    continue
                }

                if let endDate = medication.endDate,
                   scheduled > endDate {
                    continue
                }

                let exists = doseRecords.contains {
                    $0.medicationID == medication.id &&
                    abs($0.scheduledAt.timeIntervalSince(scheduled)) < 60
                }

                if !exists {

                    let record = DoseRecord(
                        medicationID: medication.id,
                        medicationName: medication.name,
                        scheduledAt: scheduled,
                        status: .upcoming
                    )

                    doseRecords.append(record)
                }
            }
        }
    }

    // MARK: - SAMPLE MEDICINE

    private func addSampleMedication() {

        let calendar = Calendar.current

        let morning = calendar.date(
            from: DateComponents(hour: 8, minute: 0)
        ) ?? Date()

        let evening = calendar.date(
            from: DateComponents(hour: 20, minute: 0)
        ) ?? Date()

        let sample = Medication(
            name: "Vitamin D",
            dosage: "1000 IU",
            form: .tablet,
            times: [morning, evening],
            startDate: calendar.startOfDay(for: Date()),
            endDate: nil,
            remainingCount: 20,
            instructions: "Take after food."
        )

        medications = [sample]

        createDoseRecords(for: sample)

        save()
    }

    // MARK: - LOAD DATA

    private func load() {

        let decoder = JSONDecoder()

        if let data = UserDefaults.standard.data(
            forKey: medicationKey
        ),
        let decoded = try? decoder.decode(
            [Medication].self,
            from: data
        ) {

            medications = decoded
        }

        if let data = UserDefaults.standard.data(
            forKey: doseKey
        ),
        let decoded = try? decoder.decode(
            [DoseRecord].self,
            from: data
        ) {

            doseRecords = decoded
        }
    }

    // MARK: - SAVE DATA

    private func save() {

        let encoder = JSONEncoder()

        if let data = try? encoder.encode(medications) {

            UserDefaults.standard.set(
                data,
                forKey: medicationKey
            )
        }

        if let data = try? encoder.encode(doseRecords) {

            UserDefaults.standard.set(
                data,
                forKey: doseKey
            )
        }
    }
}

