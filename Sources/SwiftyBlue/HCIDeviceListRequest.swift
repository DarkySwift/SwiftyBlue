//
//  HCIDeviceListRequest.swift
//  SwiftyBlue
//
//  Created by Carlos Duclos on 3/30/18.
//

import Foundation

extension HCI {
    
    struct DeviceListRequest {
        
        /// uint16_t dev_num;
        var count: UInt16 = 0
        
        /// struct hci_dev_req dev_req[0];    /* hci_dev_req structures */
        /// 16 elements
        var list: (HCIDeviceRequest, HCIDeviceRequest, HCIDeviceRequest, HCIDeviceRequest, HCIDeviceRequest, HCIDeviceRequest, HCIDeviceRequest, HCIDeviceRequest, HCIDeviceRequest, HCIDeviceRequest, HCIDeviceRequest, HCIDeviceRequest, HCIDeviceRequest, HCIDeviceRequest, HCIDeviceRequest, HCIDeviceRequest) = (HCIDeviceRequest(), HCIDeviceRequest(), HCIDeviceRequest(), HCIDeviceRequest(), HCIDeviceRequest(), HCIDeviceRequest(), HCIDeviceRequest(), HCIDeviceRequest(), HCIDeviceRequest(), HCIDeviceRequest(), HCIDeviceRequest(), HCIDeviceRequest(), HCIDeviceRequest(), HCIDeviceRequest(), HCIDeviceRequest(), HCIDeviceRequest())
        
        init() { }
        
        subscript (index: Int) -> HCIDeviceRequest {
            
            switch index {
                
            case 0:  return list.0
            case 1:  return list.1
            case 2:  return list.2
            case 3:  return list.3
            case 4:  return list.4
            case 5:  return list.5
            case 6:  return list.6
            case 7:  return list.7
            case 8:  return list.8
            case 9:  return list.9
            case 10: return list.10
            case 11: return list.11
            case 12: return list.12
            case 13: return list.13
            case 14: return list.14
            case 15: return list.15
                
            default: fatalError("Invalid index \(index)")
            }
        }
        
    }
    
}
