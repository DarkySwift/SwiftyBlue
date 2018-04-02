//
//  InquiryInfo.swift
//  SwiftyBlue
//
//  Created by Carlos Duclos on 4/1/18.
//

import Foundation

public struct InquiryResult {
    
    var address: Address = Address()
    var pscanRepMode: UInt8 = 0
    var pscanPeriodMode: UInt8 = 0
    var pscanMode: UInt8 = 0
    var deviceClasses: (UInt8, UInt8, UInt8) = (0, 0, 0)
    var clockOffset: UInt16 = 0
}
