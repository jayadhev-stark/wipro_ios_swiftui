import SwiftUI

struct ContentView: View {
    let name: String = "Jayadhev"
    let age: Int = 20
    let isStudent: Bool = true

    var body: some View {
        VStack {
            Text("Name: \(name)")
            Text("Age: \(age)")
            Text("Student: \(isStudent ? "Yes" : "No")")
        }
        .padding()
    }
}
