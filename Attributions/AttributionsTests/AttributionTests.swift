import XCTest
@testable import Attributions

class AttributionTests: XCTestCase {

    private lazy var testsBundle = Bundle(for: type(of: self))

    func testNoBundleIDsMatchesAnyBundle() {
        let attribution = Attribution(name: "framework", displayedForMainBundleIDs: [], license: .id("apache-2.0"))
        XCTAssert(attribution.isDisplayed(in: testsBundle))
    }

    func testBundleIDMatchesTestsBundle() {
        let attribution = Attribution(name: "framework", displayedForMainBundleIDs: ["com.kayak.AttributionsTests"], license: .id("apache-2.0"))
        XCTAssert(attribution.isDisplayed(in: testsBundle))
    }

    func testBundleIDDoesntMatchTestsBundle() {
        let attribution = Attribution(name: "framework", displayedForMainBundleIDs: ["arbitrary.bundle.id"], license: .id("apache-2.0"))
        XCTAssertFalse(attribution.isDisplayed(in: testsBundle))
    }

}
