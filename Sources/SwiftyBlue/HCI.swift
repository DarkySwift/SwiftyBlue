//
//  HCI.swift
//  SwiftyBlue
//
//  Created by Carlos Duclos on 3/30/18.
//

import Foundation

typealias HCIDeviceRequest = HCI.DeviceRequest
typealias HCIDeviceListRequest = HCI.DeviceListRequest
typealias HCIDeviceFlag = HCI.DeviceFlag
typealias HCIDeviceInfo = HCI.DeviceInfo
typealias HCIDeviceState = HCI.DeviceState
typealias HCIIOCTL = HCI.IOCTL
typealias HCIInquiryRequest = HCI.InquiryRequest

internal struct HCI {
    
    static func inquiry(deviceIdentifier: CInt, duration: Int, limit: Int) throws -> [InquiryResult] {
        
        let descriptor = socket(AF_BLUETOOTH, SOCK_RAW | SOCK_CLOEXEC, 1)
        guard descriptor >= 0 else { throw POSIXError.fromErrno }
        defer { close(descriptor) }
        print("descriptor:", descriptor)        

        let bufferSize = MemoryLayout<HCIInquiryRequest>.size + (MemoryLayout<InquiryResult>.size * limit)
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        defer { buffer.deallocate(capacity: bufferSize) }
        print("bufferSize:", bufferSize)
        
        let deviceClass: (UInt8, UInt8, UInt8) = (0x33, 0x8b, 0x9e)
        
        buffer.withMemoryRebound(to: HCIInquiryRequest.self, capacity: 1) { (inquiryRequest) in
            inquiryRequest.pointee.deviceIndentifier = UInt16(deviceIdentifier)
            inquiryRequest.pointee.numberResponse = UInt8(limit)
            inquiryRequest.pointee.length = UInt8(duration)
            inquiryRequest.pointee.flags = 0
            inquiryRequest.pointee.lap = deviceClass
            return
        }
        
        let ioctlValue = ioctl(descriptor, HCIIOCTL.Inquiry, UnsafeMutableRawPointer(buffer))
        guard ioctlValue >= 0 else { throw POSIXError.fromErrno }
        print("ioctlValue:", ioctlValue)
        
        
        let resultCount = buffer.withMemoryRebound(to: HCIInquiryRequest.self, capacity: 1) {
            Int($0.pointee.numberResponse)
        }
        print("resultCount:", resultCount)
        
        let resultBufferSize = MemoryLayout<InquiryResult>.size * resultCount
        print("resultBufferSize:", resultBufferSize)
        
        var results = [InquiryResult](repeating: InquiryResult(), count: resultCount)
        memcpy(&results, buffer.advanced(by: MemoryLayout<HCIInquiryRequest>.size), resultBufferSize)
        
        return results
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
        return (a & b) != 0
    }
    
    static func openDevice(deviceIdentifier: CInt) throws -> CInt {
        guard deviceIdentifier >= 0 else { throw POSIXError(code: .ENODEV) }
        
        let hciSocket = socket(AF_BLUETOOTH, SOCK_RAW | SOCK_CLOEXEC, 1)
        guard hciSocket >= 0 else { throw POSIXError.fromErrno }
        defer { close(hciSocket) }
        
        var socketAddress = SocketAddress()
        socketAddress.family = sa_family_t(AF_BLUETOOTH)
        socketAddress.deviceIdentifier = UInt16(deviceIdentifier)
        
        let didBind = withUnsafeMutablePointer(to: &socketAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                bind(hciSocket, $0, socklen_t(MemoryLayout<SocketAddress>.size)) >= 0
            }
        }
        
        guard didBind else { close(hciSocket); throw POSIXError.fromErrno }
        
        return hciSocket
    }
    
}
