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
        let immediatePath = path[0]
        guard let nextNode = dictionary[immediatePath] else {
            throw TemplateError.invalidPath(path: path)
        }
        let remainingPath = Array(path.dropFirst())
        return try contextValue(at: remainingPath, node: nextNode)

    case .class:
        if path.isEmpty {
            return node
        }
        let remainingPath = Array(path.dropFirst())
        let immediatePath = path[0]
        let nextNode = mirror.descendant(immediatePath)
        return try contextValue(at: remainingPath, node: nextNode)

    case .optional:
        let nextNode = mirror.descendant("some")
        return try contextValue(at: path, node: nextNode)

    case .struct:
        if path.isEmpty {
            return node
        }
        let remainingPath = Array(path.dropFirst())
        let immediatePath = path[0]
        let nextNode = mirror.descendant(immediatePath)
        return try contextValue(at: remainingPath, node: nextNode)

    default:
        guard path.isEmpty else {
            throw TemplateError.invalidPath(path: path)
        }
        return node
    }
}
