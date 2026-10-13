import SwiftUI
struct ContentView: View {
    let name : String = "jayadhev"
    let height : Double = 175.5
    let grade : Character = "A"
    let  hasCertificate: Bool = true
    var body: some View {
        VStack {
            Text("name : \(name)")
            Text("Height : \(height, specifier:" %.1f" )cm")
            Text("grade: \(grade)")
            Text("certificate : \(hasCertificate ? "complete":"pending")")
        }
        .padding()
        
    }
}
