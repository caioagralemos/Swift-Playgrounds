import SwiftUI
import Guide

struct ContentView: View {
    
    @EnvironmentObject var animais : CreatureZoo // pegando do provider"
    //#-learning-code-snippet(declareEnvironmentObject)

    var body: some View {
        SPCAssessableGroup(view: self) {
            NavigationStack{
                List {
                    NavigationLink("Bindings"){
                        Bindings().navigationTitle("Bindings")
                    }
                    NavigationLink("Conditional Circle"){
                        ConditionalCircle().navigationTitle("Conditional Circle")
                    }
                    NavigationLink("Conditional Views"){
                        ConditionalViews().navigationTitle("Conditional Views")
                    }
                    NavigationLink("Sliding Rectangle"){
                        SlidingRectangle().navigationTitle("Sliding Rectangle")
                    }
                    NavigationLink("Make the Creatures Dance"){
                        DancingCreatures().navigationTitle("Dancing Creatures").toolbar { 
                            ToolbarItem { 
                                NavigationLink("Edit") { 
                                    CreatureEditor().navigationTitle("Edit Creatures")
                                }
                            }
                        }
                    }
                }
                
            }
            //#-learning-code-snippet(addToolBarContentView)
        }
    }
}

