
import SwiftUI

struct ContentView: View {
    let myname = "Jayadhev"
    let lastname = "Maheshwaran"
    let age = 20

    var body: some View {
        VStack(spacing: 10) {
            Text("My Name: \(myname)")
            Text("Last Name: \(lastname)")
            Text("My Age: \(age)")
        }
        .font(.title2)
        .padding()
    }
}
