import Foundation

extension Scanner {

    @discardableResult
    func scanWhiteSpace() -> String? {
        return scanCharacters(from: .whitespacesAndNewlines)
    }

    @discardableResult
    func scanIdentifier() -> String? {
        let characters = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "_"))
        return scanCharacters(from: characters)
    }

    @discardableResult
    func scanPath() -> [String]? {
        var path: [String] = []
        let dotSet = CharacterSet(charactersIn: ".")
        while let identifier = scanIdentifier() {
            path.append(identifier)
            guard let dot = scanCharacters(from: dotSet), dot.count == 1 else {
                break
            }
        }
        return path.isEmpty ? nil : path
    }
    
    @discardableResult
    func scanKeyword(_ keyword: String) -> String? {
        let backtrackIndex = currentIndex
        let characters = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "_"))
        guard let string = scanCharacters(from: characters), string == keyword else {
            currentIndex = backtrackIndex
            return nil
        }
        return keyword
    }
}
