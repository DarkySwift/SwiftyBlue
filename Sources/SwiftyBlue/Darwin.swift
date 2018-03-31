//
//  Darwin.swift
//  SwiftyBlue
//
//  Created by Carlos Duclos on 3/30/18.
//

import Foundation

#if os(OSX) || os(iOS)
    
    internal func stub() -> Never {
        
        fatalError("Method not implemented. This code only runs on Linux.")
    }
    
#endif
