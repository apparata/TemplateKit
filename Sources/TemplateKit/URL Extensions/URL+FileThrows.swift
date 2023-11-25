import Foundation

extension URL {

    init(file: String) {
        if #available(iOS 16.0, macOS 13.0, *) {
            self = URL(filePath: file)
        } else {
            self = URL(fileURLWithPath: file)
        }
    }
}
