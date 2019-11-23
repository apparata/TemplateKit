//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public typealias Transformer = (Any?) -> Any?

public struct Transformers {
    
    public static let lowercased: Transformer = { (value: Any?) -> Any? in
        if let string = value as? String {
            return string.lowercased()
        } else {
            return value
        }
    }

    public static let uppercased: Transformer = { (value: Any?) -> Any? in
        if let string = value as? String {
            return string.uppercased()
        } else {
            return value
        }
    }
    
    public static let uppercasingFirstLetter: Transformer = { (value: Any?) -> Any? in
        if let string = value as? String {
            return string.uppercasingFirstLetter()
        } else {
            return value
        }
    }

    public static let lowercasingFirstLetter: Transformer = { (value: Any?) -> Any? in
        if let string = value as? String {
            return string.lowercasingFirstLetter()
        } else {
            return value
        }
    }
    
    public static let trimmed: Transformer = { (value: Any?) -> Any? in
        if let string = value as? String {
            return string.trimmed()
        } else {
            return value
        }
    }

    public static let removingWhitespace: Transformer = { (value: Any?) -> Any? in
        if let string = value as? String {
            return string.removingWhitespace()
        } else {
            return value
        }
    }
    
    public static let collapsingWhiteSpace: Transformer = { (value: Any?) -> Any? in
        if let string = value as? String {
            return string.collapsingWhitespace()
        } else {
            return value
        }
    }
}
