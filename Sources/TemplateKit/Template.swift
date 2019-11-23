//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public struct Template: ExpressibleByStringLiteral {

    public let templateString: String
    
    public init(_ template: String) {
        self.templateString = template
    }
    
    public init(stringLiteral value: String) {
        self.templateString = value
    }
    
    public func render(context: [String: Any?]) throws -> String {

        let lexer = Lexer()
        let tokens = try lexer.tokenize(templateString)

        let parser = Parser()
        let tree = try parser.parse(tokens)

        let renderer = Renderer()
        let string = try renderer.render(nodes: tree, context: context)
        
        return string
    }
}
