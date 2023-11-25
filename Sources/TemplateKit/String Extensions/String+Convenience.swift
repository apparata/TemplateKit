import Foundation

// MARK: - Casing

public extension String {
    
    func uppercasingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func uppercaseFirstLetter() {
        self = uppercasingFirstLetter()
    }

    func lowercasingFirstLetter() -> String {
        return prefix(1).lowercased() + dropFirst()
    }
    
    mutating func lowercasingFirstLetter() {
        self = lowercasingFirstLetter()
    }
}

// MARK: - Whitespace

public extension String {
    
    /// Example:
    /// ```
    /// "    How are you?   ".trimmed()
    /// result: "How are you?"
    /// ```
    func trimmed() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    /// Example:
    /// ```
    /// "This is a test.".removingWhitespace()
    /// result: "Thisisatest"
    /// ```
    func removingWhitespace() -> String {
        let components = self.components(separatedBy: CharacterSet.whitespacesAndNewlines).filter { !$0.isEmpty }
        return components.joined(separator: "")
    }
    
    /// Example:
    /// ```
    /// "This    is    a    test.".collapsingWhitespace()
    /// result: "This is a test"
    /// ```
    func collapsingWhitespace() -> String {
        let components = self.components(separatedBy: CharacterSet.whitespacesAndNewlines).filter { !$0.isEmpty }
        return components.joined(separator: " ")
    }
}
