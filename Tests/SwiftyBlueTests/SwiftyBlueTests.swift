import XCTest
@testable import SwiftyBlue

class SwiftyBlueTests: XCTestCase {
    
    func testAdapter() {
        do {
            let adapter = try Adapter()
            print("Found adapter with identifier", adapter.identifier)
            print("Found adapter with hciSocket", adapter.hciSocket)
            
            XCTAssert(adapter.identifier >= 0, "identifier must be equals or greater than 0")
            XCTAssert(adapter.hciSocket >= 0, "hciSocket must be equals or greater than 0")
        } catch {
            XCTFail("Adapter not found")
        }
    }
    
    func testScan() {
        
        let adapter: Adapter
        do {
            adapter = try Adapter()
            XCTAssert(adapter.identifier >= 0, "identifier must be equals or greater than 0")
            XCTAssert(adapter.hciSocket >= 0, "hciSocket must be equals or greater than 0")
            
        } catch {
            XCTFail("Adapter not found")
            return
        }
        
        let scanStartDate = Date()
        print("Scan started at: ", scanStartDate)
        
        let results: [InquiryResult]
        do {
            results = try adapter.scan(duration: 10, limit: 200)
        } catch {
            XCTFail("Could not retrieve results")
            return
        }
        
        let scanEndDate = Date()
        print("Scan finished at: ", scanEndDate)
        
        for (index, info) in results.enumerated() {
            print(index+1, ":", String.init(data: info.address.data, encoding: .utf8))
        }
    }

    static var allTests = [
        ("testAdapter", testAdapter),
        ("testScan", testScan),
    ]
    
}
