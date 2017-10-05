import Foundation

class Attribution {

    let name: String
    let displayedForMainBundleIDs: [String]
    let license: License

    convenience init?(json: [AnyHashable: Any]) {
        guard
            let name = json["name"] as? String,
            let licenseJSON = json["license"] as? [AnyHashable: Any],
            let license = License(json: licenseJSON)
        else {
            return nil
        }
        let displayedForMainBundleIDs = json["displayedForMainBundleIDs"] as? [String] ?? []

        self.init(name: name, displayedForMainBundleIDs: displayedForMainBundleIDs, license: license)
    }

    init(name: String, displayedForMainBundleIDs: [String], license: License) {
        self.name = name
        self.displayedForMainBundleIDs = displayedForMainBundleIDs
        self.license = license
    }

    func isDisplayed(in mainBundle: Bundle) -> Bool {
        guard let mainBundleIdentifier = mainBundle.bundleIdentifier else {
            return true
        }
        guard displayedForMainBundleIDs.count > 0 else {
            return true
        }
        return displayedForMainBundleIDs.contains(mainBundleIdentifier)
    }

}
