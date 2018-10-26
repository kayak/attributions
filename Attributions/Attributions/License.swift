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

}
