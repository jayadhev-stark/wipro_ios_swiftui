import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()
    private init() {}

    func requestPermission() async {
        _ = try? await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
    }

    func schedule(for medication: Medication) {
        let center = UNUserNotificationCenter.current()
        for (index, time) in medication.times.enumerated() {
            let content = UNMutableNotificationContent()
            content.title = "Medication reminder"
            content.body = "Time to take \(medication.name) – \(medication.dosage)"
            content.sound = .default

            let components = Calendar.current.dateComponents([.hour, .minute], from: time)
            var triggerComponents = DateComponents()
            triggerComponents.hour = components.hour
            triggerComponents.minute = components.minute
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: true)
            let request = UNNotificationRequest(identifier: "\(medication.id.uuidString)-\(index)", content: content, trigger: trigger)
            center.add(request)
        }
    }

    func cancel(for medication: Medication) {
        let ids = medication.times.indices.map { "\(medication.id.uuidString)-\($0)" }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
    }
}
