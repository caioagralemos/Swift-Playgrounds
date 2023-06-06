import SwiftUI

struct StoryView: View {
    var body: some View {
        /*#-code-walkthrough(StoryView.starterCode)*/
        /*#-code-walkthrough(StoryView.scrollView)*/
        ScrollView {
            /*#-code-walkthrough(StoryView.scrollView)*/
            VStack(alignment: .leading) {
                Group {
                    // como uma div
                    Text("Minha História")
                        .font(.largeTitle)
                    Text("Caio Agra Lemos")
                    /*#-code-walkthrough(StoryView.intro)*/
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Divider()
                }
                HStack(spacing: 2, content: {
                    Image("kiddo2").resizable().scaledToFit().cornerRadius(5).padding()
                    Text("Desde pequeno sempre fui apaixonado por tecnologia").padding()
                
                })
            }
            /*#-code-walkthrough(StoryView.modifiers)*/
            .padding() // adiciona padding interno a essa VStack
            .frame(maxWidth: .infinity) // extende a VStack horizontalmente
            .background(in: RoundedRectangle(cornerRadius: 15)) // dá o fundo preto e arredonda as bordas
            .padding() // adiciona padding entre a vstack e as bordas da view
            
            VStack (alignment: .center){
                Text("Hoje em dia, faço faculdade de Ciência da Computação na Universidade Federal de Alagoas, e sou desenvolvedor web e mobile, com foco em React.js e Swift, mas também com conhecimento em Python e Flutter (Linguagem DART).").multilineTextAlignment(.center)
                Link("Visite meu portfólio!", destination: URL(string: "http://caioagralemos.com")!)
                    .accentColor(.white)
                    .padding()
                    .background(.blue, in: RoundedRectangle(cornerRadius: 25))
                    .multilineTextAlignment(.center)
            }
            .padding() // adiciona padding interno a essa VfillStyle: fillStyle: Stack
            .frame(maxWidth: .infinity) // extende a VStack horizontalmente
            .background(in: RoundedRectangle(cornerRadius: 15)) // dá o fundo preto e arredonda as bordas
            .padding() // adiciona padding entre a vstack e as bordas da view
            
            
            
            /*#-code-walkthrough(StoryView.secondArticle)*/
            
            /*#-code-walkthrough(StoryView.secondArticle)*/
        }
        .background(Image("Purple").opacity(0.5))
        /*#-code-walkthrough(StoryView.modifiers)*/
        /*#-code-walkthrough(StoryView.starterCode)*/
    }
}

struct StoryView_Previews: PreviewProvider {
    static var previews: some View {
        StoryView()
    }
}
