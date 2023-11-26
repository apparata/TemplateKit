import Foundation

public class Node {
    
}

public class TextNode: Node {
    let text: String
    
    public init(text: String) {
        self.text = text
    }
}

public class VariableNode: Node {
    let path: [String]
    let transformers: [String]
    
    public init(path: [String], transformers: [String]) {
        self.path = path
        self.transformers = transformers
    }
}

public class IfNode: Node {
    let condition: ConditionalExpression
    let children: [Node]
    
    public init(condition: ConditionalExpression, children: [Node]) {
        self.condition = condition
        self.children = children
    }
}

public class ElseNode: Node {
    let children: [Node]
    
    public init(children: [Node]) {
        self.children = children
    }
}

public class ForNode: Node {
    let variable: String
    let sequence: [String]
    let children: [Node]
    
    public init(variable: String, sequence: [String], children: [Node]) {
        self.variable = variable
        self.sequence = sequence
        self.children = children
    }
}

public class ImportNode: Node {
    let file: String

    public init(file: String) {
        self.file = file
    }
}
