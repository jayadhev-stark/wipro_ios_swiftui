# Medication & Pill Reminder Manager (iOS)

A SwiftUI iPhone app following MVVM architecture.

## Requirements
- Xcode 15 or later
- iOS 17+
- iPhone simulator or physical iPhone

## Open the project
1. Extract `MedicationPillReminder-iOS.zip`.
2. Open `MedicationPillReminder.xcodeproj` in Xcode.
3. Select an iPhone simulator or connected iPhone.
4. Select a signing team under **Signing & Capabilities** if running on a physical device.
5. Press **Run**.

## Features
- Face ID / Touch ID / device passcode authentication with local passcode fallback
- Dashboard with today's doses, taken and missed counts, low-stock warnings
- Add, view, edit, refill and delete medicines
- Multiple dose times, start/end dates, dosage, form and instructions
- Search by medicine name and filter by form or time of day
- Dose status tracking (Taken, Upcoming, Missed)
- Daily local notifications
- Local persistence using Codable + UserDefaults

## Project structure
- `Models/` – medication and dose data models
- `ViewModels/` – app state, persistence, filtering and authentication
- `Views/` – individual SwiftUI screens and reusable rows
- `Services/` – local notification scheduling
- `Assets.xcassets/` – app icon asset catalog

## Notes
- The first launch asks you to create a local fallback passcode. Face ID / Touch ID can also unlock the app.
- Notifications require permission. You can change permission in iPhone Settings.
- Data is stored locally on the device; this starter project does not sync to iCloud or a server.
- The sample Vitamin D medicine can be deleted after launch.
- This is a medication organizer, not a medical device. It does not prescribe doses or replace advice from a healthcare professional.

## App icon
Add a 1024 x 1024 PNG named `AppIcon.png` to `Assets.xcassets/AppIcon.appiconset/` before archive submission. The asset catalog is configured to use this file.
