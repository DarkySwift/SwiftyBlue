//
//  HCIDeviceInfo.swift
//  SwiftyBlue
//
//  Created by Carlos Duclos on 3/30/18.
//

import Foundation

extension HostControllerInterface {
    
    internal struct DeviceInfo {
        
        /// uint16_t dev_id;
        var identifier: UInt16 = 0
        
        /// char name[8];
        var name: (CChar, CChar, CChar, CChar, CChar, CChar, CChar, CChar) = (0, 0, 0, 0, 0, 0, 0, 0)
        
        /// bdaddr_t bdaddr;
        var address: Address = .zero
        
        /// uint32_t flags;
        var flags: UInt32 = 0
        
        /// uint8_t type;
        var type: UInt8 = 0
        
        /// uint8_t  features[8];
        var features: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8) = (0, 0, 0, 0, 0, 0, 0, 0)
        
        /// uint32_t pkt_type;
        var packetType: UInt32 = 0
        
        /// uint32_t link_policy;
        var linkPolicy: UInt32 = 0
        
        /// uint32_t link_mode;
        var linkMode: UInt32 = 0
        
        /// uint16_t acl_mtu;
        var ACLMaximumTransmissionUnit: UInt16 = 0
        
        /// uint16_t acl_pkts;
        var ACLPacketSize: UInt16 = 0
        
        /// uint16_t sco_mtu;
        var SCOMaximumTransmissionUnit: UInt16 = 0
        
        /// uint16_t sco_pkts;
        var SCOPacketSize: UInt16 = 0
        
        /// struct hci_dev_stats stat;
        var stat: DeviceState = DeviceState()
        
        init() { }
    }
    
}

