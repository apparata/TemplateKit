//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public indirect enum ConditionalExpression {
    case or([ConditionalExpression])
    case and([ConditionalExpression])
    case not(ConditionalExpression)
    case terminal(variable: String)
}

public extension ConditionalExpression {
    
    func evaluate(with context: [String: Any?]) -> Bool {
        switch self {
            
        case .or(let conditions):
            for condition in conditions {
                if condition.evaluate(with: context) {
                    return true
                }
            }
            return false
            
        case .and(let conditions):
            for condition in conditions {
                if !condition.evaluate(with: context) {
                    return false
                }
            }
            return true
        
        case .not(let condition):
            return !condition.evaluate(with: context)
        
        case .terminal(let variable):
            if let value: Any = context[variable]?.flatMap({ $0 }) {
                if let booleanValue = value as? Bool {
                    return booleanValue
                } else {
                    return true
                }
            }
            return false
        }
    }
}
