//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public class ConditionParser {
    
    public enum Error: Swift.Error {
        case parseConditionalFailed
    }
        
    public init() {
        //
    }

    public func parse(_ tokens: [ConditionalToken]) throws -> ConditionalExpression {
        guard let (condition, index) = try parseExpr(tokens, index: 0, level: 0) else {
            throw Error.parseConditionalFailed
        }
        
        if index < tokens.count {
            throw Error.parseConditionalFailed
        }
        
        return condition
    }

    private func parseExpr(_ tokens: [ConditionalToken], index: Int, level: Int) throws -> (condition: ConditionalExpression, index: Int)? {
        
        var terms: [ConditionalExpression] = []
        
        var i = index
        
        guard let (condition, newIndex) = try parseTerm(tokens, index: i, level: level + 1) else {
            return nil
        }

        i = newIndex
        terms.append(condition)

        while i < tokens.count {
            guard case .or = tokens[i] else {
                break
            }
            
            i += 1
            
            guard let (condition, newIndex) = try parseTerm(tokens, index: i, level: level + 1) else {
                throw Error.parseConditionalFailed
            }
            
            i = newIndex
            terms.append(condition)
        }
        
        return (condition: ConditionalExpression.or(terms), index: i)
    }
    
    private func parseTerm(_ tokens: [ConditionalToken], index: Int, level: Int) throws -> (condition: ConditionalExpression, index: Int)? {
        
        var factors: [ConditionalExpression] = []
        
        var i = index
        
        guard let (condition, newIndex) = try parseFactor(tokens, index: i, level: level + 1) else {
            return nil
        }

        i = newIndex
        factors.append(condition)

        while i < tokens.count {
            guard case .and = tokens[i] else {
                break
            }
            
            i += 1
            
            guard let (condition, newIndex) = try parseFactor(tokens, index: i, level: level + 1) else {
                throw Error.parseConditionalFailed
            }
            
            i = newIndex
            factors.append(condition)
        }
        
        return (condition: ConditionalExpression.and(factors), index: i)
    }
    
    private func parseFactor(_ tokens: [ConditionalToken], index: Int, level: Int) throws -> (condition: ConditionalExpression, index: Int)? {
        
        var i = index
        
        var shouldInvert = false
        if case .not = tokens[i] {
            shouldInvert = true
            i += 1
        }
        
        switch tokens[i] {
        
        case .startParenthesis:
            i += 1
            guard let (condition, newIndex) = try parseExpr(tokens, index: i, level: i + 1) else {
                throw Error.parseConditionalFailed
            }
            i = newIndex
            guard case ConditionalToken.endParenthesis = tokens[i] else {
                throw Error.parseConditionalFailed
            }
            i += 1
            if shouldInvert {
                return (condition: .not(condition), index: i)
            } else {
                return (condition: condition, index: i)
            }
            
        case .terminal(let variable):
            i += 1
            if shouldInvert {
                return (condition: .not(.terminal(variable: variable)), index: i)
            } else {
                return (condition: .terminal(variable: variable), index: i)
            }
        
        default:
            throw Error.parseConditionalFailed
        }
    }
}
