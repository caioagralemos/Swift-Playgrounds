import SwiftUI

struct NavigationExperiment: View {
    var body: some View {
        VStack {
            //#-learning-code-snippet(addNavigationStack)
            NavigationStack {
                List {
                    Text("Conteúdo do NavigationStack")
                    NavigationLink(destination: ConditionalCircle()) {
                        Text("Conditional Circle")
                    }
                    NavigationLink(destination: ConditionalViews()) {
                        Text("Conditional Views")
                    }
                }
            }
        }
    }
}

struct NavigationExperiment_Previews: PreviewProvider {
    static var previews: some View {
        NavigationExperiment().assess()
    }
}
