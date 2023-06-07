import SwiftUI

struct ExperimentView: View {
    var body: some View {
        HStack {
            VStack{
                Image("FriendAndGem").resizable().scaledToFit()
                Text("Friend and his Friend?").font(.title)
                Text("Money money money!").font(.caption)
            }
            VStack {
               FriendDetailView()         
            }
                //#-learning-task(createDetailView)
                //#-learning-task(createBluView)
                //#-learning-task(createHopperView)
            }
        HStack {
            VStack{
                Text("Blu").font(.largeTitle)
                Text("Friend's Best Friend!").font(.caption)   
                Image("Blu").resizable().scaledToFit()
            }
            HStack{
                VStack{
                    Text("Hopper").font(.largeTitle)
                    Text("Yessssss!").font(.caption)   
                }
                Image("Hopper").resizable().scaledToFit()
            }
        }
    }
}

struct ExperimentView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ExperimentView()
        }
    }
}
