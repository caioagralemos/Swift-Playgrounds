import SwiftUI
//#-learning-task(symbolStruct)

/*#-code-walkthrough(symbol.struct)*/
struct Symbol : Identifiable, Equatable {
    /*#-code-walkthrough(symbol.id)*/
    var id = UUID() // requisito de identifiable
    /*#-code-walkthrough(symbol.id)*/
    /*#-code-walkthrough(symbol.name)*/
    var name : String
    /*#-code-walkthrough(symbol.name)*/
}
/*#-code-walkthrough(symbol.struct)*/
