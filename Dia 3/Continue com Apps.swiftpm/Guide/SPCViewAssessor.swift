import SwiftUI

class SPCViewAssessor<Content: View, ViewContent: View>: SPCAssessor {
    let assessedView: Content
    let assessedViewBodyType: String
    private let flattenedBodyMirror: [Mirror.Child]
    
    init(assessedView: Content, assessedViewContent: ViewContent) {
        self.assessedView = assessedView
        if String(describing: type(of: assessedView)).starts(with: "ModifiedContent") == false {
            self.assessedViewBodyType = String(describing: assessedViewContent)
            self.flattenedBodyMirror = SPCViewAssessor.flattenMirror(view: assessedViewContent)
        } else {
            self.assessedViewBodyType = String(describing: assessedViewContent)
            self.flattenedBodyMirror = []
        }
        super.init(assessedItem: assessedView)
    }
    
    @discardableResult
    func runAssessments() -> Bool {
        let typeName = String(describing: type(of: assessedView))
        return runAssessments(typeName: typeName)
    }
    
    @discardableResult
    func runAssessments(typeName: String) -> Bool {
        guard let taskFunction = taskFunctionByView[typeName] else { return false }
        return taskFunction()
    }
    
    @discardableResult
    func runAssessments<T>(view: T.Type) -> Bool {
        let viewName = String(describing: type(of: view))
        guard let taskFunction = taskFunctionByView[viewName] else { return false }
        return taskFunction()
    }
    
    override func SPCContainsType(_ type: String) -> Bool {
        let searchBaseType = assessedItemType.contains(type)
        let searchBodyType = assessedViewBodyType.contains(type)
        
        return searchBaseType || searchBodyType
    }
}

extension SPCViewAssessor {

    //MARK: Type Name Based
    
    func SPCContainsChildMatching(pattern: String) -> Bool {
        return SPCCountChildMatching(pattern: pattern) > 0
    }
    
    func SPCCountChildMatching(pattern: String) -> Int {
        let allMatches = flattenedBodyMirror.filter{
            let valueType = String(describing: type(of: $0.value))
            return valueType.contains(pattern)
        }
        return allMatches.count
    }
    
    //MARK: View Hierarchy Based
    
    enum SPCAssessmentUIElement {
        case VStack
        case HStack
        case Text
        case TextField
        case Image
        case ColorPicker
        case Slider
        case Rectangle
        case Circle
        case Form
        case TextButton
        case ToolbarItem
    }
    
    func SPCViewContainsUIElement<T>(type: T.Type) -> Bool {
        return _SPCViewContainsUIElement(rawType: type)
    }
    
    func SPCViewContainsUIElement(elementType: SPCAssessmentUIElement) -> Bool {
        return SPCCountUIElement(elementType: elementType) > 0
    }
    
    func SPCCountUIElement(elementType: SPCAssessmentUIElement) -> Int {
        let typeCount: Int
        switch elementType {
        case .VStack:
            typeCount = flattenedBodyMirror.filter{ $0.value is _VStackLayout }.count
        case .HStack:
            typeCount = flattenedBodyMirror.filter{ $0.value is _HStackLayout }.count
        case .Text:
            typeCount = flattenedBodyMirror.filter{ $0.value is Text }.count
        case .TextField:
            typeCount = flattenedBodyMirror.filter{ $0.value is TextField<EmptyView> || $0.value is TextField<Text> }.count
        case .Image:
            typeCount = flattenedBodyMirror.filter{ $0.value is Image }.count
        case .ColorPicker:
            typeCount = flattenedBodyMirror.filter{ $0.value is ColorPicker<Text> || $0.value is ColorPicker<EmptyView> }.count
        case .Slider:
            typeCount = flattenedBodyMirror.filter{ $0.value is Slider<EmptyView, EmptyView> || $0.value is Slider<EmptyView, Text> ||  $0.value is Slider<Text, EmptyView> || $0.value is Slider<Text, Text> }.count
        case .Rectangle:
            typeCount = flattenedBodyMirror.filter{ $0.value is Rectangle }.count
        case .Circle:
            typeCount = flattenedBodyMirror.filter{ $0.value is Circle }.count
        case .Form:
            let formSearchResult = flattenedBodyMirror.contains {
                let valueType = String(describing: type(of: $0.value))
                return valueType.contains("Form<")
            }
            return formSearchResult ? 1 : 0
        case .TextButton:
            typeCount = flattenedBodyMirror.filter{ $0.value is Button<Text> }.count
        case .ToolbarItem:
            let toolbarItemSearchResult = flattenedBodyMirror.contains {
                let valueType = String(describing: type(of: $0.value))
                return valueType.contains("ToolbarItem<")
            }
            return toolbarItemSearchResult ? 1 : 0
        }
        
        return typeCount
    }
    
    func SPCStackChildCounts() -> [Int] {
        var childCount = [Int]()
        
        for child in flattenedBodyMirror {
            if let stackContent = Mirror(reflecting: child.value).descendant("content", "value") {
                let contentMirror = Mirror(reflecting: stackContent)
                childCount.append(contentMirror.children.count)
            }
        }
        
        return childCount
    }
    
    //MARK: Navigation
    enum SPCAssessmentNavigationLink {
        case anyTitle
        case defaultTitle
        case customTitle
    }
    
    func SPCContainsNavigationLinks(_ linkType: SPCAssessmentNavigationLink) -> Bool {
        return SPCCountNavigationLinks(linkType) > 0
    }
    
    func SPCCountNavigationLinks(_ linkType: SPCAssessmentNavigationLink) -> Int {
        return SPCAllNavigationLinks(linkType).count
    }
    
    func SPCAllNavigationLinks(_ linkType: SPCAssessmentNavigationLink) -> [Mirror.Child] {
        let allLinks = flattenedBodyMirror.filter{
            let valueType = String(describing: type(of: $0.value))
            return valueType.starts(with: "NavigationLink<")
        }
        
        let matchedLinks: [Mirror.Child]
        
        switch linkType {
        case .defaultTitle:
            matchedLinks = allLinks.filter{
                let valueType = String(describing: type(of: $0.value))
                return valueType.starts(with: "NavigationLink<Text,")
            }
        case .customTitle:
            matchedLinks = allLinks.filter{
                let valueType = String(describing: type(of: $0.value))
                return valueType.starts(with: "NavigationLink<Text,") == false
            }
        case .anyTitle:
            matchedLinks = allLinks
        }
        
        return matchedLinks
    }
    
    func SPCLinkToTargetTypeExists(_ target: String) -> Bool {
        let allLinks = SPCAllNavigationLinks(.anyTitle)
        for child in allLinks {
            if let linkDestination = Mirror(reflecting: child.value).descendant("destination") {
                let destinationType = String(describing: type(of: linkDestination))
                if destinationType.contains(target) {
                    return true
                }
            }
        }
        return false
    }
    
    func SPCContainsNavigationStack() -> Bool {
        let searchByTypeName = SPCContainsType("NavigationStack")
        let searchByMirror = flattenedBodyMirror.contains {
            let valueType = String(describing: type(of: $0.value))
            return valueType.starts(with: "NavigationStack<")
        }
        return searchByTypeName || searchByMirror
    }
    
    //MARK: Modifier Based
    enum SPCAssessmentGestureType {
        case any
        case tap
    }
    
    enum SPCAssessmentModifier {
        case colorModifier(color: Color?)
        case frameModifier(minHeight: CGFloat?, maxHeight: CGFloat?)
        case shadowEffect(color: Color?)
        case scaleEffect(scale: CGFloat?)
        case animationModifier
        case deleteModifier
        case gestureModifier(gestureType: SPCAssessmentGestureType)
        case toolbar
        
        var stringType: String? {
            switch self {
            case .colorModifier(color: _):
                return nil
            case .frameModifier(minHeight: _, maxHeight: _):
                return nil
            case .shadowEffect(color: _):
                return "_ShadowEffect"
            case .scaleEffect(scale: _):
                return "_ScaleEffect"
            case .animationModifier:
                return "_AnimationModifier"
            case .deleteModifier:
                return nil
            case .gestureModifier(gestureType: _):
                return nil
            case .toolbar:
                return "ToolbarModifier"
            }
        }
    }
    
    func SPCViewContainsModifier(_ modifier: SPCAssessmentModifier, valueComparisonStrategy: SPCAssessmentValueComparisonStrategy) -> Bool {
        let firstPass = _SPCViewContainsModifier(modifier, valueComparisonStrategy: valueComparisonStrategy)
        guard firstPass == false else { return firstPass }
        
        let allForEachContent = flattenedBodyMirror.filter{
            guard let modifierType = modifier.stringType else { return false }
            let valueType = String(describing: type(of: $0.value))
            return valueType.starts(with: "ForEach") && valueType.contains(modifierType)
        }
        return allForEachContent.isEmpty == false
        
    }
    
    //MARK: Control Structure Based
    
    func SPCViewContainsConditionalContent() -> Bool {
        return SPCConditionalContentCount() > 0
    }
    
    func SPCConditionalContentCount() -> Int {
        let allConditionalContent = flattenedBodyMirror.filter{
            let valueType = String(describing: type(of: $0.value))
            return valueType.starts(with: "_ConditionalContent")
        }
        return allConditionalContent.count
    }
    
    enum ConditionalChildComposition {
        case unknown
        case bothEmpty
        case oneEmptyOneSingle
        case oneEmptyOneMultiple
        case oneSingleOneMultiple
        case bothSingle
        case bothMultiple
        
        var bothSidesPopulated: Bool {
            [ConditionalChildComposition.oneSingleOneMultiple, .bothSingle, .bothMultiple].contains(self)
        }
    }
    
    func SPCConditionalContentCompositions() -> [ConditionalChildComposition] {
        var compositions = [ConditionalChildComposition]()
        
        for child in flattenedBodyMirror {
            let valueType = String(describing: type(of: child.value))
            
            let composition: ConditionalChildComposition
            if valueType.starts(with: "_ConditionalContent") {
                let emptyCount = valueType.components(separatedBy: "EmptyView").count - 1
                let tupleCount = valueType.components(separatedBy: "TupleView").count - 1
                
                switch emptyCount {
                case 0:
                    switch tupleCount {
                    case 0:
                        composition = .bothSingle
                    case 1:
                        composition = .oneSingleOneMultiple
                    case 2:
                        composition = .bothMultiple
                    default:
                        composition = .unknown
                    }
                case 1:
                    composition = tupleCount == 0 ? .oneEmptyOneSingle : .oneEmptyOneMultiple
                case 2:
                    composition = .bothEmpty
                default:
                    composition = .unknown
                }
                
                compositions.append(composition)
            }
        }
        
        return compositions
      
        
    }
    
    func SPCViewContainsList() -> Bool {
        return SPCListCount() > 0
    }
    
    func SPCListCount() -> Int {
        let allConditionalContent = flattenedBodyMirror.filter{
            let valueType = String(describing: type(of: $0.value))
            return valueType.starts(with: "List<")
        }
        return allConditionalContent.count
    }
    
    func SPCViewContainsForEach(collectionType: String? = nil) -> Bool {
        return SPCForEachCount(collectionType: collectionType) > 0
    }
    
    func SPCForEachCount(collectionType: String? = nil) -> Int {
        let allConditionalContent = flattenedBodyMirror.filter{
            let valueType = String(describing: type(of: $0.value))
            var typeToSeek = "ForEach<"
            if let collectionType = collectionType {
                typeToSeek += collectionType
            }
            return valueType.starts(with: typeToSeek)
        }
        return allConditionalContent.count
    }
    
    
    private func _SPCViewContainsUIElement<T>(rawType: T.Type) -> Bool {
        let typeTestPassed = flattenedBodyMirror.contains{ $0.value is T }
        return typeTestPassed
    }
    
    
    private func _SPCViewContainsModifier(_ targetModifier: SPCAssessmentModifier, valueComparisonStrategy: SPCAssessmentValueComparisonStrategy) -> Bool {
        let allModifiers = flattenedBodyMirror.filter{ $0.label  == "modifier" }
        
        var modifierMatched = false
        var valueMatched = valueComparisonStrategy == .doNotCompare ? true : false
        
        for modifier in allModifiers {
            if modifierMatched && valueMatched { break }
            let typeString = String(describing: type(of: modifier.value))
            
            switch targetModifier {
            case .colorModifier(let desiredColor):
                if let colorModifier = modifier.value as? SwiftUI._EnvironmentKeyWritingModifier<Swift.Optional<SwiftUI.Color>> {
                    modifierMatched = true
                    
                    if valueMatched == false {
                        switch valueComparisonStrategy {
                        case .equals:
                            valueMatched = colorModifier.value == desiredColor
                        case .notEquals:
                            valueMatched = colorModifier.value != desiredColor
                        case .doNotCompare:
                            break
                        }
                    }
                }
            case .frameModifier(let desiredMinHeight, let desiredMaxHeight):
                if let frameModifier = modifier.value as? _FlexFrameLayout {
                    modifierMatched = true
                    
                    if valueMatched == false {
                        let candidateMinHeight = Mirror(reflecting: frameModifier).descendant("minHeight") as? CGFloat
                        let candidateMaxHeight = Mirror(reflecting: frameModifier).descendant("maxHeight") as? CGFloat
                        
                        switch valueComparisonStrategy {
                        case .equals:
                            valueMatched = candidateMaxHeight == desiredMaxHeight && candidateMinHeight == desiredMinHeight
                        case .notEquals:
                            valueMatched = candidateMaxHeight != desiredMaxHeight || candidateMinHeight != desiredMinHeight
                        case .doNotCompare:
                            break
                        }
                    }
                }
            case .shadowEffect(let desiredColor):
                if let shadowModifier = modifier.value as? _ShadowEffect {
                    modifierMatched = true
                    
                    if valueMatched == false {
                        switch valueComparisonStrategy {
                        case .equals:
                            valueMatched = shadowModifier.color == desiredColor
                        case .notEquals:
                            valueMatched = shadowModifier.color != desiredColor
                        case .doNotCompare:
                            break
                        }
                    }
                }
            case .scaleEffect(let desiredScale):
                if let scaleModifier = modifier.value as? _ScaleEffect {
                    modifierMatched = true
                    
                    if valueMatched == false {
                        switch valueComparisonStrategy {
                        case .equals:
                            valueMatched = scaleModifier.scale.width == desiredScale && scaleModifier.scale.height == desiredScale
                        case .notEquals:
                            valueMatched = scaleModifier.scale.width != desiredScale || scaleModifier.scale.height != desiredScale
                        case .doNotCompare:
                            break
                        }
                    }
                }
                
            case .animationModifier:
                if modifier.value is _AnimationModifier<Bool> {
                    modifierMatched = true
                    valueMatched = true
                }
            case .deleteModifier:
                modifierMatched = typeString == "_TraitWritingModifier<OnDeleteTraitKey>"
                valueMatched = true
            case .gestureModifier(let gestureType):
                let introspectedGestureType = Mirror(reflecting: modifier.value).descendant("gesture", "_body", "content")
                switch gestureType {
                case .any:
                    modifierMatched = typeString.starts(with: "AddGestureModifier<")
                case .tap:
                    modifierMatched = introspectedGestureType is TapGesture
                }
                valueMatched = true
            case .toolbar:
                if let targetModifierType = targetModifier.stringType {
                    modifierMatched = typeString.starts(with: targetModifierType)
                }
                valueMatched = true
            }
            
        }
        
        return modifierMatched && valueMatched
    }
    
    /// Takes a hierarchy produced by recursively expanding all children in the Mirror and stores it in an array - can't use a set as not all Mirror.Children will be Hashable
    private static func flattenMirror<T>(view: T) -> [Mirror.Child] {
        var uiElements = [Mirror.Child]()
        let mirror = Mirror(reflecting: view)
        
        for child in mirror.children {
            if SPCAssessmentLoggingPreferences.printTree {
                print("=========================")
                print("Mirror Item:")
                print("Label = \(String(describing: child.label))")
                print("Value = \(String(describing: child.value))")
            }
            
            if child.label != "connections" {
                uiElements.append(child)
                uiElements.append(contentsOf: SPCViewAssessor.flattenMirror(view: child.value))
            }
        }
        
        return uiElements
    }
    
}


