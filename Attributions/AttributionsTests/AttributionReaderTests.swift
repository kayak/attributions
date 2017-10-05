import XCTest
@testable import Attributions

class AttributionReaderTests: XCTestCase {

    private lazy var testsBundle = Bundle(for: type(of: self))
    private var sections: [AttributionSection] = []

    func testLoadsGoodJSON() {
        guard let path = testsBundle.url(forResource: "goodJSON", withExtension: "json") else {
            XCTFail()
            return
        }
        sections.append(AttributionSection(file: path, description: "GoodJSON"))

        verifyReadingSections(framework: "Apache", hasBundleIDs: [])
        verifyReadingSections(framework: "Eclipse", hasBundleIDs: [])
        verifyReadingSections(framework: "Another Framework", hasBundleIDs: ["com.kayak.AttributionsTests"])
    }

    func testThrowsErrorForBadLicenseKey() {
        guard let path = testsBundle.url(forResource: "badKey", withExtension: "json") else {
            XCTFail()
            return
        }
        sections.append(AttributionSection(file: path, description: "BadKey"))

        verifyReadingSectionsThrows()
    }

    func testThrowsErrorForBadLicenseFile() {
        guard let path = testsBundle.url(forResource: "badFile", withExtension: "json") else {
            XCTFail()
            return
        }
        sections.append(AttributionSection(file: path, description: "BadFile"))
        
        verifyReadingSectionsThrows()
    }

    // MARK: - Helpers

    private func verifyReadingSections(framework: String, hasBundleIDs bundleIDs: [String]) {
        do {
            let attributions = try compileAttributions()
            for attribution in attributions {
                if attribution.name == framework {
                    XCTAssert(attribution.displayedForMainBundleIDs.elementsEqual(bundleIDs))
                    XCTAssertNoThrow(try attribution.license.getText())
                    return
                }
            }
            XCTFail("Didn't find matching attribution for framework \(framework)")
        } catch {
            XCTFail()
        }
    }

    private func verifyReadingSectionsThrows() {
        XCTAssertThrowsError(try compileAttributions())
    }

    private func compileAttributions() throws -> [Attribution] {
        let attributions = try AttributionReader().compileAttributions(sections: sections, mainBundle: testsBundle)
        return attributions.flatMap { $0 }
    }

}