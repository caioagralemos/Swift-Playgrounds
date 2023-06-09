import SwiftUI

struct CreatureRow: View {
    var creature : Creature
    
    var body: some View {
        HStack {
            Text(creature.name)
                .font(.title)
            
            Spacer()
            
            Text(creature.emoji)
                .resizableFont()
                .frame(minWidth: 125)
        }
        
        
    }
}

struct CreatureRow_Previews: PreviewProvider {
    static var previews: some View {
        CreatureRow(creature: Creature(name: "Dodo Bird", emoji: "🦤"))
    }
}
