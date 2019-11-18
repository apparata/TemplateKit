
import Foundation

public class Renderer {
    
    public enum Error: Swift.Error {
        case unsupportedValueType(Any)
    }
    
    public init() {
        //
    }

    public func render(nodes: [Node], context: [String: Any?]) throws -> String {
        return try renderParts(nodes: nodes, context: context).joined()
    }
    
    private func renderParts(nodes: [Node], context: [String: Any?]) throws -> [String] {
        
        var parts: [String] = []
        
        for node in nodes {
            if let textNode = node as? TextNode {
                parts.append(textNode.text)
            } else if let variableNode = node as? VariableNode {
                if let part = context[variableNode.variable]?.flatMap({ "\($0)" }) {
                    parts.append(part)
                }
            } else if let ifNode = node as? IfNode {
                if let value: Any = context[ifNode.variable]?.flatMap({ $0 }) {
                    if let booleanValue = value as? Bool {
                        if booleanValue {
                            parts.append(contentsOf: try renderParts(nodes: ifNode.children,
                                                                     context: context))
                        }
                    } else {
                        parts.append(contentsOf: try renderParts(nodes: ifNode.children,
                                                                 context: context))
                    }
                }
            } else if let forNode = node as? ForNode {
                if let sequence: Array<Any> = context[forNode.sequence]?.flatMap({ $0 as? Array<Any> }) {
                    for value in sequence {
                        var newContext = context
                        newContext[forNode.variable] = value
                        parts.append(contentsOf: try renderParts(nodes: forNode.children, context: newContext))
                    }
                }
            }
        }
        
        return parts
    }
}
