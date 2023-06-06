import SwiftUI
//#-learning-task(favoritesView)

struct FavoritesView: View {
    var body: some View {
        VStack {
            Text("Meus favoritos")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 40)
            /*#-code-walkthrough(FavoritesView.composition)*/
            HStack {
                Text("Hobbies")
                    .font(.title2)
                /*#-code-walkthrough(FavoritesView.alignment)*/
                Spacer()
                /*#-code-walkthrough(FavoritesView.alignment)*/
            }
            .padding(.leading)
            
            HStack(spacing: 20) {
                /*#-code-walkthrough(FavoritesView.edithobbies)*/
                Text("⚽️")
                    .font(.system(size: 48))
                Text("🎸")
                    .font(.system(size: 48))
                Text("🎲")
                    .font(.system(size: 48))
                Text("🎹")
                    .font(.system(size: 48))
                Text("🏎️")
                    .font(.system(size: 48))
                Text("🎮")
                    .font(.system(size: 48))
                Text("✈️")
                    .font(.system(size: 48))
                Text("🎢")
                    .font(.system(size: 48))
                Text("💻")
                    .font(.system(size: 48))
                /*#-code-walkthrough(FavoritesView.edithobbies)*/
                /*#-code-walkthrough(FavoritesView.alignment1)*/
                Spacer()
                /*#-code-walkthrough(FavoritesView.alignment1)*/
            }
            
            .padding()

            Divider()
            /*#-code-walkthrough(FavoritesView.composition)*/
            
            HStack {
                Text("Comidas")
                    .font(.title2)
                /*#-code-walkthrough(FavoritesView.alignment2)*/
                Spacer()
                /*#-code-walkthrough(FavoritesView.alignment2)*/
            }
            
            .padding([.top, .leading])
            /*#-code-walkthrough(FavoritesView.scroll)*/
            ScrollView(.horizontal) {
                /*#-code-walkthrough(FavoritesView.scroll)*/
                HStack(spacing: 30) {
                    Group {
                        Text("🥐")
                            .font(.system(size: 48))
                        Text("🍔")
                            .font(.system(size: 48))
                        Text("🥖")
                            .font(.system(size: 48))
                        Text("🧀")
                            .font(.system(size: 48))
                        Text("🥩")
                            .font(.system(size: 48))
                        Text("🧇")
                            .font(.system(size: 48))
                        Text("🍣")
                            .font(.system(size: 48))
                        Text("🍟")
                            .font(.system(size: 48))
                        /*#-code-walkthrough(FavoritesView.foods)*/
                        Text("🍕")
                            .font(.system(size: 48))
                        Text("🥟")
                            .font(.system(size: 48)) 
                    }
                    Group {
                        Text("🍝")
                            .font(.system(size: 48))
                        Text("🍦")
                            .font(.system(size: 48))
                        Text("🎂")
                            .font(.system(size: 48))
                        Text("🍫")
                            .font(.system(size: 48))
                        Text("🍿")
                            .font(.system(size: 48))
                        Text("🍪")
                            .font(.system(size: 48))
                        Text("🥛")
                            .font(.system(size: 48))
                    }
                    /*#-code-walkthrough(FavoritesView.foods)*/
                    /*#-code-walkthrough(FavoritesView.editFood)*/
                }
            }
            .padding()
            
            Divider()
            
            /*#-code-walkthrough(FavoritesView.disclosures)*/
            DisclosureGroup {
                /*#-code-walkthrough(FavoritesView.disclosures)*/
                HStack(spacing: 30) {
                    Color.blue
                        .frame(width: 70, height: 70)
                        .cornerRadius(10)
                    Color.red
                        .frame(width: 70, height: 70)
                        .cornerRadius(10)
                    Color.purple
                    /*#-code-walkthrough(FavoritesView.colors)*/
                        .frame(width: 70, height: 70)
                        .cornerRadius(10)
                    Spacer()
          }
                .padding(.vertical)
                
            } label: {
                Text("Adivinhe as minhas cores favoritas")
                    .font(.title2)
            }
            .padding()
            /*#-code-walkthrough(FavoritesView.accent)*/
            .accentColor(.purple)
            /*#-code-walkthrough(FavoritesView.accent)*/

        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
