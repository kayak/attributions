import Foundation

public struct AttributionSection {

    public let file: URL
    public let description: String
    public let additionalAttributions: [Attribution]

    public init(file: URL, description: String, additionalAttributions: [Attribution] = []) {
        self.file = file
        self.description = description
        self.additionalAttributions = additionalAttributions
    }

}
