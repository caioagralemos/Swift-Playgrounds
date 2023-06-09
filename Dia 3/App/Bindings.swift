import SwiftUI
//#-learning-code-snippet(toggleExperiment)


struct Bindings: View {
    /*#-code-walkthrough(toggle.stateVar)*/
    @State var isOn = false
    @State var color = Color.primary
    /*#-code-walkthrough(toggle.stateVar)*/
    //#-learning-code-snippet(addAStateVar)
    
    var body: some View {
        VStack {
            /*#-code-walkthrough(toggle.viewDef)*/
            Toggle("Press Me", isOn: /*#-code-walkthrough(toggle.binding)*/ $isOn /*#-code-walkthrough(toggle.binding)*/)
            /*#-code-walkthrough(toggle.viewDef)*/
            
            //#-learning-code-snippet(addAColorPicker)
            
            
            Image(systemName: isOn ? "battery.100" : "battery.25")
                .font(.system(size: 150))
                .foregroundColor(color)
            
            Text("da cor que você escolher")
                .foregroundColor(color)
                .font(.largeTitle)
            //#-learning-code-snippet(addAColorModifier)
            
            //#-learning-code-snippet(addATextView)
            ColorPicker("Selecione uma cor", selection: $color)
        }
        .padding()
        
    }
}

struct Bindings_Previews: PreviewProvider {
    static var previews: some View {
        Bindings().assess()
    }
}
