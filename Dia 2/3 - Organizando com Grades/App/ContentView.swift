//#-learning-code-snippet(contentView)
import SwiftUI

/*#-code-walkthrough(2.contentView)*/
struct ContentView: View {
    @State private var selectedColor = Color.white
    
    /*#-code-walkthrough(2.contentView)*/
    //#-learning-code-snippet(addStateProperty)
    /*#-code-walkthrough(2.columnLayout)*/
    let columnLayout = Array(repeating: /*#-code-walkthrough(changeGridItem)*/ GridItem(.flexible(minimum: 20, maximum: 300), spacing: 20, alignment: .center) /*#-code-walkthrough(changeGridItem)*/, count: 5)
    
    let customColumns = [GridItem(.fixed(75)), GridItem(.fixed(100)), GridItem(.flexible(minimum: 15, maximum: 20)), GridItem(.adaptive(minimum: 120, maximum: 150))]
    
    let adpColumns = [GridItem(.adaptive(minimum: 100, maximum: 150))]
    /*#-code-walkthrough(2.columnLayout)*/
    //#-learning-code-snippet(customGridItems)
    //#-learning-code-snippet(adaptive)
    
    /*#-code-walkthrough(2.allColors)*/
    let allColors: [Color] = [.pink, .red, .orange, .yellow, .green, .mint, .teal, .cyan, .blue, .indigo, .purple, .brown, .gray]
    /*#-code-walkthrough(2.allColors)*/
    
    /*#-code-walkthrough(2.body)*/
    var body: some View {
        /*#-code-walkthrough(2.body)*/
        /*#-code-walkthrough(2.scrollView)*/
        ScrollView {
            /*#-code-walkthrough(2.scrollView)*/
            //#-learning-code-snippet(newImage)
            /*#-code-walkthrough(2.lazyVGrid)*/
            LazyVGrid(columns: adpColumns) {
                /*#-code-walkthrough(2.lazyVGrid)*/
                /*#-code-walkthrough(2.gridForEach)*/
                ForEach(allColors.indices, id: \.self) { index in
                    Button {
                        selectedColor = allColors[index]
                        print(selectedColor)
                    } label : {
                        if (selectedColor == allColors[index]) {
                            Image("Shelly").resizable().scaledToFit().colorMultiply(selectedColor)
                                .cornerRadius(4, antialiased: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                        } else {
                            RoundedRectangle(cornerRadius: 4.0)
                                .aspectRatio(1.0, contentMode: ContentMode.fit)
                                .foregroundColor(allColors[index])
                        }
                    }
                    /*#-code-walkthrough(2.gridForEach)*/
                    /*#-code-walkthrough(2.gridLabel)*/
                }
            }
        }
        .padding()
    }
}
