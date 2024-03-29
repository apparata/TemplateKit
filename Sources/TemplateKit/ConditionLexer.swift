import Foundation

public class ConditionLexer {
    
    public enum Error: Swift.Error {
        case invalidCondition(index: String.Index)
    }
    
    public init() {
        //
    }
        
    public func tokenize(_ string: String) throws -> [ConditionalToken] {
                
        let scanner = Scanner(string: string)
        scanner.charactersToBeSkipped = nil
        scanner.caseSensitive = true
        
        return try tokenize(scanner)
    }
    
    public func tokenize(_ scanner: Scanner) throws -> [ConditionalToken] {

        let backtrackIndex = scanner.currentIndex
        
        var tokens: [ConditionalToken] = []
        
        scanner.scanWhiteSpace()
        
        while !scanner.isAtEnd {
            if scanner.scanKeyword("or") != nil {
                tokens.append(.or)
            } else if scanner.scanKeyword("and") != nil {
                tokens.append(.and)
            } else if scanner.scanKeyword("not") != nil {
                tokens.append(.not)
            } else if scanner.scanString("(") != nil {
                tokens.append(.startParenthesis)
            } else if scanner.scanString(")") != nil {
                tokens.append(.endParenthesis)
            } else if scanner.scanString("==") != nil {
                tokens.append(.comparisonOperator(.equals))
            } else if scanner.scanString("!=") != nil {
                tokens.append(.comparisonOperator(.notEquals))
            } else if scanner.scanString("\"") != nil {
                let string = scanner.scanUpToString("\"") ?? ""
                guard scanner.scanString("\"") != nil else {
                    throw Error.invalidCondition(index: backtrackIndex)
                }
                tokens.append(.string(string))
            } else if scanner.scanString("'") != nil {
                let string = scanner.scanUpToString("'") ?? ""
                guard scanner.scanString("'") != nil else {
                    throw Error.invalidCondition(index: backtrackIndex)
                }
                tokens.append(.string(string))
            } else if let path = scanner.scanPath() {
                tokens.append(.terminal(path))
            } else {
                throw Error.invalidCondition(index: backtrackIndex)
            }
            scanner.scanWhiteSpace()
        }
        
        return tokens
    }
}
