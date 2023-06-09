import SwiftUI

struct SlidingRectangle: View {
    @State var sliderValue: Double = 0.0
    //#-learning-code-snippet(width)

    var body: some View {
        VStack {
            Rectangle().frame(width: sliderValue * 300).foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            //#-learning-code-snippet(slider)
            Slider(value: $sliderValue)
            //#-learning-code-snippet(rectangle)
        }
        .padding()
    }
}

struct SlidingRectangle_Previews: PreviewProvider {
    static var previews: some View {
        SlidingRectangle().assess()
    }
}
