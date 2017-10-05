import Foundation

public struct AttributionSection {

    public let file: URL
    public let description: String

    public init(file: URL, description: String) {
        self.file = file
        self.description = description
    }

}
