import SwiftUI


struct FunFactsView: View {
    /*#-code-walkthrough(FunFactsView.funFacts)*/
    var allFunFacts: Array =
    [
        "Eu aprendi a ler com 2 anos",
        "Com 8 anos, eu desbloqueei meu primeiro celular por que queria jogar joguinhos e meu pai não tinha cartão de crédito",
        "Nasci e cresci em Maceió, uma cidade de praia",
        "Desde pequeno, sou o TI da família",
        "Sempre fui viciado em videogames, meu jogo favorito é The Last of Us Part II",
        "Sou extremamente extrovertido em momentos que preciso ser, mas sou introvertido quando não preciso",
        "Sou torcedor do CRB"
    ]
    /*#-code-walkthrough(FunFactsView.funFacts)*/
    /*#-code-walkthrough(FunFactsView.stateVariable)*/
    @State private var funFact = ""
    /*#-code-walkthrough(FunFactsView.stateVariable)*/
    
    var body: some View {
        /*#-code-walkthrough(FunFactsView.color)*/
        ZStack {
            Image("Green")
            VStack {
                /*#-code-walkthrough(FunFactsView.color)*/
                Text("Curiosidades sobre mim")
                    .font(.largeTitle)
                /*#-code-walkthrough(FunFactsView.textView)*/
                Text(funFact)
                    .font(.title)
                    .frame(maxWidth: 400, minHeight: 300)
                /*#-code-walkthrough(FunFactsView.textView)*/
                
                /*#-code-walkthrough(FunFactsView.button)*/
                Button("Mostrar curiosidade") {
                    funFact = allFunFacts.randomElement() ?? "Fiquei sem ter o que falar."
                }.padding().background(.white, in: RoundedRectangle(cornerRadius: 10, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
                /*#-code-walkthrough(FunFactsView.button)*/
                /*#-code-walkthrough(FunFactsView.button.modifiers)*/
                
                /*#-code-walkthrough(FunFactsView.button.modifiers)*/
            }
            .padding()
        }
        
    }
}

struct FunFactsView_Previews: PreviewProvider {
    static var previews: some View {
        FunFactsView()
    }
}
