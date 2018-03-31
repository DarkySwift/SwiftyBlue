//
//  SocketAddress.swift
//  SwiftyBlue
//
//  Created by Carlos Duclos on 3/30/18.
//

import Foundation

extension HostControllerInterface {
    
    struct SocketAddress {
        var family = sa_family_t()
        var deviceIdentifier: UInt16 = 0
        var channel: UInt16 = 0
        
        init() { }
    }
    
}
