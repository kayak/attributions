import Foundation

extension Bundle {

    static var current: Bundle {
        return Bundle(for: BundleMarker.self)
    }

}

private final class BundleMarker {}
