import Foundation

let assessOnSourceEditorUpdates = true

let taskQueryByID = [
    "changeText": assessChangeText,
    "textElement": assessTextElement,
    "addFriend": assessAddFriend,
    "modifier": assessModifier,
    "placeOneViewInsideAnother": assessPlaceOneViewInsideAnother,
    "addImageInHStack": assessAddImageInHStack,
    "composeAView": assessComposeAView,
    "addVStackInHStack": assessAddVStackInHStack,
    "addTextInVStack": assessAddTextInVStack,
    "describeFriend": assessDescribeFriend,
    "createDetailView": assessCreateDetailView
]

let inspectCodeOnSourceEditorUpdates = true

@_cdecl("Assessment") public dynamic func Assessment(_ payload: [String: Any], _ completion: @escaping ([String: Any]?, NSError?) -> Void) -> Void {
    
    guard let taskIDData = payload["TaskID"] as? Data, let taskID = String(data: taskIDData, encoding: .utf8) else { return }
        
    var completionPayload = [String : Data]()
            
    completionPayload["InspectCodeOnSourceEditorUpdates"] = Data(inspectCodeOnSourceEditorUpdates.description.utf8)
    
    if let taskQuery = taskQueryByID[taskID], let taskQueryData = taskQuery.jsonData {
        completionPayload["AssessmentSyntaxQuery"] = taskQueryData
    }
    
    completion(completionPayload, nil)
}
