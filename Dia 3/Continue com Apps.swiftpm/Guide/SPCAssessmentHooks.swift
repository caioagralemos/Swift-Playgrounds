import Foundation
import SwiftUI

public extension View {
    @available(iOS 15.0, *)
    func assess() -> some View {
        let body = self.body
        return task {
            if SPCAssessmentLoggingPreferences.printBreadcrumbs {
                print("#### \(type(of: self)): content.onAppear")
            }
            let assesser = SPCViewAssessor(assessedView: self, assessedViewContent: body)
            assesser.runAssessments()
        }
    }
    
    func assess<Content: View>(view: Content) -> some View {
        let body = self.body
        return task {
            if SPCAssessmentLoggingPreferences.printBreadcrumbs {
                print("#### Assessing \(type(of: view))")
            }
            let assesser = SPCViewAssessor(assessedView: view, assessedViewContent: body)
            assesser.runAssessments()
        }
    }

    func assess<Content: View, Embedded: View>(view: Content, content: Embedded) {
        let viewType = String(describing: type(of: view))
        if SPCAssessmentLoggingPreferences.printBreadcrumbs {
            print("#### Assessing \(viewType)")
        }
        
        let assesser = SPCViewAssessor(assessedView: view, assessedViewContent: content)
        assesser.runAssessments(typeName: viewType)
    }
    
    func assessMe() {
        if SPCAssessmentLoggingPreferences.printBreadcrumbs {
            print("Assessing \(type(of: self))")
        }
        
        let assesser = SPCViewAssessor(assessedView: self, assessedViewContent: self.body)
        assesser.runAssessments()
    }
}

public extension WindowGroup {
    @available(iOS 15.0, *)
    func assess<AppContent: App>(app: AppContent, otherAssessmentCandidates: [Any] ) -> some Scene {
        if SPCAssessmentLoggingPreferences.printBreadcrumbs {
            print("#### \(type(of: self)): created")
        }
        
        let windowGroupAssessor = SPCAssessor(assessedItem: self)
        windowGroupAssessor.runAssessments(assessedItemType: "WindowGroup")
        
        let appAssessor = SPCAssessor(assessedItem: app)
        appAssessor.runAssessments(assessedItemType: "App")
        
        
        for candidate in otherAssessmentCandidates {
            let candidateType = String(describing: type(of: candidate))
            let candidateAssessor = SPCAssessor(assessedItem: candidate)
            candidateAssessor.runAssessments(assessedItemType: candidateType)
        }
        
        return self
    }
}


public struct SPCAssessableGroup<AssessedView, EmbeddedContent>: View where EmbeddedContent: View, AssessedView: View {
    let view: AssessedView
    @ViewBuilder let embedded: () -> EmbeddedContent
    
    public init(view: AssessedView, embedded: @escaping () -> EmbeddedContent) {
        self.view = view
        self.embedded = embedded
    }
    
    public var body: some View {
        Group {
            embedded()
        }.task {
            assess(view: view, content: Group {embedded()})
        }
    }
}

public struct SPCAssessableWindowGroup<AppContent, EmbeddedContent>: Scene where AppContent: App, EmbeddedContent: View {
    var app: AppContent
    var assessmentCandidates: [Any]
    @ViewBuilder let embedded: () -> EmbeddedContent
    
    public init(app: AppContent, assessmentCandidates: [Any], embedded: @escaping () -> EmbeddedContent) {
        self.app = app
        self.assessmentCandidates = assessmentCandidates
        self.embedded = embedded
    }
    
    public var body: some Scene {
        WindowGroup {
            embedded()
        }.assess(app: app, otherAssessmentCandidates: assessmentCandidates)
    }
}
