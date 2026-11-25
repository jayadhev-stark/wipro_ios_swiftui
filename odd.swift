
import SwiftUI

struct ContentView: View {

    @State private var number = ""
    @State private var result = ""

    var body: some View {

        VStack(spacing: 20) {

            Text("Even or Odd Checker")
                .font(.largeTitle)
                .bold()

            TextField("Enter a number", text: $number)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)

            Button("Check Number") {

                if let value = Int(number) {

                    if value % 2 == 0 {
                        result = "Even Number"
                    } else {
                        result = "Odd Number"
                    }

                } else {
                    result = "Please enter a valid number"
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            Text(result)
                .font(.title2)
                .bold()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
