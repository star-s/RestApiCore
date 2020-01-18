import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(RestApiCoreTests.allTests),
    ]
}
#endif
