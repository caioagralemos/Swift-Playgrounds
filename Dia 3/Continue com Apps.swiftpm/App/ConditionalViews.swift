import SwiftUI
//#-learning-code-snippet(conditionalViews)

struct ConditionalViews: View {
    /*#-code-walkthrough(conditionalView.stateVar)*/
    /*#-code-walkthrough(conditionalView.statePropertyWrapper)*/@State /*#-code-walkthrough(conditionalView.statePropertyWrapper)*/var isOn = true
    @State var newIsOn = false
    /*#-code-walkthrough(conditionalView.stateVar)*/
    
    var body: some View {
        VStack {
            /*#-code-walkthrough(conditionalView.ifStatement)*/
            if isOn {
                /*#-code-walkthrough(conditionalView.circleView)*/
                Circle()
                    .frame(maxHeight: 200)
                    .foregroundColor(.white)
                Text("Ativado")
                //#-learning-code-snippet(customizeIntro)
                /*#-code-walkthrough(conditionalView.circleView)*/
            } else {
                Capsule()
                    .frame(maxHeight: 200)
                    .foregroundColor(.black)
                Text("Desativado")
            }
            /*#-code-walkthrough(conditionalView.ifStatement)*/
            //#-learning-code-snippet(addElse)
            
            /*#-code-walkthrough(conditionalView.button)*/
            Button(isOn ? "Desligar" : "Ligar") {
                /*#-code-walkthrough(conditionalView.buttonAction)*/
                isOn.toggle()
                /*#-code-walkthrough(conditionalView.buttonAction)*/
            }
            
            VStack {
                Button("Bazinga!") {
                    newIsOn.toggle()
                }.padding(.top)
                if newIsOn {
                    Image("Shelly")
                        .resizable()
                        .scaledToFit()
                }
            }
        }
    }
    
}

struct ConditionalViews_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ConditionalViews().assess()
        }
    }
}


