import XCTest
@testable import RestApiCore

final class RestApiCoreTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        //XCTAssertEqual(RestApiCore().text, "Hello, World!")
    }

    struct Response<T: Decodable>: Decodable {
        var result: T
    }
    
    @discardableResult
    func decodeVoidResponse(from json: String) throws -> Response<VoidResponse> {
        guard let data = json.data(using: .utf8) else {
            fatalError("Wrong json: \(json)")
        }
        return try ApiMethod("").makeJsonDecoder().decode(Response<VoidResponse>.self, from: data)
    }
    
    func testNullFromText() {
        let json = "{\"result\":\"OK\"}"
        XCTAssertNoThrow(try decodeVoidResponse(from: json))
    }
    
    func testNullFromInt() {
        let json = "{\"result\": 42}"
        XCTAssertNoThrow(try decodeVoidResponse(from: json))
    }
    
    func testNullFromNull() {
        let json = "{\"result\": null}"
        XCTAssertNoThrow(try decodeVoidResponse(from: json))
    }
    
    func testEmptyNull() {
        let json = "{}"
        XCTAssertThrowsError(try decodeVoidResponse(from: json))
    }
    
    static var allTests = [
        ("testExample", testExample), ("testNull", testNullFromText), ("testEmptyNull", testEmptyNull)
    ]
}
