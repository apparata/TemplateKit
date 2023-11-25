import Foundation

public enum TemplateError: Swift.Error {
    case unsupportedValueType(Any)
    case invalidPath(path: [String])
    case invalidDictionary
}
