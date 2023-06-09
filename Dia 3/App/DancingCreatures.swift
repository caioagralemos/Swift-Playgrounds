import SwiftUI
import Guide

struct DancingCreatures: View {
    
    // Passando dados entre views
    @EnvironmentObject var animais : CreatureZoo // tipo provider (msm fonte da verdade)
    @StateObject var animals = CreatureZoo() // pegando direto
    //#-learning-code-snippet(varDeclaration)

    var body: some View {
        SPCAssessableGroup(view: self) {
            VStack {
                //#-learning-code-snippet(dancingCreaturesView)
                ForEach(animais.creatures){ creature in
                    Text(creature.emoji)
                        .resizableFont()
                        .offset(creature.offset)
                        .rotationEffect(creature.rotation)
                        .animation(.default.delay(animais.indexFor(creature) / 5), value: creature.offset)
                        // .animation(.spring(response:0.5, dampingFraction: 0.5) ,value: creature.offset) // essa animação spring é do cacete e dumping é quanto as coisas vao ficar pendendo antes de parar
                }
            }.onTapGesture {
                animais.randomizeOffsets() // em algum toque nos animais ele vai randomizar a localizacao dos mesmos
            }
        }
    }
}

struct DancingCreatures_Previews: PreviewProvider {
    static var previews: some View {
        DancingCreatures().environmentObject(CreatureZoo())
    }
}
