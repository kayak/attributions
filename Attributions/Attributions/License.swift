import Foundation

enum License {

    case id(String)
    case text(String)
    case file(String, String?)

    init?(json: [AnyHashable: Any]) {
        if let id = json ["id"] as? String {
            self = .id(id)
            return
        }
        if let text = json["text"] as? String{
            self = .text(text)
            return
        }
        if let file = json["filename"] as? String {
            self = .file(file, json["bundleID"] as? String)
            return
        }
        return nil
    }

    func getText() throws -> String {
        switch self {
        case .id(let id):
            return try readText(resource: id.appending(".txt"), bundle: .current)
        case .text(let text):
            return text
        case .file(let file, let bundleID):
            let bundle = bundleFromIdentifier(bundleID)
            return try readText(resource: file, bundle: bundle)
        }
    }

    private func readText(resource: String, bundle: Bundle) throws -> String {
        let filename = (resource as NSString).deletingPathExtension
        let fileExtension = (resource as NSString).pathExtension
        let path: URL
        if let filePath = bundle.url(forResource: filename, withExtension: fileExtension) {
            path = filePath
        } else {
            throw NSError.makeError(description: "Could not find file: \(resource)")
        }
        let data = try Data(contentsOf: path)
        guard let text = String(data: data, encoding: .utf8) else {
            throw NSError.makeError(description: "Could not read from file: \(resource)")
        }
        return text
    }

    func verifyLicenseExists(attribution: Attribution) throws {
        switch self {
        case .id(let id):
            guard Bundle.current.url(forResource: id, withExtension: "txt") != nil else {
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
