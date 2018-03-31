//
//  HCIDeviceRequest.swift
//  SwiftyBlue
//
//  Created by Carlos Duclos on 3/30/18.
//

import Foundation

extension HostControllerInterface {
    
    struct DeviceRequest {
        var identifier: UInt16 = 0
        var options: UInt32 = 0
        
        init () {}
    }
    
}
