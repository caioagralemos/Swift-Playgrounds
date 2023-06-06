import SwiftUI

/*#-code-walkthrough(HomeView.struct)*/
struct HomeView: View {
    /*#-code-walkthrough(HomeView.struct)*/
    /*#-code-walkthrough(HomeView.views)*/
    var body: some View {
        VStack {
            Text("Sobre mim")
            /*#-code-walkthrough(HomeView.modifiers)*/
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            /*#-code-walkthrough(HomeView.modifiers)*/
            /*#-code-walkthrough(HomeView.Image)*/
            Image("Profile")
            /*#-code-walkthrough(HomeView.Image)*/
            /*#-code-walkthrough(HomeView.Image.resizable)*/
                .resizable()
                .scaledToFit()
            /*#-code-walkthrough(HomeView.Image.resizable)*/
            /*#-code-walkthrough(HomeView.Image.modifiers)*/
                .clipShape(RoundedRectangle(cornerRadius:10))
                .overlay(
                    RoundedRectangle(cornerRadius:10)
                        .stroke(.white, style: StrokeStyle(lineWidth: 10))
                )

            /*#-code-walkthrough(HomeView.Image.modifiers)*/
            /*#-code-walkthrough(omeView.Image.overlay)*/
            
            /*#-code-walkthrough(omeView.Image.overlay)*/
            /*#-code-walkthrough(HomeView.Text)*/
            Text("Caio Agra Lemos")
            /*#-code-walkthrough(HomeView.Text)*/
            /*#-code-walkthrough(HomeView.Text.modifiers)*/
                .font(.custom(FontNames.helvetica, size: 50))
                .padding(40).shadow(color: .white, radius: 50)


            /*#-code-walkthrough(HomeView.Text.moreModifiers)*/
            HStack {
                Image(systemName: "desktopcomputer")
                    .foregroundColor(.white)
                Text("Desenvolvedor de Software")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
            }


            /*#-code-walkthrough(HomeView.stacksOnStacks)*/
        }
        .padding()
        /*#-code-walkthrough(HomeView.Image.background)*/
        .background(Image("Blue"))
            .scaledToFit()
        /*#-code-walkthrough(HomeView.Image.background)*/
        /*#-code-walkthrough(HomeView.Image.clip)*/
        
        /*#-code-walkthrough(HomeView.Image.clip)*/
        
    }
    /*#-code-walkthrough(HomeView.views)*/
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct FontNames {
    static var americanTypwriter = "American Typewriter"
    static var arial = "Arial"
    static var baskerville = "Baskerville"
    static var chalkduster = "Chalkduster"
    static var courier = "Courier"
    static var georgia = "Georgia"
    static var helvetica = "Helvetica"
    static var palatino = "Palatino"
    static var zapfino = "Zapfino"
}
