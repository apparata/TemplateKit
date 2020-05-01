//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

import Foundation

public enum TemplateError: Swift.Error {
    case unsupportedValueType(Any)
    case invalidPath(path: [String])
    case invalidDictionary
}
