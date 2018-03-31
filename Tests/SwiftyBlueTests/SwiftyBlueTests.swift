import XCTest
@testable import SwiftyBlue

class SwiftyBlueTests: XCTestCase {
    
    func testDeviceInfo() {
        do {
            let adapter = try Adapter()
            print("Found adapter with identifier", adapter.identifier)
            print("Found adapter with hciSocket", adapter.hciSocket)
        } catch {
            print("No adapter found")
        }
    }

    static var allTests = [
        ("testDeviceInfo", testDeviceInfo),
    ]
    
}
