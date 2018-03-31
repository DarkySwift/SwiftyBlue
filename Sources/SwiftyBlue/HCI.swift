//
//  HCI.swift
//  SwiftyBlue
//
//  Created by Carlos Duclos on 3/30/18.
//

import Foundation

typealias HCIDeviceRequest = HostControllerInterface.DeviceRequest
typealias HCIDeviceListRequest = HostControllerInterface.DeviceListRequest
typealias HCIDeviceFlag = HostControllerInterface.DeviceFlag
typealias HCIDeviceInfo = HostControllerInterface.DeviceInfo
typealias HCIDeviceState = HostControllerInterface.DeviceState
typealias HCIIOCTL = HostControllerInterface.IOCTL

internal struct HostControllerInterface {
    
    static func inquiry() throws {
//        guard let identifier = try getRoute(address: nil) else {  }
//        guard identifier >= 0 else { throw POSIXError.fromErrno }
//
//        let sock = socket(AF_BLUETOOTH, SOCK_RAW | SOCK_CLOEXEC, 1)
//        guard sock >= 0 else { throw POSIXError.fromErrno }
        
    }
    
    static func getRoute(address: Address? = nil) throws -> CInt? {
        guard let device = try getDeviceIdentifier() else { return nil }
        
        defer { close(device.hciSocket) }
        
        var deviceInfo = HCIDeviceInfo()
        deviceInfo.identifier = UInt16(device.deviceIdentifier)
        
        let ioctlValue = withUnsafeMutablePointer(to: &deviceInfo, { pointer -> CInt in
            return ioctl(device.hciSocket, HCIIOCTL.GetDeviceInfo, pointer)
        })
        
        guard ioctlValue == 0 else { throw POSIXError.fromErrno }
        
        return device.deviceIdentifier
    }
    
    static func getDeviceInfo(_ deviceIdentifier: CInt) throws -> HCIDeviceInfo {
        let hciSocket = socket(AF_BLUETOOTH, SOCK_RAW | SOCK_CLOEXEC, 1)
        
        guard hciSocket >= 0 else { throw POSIXError.fromErrno }
            
        defer { close(hciSocket) }
        
        var deviceInfo = HCIDeviceInfo()
        deviceInfo.identifier = UInt16(deviceIdentifier)
        
        let result = withUnsafeMutablePointer(to: &deviceInfo) { pointer -> CInt in
            return ioctl(hciSocket, HCIIOCTL.GetDeviceInfo, UnsafeMutableRawPointer(pointer))
        }
        
        guard result == 0 else { throw POSIXError.fromErrno }
        
        return deviceInfo
    }
    
    static func getDeviceIdentifier(flag: HCIDeviceFlag = .Up) throws -> (hciSocket: CInt, deviceIdentifier: CInt)? {
        let hciSocket = socket(AF_BLUETOOTH, SOCK_RAW | SOCK_CLOEXEC, 1)
        guard hciSocket >= 0 else { throw POSIXError.fromErrno }
        
        var deviceList = HCIDeviceListRequest()
        deviceList.count = UInt16(16)
        
        let ioctlValue = withUnsafeMutablePointer(to: &deviceList) { pointer -> CInt in
            return ioctl(hciSocket, HCIIOCTL.GetDeviceList, UnsafeMutableRawPointer(pointer))
        }
        
        guard ioctlValue >= 0 else { throw POSIXError.fromErrno }
        
        for i in 0..<Int(deviceList.count) {
            let deviceRequest = deviceList[i]
            let deviceIdentifier = CInt(deviceRequest.identifier)
            
            guard testBit(flag: flag, options: deviceRequest.options) else { continue }
            
            guard deviceIdentifier >= 0 else { throw POSIXError(code: .ENODEV) }
            
            return (hciSocket, deviceIdentifier)
        }
        
        return nil
    }
    
    static func testBit(flag: HCIDeviceFlag, options: UInt32) -> Bool {
        let a = (options + (UInt32(bitPattern: flag.rawValue) >> 5))
        let b = (1 << (UInt32(bitPattern: flag.rawValue) & 31))
        return true//(a & b) != 0
    }
    
}

extension HostControllerInterface {
    
    public struct IOCTL {
        
        private static let H                    = CInt(UnicodeScalar(unicodeScalarLiteral: "H").value)
        
        /// #define HCIDEVUP    _IOW('H', 201, int)
        public static let DeviceUp              = IOC.IOW(H, 201, CInt.self)
        
        /// #define HCIDEVDOWN    _IOW('H', 202, int)
        public static let DeviceDown            = IOC.IOW(H, 202, CInt.self)
        
        /// #define HCIDEVRESET    _IOW('H', 203, int)
        public static let DeviceReset           = IOC.IOW(H, 203, CInt.self)
        
        /// #define HCIDEVRESTAT    _IOW('H', 204, int)
        public static let DeviceRestat          = IOC.IOW(H, 204, CInt.self)
        
        /// #define HCIGETDEVLIST    _IOR('H', 210, int)
        public static let GetDeviceList         = IOC.IOR(H, 210, CInt.self)
        
        /// #define HCIGETDEVINFO    _IOR('H', 211, int)
        public static let GetDeviceInfo         = IOC.IOR(H, 211, CInt.self)
        
        // TODO: All HCI ioctl defines
        
        /// #define HCIINQUIRY    _IOR('H', 240, int)
        public static let Inquiry               = IOC.IOR(H, 240, CInt.self)
    }
    
    
    
}