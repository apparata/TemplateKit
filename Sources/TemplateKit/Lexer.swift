//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public enum Token {
    case text(String)
    case tag(Tag)
    case newline
    case whitespace(String)
}

public enum Tag {
    case `if`(condition: ConditionalExpression)
    case `for`(variable: String, sequence: String)
    case `else`
    case end
    case variable(String, transformers: [String])
}

public enum ComparisonOperator {
    case equals
    case notEquals
}

public enum ConditionalToken {
    case not
    case and
    case or
    case startParenthesis
    case endParenthesis
    case terminal(variable: String)
    case string(String)
    case comparisonOperator(ComparisonOperator)
}

@available(iOS 13.0, *)
public class Lexer {
    
    public enum Error: Swift.Error {
        case missingTagEnd(index: String.Index)
    }
    
    public struct Configuration {
        public let tagStart: String
        public let tagEnd: String
        
        public init(tagStart: String = "<{",
                    tagEnd: String = "}>") {
            self.tagStart = tagStart
            self.tagEnd = tagEnd
        }
    }
    
    public let configuration: Configuration
    
    public init(configuration: Configuration = Configuration()) {
        self.configuration = configuration
    }
    
    public func tokenize(_ string: String) throws -> [Token] {
        
        var tokens: [Token] = []
        
        let scanner = Scanner(string: string)
        scanner.charactersToBeSkipped = nil
        scanner.caseSensitive = true
        
        while true {
            if let tag = try scanTag(scanner) {
                tokens.append(tag)
            } else if scanner.scanString("\n") != nil {
                tokens.append(.newline)
            } else if let text = scanText(scanner) {
                tokens.append(text)
            } else {
                break
            }
        }
        
        return tokens
    }
    
    private func scanTag(_ scanner: Scanner) throws -> Token? {
        guard scanner.scanString(configuration.tagStart) != nil else {
            return nil
        }
        var index = scanner.currentIndex
        guard let tagString = scanner.scanUpToString(configuration.tagEnd) else {
            throw Error.missingTagEnd(index: index)
        }
        index = scanner.currentIndex
        guard scanner.scanString(configuration.tagEnd) != nil else {
            throw Error.missingTagEnd(index: index)
        }
        let tagParser = TagParser()
        let tag = try tagParser.parse(tagString)
        return .tag(tag)
    }

    private func scanText(_ scanner: Scanner) -> Token? {
        guard let firstTagCharacter = configuration.tagStart.first else {
            return nil
        }
        
        var scannedText = scanner.scanUpToCharacters(from: CharacterSet(charactersIn: "\n\(firstTagCharacter)"))
        
        let index = scanner.currentIndex
        
        if scannedText == nil {
            if scanner.isAtEnd {
                return nil
            } else if scanner.scanString("\n") != nil {
                scanner.currentIndex = index
                return .whitespace("")
            } else if scanner.scanString(configuration.tagStart) != nil {
                scanner.currentIndex = index
                return .whitespace("")
            } else {
                scannedText = ""
            }
        }
        
        guard let text = scannedText else {
            return nil
        }
        
        if scanner.isAtEnd {
            if isWhitespaceOnly(text) {
                return .whitespace(text)
            } else {
                return .text(text)
            }
        }
        if scanner.scanString("\n") != nil {
            scanner.currentIndex = index
            if isWhitespaceOnly(text) {
                return .whitespace(text)
            } else {
                return .text(text)
            }
        }
        if scanner.scanString(configuration.tagStart) != nil {
            scanner.currentIndex = index
            if isWhitespaceOnly(text) {
                return .whitespace(text)
            } else {
                return .text(text)
            }
        }
        // This means that we have encountered the first character of a tag
        // start, but it's just part of the text and there is no second
        // character from the tag.
        _ = scanner.scanCharacter()
        return .text(text + String(firstTagCharacter))
    }
    
    private func isWhitespaceOnly(_ string: String) -> Bool {
        string.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
