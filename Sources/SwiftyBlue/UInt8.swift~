public extension UInt8 {
    
    func toHexadecimal() -> String {
        
        var string = String(self, radix: 16)
        
        if string.utf8.count == 1 {
            
            string = "0" + string
        }
        
        return string.uppercased()
    }
}