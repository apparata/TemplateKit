import Foundation

public indirect enum ConditionalExpression {
    case or([ConditionalExpression])
    case and([ConditionalExpression])
    case not(ConditionalExpression)
    case terminal(path: [String])
    case terminalCompareToString(path: [String], string: String, operator: ComparisonOperator)
}

public extension ConditionalExpression {
    
    func evaluate(with context: [String: Any?]) throws -> Bool {
        switch self {
            
        case .or(let conditions):
            for condition in conditions {
                if try condition.evaluate(with: context) {
                    return true
                }
            }
            return false
            
        case .and(let conditions):
            for condition in conditions {
                if try !condition.evaluate(with: context) {
                    return false
                }
            }
            return true
        
        case .not(let condition):
            return try !condition.evaluate(with: context)
        
        case .terminal(let path):
            if let value: Any = try contextValue(at: path, node: context).flatMap({ $0 }) {
                if let booleanValue = value as? Bool {
                    return booleanValue
                } else {
                    return true
                }
            }
            return false
            
        case .terminalCompareToString(let path, let string, let comparisonOperator):
            if let value: Any = try contextValue(at: path, node: context).flatMap({ $0 }) {
                if let stringValue = value as? String {
                    switch comparisonOperator {
                    case .equals:
                        return stringValue == string
                    case .notEquals:
                        return stringValue != string
                    }
                } else {
                    return false
                }
            } else {
                // Value is nil
                switch comparisonOperator {
                case .equals where string == "":
                    return true
                case .equals where string != "":
                    return false
                case .notEquals where string == "":
                    return false
                case .notEquals where string != "":
                    return true
                default:
                    return false
                }
            }
        }
    }
}
