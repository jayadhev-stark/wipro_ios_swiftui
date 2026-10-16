
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome!")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)

            Text("Welcome to SwiftUI Fundamentals")
                .foregroundColor(.green)
        }
        .padding(20)
    }
}
