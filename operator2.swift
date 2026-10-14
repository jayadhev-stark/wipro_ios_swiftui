
import SwiftUI

struct ContentView: View {
    let length = 12
    let width = 5

    var body: some View {
        VStack {
            Text("Rectangle Calculator")
            Text("Length: \(length)")
            Text("Width: \(width)")
            Text("Area: \(length * width)")
            Text("perimeter: \(2 * (length + width))")
        }
        .padding()
    }
}
