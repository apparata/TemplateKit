import Foundation

func contextValue(at path: [String], node: Any?) throws -> Any? {
    
    guard let node = node else {
        return nil
    }
    
    let mirror = Mirror(reflecting: node)

    switch mirror.displayStyle {
    
    case .dictionary:
        if path.isEmpty {
            return node
        }
        guard let dictionary = node as? [String: Any?] else {
            throw TemplateError.invalidDictionary
        }
        guard let nextNode = dictionary[path[0]] else {
            throw TemplateError.invalidPath(path: path)
        }
        return try contextValue(at: Array(path.dropFirst()), node: nextNode)

    case .class:
        if path.isEmpty {
            return node
        }
        return try contextValue(at: Array(path.dropFirst()), node: mirror.descendant(path[0]))

    case .struct:
        if path.isEmpty {
            return node
        }
        return try contextValue(at: Array(path.dropFirst()), node: mirror.descendant(path[0]))

    default:
        guard path.isEmpty else {
            throw TemplateError.invalidPath(path: path)
        }
        return node
    }
}
