//
//  PerformanceManager.swift
//  Refraktions
//
//  Created by Jason Snell on 11/7/15.
//  Copyright © 2015 Jason J. Snell. All rights reserved.
//

//classes that check the performance:

//metronome, when setting a timer loop
//visual output, removing and limiting visuals
//audio mixer, limits channels

import UIKit

public class Device {
    
    //MARK:-
    //MARK: CONSTANTS
    
    public static let SCREEN_MAX:CGFloat = 2208
    
    public static let SPEED_SLOW:UInt = 1
    public static let SPEED_MED:UInt = 2
    public static let SPEED_FAST:UInt = 3
    
    public static let TYPE_IPAD:String = "iPad"
    public static let TYPE_IPHONE:String = "iPhone"
    public static let TYPE_IPOD:String = "iPod"
    
  
    //MARK:- PUBLIC API -

    public class func getSpeed() -> UInt {
        return getSpeed(fromName: getName(fromIdenfier: getIdenfierFromDevice()))
    }
    
    public class func getType() -> String {
        return getType(fromIdenfier: getIdenfierFromDevice())
    }
    
    
    //MARK:- PRIVATE API -
    //get speed based on name of device
    fileprivate class func getSpeed(fromName:String) -> UInt {
        
        switch fromName {
            
        case "iPod Touch 5", "iPhone 4", "iPhone 4s", "iPad 2", "iPad 3", "iPad Mini" :
            return  SPEED_SLOW
        case "iPhone 5", "iPhone 5c", "iPad 4", "iPad Air", "iPad Mini 2", "iPad Mini 3" :
            return SPEED_MED
        default :
            return SPEED_FAST
        }
        
    }
    
    //type, like iPod, iPad, iPhone
    fileprivate class func getType(fromIdenfier:String) -> String {
        
        if (fromIdenfier.contains(TYPE_IPAD)){
            return TYPE_IPAD
        } else if (fromIdenfier.contains(TYPE_IPOD)){
            return TYPE_IPOD
        } else {
            return TYPE_IPHONE
        }
        
    }
    
    //translates device name into a more readable name
    fileprivate class func getName(fromIdenfier:String) -> String {
        
        //code: http://stackoverflow.com/questions/26028918/ios-how-to-determine-iphone-model-in-swift
        //specs: http://blakespot.com/ios_device_specifications_grid.html
        //cpu / gpu clocks
        
        switch fromIdenfier {
            
        case "iPod5,1":                                 return "iPod Touch 5"      //"800", "200"]  //slow
        case "iPod7,1":                                 return "iPod Touch 6"      //"1100", "450"] //fast
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"          //800, 200 ]     //slow
        case "iPhone4,1":                               return "iPhone 4s"         //800, 250 ]     //slow
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"          //1300, 266]     //med
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"         //1300, 266]     //med
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"         //1300, 450]     //fast
        case "iPhone7,2":                               return "iPhone 6"          //1400, 450]     //fast
        case "iPhone7,1":                               return "iPhone 6 Plus"     //1400, 450]     //fast
        case "iPhone8,1":                               return "iPhone 6s"         //1850, 450]     //fast
        case "iPhone8,2":                               return "iPhone 6s Plus"    //1850, 450]     //fast
        case "iPhone8,4":                               return "iPhone SE"         //1850, 450]     //fast
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"            //1000, 250]     //slow
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"            //1000, 250]     //slow
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"            //1400, 300]     //med
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"          //1400, 300?]     //med
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"        //1500, 450]     //fast
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"         //1000, 250]     //slow
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"       //1300, 300]     //med
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"       //1300, 300]     //med
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"       //1400, 450]     //fast
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"          //2260, 450]     //fast
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return fromIdenfier
            
        }
    }
    
    //gets the device ID from system
    fileprivate class func getIdenfierFromDevice() -> String {
        return UIDevice.current.identifier
    }
    
}

//UIDevice code
public extension UIDevice {
    
    var identifier: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
}
