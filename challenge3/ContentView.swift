import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "graduationcap") {
                Text("Hello")
            }
            Tab("Photo", systemImage: "photo") {
                Text("Photo")
            }
            Tab("Profile", systemImage: "person.crop.circle") {
                Text("Profile")
            }
        }
    }
}

#Preview {
    ContentView()
}

