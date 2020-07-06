//
//  Hex.swift
//  XvUtils
//
//  Created by Jason Snell on 6/21/20.
//  Copyright © 2020 Jason J. Snell. All rights reserved.
//

import Foundation

public class Hex {
    
    //MARK: - 2 string hex from 2 bytes packets
    public class func getHex(fromBytes:[UInt8]) -> String {
        
        //int blank string
        var hexStr:String = ""
        
        //loop through each byte in array
        for byte in fromBytes {
            
            //convert byte into a hex formatted string and build via concatentation
            
            //hexStr += String(format:"%02X", byte) // positive values only?
            hexStr += String(format: "%02hhX", byte) //can include negative values
        }
        return hexStr
    }
    
    //MARK: - get hex array
    public class func getHexArray(fromBytes:[UInt8], packetLength:Int, packetTotal:Int) -> [String] {
        
        var hexArray:[String] = []
        var bytePos:Int = 0
        
        //error check
        if (packetTotal > (fromBytes.count / packetLength)) {
            print("Hex: Error: Attempting to decode more packets than is available with the incoming data. Returning []")
            return []
        }
        
        for _ in 0..<packetTotal {
        
            //traverse array positions until reaching the end point (which is the curr pos + length)
            let posEnd:Int = bytePos + packetLength

            //init blank array
            var byteArr:[UInt8] = []

            //keep adding bytes until end position is reached
            while bytePos < posEnd {
                byteArr.append(fromBytes[bytePos])
                bytePos += 1
            }

            //convert bytes into a hex
            let hex:String = getHex(fromBytes: byteArr)
            
            //add to hex aray
            hexArray.append(hex)
        }
        
        return hexArray
    }
    
    //MARK: - Unsigned ints from from hex
    
    public class func getUInt8(fromHex:String) -> UInt8? {
        
        //8-bit values need to be 2 chars
        if (fromHex.count == 2) {
            
            //try to convert hex into UInt8
            if let uInt8Value:UInt8 = UInt8(fromHex, radix: 16) {
                
                return uInt8Value
                
            } else {
                return nil
            }
            
        } else {
            print("Hex: Error: Hex needs to be 2 characters long to create an 8-bit value")
            return nil
        }
    }
    
    public class func getUInt16(fromHex:String) -> UInt16? {
        
        //16-bit values need to be 4 chars
        if (fromHex.count == 4) {
            
            //try to convert hex into UInt16
            if let uInt16Value:UInt16 = UInt16(fromHex, radix: 16) {
                
                return uInt16Value
                
            } else {
                return nil
            }
                
        } else {
            print("Hex: Error: Hex needs to be 4 characters long to create an 16-bit value")
            return nil
        }
    }
    
    //MARK: - Sign ints from hex
    
    public class func getInt8(fromHex:String) -> Int8? {
        
        //8-bit values need to be 2 chars
        if (fromHex.count == 2) {
            
            //try to convert hex into UInt8
            if let uInt8Value:UInt8 = UInt8(fromHex, radix: 16) {
                
                //and return the bit pattern as Int8
                return Int8(bitPattern: uInt8Value)
                
            } else {
                return nil
            }
            
        } else {
            print("Hex: Error: Hex needs to be 2 characters long to create an 8-bit value")
            return nil
        }
    }
    
    public class func getInt16(fromHex:String) -> Int16? {
        
        //16-bit values need to be 4 chars
        if (fromHex.count == 4) {
            
            //try to convert hex into UInt16
            if let uInt16Value:UInt16 = UInt16(fromHex, radix: 16) {
                
                //and return the bit pattern as Int8
                return Int16(bitPattern: uInt16Value)
                
            } else {
                return nil
            }
                
        } else {
            print("Hex: Error: Hex needs to be 4 characters long to create an 16-bit value")
            return nil
        }
    }
    
    
    //MARK: - Int arrays from hex arrays
    
    public class func getUInt8Array(fromHexArray:[String]) -> [UInt8] {
        
        var uint8Array:[UInt8] = []
        
        for hex in fromHexArray {
            if let uint8:UInt8 = getUInt8(fromHex: hex) {
                uint8Array.append(uint8)
            }
        }
        return uint8Array
    }
    
    public class func getInt8Array(fromHexArray:[String]) -> [Int8] {
        
        var int8Array:[Int8] = []
        
        for hex in fromHexArray {
            if let int8:Int8 = getInt8(fromHex: hex) {
                int8Array.append(int8)
            }
        }
        return int8Array
    }
    
    public class func getUInt16Array(fromHexArray:[String]) -> [UInt16] {
        
        var uint16Array:[UInt16] = []
        
        for hex in fromHexArray {
            if let uint16:UInt16 = getUInt16(fromHex: hex) {
                uint16Array.append(uint16)
            }
        }
        return uint16Array
    }
    
    public class func getInt16Array(fromHexArray:[String]) -> [Int16] {
        
        var int16Array:[Int16] = []
        
        for hex in fromHexArray {
            if let int16:Int16 = getInt16(fromHex: hex) {
                int16Array.append(int16)
            }
        }
        return int16Array
    }
    
    //MARK: - 12 Bit (three character hex)
    
    public class func get12BitHexArray(fromUInt8Array:[UInt8]) -> [String] {
        
        //first convert UInt8 to UInt 16
        let UInt16Array:[UInt16] = fromUInt8Array.map { UInt16($0) }
        
        //pass to method below
        return get12BitHexArray(fromUInt16Array: UInt16Array)
    }
    
    public class func get12BitHexArray(fromUInt16Array:[UInt16]) -> [String] {
        
        //get 12-bit array
        let uInt12Array:[UInt16] = Bytes.constructUInt12Array(fromUInt16Array: fromUInt16Array)
        
        //take new 12-bit values and convert them to 3 character hex values
        //%03 will put a zero in front of a 2 character hex, if needed
        // the "l" means long, which allows larger values than h or hh (used for 2 char hexes)
        return uInt12Array.map { String(format: "%03lX", $0) }
    }
    
}
