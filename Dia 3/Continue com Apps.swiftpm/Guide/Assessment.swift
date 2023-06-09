import SwiftUI
import UIKit

class SPCAssessmentResults: ObservableObject {
    static let shared = SPCAssessmentResults()
    @Published var results = [String: Bool]()
}

struct SPCAssessmentLoggingPreferences {
    static let printBreadcrumbs = false
    static let printTree = false
    static let printAssessmentResults = false
}

extension SPCAssessor {
    var tasks: [String: () -> Bool] {
        ["App": appAssessments,
         "WindowGroup": windowGroupAssessments,
         "CreatureZoo": creatureZooAssessments
        ]
    }
    
    //MARK: - "Non View Or App" Individual Assessment Tasks

    //MARK: - My App
    
    func appAssessments() -> Bool {
        var assessments: [() -> Bool] {
            [addModelData]
        }
        return runAssessments(assessments)
    }
    
    // Verify that a state object of type CreatureZoo has been created in MyApp.swift and passed into the NavigationStack using the .environmentObject modifier.
    @discardableResult
    func addModelData() -> Bool {
        let appTestResult = SPCContainsProperty(typeString:"StateObject<CreatureZoo>")
        let windowGroupTestResult = SPCAssessmentResults.shared.results["addModelData_WindowGroup"] ?? false
        let result = appTestResult && windowGroupTestResult
        recordResult(result)
        return result
    }
    
    func addModelData_WindowGroup() -> Bool {
        let usesCreatureZooAsEnvironmentVariable = SPCContainsType("_EnvironmentKeyWritingModifier<Swift.Optional<App.CreatureZoo>")
        recordResult(usesCreatureZooAsEnvironmentVariable)
        return usesCreatureZooAsEnvironmentVariable
    }
    
    func windowGroupAssessments() -> Bool {
        var assessments: [() -> Bool] {
            [addNavView,
             addNavTitle,
             addModelData_WindowGroup]
        }
        return runAssessments(assessments)
    }
    
    // Verify that in MyApp.swift, the ContentView is now wrapped in a NavigationStack.
    func addNavView() -> Bool {
        let result = SPCContainsType("NavigationStack")
        recordResult(result)
        return result
    }
    
    // Verify that ContentView now has a navigation title.
    func addNavTitle() -> Bool {
        let result = SPCContainsType("NavigationTitle")
        recordResult(result)
        return result
    }
    
    //MARK: - App Data
    func creatureZooAssessments() -> Bool {
        var assessments: [() -> Bool] {
            [addCreatures]
        }
        return runAssessments(assessments)
    }
    
    // Verify that CreatureZoo.creatures contains 5 or more elements
    func addCreatures() -> Bool {
        let result: Bool
        if let creaturesProperty = SPCGetProperty(name: "creatures"),
           let creaturesStorage = Mirror(reflecting: creaturesProperty).descendant("storage"),
           let creaturesArray = Mirror(reflecting: creaturesStorage).children.first?.value as? [Any] {
            result = creaturesArray.count >= 5
        } else {
            result = false
        }

        recordResult(result)
        return result
    }
}

extension SPCViewAssessor {
    
    var taskFunctionByView: [String : () -> Bool] {
        ["Bindings": bindingsAssessments,
         "SlidingRectangle": buildASliderAssessment,
         "ConditionalCircle": conditionalCircleAssessments,
         "ConditionalViews": conditionalViewAssessments,
         "NavigationExperiment": navigationExperimentAssessments,
         "ContentView": contentViewAssessments,
         "DancingCreatures": dancingCreaturesAssessments,
         "CreatureEditor": creatureEditorAssessments,
         "StoryEditor": storyEditorAssessments,
         "CreatureDetail": creatureDetailAssessments
        ]
    }
    
    
    //MARK: - View Individual Assessment Tasks
    
    //MARK: - Bindings
    func bindingsAssessments() -> Bool {
        var assessments: [() -> Bool] {
            [addAStateVar,
             addAColorPicker,
             addAColorModifier,
             addATextView]
        }
        return runAssessments(assessments)
    }
    
    // Verify that a state variable of type Color has been defined in Bindings.swift
    func addAStateVar() -> Bool {
        let result = SPCContainsProperty(type: State<Color>.self)
        recordResult(result)
        return result
    }
    
    // Verify that a ColorPicker has been added, and that the color state variable is used as the binding value for `selection`.
    func addAColorPicker() -> Bool {
        let result = SPCViewContainsUIElement(elementType: .ColorPicker)
        recordResult(result)
        return result
    }
    
    // Verify that the color of the Image view is now using the color state variable for its `.foregroundColor` modifier.
    func addAColorModifier() -> Bool {
        let result = SPCViewContainsModifier(.colorModifier(color: nil), valueComparisonStrategy: .doNotCompare)
        recordResult(result)
        return result
    }
    
    // Verify that a Text view has been added, that also sets its foreground color using the color state variable.
    func addATextView() -> Bool {
        let result = SPCViewContainsUIElement(elementType: .Text)
        recordResult(result)
        return result
    }
    
    //MARK: - Build A Slider
    
    func buildASliderAssessment() -> Bool {
        var assessments: [() -> Bool] {
            [buildASlider]
        }
        return runAssessments(assessments)
    }
    
    
    // Verify that SlidingRectangle contains a SliderView, a state variable tracking a Double value, and a Rectangle view whose width is controlled by the Double state value.
    func buildASlider() -> Bool {
        let sliderPresent = SPCViewContainsUIElement(elementType: .Slider)
        let floatStateVariablePresent = SPCContainsProperty(type: State<Double>.self)
        let rectanglePresent = SPCViewContainsUIElement(elementType: .Rectangle)
        
        let result = sliderPresent && floatStateVariablePresent && rectanglePresent
        recordResult(result)
        return result
    }
    
    //MARK: - Story Editor
    
    func storyEditorAssessments() -> Bool {
        var assessments: [() -> Bool] {
            [storyEditor]
        }
        return runAssessments(assessments)
    }
    
    // Experiment: Verify that StoryEditor contains at least 2 state values, 2 TextFields using those values as binding values, and a TextField that also uses those state values as part of its text.
    func storyEditor() -> Bool {
        let sufficientStateVariables = SPCCountProperties(type: .state) >= 2
        let sufficientTextFields = SPCCountUIElement(elementType: .TextField) >= 3
        
        let result = sufficientStateVariables && sufficientTextFields
        recordResult(result)
        return result
    }
    
    //MARK: - Conditional View
    
    func conditionalViewAssessments() -> Bool {
        var assessments: [() -> Bool] {
            [addElse,
             customizeConditionalViews,
             addNewConditionalView]
        }
        return runAssessments(assessments)
    }
    
    // Verify that an `else` statement has been added that shows a `Circle` of a different color.
    func addElse() -> Bool {
        let conditionalComposition = SPCConditionalContentCompositions()
        let result = conditionalComposition.contains{ $0.bothSidesPopulated }
        recordResult(result)
        return result
    }
    
    // Verify that both the conditional views have been customized by adding another view (two views in stack).
    func customizeConditionalViews() -> Bool {
        let conditionalComposition = SPCConditionalContentCompositions()
        let result = conditionalComposition.contains(.bothMultiple)
        recordResult(result)
        return result
    }
    
    // Experiment Task: Check that a new state variable has been defined, and that an additional conditional view has been created, showing or hiding as a result of the state value changing.
    func addNewConditionalView() -> Bool {
        let expectedNumberOfStateProperties = SPCCountProperties(type: .state) >= 2
        let containsConditional = SPCConditionalContentCount() >= 2
        
        let result = expectedNumberOfStateProperties && containsConditional
        recordResult(result)
        return result
    }
    
    //MARK: - Conditional Circle
    
    func conditionalCircleAssessments() -> Bool {
        var assessments: [() -> Bool] {
            [addShadowModifier,
             addScaleModifier,
             addAnimationModifier]
        }
        return runAssessments(assessments)
    }
    
    // Verify that the `.shadow` modifier has been added to the Circle view, and that the value is conditionally changed based upon the value of `isOn`.
    func addShadowModifier() -> Bool {
        let result = SPCViewContainsModifier(.shadowEffect(color: nil), valueComparisonStrategy: .doNotCompare)
        recordResult(result)
        return result
    }
    
    // Verify that the `.shadow` modifier has been added to the Circle view, and that the value is conditionally changed based upon the value of `isOn`.
    func addScaleModifier() -> Bool {
        let result = SPCViewContainsModifier(.scaleEffect(scale: nil), valueComparisonStrategy: .doNotCompare)
        recordResult(result)
        return result
    }
    
    // Verify that the `.animation` modifier has been added to the Circle view, and that changes to `isOn` are now animated by the view.
    func addAnimationModifier() -> Bool {
        let result = SPCViewContainsModifier(.animationModifier, valueComparisonStrategy: .doNotCompare)
        recordResult(result)
        return result
    }
    
    //MARK: - NavigationExperiment
    
    func navigationExperimentAssessments() -> Bool {
        var assessments: [() -> Bool] {
            [navigationExperiment,
             addNavLink,
            ]
        }
        return runAssessments(assessments)
    }
    
    // Verify that the learner has added a NavigationStack to NavigationExperiment per code snippet in @Page addExampleNavigationStack
    func navigationExperiment() -> Bool {
        let result = SPCContainsNavigationStack()
        recordResult(result)
        return result
    }
    
    // Verify that ContentView now contains two working NavigationLinks. Their label and content can be any view.
    func addNavLink() -> Bool {
        let result = SPCCountNavigationLinks(.anyTitle) >= 2
        recordResult(result)
        return result
    }

    //MARK: - Content View
    
    func contentViewAssessments() -> Bool {
        var assessments: [() -> Bool] {
            [addNavLinkCreatureDance,
             usingCreatureZoo,
             replaceHStackWithCreatureRow,
             createAList,
             useEnvironmentObject,
             deleteACreature,
             addToolBarContentView,
             addNavigationLinkCreatureDetail,
             addNavigationTitleCreatureEditor
            ]
        }
        return runAssessments(assessments)
    }
    
    // Verify that ContentView contains a NavigationLink with a destination of DancingCreatures
    func addNavLinkCreatureDance() -> Bool {
        let result = SPCLinkToTargetTypeExists("DancingCreatures")
        recordResult(result)
        return result
    }
    
    // Verify that a new state object of type CreatureZoo has been created in CreatureList.
    func usingCreatureZoo() -> Bool {
        let result = SPCContainsProperty(typeString:"StateObject<CreatureZoo>")
        recordResult(result)
        return result
    }
    
    // Experiment: Verify that the learner has replaced the contents of the ForEach with the CreatureRow view.
    func replaceHStackWithCreatureRow() -> Bool {
        let hStackRemoved = SPCViewContainsUIElement(elementType: .HStack) == false
        let forEachAdded = SPCContainsChildMatching(pattern: "ForEach<Array<Creature>, UUID, CreatureRow>")
        
        let result = hStackRemoved && forEachAdded
        recordResult(result)
        return result
    }
    
    // Verify that a List view has been created that iterates over the CreatureZoo.creatures array using a ForEach create a view for each creature in the array.
    func createAList() -> Bool {
        let containsList = SPCViewContainsList()
        let containsForEachCreature = SPCViewContainsForEach(collectionType: "Array<Creature>")
        
        let result = containsList && containsForEachCreature
        recordResult(result)
        return result
    }
    
    // Verify that the state object in CreatureList has been removed, and replaced with an environment object of type CreatureZoo.
    func useEnvironmentObject() -> Bool {
        let stateObjectRemoved = SPCContainsProperty(typeString:"StateObject<CreatureZoo>") == false
        let environmentObjectAdded = SPCContainsProperty(typeString:"EnvironmentObject<CreatureZoo>")
        
        let result = stateObjectRemoved && environmentObjectAdded
        recordResult(result)
        return result
    }
    
    // Verify that the ForEach loop in CreatureList now contains a modifier, .onDelete, and calls data.creatures.remove(atOffsets:).
    func deleteACreature() -> Bool {
        let result = SPCViewContainsModifier(.deleteModifier, valueComparisonStrategy: .doNotCompare)
        recordResult(result)
        return result
    }
    
    // Verify that a toolbar has been added to ContentView, with a toolbar item that contains a NavigationLink to CreatureEditor.
    func addToolBarContentView() -> Bool {
        let toolbarPresent = SPCViewContainsModifier(.toolbar, valueComparisonStrategy: .doNotCompare)
        let creatureLinkPresent = SPCContainsChildMatching(pattern: "NavigationLink<Text, CreatureEditor>")
        
        let result = toolbarPresent && creatureLinkPresent
        recordResult(result)
        return result
    }
    
    // Verify that a new link has been added via the ForEach to CreatureDetail view, using a label of CreatureRow.
    func addNavigationLinkCreatureDetail() -> Bool {
        let result = SPCContainsChildMatching(pattern: "ForEach<Array<Creature>, UUID, NavigationLink<CreatureRow")
        recordResult(result)
        return result
    }
    
    // Verify that a navigation title has been added to CreatureEditor view.
    func addNavigationTitleCreatureEditor() -> Bool {
        let result = SPCContainsType("CreatureEditor, TransactionalPreferenceTransformModifier<NavigationTitleKey")
        recordResult(result)
        return result
    }
    
    //MARK: - Dancing Creatures
    func dancingCreaturesAssessments() -> Bool {
        var assessments: [() -> Bool] {
            [dancingCreaturesData,
             dancingCreaturesView,
             animateCreatures
            ]
        }
        return runAssessments(assessments)
    }
    
    // Verify that an environment object of type CreatureZoo has been declared in DancingCreatures
    func dancingCreaturesData() -> Bool {
        let result = SPCContainsProperty(typeString:"EnvironmentObject<CreatureZoo>")
        recordResult(result)
        return result
    }
    
    // Verify that a view has been created that iterates over each creature in CreatureZoo.creatures with a ForEach loop, creating a view for each. Verify that a tap gesture has an action that calles data.randomizeOffsets()
    func dancingCreaturesView() -> Bool {
        let containsForEachCreature = SPCViewContainsForEach(collectionType: "Array<Creature>")
        let tapModifier = SPCViewContainsModifier(.gestureModifier(gestureType: .tap), valueComparisonStrategy: .doNotCompare)
        let result = containsForEachCreature && tapModifier
        recordResult(result)
        return result
    }
    
    // Verify that an animation modifier has been added to the Text view that contains the creature emoji, animating the creature.offset value.
    func animateCreatures() -> Bool {
        let animationModifier = SPCViewContainsModifier(.animationModifier, valueComparisonStrategy: .doNotCompare)
        let result = animationModifier
        recordResult(result)
        return result
    }
    
    //MARK: - Creature Editor
    func creatureEditorAssessments() -> Bool {
        var assessments: [() -> Bool] {
            [defineVariablesCreatureEditor,
             defineYourView,
             addACreatureEditorTextField,
             addButtonToToolbar,
             addCreatureToCreatureZoo
            ]
        }
        return runAssessments(assessments)
    }
    
    // Verify that a state variable of type Creature and an environment object of type CreatureZoo have been added to CreatureEditor.
    func defineVariablesCreatureEditor() -> Bool {
        let stateVarAdded = SPCContainsProperty(typeString:"State<Creature>")
        let environmentVarAdded = SPCContainsProperty(typeString:"EnvironmentObject<CreatureZoo>")
        
        let result = stateVarAdded && environmentVarAdded
        recordResult(result)
        return result
    }
    
    // Verify that a Form has been added to the view, with 3 Section subviews.
    func defineYourView() -> Bool {
        let result = SPCViewContainsUIElement(elementType: .Form)
        recordResult(result)
        return result
    }
    
    // Verify that two TextFields have been added. One in the first Section, that uses $creature.name as a binding value, the second in the second Section, using $creature.emoji as a binding value.
    func addACreatureEditorTextField() -> Bool {
        let result = SPCCountUIElement(elementType: .TextField) >= 2
        recordResult(result)
        return result
    }

    // Verify that a ToolBarItem has been added to CreatureEditor's `.toolbar` content.
    func addButtonToToolbar() -> Bool {
        let result = SPCViewContainsUIElement(elementType: .ToolbarItem)
        recordResult(result)
        return result
    }
    
    // Verify that a ToolBarItem label contains a Button with an action that calls data.creatures.append(newCreature).
    func addCreatureToCreatureZoo() -> Bool {
        let toolbarItem = SPCViewContainsUIElement(elementType: .ToolbarItem)
        let button = SPCViewContainsUIElement(elementType: .TextButton)
        let result = toolbarItem && button
        recordResult(result)
        return result
    }
    
    
    //MARK: - Creature Detail
    
    func creatureDetailAssessments() -> Bool {
        var assessments: [() -> Bool] {
            [addColorPicker,
             addSliderShadowRadius,
             addScaleButton,
             animateChangesIsScaled
            ]
        }
        return runAssessments(assessments)
    }
    
    // Verify that a color picker has been added to CreatureDetail, using the state variable color as a binding.
    func addColorPicker() -> Bool {
        let result = SPCViewContainsUIElement(elementType: .ColorPicker)
        recordResult(result)
        return result
    }
    
    // Verify that a Slider has been added to CreatureDetail, using the state variable shadowRadius as a binding.
    func addSliderShadowRadius() -> Bool {
        let result = SPCViewContainsUIElement(elementType: .Slider)
        recordResult(result)
        return result
    }
    
    // Verify that a state value tracking a boolean was added to the view, and that a button was added to toggle that state variable on and off. Verify that a scaleEffect modifier was added to the text view that conditionally scales up and down the view based upon the boolean value state.
    func addScaleButton() -> Bool {
        let stateVarAdded = SPCContainsProperty(typeString: "State<Bool>")
        let scaleModifierAdded = SPCViewContainsModifier(.scaleEffect(scale: nil), valueComparisonStrategy: .doNotCompare)
        let buttonAdded = SPCViewContainsUIElement(elementType: .TextButton)
        
        let result = stateVarAdded && scaleModifierAdded && buttonAdded
        recordResult(result)
        return result
    }
    
    // Verify that changes to the boolean value are animated using the .animation modifier.
    func animateChangesIsScaled() -> Bool {
        let result = SPCViewContainsModifier(.animationModifier, valueComparisonStrategy: .doNotCompare)
        recordResult(result)
        return result
    }
    
    //MARK: - Unused?
    // Verify that a new NavigationLink has been added to ContentView with a destination of DancingCreatures
    func addLinkToDancingCreatures() -> Bool {
        let result = SPCLinkToTargetTypeExists("DancingCreatures")
        recordResult(result)
        return result
    }
    
    // Verify that a NavigationLink has been added to ContentView with a destination of CreatureEditor.
    func addNavLinkCreatureEditor() -> Bool {
        let result = SPCLinkToTargetTypeExists("CreatureEditor")
        recordResult(result)
        return result
    }
    
}

struct UIElement: Identifiable {
    static var elements: [UIElement] {
        get {
            var elements = [UIElement]()
            
            for windowScene in UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }) {
                for window in windowScene.windows {
                    if let rootView = window.rootViewController?.view {
                        elements.append(contentsOf: elementData(rootView))
                        
                        break
                    }
                }
            }
            
            return elements
        }
    }
    
    static func elementData(_ container: NSObject, removeRoot: Bool = false) -> [UIElement] {
        var data = [UIElement]()
        
        let elemData = UIElement(element: container)
        
        if !removeRoot {
            data.append(elemData)
        }
        
        if let elements = container.accessibilityElements {
            for element in elements.compactMap( { $0 as? NSObject } ) {
                data.append(contentsOf: elementData(element))
            }
        }
        
        return data
    }
    
    let id = UUID()
    var identifier: String?
    var label: String?
    var hint: String?
    var value: String?
    var frame = CGRect.zero
    var traits = UIAccessibilityTraits.none
    var containerType = UIAccessibilityContainerType.none
    var elements = [UIElement]()
    
    init(element: NSObject) {
        if let identifier = element.perform(#selector(getter: UIAccessibilityIdentification.accessibilityIdentifier))?.takeUnretainedValue() as? String {
            self.identifier = identifier
        }
        
        if let label = element.perform(#selector(NSObject.accessibilityLabel))?.takeUnretainedValue() as? String {
            self.label = label
        }
        
        if let hint = element.perform(#selector(NSObject.accessibilityHint))?.takeUnretainedValue() as? String {
            self.hint = hint
        }
        
        if let value = element.perform(#selector(NSObject.accessibilityValue))?.takeUnretainedValue() as? String {
            self.value = value
        }
        
        if let frame = element.value(forKey: "accessibilityFrame") as? CGRect {
            self.frame = frame
        }
        
        if let traits = element.value(forKey: "accessibilityTraits") as? UIAccessibilityTraits {
            self.traits = traits
        }
        
        if let containedElements = element.value(forKey: "accessibilityElements") as? [Any] {
            for containedElement in containedElements {
                if let containedNSObject = containedElement as? NSObject {
                    self.elements.append(UIElement(element: containedNSObject))
                }
            }
        }
    }
    
    static func debugPrint() {
        print("\n####\n\(elements[0].debugDescription())\n####")
    }
    
    static var debugTabDepth = 0
    
    func debugDescription() -> String {
        var description = ""
        var tabString = ""
        
        for _ in 0..<UIElement.debugTabDepth {
            tabString += "\t"
        }
        
        description += "\(tabString)[ "
        
        if let id = identifier {
            description += "id:\(id) "
        }
        
        if let label = label {
            description += "label:'\(label)' "
        }
        
        description += "frame:(\(Int(frame.origin.x)),\(Int(frame.origin.x)))(\(Int(frame.size.width)),\(Int(frame.size.height))) "
        
        if let hint = hint {
            description += "hint:\(hint) "
        }
        
        if let value = value {
            description += "value:\(value) "
        }
        
        var traitString = ""
        
        if !traits.isEmpty {
            if traits.contains(.button)                    { traitString += ".button " }
            if traits.contains(.header)                    { traitString += ".header " }
            if traits.contains(.selected)                  { traitString += ".selected " }
            if traits.contains(.link)                      { traitString += ".link " }
            if traits.contains(.searchField)               { traitString += ".searchField " }
            if traits.contains(.image)                     { traitString += ".image " }
            if traits.contains(.playsSound)                { traitString += ".playsSound " }
            if traits.contains(.keyboardKey)               { traitString += ".keyboardKey " }
            if traits.contains(.staticText)                { traitString += ".staticText " }
            if traits.contains(.summaryElement)            { traitString += ".summaryElement " }
            if traits.contains(.updatesFrequently)         { traitString += ".updatesFrequently " }
            if traits.contains(.startsMediaSession)        { traitString += ".startsMediaSession " }
            if traits.contains(.allowsDirectInteraction)   { traitString += ".allowsDirectInteraction " }
            if traits.contains(.causesPageTurn)            { traitString += ".causesPageTurn " }
            if traits.contains(.tabBar)                    { traitString += ".tabBar " }
            
            if traitString.count > 0 {
                description += "traits:(\(traitString)) "
            }
        }
        
        if !elements.isEmpty {
            description += "{\n"
            
            UIElement.debugTabDepth += 1
            
            for element in elements {
                description += element.debugDescription()
            }
            
            UIElement.debugTabDepth -= 1
            
            description += "\(tabString)}"
        }
        
        description += "]\n"
        
        return description
    }
}
