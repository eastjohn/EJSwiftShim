import XCTest
@testable import EJSwiftShim

final class EJSwiftShimTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(EJSwiftShim().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
