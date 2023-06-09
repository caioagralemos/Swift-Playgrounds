import SwiftUI
import Guide

struct ContentView: View {
    
    @EnvironmentObject var animais : CreatureZoo // pegando do provider"
    //#-learning-code-snippet(declareEnvironmentObject)

    var body: some View {
        SPCAssessableGroup(view: self) {
            NavigationStack{
                List {
                    NavigationLink(destination: Bindings()){
                        Text("Bindings")
                    }
                    NavigationLink(destination: ConditionalCircle()){
                        Text("Conditional Circle")
                    }
                    NavigationLink("Conditional Views"){
                        ConditionalViews().navigationTitle("Conditional Views")
                    }
                    NavigationLink("Sliding Rectangle"){
                        SlidingRectangle().navigationTitle("Sliding Rectangle")
                    }
                    NavigationLink("Edit Creatures"){
                        DancingCreatures().navigationTitle("Edit Creatures")
                    }
                    NavigationLink("Make the Creatures Dance"){
                        DancingCreatures().navigationTitle("Dancing Creatures")
                    }
                    ForEach(animais.creatures) {
                        creature in
                        CreatureRow(creature: creature)
                    }.onDelete { indexSet in
                        animais.creatures.remove(atOffsets: indexSet)
                    }
                }
            }
            //#-learning-code-snippet(addToolBarContentView)
        }
    }
}

