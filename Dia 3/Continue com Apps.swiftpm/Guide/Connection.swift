import Foundation
import Combine

private var resultSubscription: AnyCancellable?

@_cdecl("Assessment") public dynamic func Assessment(_ payload: [String: Any], _ completion: @escaping ([String: Any]?, NSError?) -> Void) -> Void {
    if let taskIDData = payload["TaskID"] as? Data,
       let taskID = String(data: taskIDData, encoding: .utf8) {
        
        
        resultSubscription = SPCAssessmentResults.shared.$results.sink{ newResults in
            DispatchQueue.main.async {
                if let result = newResults[taskID] {
                    completion([taskID: Data(result.description.utf8)], nil)
                }
            }
        }
    }
}
