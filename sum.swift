
import SwiftUI

struct ContentView: View {
    @State private var number1 = ""
    @State private var number2 = ""
    @State private var result = 0

    var body: some View {
        VStack(spacing: 20) {

            Text("Addition Calculator")
                .font(.largeTitle)
                .bold()

            TextField("Enter First Number", text: $number1)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)

            TextField("Enter Second Number", text: $number2)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)

            Button("Calculate Sum") {
                let a = Int(number1) ?? 0
                let b = Int(number2) ?? 0
                result = a + b
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            Text("Result: \(result)")
                .font(.title2)
                .bold()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
