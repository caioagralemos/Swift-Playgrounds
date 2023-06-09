import SwiftUI
//#-learning-code-snippet(conditionalCircle)

struct ConditionalCircle: View {
    @State var isOn = false
    
    var body: some View {
        VStack {
            Button() {
                isOn.toggle()
            } label : {
                Circle()
                    .frame(maxHeight: 200)
                /*#-code-walkthrough(conditionalCircle.foregroundColor)*/
                    .foregroundColor(/*#-code-walkthrough(conditionalCircle.ternary)*/ isOn ? .purple : .mint /*#-code-walkthrough(conditionalCircle.ternary)*/)
                    .shadow(color: isOn ? .purple : .mint, radius: 20)
                    .scaleEffect(isOn ? 3 : 1)
                    .animation(.spring(response: 1.5), value: isOn)
                /*#-code-walkthrough(conditionalCircle.foregroundColor)*/
                /*#-code-walkthrough(conditionalCircle.circleView)*/
                //#-learning-code-snippet(addShadowModifier)
                //#-learning-code-snippet(addScaleModifier)
            }
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ConditionalCircle().assess()
    }
}
