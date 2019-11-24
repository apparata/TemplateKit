//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public class Parser {
        
    public enum Error: Swift.Error {
        case unexpectedToken(Token)
        case unbalancedIfOrFor(index: Int)
    }
        
    public init() {
        //
    }
    
    public func parse(_ tokens: [Token]) throws -> [Node] {
        let filteredTokens = removeUnwantedNewlines(from: tokens)
        return try parse(filteredTokens, index: 0, level: 0).nodes
    }
    
    private func parse(_ tokens: [Token], index: Int, level: Int) throws -> (nodes: [Node], index: Int) {
        
        var nodes: [Node] = []
        
        var i = index
                
        while i < tokens.count {
                        
            let token = tokens[i]
            switch token {
            
            case .text(let text):
                let node = TextNode(text: text)
                nodes.append(node)
                i += 1
                
            case .tag(let tag):
                switch tag {
                case .variable(let variable, let transformers):
                    let node = VariableNode(variable: variable, transformers: transformers)
                    nodes.append(node)
                    i += 1
                case .if(_):
                    let (node, newIndex) = try parseIf(tokens, index: i, level: level + 1)
                    nodes.append(node)
                    i = newIndex
                case .for(_, _):
                    let (node, newIndex) = try parseFor(tokens, index: i, level: level + 1)
                    nodes.append(node)
                    i = newIndex
                case .else:
                    if level == 0 {
                        throw Error.unbalancedIfOrFor(index: i)
                    }
                    let (node, newIndex) = try parseElse(tokens, index: i, level: level + 1)
                    nodes.append(node)
                    i = newIndex
                    return (nodes: nodes, index: i)
                case .end:
                    if level == 0 {
                        throw Error.unbalancedIfOrFor(index: i)
                    }
                    i += 1
                    return (nodes: nodes, index: i)
                }

            case .newline:
                let node = TextNode(text: "\n")
                nodes.append(node)
                i += 1
                
            case .whitespace(let text):
                let node = TextNode(text: text)
                nodes.append(node)
                i += 1
            }
        }
        
        if level > 0 {
            throw Error.unbalancedIfOrFor(index: i)
        }
        
        return (nodes: nodes, index: i)
    }
    
    private func parseIf(_ tokens: [Token], index: Int, level: Int) throws -> (IfNode, Int) {
        
        var i = index
        
        let token = tokens[i]
        guard case .tag(let tag) = token,
            case .if(let condition) = tag else {
            throw Error.unexpectedToken(token)
        }
        i += 1
        
        let (nodes, newIndex) = try parse(tokens, index: i, level: level)
        i = newIndex
        
        return (IfNode(condition: condition, children: nodes), i)
    }
    
    private func parseElse(_ tokens: [Token], index: Int, level: Int) throws -> (ElseNode, Int) {
        
        var i = index
        
        let token = tokens[i]
        guard case .tag(let tag) = token,
            case .else = tag else {
            throw Error.unexpectedToken(token)
        }
        i += 1
        
        let (nodes, newIndex) = try parse(tokens, index: i, level: level)
        i = newIndex
        
        return (ElseNode(children: nodes), i)
    }
    
    private func parseFor(_ tokens: [Token], index: Int, level: Int) throws -> (ForNode, Int) {
        
        var i = index
        
        let token = tokens[i]
        guard case .tag(let tag) = token,
            case .for(let variable, let sequence) = tag else {
            throw Error.unexpectedToken(token)
        }
        i += 1

        let (nodes, newIndex) = try parse(tokens, index: i, level: level)
        i = newIndex
        
        return (ForNode(variable: variable, sequence: sequence, children: nodes), i)
    }
    
    private func removeUnwantedNewlines(from tokens: [Token]) -> [Token] {
        
        // There are definitely smarter ways to do this. :)
        
        var filteredTokens: [Token] = []
        
        var tokenMinus4: Token?
        var tokenMinus3: Token?
        var tokenMinus2: Token?
        var tokenMinus1: Token?
        
        for token in tokens {
            switch token {
            case .newline:
                if case .newline = tokenMinus2,
                    case .tag(let tag) = tokenMinus1,
                    isTagNewlineSensitive(tag) {
                    // This newline is redundant.
                } else if case .newline = tokenMinus3,
                    case .tag(let tag) = tokenMinus2,
                    isTagNewlineSensitive(tag),
                    case .whitespace(_) = tokenMinus1 {
                    // This newline is redundant
                } else if case .newline = tokenMinus3,
                    case .whitespace(_) = tokenMinus2,
                    case .tag(let tag) = tokenMinus1,
                    isTagNewlineSensitive(tag) {
                    // This newline is redundant
                } else if case .newline = tokenMinus4,
                    case .whitespace(_) = tokenMinus3,
                    case .tag(let tag) = tokenMinus2,
                    isTagNewlineSensitive(tag),
                    case .whitespace(_) = tokenMinus1 {
                    // This newline is redundant
                } else {
                    filteredTokens.append(token)
                }
                
            default:
                filteredTokens.append(token)
            }
            
            tokenMinus4 = tokenMinus3
            tokenMinus3 = tokenMinus2
            tokenMinus2 = tokenMinus1
            tokenMinus1 = token
        }
        
        return filteredTokens
    }
    
    private func isTagNewlineSensitive(_ tag: Tag) -> Bool {
        switch tag {
        case .if(_), .for(_, _), .else, .end: return true
        case .variable(_): return false
        }
    }
}
