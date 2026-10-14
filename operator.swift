
import SwiftUI

struct ContentView: View {
    let a = 10
    let b = 5

    var body: some View {
        VStack {
            Text("Addition: \(a + b)")
            Text("Subtraction: \(a - b)")
            Text("Multiplication: \(a * b)")
            Text("Division: \(a / b)")
            Text("Remainder: \(a % b)")
        }
        .padding()
    }
}
