import Foundation

public class Renderer {
        
    public let lexerConfiguration: Lexer.Configuration

    public let root: URL?

    public init(lexerConfiguration: Lexer.Configuration = Lexer.Configuration(), root: URL? = nil) {
        self.lexerConfiguration = lexerConfiguration
        self.root = root
    }

    public func render(nodes: [Node], context: [String: Any?]) throws -> String {
        return try renderParts(nodes: nodes, context: context).joined()
    }
    
    private func renderParts(nodes: [Node], context userContext: [String: Any?]) throws -> [String] {

        var context: [String: Any?] = [
            "lowercased": Transformers.lowercased,
            "uppercased": Transformers.uppercased,
            "uppercasingFirstLetter": Transformers.uppercasingFirstLetter,
            "lowercasingFirstLetter": Transformers.lowercasingFirstLetter,
            "trimmed": Transformers.trimmed,
            "removingWhitespace": Transformers.removingWhitespace,
            "collapsingWhitespace": Transformers.removingWhitespace
        ]
        for (key, value) in userContext {
            context[key] = value
        }
        
        var parts: [String] = []
        
        for node in nodes {
            if let textNode = node as? TextNode {
                parts.append(textNode.text)
            } else if let variableNode = node as? VariableNode {
                var value: Any? = try contextValue(at: variableNode.path, node: context)
                for transformID in variableNode.transformers {
                    if let transform = context[transformID] as? ((Any?) -> Any?) {
                        value = transform(value)
                    }
                }
                if let part = value.flatMap({ "\($0)" }) {
                    parts.append(part)
                }
            } else if let ifNode = node as? IfNode {
                if try ifNode.condition.evaluate(with: context) {
                    parts.append(contentsOf: try renderParts(nodes: ifNode.children,
                                                             context: context))
                } else {
                    if let elseNode = ifNode.children.first(where: { node in node is ElseNode }) as? ElseNode {
                        parts.append(contentsOf: try renderParts(nodes: elseNode.children,
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
            } else if let importNode = node as? ImportNode {
                let url: URL
                if let root {
                    url = root.appending(path: importNode.file)
                } else {
                    url = URL(file: importNode.file)
                }
                let template = try Template(contentsOf: url, lexerConfiguration: lexerConfiguration)
                let part = try template.render(context: context, root: root)
                parts.append(part)
            }
        }
        
        return parts
    }    
}
