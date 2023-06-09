import Foundation
import SwiftUI

class SPCAssessor {
    let assessedItem: Any
    let assessedItemType: String
    private let propertyMirror: Mirror
    
    init(assessedItem: Any) {
        self.assessedItem = assessedItem
        self.assessedItemType = String(describing: assessedItem)
        self.propertyMirror = Mirror(reflecting: assessedItem)
    }
    
    
    @discardableResult
    func runAssessments(assessedItemType: String) -> Bool {
        guard let taskFunction = tasks[assessedItemType] else { return false }
        return taskFunction()
    }
    
    @discardableResult
    func runAssessments(_ assessments: [() -> Bool]) -> Bool {
        let results = assessments.map{ $0() }
        let result = results.contains(false) == false
        return result
    }
    
    func recordResult(_ result: Bool,
            function: String = #function) {
        let sanitisedFunctionName = function.replacingOccurrences(of: "()", with: "").replacingOccurrences(of: "__preview__", with: "")
        if SPCAssessmentLoggingPreferences.printAssessmentResults {
            print("*** Result of \(sanitisedFunctionName) = \(result)")
        }
        SPCAssessmentResults.shared.results[sanitisedFunctionName] = result
    }
    
    //MARK: Type Name Based
    
    func SPCContainsType(_ type: String) -> Bool {
       return assessedItemType.contains(type)
    }
    
    enum SPCAssessmentValueComparisonStrategy {
        case equals
        case notEquals
        case doNotCompare
    }
    
    //MARK: Property Based
    func SPCGetProperty(name: String) -> Any? {
        let nameToSearch = name.hasPrefix("_") ? name : "_\(name)"
        let property = propertyMirror.children.first{ $0.label == nameToSearch }
        return property?.value
    }
    
    func SPCContainsProperty(name: String) -> Bool {
        let nameToSearch = name.hasPrefix("_") ? name : "_\(name)"
        return propertyMirror.children.contains{ $0.label == nameToSearch }
    }
    
    func SPCContainsProperty<T: Equatable>(name: String, value: T, valueComparisonStrategy: SPCAssessmentValueComparisonStrategy = .equals) -> Bool {
        let nameToSearch = name.hasPrefix("_") ? name : "_\(name)"
        let valueToAssess: T
        
        if let child = propertyMirror.children.first(where: { $0.label == nameToSearch }) {
            if let stateValue = child.value as? State<T> {
                valueToAssess = stateValue.wrappedValue
            } else if let childValue = child.value as? T {
                valueToAssess = childValue
            } else {
                return false
            }
        } else {
            return false
        }
        
        return valueToAssess == value
    }
    
    func SPCContainsProperty<T>(name: String, type: T.Type) -> Bool {
        return _SPCContainsProperty(name: name, type: type)
    }
    
    func SPCContainsProperty<T>(type: T.Type) -> Bool {
        return _SPCContainsProperty(name: nil, type: type)
    }
    
    func SPCContainsProperty(name: String, typeString: String) -> Bool {
        return _SPCContainsProperty(name: name, typeString: typeString)
    }
    
    func SPCContainsProperty(typeString: String) -> Bool {
        return _SPCContainsProperty(name: nil, typeString: typeString)
    }
    
    func SPCContainsProperty<T, V: Equatable>(name: String, type: T.Type, value: V, valueComparisonStrategy: SPCAssessmentValueComparisonStrategy = .equals) -> Bool {
        let nameAndValueMatches = SPCContainsProperty(name: name, value: value, valueComparisonStrategy: valueComparisonStrategy)
        let nameAndTypeMatches = SPCContainsProperty(name: name, type:type)
        
        return nameAndValueMatches && nameAndTypeMatches
    }
    
    func SPCCountProperties<T>(type candidateType: T.Type) -> Int {
        let propertiesMatchingType = propertyMirror.children.filter{ $0.value is T }
        return propertiesMatchingType.count
    }
    
    func SPCCountProperties(type candidateType: SPCAssessmentPropertyType) -> Int {
        let propertiesMatchingType = propertyMirror.children.filter{
            let propertyType = String(describing: type(of: $0.value))
            return candidateType.typeMatchCheck(typeString:propertyType)
        }
        return propertiesMatchingType.count
    }
    
    enum SPCAssessmentPropertyType {
        case state
        case optional
        case binding
        
        func typeMatchCheck(typeString: String) -> Bool {
            
            switch self {
            case .state:
                return typeString.contains("State<")
            case .optional:
                return typeString.contains("Optional<")
            case .binding:
                return typeString.contains("Binding<")
            }
            
        }
    }
    
    //MARK: Private
    
    private func _SPCContainsProperty<T>(name: String? = nil, type: T.Type) -> Bool {
        var nameTestSkippedOrPassed = true
        if let name = name {
            nameTestSkippedOrPassed = SPCContainsProperty(name: name)
        }
        
        let typeTestPassed = propertyMirror.children.contains{ $0.value is T }
        
        return nameTestSkippedOrPassed && typeTestPassed
    }
    
    private func _SPCContainsProperty(name: String? = nil, typeString: String) -> Bool {
        var nameTestSkippedOrPassed = true
        if let name = name {
            nameTestSkippedOrPassed = SPCContainsProperty(name: name)
        }
        
        let typeNames = propertyMirror.children.compactMap { String(describing: type(of: $0.value)) }
        let typeTestPassed = typeNames.contains(typeString)
 
        return nameTestSkippedOrPassed && typeTestPassed
    }
    
}
