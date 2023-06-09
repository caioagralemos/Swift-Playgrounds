import SwiftUI

struct StoryEditor: View {
    @State var hobby = "programar"
    @State var name = "Caio"
    @State var favoriteFood = "Pizza Branca"
    @State var isOn = false
    
    var body: some View {
        VStack {
            if isOn {
                Text("Olá, me chamo \(name), meu hobby favorito é \(hobby) e adoro comer \(favoriteFood)!").padding()
            }
            
            Button("Mostrar história") {
                isOn.toggle()
            }.padding()
        }
    }
}

struct StoryEditor_Previews: PreviewProvider {
    static var previews: some View {
        StoryEditor()
    }
}
