//#-learning-code-snippet(colorGridApp)
import SwiftUI

@main
struct ColorGridApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
                    .tabItem {
                        Label("Sheldon", systemImage: "person")
                    }
                
                BasicGrid()
                    .tabItem {
                        Label("Grid Básico", systemImage: "grid")
                    }
            }
        }
    }
}
