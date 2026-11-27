import Foundation

enum MedicationForm: String, CaseIterable, Codable, Identifiable {
    case tablet = "Tablet"
    case capsule = "Capsule"
    case syrup = "Syrup"
    case drops = "Drops"
    case injection = "Injection"
    case other = "Other"

    var id: String { rawValue }
}

enum DosePeriod: String, CaseIterable, Codable, Identifiable {
    case morning = "Morning"
    case afternoon = "Afternoon"
    case night = "Night"

    var id: String { rawValue }
}

struct Medication: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var dosage: String
    var form: MedicationForm
    var times: [Date]
    var startDate: Date
    var endDate: Date?
    var remainingCount: Int
    var instructions: String
    var isActive: Bool = true

    var scheduleDescription: String {
        times.sorted().map { $0.formatted(date: .omitted, time: .shortened) }.joined(separator: ", ")
    }
}

enum DoseStatus: String, Codable {
    case taken = "Taken"
    case upcoming = "Upcoming"
    case missed = "Missed"
}

struct DoseRecord: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var medicationID: UUID
    var medicationName: String
    var scheduledAt: Date
    var status: DoseStatus
}
