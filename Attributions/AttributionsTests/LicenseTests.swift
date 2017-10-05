import XCTest
@testable import Attributions

class LicenseTests: XCTestCase {

    func testLoadsTextFromAllBundledLicenses() {
        guard let files = Bundle.current.urls(forResourcesWithExtension: "txt", subdirectory: "Licenses") else {
            XCTFail()
            return
        }

        for file in files {
            let filename = (file.lastPathComponent as NSString).deletingPathExtension
            XCTAssertNoThrow(try License.id(filename).getText())
        }
    }

}

