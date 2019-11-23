//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

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
    let variable: String
    let transformers: [String]
    
    public init(variable: String, transformers: [String]) {
        self.variable = variable
        self.transformers = transformers
    }
}

public class IfNode: Node {
    let variable: String
    let children: [Node]
    
    public init(variable: String, children: [Node]) {
        self.variable = variable
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
    let sequence: String
    let children: [Node]
    
    public init(variable: String, sequence: String, children: [Node]) {
        self.variable = variable
        self.sequence = sequence
        self.children = children
    }
}
