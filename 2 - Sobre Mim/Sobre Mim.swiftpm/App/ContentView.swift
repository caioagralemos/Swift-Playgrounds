import SwiftUI

struct ContentView: View {
    var body: some View {
        /*#-code-walkthrough(ContentView.tabView)*/
        TabView {
            /*#-code-walkthrough(ContentView.tabView)*/
            /*#-code-walkthrough(ContentView.homeTab)*/
            HomeView()
            /*#-code-walkthrough(ContentView.homeTab)*/
            /*#-code-walkthrough(ContentView.tabItem)*/
                .tabItem {
                    Label("Home", systemImage: "person")
                }
            /*#-code-walkthrough(ContentView.tabItem)*/

            StoryView()
                .tabItem {
                    Label("História", systemImage: "book")
                }
            
            FavoritesView()
                .tabItem {
                    Label("Meus Favoritos", systemImage: "star")
                }
            
            FunFactsView()
                .tabItem {
                    Label("Curiosidades", systemImage: "hand.thumbsup")
                }
            /*#-code-walkthrough(ContentView.addATab)*/
            //#-learning-task(addATab)
            YourTab()
                .tabItem {
                    Label("Mais", systemImage: "plus.app.fill")
                }
            /*#-code-walkthrough(ContentView.addATab)*/
        }  
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
