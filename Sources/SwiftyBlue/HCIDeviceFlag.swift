//
//  HCIDeviceFlag.swift
//  SwiftyBlue
//
//  Created by Carlos Duclos on 3/30/18.
//

import Foundation

extension HostControllerInterface {
    
    enum DeviceFlag: CInt {
        
        case Up
        case Initialized
        case Running
        
        case PassiveScan
        case InteractiveScan
        case Authenticated
        case Encrypt
        case Inquiry
        
    }
    
}
