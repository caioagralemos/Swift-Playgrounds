//
//  CodeSyntaxQueryBuilder.swift
//  Nautilus
//
//  Created by John Cromie on 23/09/2022.
//

import Foundation

struct CodeSyntax {
    enum QueryNodeType: Codable {
        case forInStmt
        case binaryOperatorExpr
        case functionCallExpr
        case functionDecl
        case identifierExpr
        case ifStmt
        case literalExpr
        case memberAccessExpr
        case sequenceExpr
        case structDecl
        case variableDecl
        case syntaxQueryOf
        case oneOf
        case anyOf
        case allOf
        case noneOf
        case countOf
    }
    
    enum ExpressionType: Codable {
        case booleanLiteral
        case integerLiteral
        case floatLiteral
        case stringLiteral
        case array
        case sequence
        case unknown
    }
    
    enum LiteralType: Codable {
        case boolean
        case integer
        case float
        case string
        
        var expressionType: ExpressionType {
            switch self {
            case .boolean: return .booleanLiteral
            case .integer: return .integerLiteral
            case .float: return .floatLiteral
            case .string: return .stringLiteral
            }
        }
    }
    
    enum SimpleType: Codable, CustomStringConvertible {
        case bool
        case float
        case double
        case int
        case string
        case custom(String)
        
        var description: String {
            switch self {
            case .bool: return "Bool"
            case .double: return "Double"
            case .float: return "Float"
            case .int: return "Int"
            case .string: return "String"
            case .custom(let name): return name
            }
        }
    }
    
    enum AllOfOption: Codable {
        case anyOrder
        case inOrder
        case exactly
    }
    
    indirect enum ComplexType: Codable {
        case simple(SimpleType)
        case array(SimpleType)
        case dictionary(key: SimpleType, value: ComplexType)
        case optional(SimpleType)
        case unknown
    }
}

// MARK: Protocols for query capabilities

/// A syntax query conforming to `QueryableByName` can be matched with a syntax node on its name.
protocol QueryableByName {
    var namePattern: String? { get set }
}

/// A syntax query conforming to `QueryableByTextContent` can be matched with a syntax node on its textual content.
protocol QueryableByTextContent {
    var textContentPattern: String? { get }
}

/// A syntax query conforming to `QueryableHasChildQueries` can be matched on its child queries.
protocol QueryableHasChildren {
    var wrappedChildren: [CodeSyntaxQueryNodeWrapper]  { get }
}

/// A syntax query conforming to `FilterableByDepth` can filter resulting syntax nodes based on their depth in the source tree.
protocol FilterableByDepth {
    var maxDepth: Int? { get set }
}

/// A syntax query conforming to `ChainableExpressionQuery` can be chained to a `Member` or `FunctionCall` query, creating a chain of queries for matching with a chain of expressions.
protocol ChainableExpressionQuery { }

/// A syntax query conforming to `CodeSyntaxQueryModifier` supports a set of modifiers depending on the capabilities of the query.
protocol CodeSyntaxQueryModifier {
    associatedtype T: CodeSyntaxQueryNode
}

// MARK: Protocols for queries matching different types of syntax

/// The base protocol for a syntax query.
protocol CodeSyntaxQueryNode: Codable, CustomStringConvertible {
    var nodeType: CodeSyntax.QueryNodeType { get }
    var id: String?  { get }
}

/// A syntax query for matching a syntax declaration.
protocol CodeSyntaxDeclarationQuery: CodeSyntaxQueryNode, QueryableByName, QueryableByTextContent, QueryableHasChildren, FilterableByDepth, Codable { }

/// A syntax query for matching a syntax expression.
protocol CodeSyntaxExpressionQuery: CodeSyntaxQueryNode, Codable { }

/// A syntax query for matching a syntax statement.
protocol CodeSyntaxStatementQuery: CodeSyntaxQueryNode, FilterableByDepth, Codable { }

/// A syntax query for quantifying contained query matches.
protocol CodeSyntaxQuantifierQuery: CodeSyntaxQueryNode, QueryableHasChildren, Codable { }


// MARK: Default implementations

/// Implementation of depth searching for syntax queries that conform to `FilterableByDepth`.
extension CodeSyntaxQueryModifier {

    func searchToDepth(_ depth: Int) -> T where T: FilterableByDepth, Self == T  {
        var newQueryNode: Self = self
        newQueryNode.maxDepth = depth
        return newQueryNode
    }

    func searchAnyDepth()  -> T where T: FilterableByDepth, Self == T  {
        var newQueryNode = self
        newQueryNode.maxDepth = nil
        return newQueryNode
    }
}

/// Implementation of query chaining for syntax expression queries that conform to `ChainableExpressionQuery`.
extension CodeSyntaxQueryModifier {

    func functionCall(_ name: String? = nil, matching namePattern: String? = nil, containingText textContentPattern: String? = nil, arguments: [Argument] = [], id: String? = nil) -> FunctionCall where Self: ChainableExpressionQuery, Self: CodeSyntaxQueryNode {
        var newQueryNode = FunctionCall(name, matching: namePattern, containingText: textContentPattern, arguments: arguments, id: id)
        newQueryNode.parentExpressionQuery = CodeSyntaxQueryNodeWrapper(self)
        return newQueryNode
    }
    
    func member(_ name: String? = nil, matching namePattern: String? = nil, containingText textContentPattern: String? = nil, id: String? = nil) -> Member where Self: ChainableExpressionQuery, Self: CodeSyntaxQueryNode {
        var newQueryNode = Member(name, matching: namePattern, id: id)
        newQueryNode.parentExpressionQuery = CodeSyntaxQueryNodeWrapper(self)
        return newQueryNode
    }
}

extension CodeSyntaxQueryNode {
    
    var description: String {
        var desc = String(describing: Self.self)
        if let id {
            desc += " '\(id)'"
        }
        return desc
    }
}

extension QueryableByName {
    
    var nameRegex: (any RegexComponent)? {
        guard let namePattern = self.namePattern, let regex = try? Regex(namePattern) else { return nil }
        return regex
    }
    
    mutating func setNamePattern(_ name: String?, _ namePattern: String?) {
        if let name {
            self.namePattern = "^\(name)$"
        } else {
            self.namePattern = namePattern
        }
    }
}

extension QueryableByTextContent {
    
    var textContentRegex: (any RegexComponent)? {
        guard let textContentPattern = self.textContentPattern, let regex = try? Regex(textContentPattern) else { return nil }
        return regex
    }
}

extension QueryableHasChildren {
    
    var children: [CodeSyntaxQueryNode] {
        wrappedChildren.map { $0.queryNode }
    }
}

// MARK: ResultBuilders

@resultBuilder
struct CodeSyntaxQueryBuilder {
    static func buildBlock() -> [CodeSyntaxQueryNode] { [] }
    
    static func buildBlock(_ nodes: CodeSyntaxQueryNode...) -> [CodeSyntaxQueryNode] {
        nodes
    }
}

@resultBuilder
struct CodeSyntaxExpressionQueryBuilder {
    static func buildBlock() -> [CodeSyntaxExpressionQuery] { [] }
    
    static func buildBlock(_ nodes: CodeSyntaxExpressionQuery...) -> [CodeSyntaxExpressionQuery] {
        nodes
    }
}

// MARK: CodeSyntaxQueryNodeWrapper

extension CodeSyntax.QueryNodeType {
    /// Maps node type to corresponding syntax query type.
    var metatype: CodeSyntaxQueryNode.Type {
        switch self {
        case .forInStmt: return ForIn.self
        case .binaryOperatorExpr: return BinaryOperator.self
        case .functionCallExpr: return FunctionCall.self
        case .functionDecl: return Function.self
        case .identifierExpr: return Identifier.self
        case .ifStmt: return If.self
        case .literalExpr: return Literal.self
        case .memberAccessExpr: return Member.self
        case .sequenceExpr: return SequenceExpr.self
        case .structDecl: return Structure.self
        case .variableDecl: return Variable.self
        case .syntaxQueryOf: return CodeSyntaxQuery.self
        case .oneOf: return OneOf.self
        case .anyOf: return AnyOf.self
        case .allOf: return AllOf.self
        case .noneOf: return NoneOf.self
        case .countOf: return CountOf.self
        }
    }
}

/// A type-erased Codable wrapper for query nodes.
/// Used for the `children` of a query node to allow Codable synthesis.
struct CodeSyntaxQueryNodeWrapper: Codable {
    var queryNode: CodeSyntaxQueryNode

    init(_ queryNode: CodeSyntaxQueryNode) {
        self.queryNode = queryNode
    }

    private enum CodingKeys : CodingKey {
        case nodeType
        case queryNode
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(queryNode.nodeType, forKey: .nodeType)
        try queryNode.encode(to: encoder)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let type = try container.decode(CodeSyntax.QueryNodeType.self, forKey: .nodeType)
        self.queryNode = try type.metatype.init(from: decoder)
    }
}

// MARK: Declarations

/// A syntax query that matches a function declaration.
struct Function: CodeSyntaxDeclarationQuery {
    var nodeType: CodeSyntax.QueryNodeType = .functionDecl
    var id: String?
    var namePattern: String?
    var textContentPattern: String?
    var maxDepth: Int? = 1
    var wrappedChildren: [CodeSyntaxQueryNodeWrapper] = []
    
    var returnType: CodeSyntax.SimpleType?

    init(_ name: String? = nil, matching namePattern: String? = nil, containingText textContentPattern: String? = nil, id: String? = nil, @CodeSyntaxQueryBuilder content: () -> [CodeSyntaxQueryNode] = { [] }) {
        setNamePattern(name, namePattern)
        self.textContentPattern = textContentPattern
        self.id = id
        self.wrappedChildren = content().map { CodeSyntaxQueryNodeWrapper($0) }
    }
}

extension Function: CodeSyntaxQueryModifier {
    typealias T = Self
    
    func withReturnType(_ simpleType: CodeSyntax.SimpleType) -> Function {
        var newQueryNode = self
        newQueryNode.returnType = simpleType
        return newQueryNode
    }
}

/// A syntax query that matches a structure declaration.
struct Structure: CodeSyntaxDeclarationQuery {
    var nodeType: CodeSyntax.QueryNodeType = .structDecl
    var id: String?
    var namePattern: String?
    var textContentPattern: String?
    var maxDepth: Int? = 1
    var wrappedChildren: [CodeSyntaxQueryNodeWrapper] = []

    init(_ name: String? = nil, matching namePattern: String? = nil, containingText textContentPattern: String? = nil, id: String? = nil, @CodeSyntaxQueryBuilder content: () -> [CodeSyntaxQueryNode] = { [] }) {
        setNamePattern(name, namePattern)
        self.textContentPattern = textContentPattern
        self.id = id
        self.wrappedChildren = content().map { CodeSyntaxQueryNodeWrapper($0) }
    }
}

extension Structure: CodeSyntaxQueryModifier {
    typealias T = Self
}

/// A syntax query that matches a variable declaration.
struct Variable: CodeSyntaxDeclarationQuery {
    var nodeType: CodeSyntax.QueryNodeType = .variableDecl
    var id: String?
    var namePattern: String?
    var textContentPattern: String?
    var expressionType: CodeSyntax.ExpressionType?
    var maxDepth: Int? = 1
    var wrappedChildren: [CodeSyntaxQueryNodeWrapper] = []
    
    var initializerQuery: CodeSyntaxQueryNodeWrapper?

    init(_ name: String? = nil, matching namePattern: String? = nil, containingText textContentPattern: String? = nil, ofType expressionType: CodeSyntax.ExpressionType? = nil, initialValue: CodeSyntaxExpressionQuery? = nil, id: String? = nil, @CodeSyntaxQueryBuilder content: () -> [CodeSyntaxQueryNode] = { [] }) {
        setNamePattern(name, namePattern)
        self.textContentPattern = textContentPattern
        self.expressionType = expressionType
        self.wrappedChildren = content().map { CodeSyntaxQueryNodeWrapper($0) }
        
        if let initialValue {
            self.initializerQuery = CodeSyntaxQueryNodeWrapper(initialValue)
        }
        self.id = id
    }
}

// MARK: Expressions

/// A syntax query that matches an identifier expression.
struct Identifier: CodeSyntaxExpressionQuery, QueryableByName, FilterableByDepth, ChainableExpressionQuery {
    var nodeType: CodeSyntax.QueryNodeType = .identifierExpr
    var id: String?
    var namePattern: String?

    var maxDepth: Int? = 1
     
    init(_ name: String? = nil, matching namePattern: String? = nil, id: String? = nil) {
        setNamePattern(name, namePattern)
        self.id = id
    }
}

extension Identifier: CodeSyntaxQueryModifier {
    typealias T = Self
}

/// A syntax query that matches a literal expression.
struct Literal: CodeSyntaxExpressionQuery {
    var nodeType: CodeSyntax.QueryNodeType = .literalExpr
    var id: String?
    
    var expressionType: CodeSyntax.ExpressionType?
        
    var parentExpressionQuery: CodeSyntaxQueryNodeWrapper?
    
    var valueBoolean: Bool?
    var valueInteger: Int?
    var valueIntegerRange: Range<Int>?
    var valueIntegerClosedRange: ClosedRange<Int>?
    var valueFloat: Double?
    var valueFloatRange: Range<Double>?
    var valueFloatClosedRange: ClosedRange<Double>?
    var valueStringPattern: String?
    
    var valueStringRegex: (any RegexComponent)? {
        guard let valueStringPattern = self.valueStringPattern, let regex = try? Regex(valueStringPattern) else { return nil }
        return regex
    }
    
    init(_ value: Bool, id: String? = nil) {
        self.valueBoolean = value
        self.expressionType = .booleanLiteral
        self.id = id
    }
    
    init(_ value: Int, id: String? = nil) {
        self.valueInteger = value
        self.expressionType = .integerLiteral
        self.id = id
    }
    
    init(inRange range: Range<Int>, id: String? = nil) {
        self.valueIntegerRange = range
        self.expressionType = .integerLiteral
        self.id = id
    }
    
    init(inRange range: ClosedRange<Int>, id: String? = nil) {
        self.valueIntegerClosedRange = range
        self.expressionType = .integerLiteral
        self.id = id
    }
    
    init(_ value: Double, id: String? = nil) {
        self.valueFloat = value
        self.expressionType = .floatLiteral
        self.id = id
    }
    
    init(inRange range: Range<Double>, id: String? = nil) {
        self.valueFloatRange = range
        self.expressionType = .floatLiteral
        self.id = id
    }
    
    init(inRange range: ClosedRange<Double>, id: String? = nil) {
        self.valueFloatClosedRange = range
        self.expressionType = .floatLiteral
        self.id = id
    }
    
    init(_ value: String, id: String? = nil) {
        self.valueStringPattern = "^\(value)$"
        self.expressionType = .stringLiteral
        self.id = id
    }
    
    init(_ literalType: CodeSyntax.LiteralType, matching valuePattern: String? = nil, id: String? = nil) {
        self.valueStringPattern = valuePattern
        self.expressionType = literalType.expressionType
        self.id = id
    }
}

/// A syntax query that matches a binary operator expression.
struct BinaryOperator: CodeSyntaxExpressionQuery {
    var nodeType: CodeSyntax.QueryNodeType = .binaryOperatorExpr
    var id: String?
     
    var token: String
    
    init(_ token: String, id: String? = nil) {
        self.token = token
        self.id = id
    }
}

/// A syntax query that matches a sequence expression.
struct SequenceExpr: CodeSyntaxExpressionQuery {
    var nodeType: CodeSyntax.QueryNodeType = .sequenceExpr
    var id: String?
        
    var wrappedExpressions: [CodeSyntaxQueryNodeWrapper] = []
        
    var expressionQueries: [CodeSyntaxExpressionQuery] {
        wrappedExpressions.compactMap { $0.queryNode as? CodeSyntaxExpressionQuery }
    }
    
    init(id: String? = nil, @CodeSyntaxExpressionQueryBuilder _ expressions: () -> [CodeSyntaxExpressionQuery]) {
        self.id = id
        self.wrappedExpressions = expressions().map { CodeSyntaxQueryNodeWrapper($0) }
    }
}

/// A syntax query that matches a Range sequence expression.
struct RangeExpr: CodeSyntaxExpressionQuery {
    var nodeType: CodeSyntax.QueryNodeType = .sequenceExpr
    var id: String?
        
    var wrappedExpressions: [CodeSyntaxQueryNodeWrapper] = []
        
    var expressionQueries: [CodeSyntaxExpressionQuery] {
        wrappedExpressions.compactMap { $0.queryNode as? CodeSyntaxExpressionQuery }
    }
    
    init(_ range: Range<Int>, id: String? = nil) {
        self.wrappedExpressions = SequenceExpr( {
            Literal(range.lowerBound)
            BinaryOperator("..<")
            Literal(range.upperBound) }).wrappedExpressions
        self.id = id
    }
    
    init(_ range: ClosedRange<Int>, id: String? = nil) {
        self.wrappedExpressions = SequenceExpr( {
            Literal(range.lowerBound)
            BinaryOperator("...")
            Literal(range.upperBound) }).wrappedExpressions
        self.id = id
    }
    
    init(_ lowerBound: CodeSyntaxExpressionQuery, _ op: String, _ upperBound: CodeSyntaxExpressionQuery, id: String? = nil) {
        self.wrappedExpressions = SequenceExpr( {
                lowerBound
                BinaryOperator(op)
                upperBound }).wrappedExpressions
        self.id = id
    }
    
    init(id: String? = nil, @CodeSyntaxExpressionQueryBuilder _ expressions: () -> [CodeSyntaxExpressionQuery]) {
        self.id = id
        self.wrappedExpressions = expressions().map { CodeSyntaxQueryNodeWrapper($0) }
    }
}

/// A syntax query that matches a member access expression.
struct Member: CodeSyntaxExpressionQuery, QueryableByName, FilterableByDepth, ChainableExpressionQuery {
    var nodeType: CodeSyntax.QueryNodeType = .memberAccessExpr
    var id: String?
    
    var namePattern: String?

    var maxDepth: Int? = 1
        
    var parentExpressionQuery: CodeSyntaxQueryNodeWrapper?
    
    init(_ name: String? = nil, matching namePattern: String? = nil, id: String? = nil) {
        setNamePattern(name, namePattern)
        self.id = id
    }
}

extension Member: CodeSyntaxQueryModifier {
    typealias T = Self
}

/// An argument used in a function call expression.
struct Argument: Codable {
    var name: String?
    var wrappedExpression: CodeSyntaxQueryNodeWrapper
    
    var expressionQuery: CodeSyntaxExpressionQuery? {
        wrappedExpression.queryNode as? CodeSyntaxExpressionQuery
    }

    init(_ name: String, _ expression: CodeSyntaxExpressionQuery) {
        self.name = name
        self.wrappedExpression = CodeSyntaxQueryNodeWrapper(expression)
    }

    init(_ expression: CodeSyntaxExpressionQuery) {
        self.wrappedExpression = CodeSyntaxQueryNodeWrapper(expression)
    }
}

/// A syntax query that matches a function call expression.
struct FunctionCall: CodeSyntaxExpressionQuery, ChainableExpressionQuery, QueryableByName, QueryableByTextContent, QueryableHasChildren, FilterableByDepth {
    var nodeType: CodeSyntax.QueryNodeType = .functionCallExpr
    var id: String?
    
    var namePattern: String?
    var textContentPattern: String?
    var maxDepth: Int? = 1
    var wrappedChildren: [CodeSyntaxQueryNodeWrapper] = []
        
    var parentExpressionQuery: CodeSyntaxQueryNodeWrapper?
    
    var arguments: [Argument] = []
    
    init(_ name: String? = nil, matching namePattern: String? = nil, containingText textContentPattern: String? = nil, arguments: [Argument] = [], id: String? = nil, @CodeSyntaxQueryBuilder content: () -> [CodeSyntaxQueryNode] = { [] }) {
        setNamePattern(name, namePattern)
        self.textContentPattern = textContentPattern
        self.arguments = arguments
        self.id = id
        self.wrappedChildren = content().map { CodeSyntaxQueryNodeWrapper($0) }
    }
}

extension FunctionCall: CodeSyntaxQueryModifier {
    typealias T = Self
    
    func modifier(_ name: String? = nil, matching namePattern: String? = nil, containingText textContentPattern: String? = nil, arguments: [Argument] = [], id: String? = nil) -> FunctionCall {
        var newQueryNode = FunctionCall(name, matching: namePattern, containingText: textContentPattern, arguments: arguments, id: id)
        newQueryNode.parentExpressionQuery = CodeSyntaxQueryNodeWrapper(self)
        return newQueryNode
    }
}

// MARK: Statements

/// A syntax query that matches an `If` conditional statement.
struct If: CodeSyntaxStatementQuery {
    var nodeType: CodeSyntax.QueryNodeType = .ifStmt
    var id: String?

    var maxDepth: Int? = 1
    
    var wrappedConditions: [CodeSyntaxQueryNodeWrapper] = []
    var wrappedBodyChildren: [CodeSyntaxQueryNodeWrapper] = []
    var wrappedElseBodyChildren: [CodeSyntaxQueryNodeWrapper] = []
        
    var conditionExpressionQueries: [CodeSyntaxExpressionQuery] {
        wrappedConditions.compactMap { $0.queryNode as? CodeSyntaxExpressionQuery }
    }

    var bodyChildren: [CodeSyntaxQueryNode] {
        wrappedBodyChildren.map { $0.queryNode }
    }
    
    var elseBodyChildren: [CodeSyntaxQueryNode] {
        wrappedElseBodyChildren.map { $0.queryNode }
    }
    
    init(id: String? = nil, @CodeSyntaxExpressionQueryBuilder _ conditions: () -> [CodeSyntaxExpressionQuery], @CodeSyntaxQueryBuilder body: () -> [CodeSyntaxQueryNode], @CodeSyntaxQueryBuilder elseBody: () -> [CodeSyntaxQueryNode] = { [] }) {
        self.id = id
        self.wrappedConditions = conditions().map { CodeSyntaxQueryNodeWrapper($0) }
        self.wrappedBodyChildren = body().map { CodeSyntaxQueryNodeWrapper($0) }
        self.wrappedElseBodyChildren = elseBody().map { CodeSyntaxQueryNodeWrapper($0) }
    }
    
    init(_ condition: CodeSyntaxExpressionQuery, id: String? = nil, @CodeSyntaxQueryBuilder body: () -> [CodeSyntaxQueryNode], @CodeSyntaxQueryBuilder elseBody: () -> [CodeSyntaxQueryNode] = { [] }) {
        self.id = id
        self.wrappedConditions = [ CodeSyntaxQueryNodeWrapper(condition) ]
        self.wrappedBodyChildren = body().map { CodeSyntaxQueryNodeWrapper($0) }
        self.wrappedElseBodyChildren = elseBody().map { CodeSyntaxQueryNodeWrapper($0) }
    }
}

extension If: CodeSyntaxQueryModifier {
    typealias T = Self
}

/// A syntax query that matches a `For in` statement.
struct ForIn: CodeSyntaxStatementQuery, QueryableByTextContent, QueryableHasChildren {
    var nodeType: CodeSyntax.QueryNodeType = .forInStmt
    var id: String?
    
    var textContentPattern: String?
    var maxDepth: Int? = 1
    var wrappedChildren: [CodeSyntaxQueryNodeWrapper] = []
    
    var itemPattern: String?
    var collectionPattern: String?
    var collectionQuery: CodeSyntaxQueryNodeWrapper?
    
    var itemRegex: (any RegexComponent)? {
        guard let collectionPattern = self.itemPattern, let regex = try? Regex(collectionPattern) else { return nil }
        return regex
    }
    
    var collectionRegex: (any RegexComponent)? {
        guard let collectionPattern = self.collectionPattern, let regex = try? Regex(collectionPattern) else { return nil }
        return regex
    }
    
    init(item: String? = nil, itemMatching itemPattern: String? = nil, containingText textContentPattern: String? = nil, collection: CodeSyntaxExpressionQuery? = nil, id: String? = nil, @CodeSyntaxQueryBuilder content: () -> [CodeSyntaxQueryNode] = { [] }) {
        if let item {
            self.itemPattern = "^\(item)$"
        } else {
            self.itemPattern = itemPattern
        }
        self.textContentPattern = textContentPattern
        if let collection {
            self.collectionQuery = CodeSyntaxQueryNodeWrapper(collection)
        }
        self.id = id
        self.wrappedChildren = content().map { CodeSyntaxQueryNodeWrapper($0) }
    }
}

extension ForIn: CodeSyntaxQueryModifier {
    typealias T = Self
}

// MARK: CodeSyntaxQuery

/// A query used to find a specified pattern in code syntax.
///
/// A code syntax query comprises a tree of nested sub-queries (query nodes), each of which must match with code syntax in order for the query as a whole to match.
struct CodeSyntaxQuery: CodeSyntaxQueryNode, QueryableHasChildren {
    var nodeType: CodeSyntax.QueryNodeType = .syntaxQueryOf
    var id: String?
    var wrappedChildren: [CodeSyntaxQueryNodeWrapper] = []
    
    var hint: String?

    init(id: String? = nil, hint: String? = nil, @CodeSyntaxQueryBuilder content: () -> [CodeSyntaxQueryNode]) {
        self.id = id
        self.hint = hint
        self.wrappedChildren = content().map { CodeSyntaxQueryNodeWrapper($0) }
    }
}

extension CodeSyntaxQuery {
    
    var jsonData: Data? {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try jsonEncoder.encode(self)
            return jsonData
        } catch {
            print("CodeSyntaxQuery: failed to encode as JSON \(error.localizedDescription)")
            return nil
        }
    }
}

// MARK: CodeSyntaxQueryList

/// A list of code syntax queries.
struct CodeSyntaxQueryList: Codable {
    var queries: [CodeSyntaxQuery]
    
    init(_ queries: [CodeSyntaxQuery]) {
        self.queries = queries
    }
}

extension CodeSyntaxQueryList {
    
    var jsonData: Data? {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try jsonEncoder.encode(self)
            return jsonData
        } catch {
            print("CodeSyntaxQueryList: failed to encode as JSON \(error.localizedDescription)")
            return nil
        }
    }
}

// MARK: Match Quantifiers

/// A syntax query that matches just one of its child queries.
struct OneOf: CodeSyntaxQuantifierQuery {
    var nodeType: CodeSyntax.QueryNodeType = .oneOf
    var id: String?
    var wrappedChildren: [CodeSyntaxQueryNodeWrapper] = []

    init(id: String? = nil, @CodeSyntaxQueryBuilder content: () -> [CodeSyntaxQueryNode]) {
        self.id = id
        self.wrappedChildren = content().map { CodeSyntaxQueryNodeWrapper($0) }
    }
}

/// A syntax query that matches one or more of its child queries.
struct AnyOf: CodeSyntaxQuantifierQuery {
    var nodeType: CodeSyntax.QueryNodeType = .anyOf
    var id: String?
    var wrappedChildren: [CodeSyntaxQueryNodeWrapper] = []

    init(id: String? = nil, @CodeSyntaxQueryBuilder content: () -> [CodeSyntaxQueryNode]) {
        self.id = id
        self.wrappedChildren = content().map { CodeSyntaxQueryNodeWrapper($0) }
    }
}

/// A syntax query that matches all of its child queries.
///
///  An `option` can be specified for an `AllOf` query:
///   - `inOrder` The matched syntax nodes must be in the same order as the child queries within `AllOf`.
///   - `exactly` The matched syntax nodes must be in the same order as, and *exactly* match, the child queries, leaving no superfluous unmatched syntax nodes.
///
struct AllOf: CodeSyntaxQuantifierQuery {
    var nodeType: CodeSyntax.QueryNodeType = .allOf
    var id: String?
    var wrappedChildren: [CodeSyntaxQueryNodeWrapper] = []
    
    var option = CodeSyntax.AllOfOption.anyOrder
 
    init(_ option: CodeSyntax.AllOfOption = .anyOrder, id: String? = nil, @CodeSyntaxQueryBuilder content: () -> [CodeSyntaxQueryNode]) {
        self.option = option
        self.id = id
        self.wrappedChildren = content().map { CodeSyntaxQueryNodeWrapper($0) }
    }
}

/// A syntax query that matches none of its child queries.
struct NoneOf: CodeSyntaxQuantifierQuery {
    var nodeType: CodeSyntax.QueryNodeType = .noneOf
    var id: String?
    var wrappedChildren: [CodeSyntaxQueryNodeWrapper] = []

    init(id: String? = nil, @CodeSyntaxQueryBuilder content: () -> [CodeSyntaxQueryNode]) {
        self.id = id
        self.wrappedChildren = content().map { CodeSyntaxQueryNodeWrapper($0) }
    }
}

/// A syntax query that matches the specified count, or count range, of syntax nodes matched by all its child queries.
///
/// Note that `CountOf` matches on the total number of found nodes unlike `OneOf/AnyOf/AllOf` which match on the number of matching subqueries.
/// This means that `CountOf(1)` is not necessarily the same as `OneOf`.
struct CountOf: CodeSyntaxQuantifierQuery {
    var nodeType: CodeSyntax.QueryNodeType = .countOf
    var id: String?
    var wrappedChildren: [CodeSyntaxQueryNodeWrapper] = []
    
    var range: Range<Int>
// TODO: Implement ClosedRange
//    var closedRange: ClosedRange<Int>
    
    var mustBeContiguous = false

    init(_ range: Range<Int>, id: String? = nil, @CodeSyntaxQueryBuilder content: () -> [CodeSyntaxQueryNode]) {
        self.range = range
        self.id = id
        self.wrappedChildren = content().map { CodeSyntaxQueryNodeWrapper($0) }
    }
    
    init(_ count: Int, id: String? = nil, @CodeSyntaxQueryBuilder content: () -> [CodeSyntaxQueryNode]) {
        self.range = count..<(count + 1)
        self.id = id
        self.wrappedChildren = content().map { CodeSyntaxQueryNodeWrapper($0) }
    }
    
    init(contiguous range: Range<Int>, id: String? = nil, @CodeSyntaxQueryBuilder content: () -> [CodeSyntaxQueryNode]) {
        self.range = range
        self.id = id
        self.wrappedChildren = content().map { CodeSyntaxQueryNodeWrapper($0) }
        self.mustBeContiguous = true
    }
    
    init(contiguous count: Int, id: String? = nil, @CodeSyntaxQueryBuilder content: () -> [CodeSyntaxQueryNode]) {
        self.range = count..<(count + 1)
        self.id = id
        self.wrappedChildren = content().map { CodeSyntaxQueryNodeWrapper($0) }
        self.mustBeContiguous = true
    }
}
