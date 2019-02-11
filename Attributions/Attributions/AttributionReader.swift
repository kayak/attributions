import Foundation

class AttributionReader {

    func compileAttributions(sections: [AttributionSection], mainBundle: Bundle, licenseFiles: [String]) throws -> [[Attribution]] {
        var attributionsPerSection = [[Attribution]]()
        for section in sections {
            let attributions = try jsonToAttribution(file: section.file, mainBundle: mainBundle)
            try attributions.forEach {
                let licenseReader = LicenseReader(attribution: $0, licenseFiles: licenseFiles)
                try licenseReader.verifyLicenseExists()
            }
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
            .compactMap { Attribution(json: $0) }
            .filter { $0.isDisplayed(in: mainBundle) }
            .sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
    }

}
