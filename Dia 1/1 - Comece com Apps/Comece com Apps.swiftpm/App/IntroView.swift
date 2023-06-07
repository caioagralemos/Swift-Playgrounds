//#-learning-task(getStartedWithApps)
import SwiftUI

/*#-code-walkthrough(1.first)*/
struct/*#-code-walkthrough(1.introView)*/ IntroView: /*#-code-walkthrough(1.introView)*/ View {
    /*#-code-walkthrough(1.body)*/
    var body: some View {
        HStack {
            Image("Hopper")
            Image("FriendAndGem")
                .resizable()
                .scaledToFit()
        }
        //#-learning-task(placeOneViewInsideAnother)
        //#-learning-task(addImageInHStack)
        //#-learning-task(modifierWalkthrough)
        /*#-code-walkthrough(2.bothModifiers)*/
        //#-learning-task(addFriend)
        //#-learning-task(modifier)
        /*#-code-walkthrough(2.bothModifiers)*/
        //#-learning-task(changeText)
        /*#-code-walkthrough(1.text)*/
        Text("Eu só queria te lembrar que aquele tempo eu não podia fazer mais por nós")
        Text("I didnt know")
        /*#-code-walkthrough(1.text)*/
        //#-learning-task(textElement)
    }
    /*#-code-walkthrough(1.body)*/
}

/*#-code-walkthrough(1.preview)*/
struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            IntroView()
        }
    }
}
/*#-code-walkthrough(1.preview)*/
/*#-code-walkthrough(1.first)*/

