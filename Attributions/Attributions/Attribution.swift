import Foundation

class Attribution {

    let name: String
    let license: License

    init?(json: [AnyHashable: Any]) {
        guard
            let name = json["name"] as? String,
            let licenseJSON = json["license"] as? [AnyHashable: Any],
            let license = License(json: licenseJSON)
        else {
            return nil
        }
        self.name = name
        self.license = license
    }

}
