//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

@available(iOS 13.0, *)
public class TagParser {
    
    public enum Error: Swift.Error {
        case invalidTag(index: String.Index)
    }
        
    public init() {
        //
    }
    
    public func parse(_ string: String) throws -> Tag {
        
        let scanner = Scanner(string: string)
        scanner.charactersToBeSkipped = nil
        scanner.caseSensitive = true
        
        scanWhiteSpace(scanner)
        
        if let tag = try scanIf(scanner) {
            return tag
        } else if let tag = try scanFor(scanner) {
            return tag
        } else if let tag = try scanElse(scanner) {
            return tag
        } else if let tag = try scanEnd(scanner) {
            return tag
        } else if let tag = try scanVariable(scanner) {
            return tag
        } else {
            throw Error.invalidTag(index: scanner.currentIndex)
        }
    }
    
    private func scanIf(_ scanner: Scanner) throws -> Tag? {
        let backtrackIndex = scanner.currentIndex
        guard scanner.scanString("if") != nil else {
            return nil
        }
        
        guard scanWhiteSpace(scanner) != nil else {
            if scanner.isAtEnd {
                throw Error.invalidTag(index: backtrackIndex)
            }
            scanner.currentIndex = backtrackIndex
            return nil
        }
        
        var conditionalTokens: [ConditionalToken] = []
        while !scanner.isAtEnd {
            if scanKeyword(scanner, keyword: "or") != nil {
                conditionalTokens.append(.or)
            } else if scanKeyword(scanner, keyword: "and") != nil {
                conditionalTokens.append(.and)
            } else if scanKeyword(scanner, keyword: "not") != nil {
                conditionalTokens.append(.not)
            } else if scanner.scanString("(") != nil {
                conditionalTokens.append(.startParenthesis)
            } else if scanner.scanString(")") != nil {
                conditionalTokens.append(.endParenthesis)
            } else if scanner.scanString("==") != nil {
                conditionalTokens.append(.equalityOperator)
            } else if scanner.scanString("\"") != nil {
                guard let string = scanner.scanUpToString("\"") else {
                    throw Error.invalidTag(index: backtrackIndex)
                }
                guard scanner.scanString("\"") != nil else {
                    throw Error.invalidTag(index: backtrackIndex)
                }
                conditionalTokens.append(.string(string))
            } else if let variable = scanIdentifier(scanner) {
                conditionalTokens.append(.terminal(variable: variable))
            } else {
                throw Error.invalidTag(index: backtrackIndex)
            }
            scanWhiteSpace(scanner)
        }

        let conditionParser = ConditionParser()
        let condition = try conditionParser.parse(conditionalTokens)
        
        return .if(condition: condition)
    }
    
    private func scanFor(_ scanner: Scanner) throws -> Tag? {
        let backtrackIndex = scanner.currentIndex
        guard scanner.scanString("for") != nil else {
            return nil
        }
        guard scanWhiteSpace(scanner) != nil else {
            if scanner.isAtEnd {
                throw Error.invalidTag(index: backtrackIndex)
            }
            scanner.currentIndex = backtrackIndex
            return nil
        }
        guard let variable = scanIdentifier(scanner) else {
            throw Error.invalidTag(index: backtrackIndex)
        }
        guard scanWhiteSpace(scanner) != nil else {
            scanner.currentIndex = backtrackIndex
            return nil
        }
        guard scanner.scanString("in") != nil else {
            throw Error.invalidTag(index: backtrackIndex)
        }
        guard scanWhiteSpace(scanner) != nil else {
            throw Error.invalidTag(index: backtrackIndex)
        }
        guard let sequence = scanIdentifier(scanner) else {
            throw Error.invalidTag(index: backtrackIndex)
        }
        scanWhiteSpace(scanner)
        guard scanner.isAtEnd else {
            throw Error.invalidTag(index: backtrackIndex)
        }
        return .for(variable: variable, sequence: sequence)
    }

    private func scanElse(_ scanner: Scanner) throws -> Tag? {
        let backtrackIndex = scanner.currentIndex
        guard scanner.scanString("else") != nil else {
            return nil
        }
        scanWhiteSpace(scanner)
        guard scanner.isAtEnd else {
            throw Error.invalidTag(index: backtrackIndex)
        }
        return .else
    }
    
    private func scanEnd(_ scanner: Scanner) throws -> Tag? {
        let backtrackIndex = scanner.currentIndex
        guard scanner.scanString("end") != nil else {
            return nil
        }
        scanWhiteSpace(scanner)
        guard scanner.isAtEnd else {
            throw Error.invalidTag(index: backtrackIndex)
        }
        return .end
    }

    private func scanVariable(_ scanner: Scanner) throws -> Tag? {
        let backtrackIndex = scanner.currentIndex
        
        let transformers = try scanTransformers(scanner)
        
        guard let variable = scanIdentifier(scanner) else {
            scanner.currentIndex = backtrackIndex
            return nil
        }
        scanWhiteSpace(scanner)
        guard scanner.isAtEnd else {
            throw Error.invalidTag(index: backtrackIndex)
        }
        return .variable(variable, transformers: transformers)
    }
    
    private func scanTransformers(_ scanner: Scanner) throws -> [String] {
        
        let backtrackIndex = scanner.currentIndex
        
        var transformers: [String] = []
        
        while scanner.scanString("#") != nil {
            guard let transformer = scanIdentifier(scanner) else {
                throw Error.invalidTag(index: backtrackIndex)
            }
            transformers.append(transformer)
            scanWhiteSpace(scanner)
        }
        
        return transformers
    }
    
    @discardableResult
    private func scanWhiteSpace(_ scanner: Scanner) -> String? {
        return scanner.scanCharacters(from: .whitespacesAndNewlines)
    }
    
    private func scanIdentifier(_ scanner: Scanner) -> String? {
        let characters = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "_"))
        return scanner.scanCharacters(from: characters)
    }

    private func scanKeyword(_ scanner: Scanner, keyword: String) -> String? {
        let backtrackIndex = scanner.currentIndex
        let characters = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "_"))
        guard let string = scanner.scanCharacters(from: characters), string == keyword else {
            scanner.currentIndex = backtrackIndex
            return nil
        }
        return keyword
    }

}


