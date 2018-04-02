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
        guard let deviceIdentifier = try HCI.getRoute(address: address) else {
            throw Adapter.Error.adapterNotFound
        }
        
        let hciSocket = try HCI.openDevice(deviceIdentifier: deviceIdentifier)
        
        self.init(identifier: deviceIdentifier, hciSocket: hciSocket)
    }
    
    init(identifier: CInt, hciSocket: CInt) {
        self.identifier = identifier
        self.hciSocket = hciSocket
    }
    
    public func scan(duration: Int = 8, limit: Int = 255) throws -> [InquiryResult] {
        precondition(duration > 0, "Scan must be longer than 0 seconds")
        precondition(limit > 0, "Must scan at least one device")
        precondition(limit <= 255, "Cannot be larger than UInt8.max")
        
        return try HCI.inquiry(deviceIdentifier: identifier, duration: duration, limit: limit)
    }
}

extension Adapter {
    
    public enum Error: Swift.Error {
        case adapterNotFound
    }
    
    public var address: Address? {
        return try? HCI.getDeviceAddress(identifier)
    }
    
}
