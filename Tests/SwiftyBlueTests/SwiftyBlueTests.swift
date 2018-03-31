import XCTest
@testable import SwiftyBlue

class SwiftyBlueTests: XCTestCase {
    
    func testDeviceInfo() {
        
        do {
            let adapter = try Adapter()
            print("identifier", adapter)
        } catch  {
            print("No adapter found")
        }
    }

    static var allTests = [
        ("testDeviceInfo", testDeviceInfo),
    ]
    
}
