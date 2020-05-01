//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

@available(iOS 13.0, *)
public struct Template: ExpressibleByStringLiteral {

    public let templateString: String
    public let lexerConfiguration: Lexer.Configuration
    
    public init(_ template: String,
                tagStart: String = "<{",
                tagEnd: String = "}>") {
        self.templateString = template
        lexerConfiguration = Lexer.Configuration(tagStart: tagStart, tagEnd: tagEnd)
    }

    public init(stringLiteral value: String,
                tagStart: String = "<{",
                tagEnd: String = "}>") {
        self.templateString = value
        lexerConfiguration = Lexer.Configuration(tagStart: tagStart, tagEnd: tagEnd)
    }
    
    public init(stringLiteral value: String) {
        self.templateString = value
        lexerConfiguration = Lexer.Configuration(tagStart: "<{", tagEnd: "}>")
    }
    
    public func render(context: [String: Any?]) throws -> String {

        let lexer = Lexer(configuration: lexerConfiguration)
        let tokens = try lexer.tokenize(templateString)

        let parser = Parser()
        let tree = try parser.parse(tokens)

        let renderer = Renderer()
        let string = try renderer.render(nodes: tree, context: context)
        
        return string
    }
}
