//
//  HCIInquiryRequest.swift
//  SwiftyBluePackageDescription
//
//  Created by Carlos Duclos on 4/1/18.
//

import Foundation

extension HCI {
    
    struct InquiryRequest {
        
        var deviceIndentifier: UInt16 = 0
        var flags: UInt16 = 0
        var lap: (UInt8, UInt8, UInt8) = (0, 0, 0)
        var length: UInt8 = 0
        var numberResponse: UInt8 = 0
        
        init() {}
    }
    
}
