//
//  Socket.swift
//  SwiftyBlue
//
//  Created by Carlos Duclos on 3/30/18.
//

import Foundation

#if os(Linux)
    import Glibc
#endif

let AF_BLUETOOTH: CInt = 31

#if os(Linux)
    
let SOCK_RAW = CInt(Glibc.SOCK_RAW.rawValue)
    
let SOCK_CLOEXEC = CInt(Glibc.SOCK_CLOEXEC.rawValue)
    
#endif


#if os(OSX) || os(iOS)
    
var SOCK_CLOEXEC: CInt { stub() }
    
#endif
