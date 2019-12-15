//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

@available(iOS 13.0, *)
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
