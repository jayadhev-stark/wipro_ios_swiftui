
import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.black

            VStack(spacing: 15) {
                Text("HELLO!")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)

                Text("My First SwiftUI App")
                    .foregroundColor(.yellow)
            }
        }
        .frame(height: 250)
    }
}
