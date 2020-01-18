import XCTest
@testable import RestApiCore

final class RestApiCoreTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(RestApiCore().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
