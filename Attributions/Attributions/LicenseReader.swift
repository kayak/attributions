import Foundation

struct LicenseReader {
    
    let attribution: Attribution
    private let licenseFiles: [String]
    
    init(attribution: Attribution, licenseFiles: [String]) {
        self.attribution = attribution
        self.licenseFiles = licenseFiles
    }
    
    func text() throws -> String {
        switch attribution.license {
        case .id(let id):
            return try readText(resource: id.appending(".txt"))
        case .text(let text):
            return text
        case .file(let file, let bundleID):
            let bundle = bundleFromIdentifier(bundleID)
            return try readText(resource: file, bundle: bundle)
        }
    }
    
    private func readText(resource: String) throws -> String {
        guard let path = licenseFiles.first(where: { $0.contains(resource) }) else {
            throw NSError.makeError(description: "Could not find file: \(resource)")
        }
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        guard let text = String(data: data, encoding: .utf8) else {
            throw NSError.makeError(description: "Could not read from file: \(resource)")
        }
        return text
    }
    
    private func readText(resource: String, bundle: Bundle) throws -> String {
        let filename = (resource as NSString).deletingPathExtension
        let fileExtension = (resource as NSString).pathExtension
        guard let path = bundle.url(forResource: filename, withExtension: fileExtension) else {
            throw NSError.makeError(description: "Could not find file: \(resource)")
        }
        let data = try Data(contentsOf: path)
        guard let text = String(data: data, encoding: .utf8) else {
            throw NSError.makeError(description: "Could not read from file: \(resource)")
        }
        return text
    }
    
    func verifyLicenseExists() throws {
        switch attribution.license {
        case .id(let id):
            guard licenseFiles.first(where: { $0.contains("\(id).txt") }) != nil else {
                throw NSError.makeError(description: "Invalid license key \(id) for \(attribution.name)")
            }
        case .text(_): break
        case .file(let file, let bundleID):
            let bundle = bundleFromIdentifier(bundleID)
            let filename = (file as NSString).deletingPathExtension
            let fileExtension = (file as NSString).pathExtension
            guard bundle.url(forResource: filename, withExtension: fileExtension) != nil else {
                throw NSError.makeError(description: "Could not find license \(file) for \(attribution.name)")
            }
        }
    }
    
    private func bundleFromIdentifier(_ identifier: String?) -> Bundle {
        if let bundleID = identifier, let licenseBundle = Bundle(identifier: bundleID) {
            return licenseBundle
        } else {
            return .main
        }
    }
    
}
