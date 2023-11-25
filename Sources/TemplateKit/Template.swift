import Foundation

public struct Template: ExpressibleByStringLiteral {

    public let templateString: String
    public let lexerConfiguration: Lexer.Configuration

    public init(
        contentsOf url: URL,
        lexerConfiguration: Lexer.Configuration
    ) throws {
        let string = try String(contentsOf: url, encoding: .utf8)
        self.init(string, lexerConfiguration: lexerConfiguration)
    }

    public init(
        _ template: String,
        lexerConfiguration: Lexer.Configuration = Lexer.Configuration()
    ) {
        self.templateString = template
        self.lexerConfiguration = lexerConfiguration
    }

    public init(
        _ template: String,
        tagStart: String,
        tagEnd: String
    ) {
        self.templateString = template
        lexerConfiguration = Lexer.Configuration(tagStart: tagStart, tagEnd: tagEnd)
    }

    public init(
        stringLiteral value: String,
        tagStart: String = "<{",
        tagEnd: String = "}>"
    ) {
        self.templateString = value
        lexerConfiguration = Lexer.Configuration(tagStart: tagStart, tagEnd: tagEnd)
    }
    
    public init(stringLiteral value: String) {
        self.templateString = value
        lexerConfiguration = Lexer.Configuration(tagStart: "<{", tagEnd: "}>")
    }
    
    public func render(context: [String: Any?], root: URL? = nil) throws -> String {

        let lexer = Lexer(configuration: lexerConfiguration)
        let tokens = try lexer.tokenize(templateString)

        let parser = Parser()
        let tree = try parser.parse(tokens)

        let renderer = Renderer(lexerConfiguration: lexerConfiguration, root: root)
        let string = try renderer.render(nodes: tree, context: context)

        return string
    }
}
