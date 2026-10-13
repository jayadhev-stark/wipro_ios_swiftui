import SwiftUI
 struct ContentView: View {
    let java: Int = 80
    let c : Int = 85
    let swift : Int = 90

    var total: Int {
        java + c + swift
    }
    var average: Double{
        Double(total) / 3.0
    }

    var body: some View {
        VStack {
            Text("Student mark")
        Text("Java: \(java)")
        Text("c : \(c)")
        Text("swift : \(swift)")
        Text("Total: \(total)")
        Text("Average:\(average, specifier: "%.2f")")
            
        }
       .padding()
        
    }
 }
