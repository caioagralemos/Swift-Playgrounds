import SwiftUI
import Guide

struct CreatureEditor: View {
    
    @EnvironmentObject var animais : CreatureZoo
    @State var newCreature : Creature = Creature(name: "T-Rex", emoji: "🦖")
    @Environment(\.dismiss) var dismiss
    //#-learning-code-snippet(defineVariablesCreatureEditor)
    //#-learning-code-snippet(environmentValue)
    
    var body: some View {
        SPCAssessableGroup(view: self) {
            VStack(alignment: .leading) {
                Form {
                    Section("Name") {
                        TextField("name", text: $newCreature.name)
                    } 
                    
                    Section("Emoji") {
                        TextField("emoji", text: $newCreature.emoji)
                    }
                    
                    Section("Creature Preview") {
                        CreatureRow(creature: newCreature)
                    }
                }
                
                Divider()
                
                NavigationStack {
                    List {
                        ForEach(animais.creatures) {
                            creature in
                            NavigationLink(destination: CreatureDetail(creature: creature)) {
                                CreatureRow(creature: creature)
                            }
                        }.onDelete { indexSet in
                            animais.creatures.remove(atOffsets: indexSet)
                        }
                    }
                }
            }.toolbar {
                ToolbarItem {
                    Button("Add") {
                        if newCreature.name != "T-Rex" && newCreature.emoji != "🦖" {
                            animais.creatures.append(newCreature)
                            newCreature.name = "T-Rex"
                            newCreature.emoji = "🦖"
                            dismiss()
                        }
                    }
                }
            }
            //#-learning-code-snippet(addButtonToToolbar)
        }
    }
}

struct CreatureEditor_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack() {
            CreatureEditor().environmentObject(CreatureZoo())
        }
    }
}

