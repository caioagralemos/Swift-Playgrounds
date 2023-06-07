import SwiftUI

struct SymbolDetail: View {
    var symbol: Symbol

    var body: some View {
        VStack {
            Text(symbol.name).font(.title)
            Image(systemName: symbol.name)
                .resizable()
                .scaledToFit()
                .symbolRenderingMode(.multicolor) // tipos de renderização (hierarchical troca as cores por um sistema de renderização por camadas)
                .foregroundColor(.accentColor) // accentColor reflete o tema do sistema
            //#-learning-code-snippet(addTextView)
            //#-learning-code-snippet(addTextModifier)
            //#-learning-code-snippet(imageInitializer)
            //#-learning-code-snippet(imageModifiers)
        }
        .padding()
    }
}

struct Details_Previews: PreviewProvider {
    static var previews: some View {
        SymbolDetail(symbol: /*#-code-walkthrough(symbolPreview)*/ Symbol(name: "person.and.background.dotted")/*#-code-walkthrough(symbolPreview)*/)
    }
}

