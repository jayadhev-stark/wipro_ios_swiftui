
import SwiftUI

struct ContentView: View {
    @State private var inputA = ""
    @State private var inputB = ""

    var body: some View {
        VStack(spacing: 12) {
            Text("Comparison Calculator")
                .font(.title)

            TextField("Enter first number", text: $inputA)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)

            TextField("Enter second number", text: $inputB)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)

            if let a = Int(inputA), let b = Int(inputB) {
                Text("First number: \(a)")
                Text("Second number: \(b)")
                Text("a > b: \(a > b)")
                Text("a < b: \(a < b)")
                Text("a == b: \(a == b)")
                Text("a != b: \(a != b)")
                Text("a >= b: \(a >= b)")
                Text("a <= b: \(a <= b)")
            } else {
                Text("Enter two valid numbers")
            }
        }
        .padding()
    }
}
