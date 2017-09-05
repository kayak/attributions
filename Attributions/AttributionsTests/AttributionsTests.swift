import XCTest
@testable import Attributions

class AttributionsTests: XCTestCase {

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

    func testLoadsGoodJSON() {
        let bundle = Bundle(for: type(of: self))
        var sections = [AttributionSection]()
        guard let path = bundle.url(forResource: "goodJSON", withExtension: "json") else {
            XCTFail()
            return
        }
        sections.append(AttributionSection(file: path, description: "GoodJSON"))
        let names = ["Apache", "Eclipse", "Another Framework"]
        
        runAttributionCompilerTest(doesThrow: false, sections: sections, names: names)
    }

    func testThrowsErrorForBadLicenseKey() {
        let bundle = Bundle(for: type(of: self))
        var sections = [AttributionSection]()
        guard let path = bundle.url(forResource: "badKey", withExtension: "json") else {
            XCTFail()
            return
        }

        sections.append(AttributionSection(file: path, description: "BadKey"))
        runAttributionCompilerTest(doesThrow: true, sections: sections, names: ["BadKey"])
    }

    func testThrowsErrorForBadLicenseFile() {
        let bundle = Bundle(for: type(of: self))
        var sections = [AttributionSection]()
        guard let path = bundle.url(forResource: "badFile", withExtension: "json") else {
            XCTFail()
            return
        }
        sections.append(AttributionSection(file: path, description: "BadFile"))
        
        runAttributionCompilerTest(doesThrow: true, sections: sections, names: ["BadFile"])
    }
    
    private func runAttributionCompilerTest(doesThrow: Bool, sections: [AttributionSection], names: [String])
    {
        if doesThrow {
            XCTAssertThrowsError(try AttributionReader().compileAttributions(sections: sections))
        } else {
            do {
                let result = try AttributionReader().compileAttributions(sections: sections)
                for section in result {
                    try section.forEach {
                        XCTAssert(names.contains($0.name))
                        XCTAssertNoThrow(try $0.license.getText())
                    }
                }
            } catch {
                XCTFail()
                return
            }
        }
    }

}
