import SwiftUI

struct FriendDetailView: View {
    var body: some View {
        VStack {
        //#-learning-task(composeAView)
        //#-learning-task(addTextInVStack)
        //#-learning-task(describeFriend)
            HStack {
                Image("Friend")
                    .resizable()
                    .scaledToFit()
                VStack {
                    Text("Friend")
                        .font(.largeTitle)
                    Text("Always there when you need him!").font(.caption)
                }
            }
        }
    }
}

struct FriendDetailView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            FriendDetailView()
        }
    }
}
