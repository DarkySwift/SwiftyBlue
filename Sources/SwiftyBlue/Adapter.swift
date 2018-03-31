//
//  Adapter.swift
//  SwiftyBlue
//
//  Created by Carlos Duclos on 3/30/18.
//

import Foundation

public final class Adapter {
    
    let identifier: CInt
//    let socket: CInt
    
//    deinit {
//        close(socket)
//    }
    
    public convenience init(address: Address? = nil) throws {
        guard let deviceIdentifier = try HostControllerInterface.getRoute(address: address) else {
            throw Adapter.Error.adapterNotFound
        }
        self.init(identifier: deviceIdentifier)
    }
    
    init(identifier: CInt) {
        self.identifier = identifier
//        self.socket = socket
    }
}

extension Adapter {
    
    public enum Error: Swift.Error {
        
        case adapterNotFound
        
    }
    
}
