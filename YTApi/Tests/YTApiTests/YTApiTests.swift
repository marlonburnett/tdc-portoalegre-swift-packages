import XCTest
@testable import YTApi

final class YTApiTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(YTApi().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
