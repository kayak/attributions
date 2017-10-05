import Foundation

class AttributionReader {

    func compileAttributions(sections: [AttributionSection], mainBundle: Bundle) throws -> [[Attribution]] {
        var attributionsPerSection = [[Attribution]]()
        for section in sections {
            let attributions = try jsonToAttribution(file: section.file, mainBundle: mainBundle)
            try attributions.forEach { try $0.license.verifyLicenseExists(attribution: $0) }
            attributionsPerSection.append(attributions)
        }
        return attributionsPerSection
    }

    private func jsonToAttribution(file: URL, mainBundle: Bundle) throws -> [Attribution] {
        let data = try Data(contentsOf: file)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        guard let attributionJSONs = json as? [[AnyHashable: Any]] else {
            throw NSError.makeError(description: "Error reading JSON file")
        }
        
        return attributionJSONs
            .flatMap { Attribution(json: $0) }
            .filter { $0.isDisplayed(in: mainBundle) }
            .sorted(by: { $0.0.name.lowercased() < $0.1.name.lowercased() })
    }

}
