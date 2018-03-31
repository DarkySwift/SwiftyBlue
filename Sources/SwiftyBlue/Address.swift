//
//  Address.swift
//  SwiftyBlue
//
//  Created by Carlos Duclos on 3/30/18.
//

import Foundation

public struct Address {
    
    public typealias ByteValue = (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)
    
    public static var zero: Address { return Address(bytes: (0, 0, 0, 0, 0, 0)) }
    public static var any: Address { return Address(bytes: (0, 0, 0, 0, 0, 0)) }
    public static var none: Address { return Address(bytes: (0xff, 0xff, 0xff, 0xff, 0xff, 0xff)) }
    
    // MARK: - Properties
    
    public var bytes: ByteValue
    
    // MARK: - Initialization
    
    public init(bytes: ByteValue = (0,0,0,0,0,0)) {
        self.bytes = bytes
    }
    
}

public extension Address {
    
    public init?(data: Data) {
        guard data.count == 6 else { return nil }
        self.bytes = (data[0], data[1], data[2], data[3], data[4], data[5])
    }
    
    public var data: Data {
        return Data([bytes.0, bytes.1, bytes.2, bytes.3, bytes.4, bytes.5])
    }
}

// MARK: - Byte Swap

public extension Address {
    
    /// A representation of this address with the byte order swapped.
    public var byteSwapped: Address {
        
        return Address(bytes: (bytes.5, bytes.4, bytes.3, bytes.2, bytes.1, bytes.0))
    }
    
    /// Creates an address from its little-endian representation, changing the
    /// byte order if necessary.
    ///
    /// - Parameter value: A value to use as the little-endian representation of
    ///   the new address.
    public init(littleEndian value: Address) {
        #if _endian(little)
            self = value
        #else
            self = value.byteSwapped
        #endif
    }
    
    /// Creates an address from its big-endian representation, changing the byte
    /// order if necessary.
    ///
    /// - Parameter value: A value to use as the big-endian representation of the
    ///   new address.
    public init(bigEndian value: Address) {
        #if _endian(big)
            self = value
        #else
            self = value.byteSwapped
        #endif
    }
    
    /// The little-endian representation of this address.
    ///
    /// If necessary, the byte order of this value is reversed from the typical
    /// byte order of this address. On a little-endian platform, for any
    /// address `x`, `x == x.littleEndian`.
    public var littleEndian: Address {
        #if _endian(little)
            return self
        #else
            return byteSwapped
        #endif
    }
    
    /// The big-endian representation of this address.
    ///
    /// If necessary, the byte order of this value is reversed from the typical
    /// byte order of this address. On a big-endian platform, for any
    /// address `x`, `x == x.bigEndian`.
    public var bigEndian: Address {
        #if _endian(big)
            return self
        #else
            return byteSwapped
        #endif
    }
}
