import SwiftUI

struct NavigationSplitViewExperiment: View {
    var body: some View {
        VStack {
            Text("Selecione um link").padding(.top)
            NavigationSplitView {
                NavigationLink (destination: ConditionalCircle()) {
                    Text("Conditional Circle").frame(alignment: .leading)
                    Image(systemName: "arrow.forward.circle")
                        .font(.largeTitle).frame(alignment: .trailing)
                    }

                NavigationLink(destination: ConditionalViews()) {
                    Text("Conditional Views")
                }
            } detail : {
                
            }
        }
    }
}

struct NavigationSplitViewExperiment_Previews: PreviewProvider {
    static var previews: some View {
        NavigationSplitViewExperiment().assess()
    }
}
