import SwiftUI

//#-learning-code-snippet(creatureZoo)

/*#-code-walkthrough(creatureZoo.observableObject)*/
class CreatureZoo : ObservableObject {
    /*#-code-walkthrough(creatureZoo.observableObject)*/
    /*#-code-walkthrough(creatureZoo.creatures)*/
    /*#-code-walkthrough(creatureZoo.published)*/ @Published /*#-code-walkthrough(creatureZoo.published)*/var creatures = [
        /*#-code-walkthrough(creatureZoo.creature)*/
        Creature(name: "Gorilla", emoji: "🦍"),
        /*#-code-walkthrough(creatureZoo.creature)*/
        Creature(name: "Peacock", emoji: "🦚"),
        Creature(name: "Squid", emoji: "🦑"),
        Creature(name: "Pig", emoji: "🐷"),
        Creature(name: "Messi", emoji: "🐐"),
        //#-learning-code-snippet(addCreatures)
        //#-learning-code-snippet(addOneMoreCreature)
    ]
    /*#-code-walkthrough(creatureZoo.creatures)*/
}

/*#-code-walkthrough(creatureZoo.creatureStruct)*/
struct Creature : Identifiable { // type = struct e class = class
    var name : String
    var emoji : String
    
    var id = UUID()
    var offset = CGSize.zero
    var rotation : Angle = Angle(degrees: 0)
}
/*#-code-walkthrough(creatureZoo.creatureStruct)*/


// Should be hidden probably
extension CreatureZoo {
    func randomizeOffsets() {
        for index in creatures.indices {
            creatures[index].offset = CGSize(width: CGFloat.random(in: -200...200), height: CGFloat.random(in: -200...200))
            creatures[index].rotation = Angle(degrees: Double.random(in: 0...720))
        }
    }
    
    func synchronizeOffsets() {
        let randomOffset = CGSize(width: CGFloat.random(in: -200...200), height: CGFloat.random(in: -200...200))
        for index in creatures.indices {
            creatures[index].offset = randomOffset
        }
    }
    
    func indexFor(_ creature: Creature) ->  Double {
        if let index = creatures.firstIndex(where: { $0.id == creature.id }) {
            return Double(index)
        }
        return 0.0
    }
}

