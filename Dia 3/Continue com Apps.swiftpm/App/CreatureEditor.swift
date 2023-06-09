import SwiftUI
import Guide

struct CreatureEditor: View {
    //#-learning-code-snippet(defineVariablesCreatureEditor)
    //#-learning-code-snippet(environmentValue)
    
    var body: some View {
        SPCAssessableGroup(view: self) {
            VStack(alignment: .leading) {
                //#-learning-code-snippet(defineYourView)
                
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

