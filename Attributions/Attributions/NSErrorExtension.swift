import Foundation

extension NSError {

    static func makeError(description: String) -> NSError {
        return NSError(domain: Bundle.current.bundleIdentifier!, code: 1, userInfo: [NSLocalizedDescriptionKey: description])
    }

}
