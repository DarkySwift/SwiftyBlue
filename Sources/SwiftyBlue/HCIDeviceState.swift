//
//  HCIDeviceState.swift
//  SwiftyBlue
//
//  Created by Carlos Duclos on 3/30/18.
//

import Foundation

extension HostControllerInterface {

    internal struct DeviceState {
        
        /// uint32_t err_rx;
        var errorRX: UInt32 = 0
        
        /// uint32_t err_tx;
        var errorTX: UInt32 = 0
        
        /// uint32_t cmd_tx;
        var commandTX: UInt32 = 0
        
        /// uint32_t evt_rx;
        var eventRX: UInt32 = 0
        
        /// uint32_t acl_tx;
        var ALC_TX: UInt32 = 0
        
        /// uint32_t acl_rx;
        var ALC_RX: UInt32 = 0
        
        /// uint32_t sco_tx;
        var SCO_TX: UInt32 = 0
        
        /// uint32_t sco_rx;
        var SCO_RX: UInt32 = 0
        
        /// uint32_t byte_rx;
        var byteRX: UInt32 = 0
        
        /// uint32_t byte_tx;
        var byteTX: UInt32 = 0
        
        init() { }
    }

}
