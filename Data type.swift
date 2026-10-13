import SwiftUI
struct ContentView: View{
    let name: String = "Jayadhev"
    let age: Int = 20
    let course: String = "Information Technology"
    let isStudent: Bool = true

    var body: some View{
        VStack{
            Text("Student profile")
            Text("Name: \(name)")
            Text("Age: \(age)")
            Text("Course: \(course)")
            Text("Student : \(isStudent ? "yes" : "no")")
        }
        .padding()
    }
}
