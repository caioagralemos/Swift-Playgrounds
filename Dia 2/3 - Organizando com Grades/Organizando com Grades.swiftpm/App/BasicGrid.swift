import SwiftUI

struct BasicGrid: View {
    var body: some View {
        /*#-code-walkthrough(basicGrid)*/
        Grid(alignment: .top, horizontalSpacing: 5, verticalSpacing: 10) { // parametros importantes
            GridRow{
                Color.mint
                Color.pink
            }.gridCellColumns(2) // determina a quantidade de colunas
            GridRow(alignment: .center) { // existem parametros especificos para gridrows
                Color.red
                Color.white
                Color.blue
                Text("Olá, mundo! lorem ipsun dolor sit amet").gridCellAnchor(.bottomTrailing) // alinhando celulas individuais
                Image("cactuswren").resizable()
            }
            /*#-code-walkthrough(basicGrid)*/
            //#-learning-code-snippet(gridIntro)
            //#-learning-code-snippet(secondRow)
        }
    }
}

struct BasicGrid_Previews: PreviewProvider {
    static var previews: some View {
        BasicGrid()
    }
}

