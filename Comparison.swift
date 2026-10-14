
import SwiftUI

struct ContentView: View {
    let a = 15
    let b = 10

    var body: some View {
        VStack(spacing: 10) {
            Text("Comparison Operators")
                .font(.title)

            Text("a = \(a), b = \(b)")
            Text("a > b: \(a > b)")
            Text("a < b: \(a < b)")
            Text("a == b: \(a == b)")
            Text("a != b: \(a != b)")
            Text("a >= b: \(a >= b)")
            Text("a <= b: \(a <= b)")
        }
        .padding()
    }
}
