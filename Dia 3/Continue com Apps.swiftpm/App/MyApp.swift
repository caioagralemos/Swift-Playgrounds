import SwiftUI
import Guide
//#-learning-code-snippet(myApp)

@main
/*#-code-walkthrough(myApp.appProtocol)*/
struct MyApp: App {
    @StateObject var animals = CreatureZoo()
    /*#-code-walkthrough(myApp.appProtocol)*/
    //#-learning-code-snippet(createInstanceCreatureZoo)

    /*#-code-walkthrough(myApp.body)*/
    var body: some Scene {
        SPCAssessableWindowGroup(app: self, assessmentCandidates: [CreatureZoo()]) {
            /*#-code-walkthrough(myApp.contentView)*/
            NavigationStack {
                ContentView().navigationTitle("Home")
            }.environmentObject(animals) // tipo um react provider, passa os dados pra todas as views filhas
        }
    }
    /*#-code-walkthrough(myApp.body)*/
}
