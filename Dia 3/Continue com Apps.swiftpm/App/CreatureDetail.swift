import SwiftUI
//#-learning-code-snippet(creatureDetailWalkthrough)

/*#-code-walkthrough(creatureDetail.intro)*/
struct CreatureDetail: View {
    /*#-code-walkthrough(creatureDetail.intro)*/
    /*#-code-walkthrough(creatureDetail.creatureConstant)*/
    let creature : Creature
    /*#-code-walkthrough(creatureDetail.creatureConstant)*/
    
    //#-learning-code-snippet(addStateVarIsScaled)
    /*#-code-walkthrough(creatureDetail.stateVars)*/
    @State var color = Color.white
    @State var shadowRadius : CGFloat = 0.5
    @State var angle = Angle(degrees: 0)
    /*#-code-walkthrough(creatureDetail.stateVars)*/
    
    var body: some View {
        VStack {
            /*#-code-walkthrough(creatureDetail.textView)*/
            Text(creature.emoji)
                .resizableFont()
                .colorMultiply(color)
                .shadow(color: color, radius: shadowRadius * 40)
                /*#-code-walkthrough(rotateTheTextView)*/
                .rotation3DEffect(Angle(degrees: 0), axis: (x: 5, y: 2, z: 1))
                /*#-code-walkthrough(rotateTheTextView)*/
                //#-learning-code-snippet(addScaleEffectModifier)
                //#-learning-code-snippet(animationSolution)


            /*#-code-walkthrough(creatureDetail.textView)*/
            
            //#-learning-code-snippet(addButton)
            
            //#-learning-code-snippet(addColorPicker)
            
            //#-learning-code-snippet(addSliderShadowRadius)
            
        }
        .padding()
    }
}

struct CreatureDetail_Previews: PreviewProvider {
    static var previews: some View {
        CreatureDetail(creature: CreatureZoo().creatures.randomElement() ?? Creature(name: "Panda", emoji: "🐼")).assess()
    }
}

