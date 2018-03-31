//
//  Adapter.swift
//  SwiftyBlue
//
//  Created by Carlos Duclos on 3/30/18.
//

import Foundation

public final class Adapter {
    
    let identifier: CInt
    let hciSocket: CInt
    
    deinit {
        close(hciSocket)
    }
    
    public convenience init(address: Address? = nil) throws {
        guard let deviceIdentifier = try HostControllerInterface.getRoute(address: address) else {
            throw Adapter.Error.adapterNotFound
        }
        
        let hciSocket = try HostControllerInterface.openDevice(deviceIdentifier: deviceIdentifier)
        
        self.init(identifier: deviceIdentifier, hciSocket: hciSocket)
    }
    
    init(identifier: CInt, hciSocket: CInt) {
        self.identifier = identifier
        self.hciSocket = hciSocket
    }
}

extension Adapter {
    
    public enum Error: Swift.Error {
        
        case adapterNotFound
        
    }
    
}
