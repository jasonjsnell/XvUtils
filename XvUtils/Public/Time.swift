//
//  Time.swift
//  XvUtils
//
//  Created by Jason Snell on 10/11/20.
//  Copyright © 2020 Jason J. Snell. All rights reserved.
//

import Foundation

public class Time {
    
    //MARK: Current time
    public class func getCurrentHour() -> Int {
        
        return Calendar.current.component(.hour, from: Date())
    }
    
    public class func getCurrentMinute() -> Int {
        
        return Calendar.current.component(.minute, from: Date())
    }
    
    public class func getCurrentSecond() -> Int {
        
        return Calendar.current.component(.second, from: Date())
    }
    
    public class func getCurrentHourAndMinute() -> [Int] {
        
        return [getCurrentHour(), getCurrentMinute()]
    }
    
    public class func getCurrentHourAndMinuteString() -> String {
        
        return String(getCurrentHour()) + ":" + String(getCurrentMinute())
    }
    
    
    //MARK: Convert to time format
    public class func convertToHourAndMinute(base10:Int) -> [Int] {
        
        let hour:Int = Int(Float(base10/100))
        
        // let minute:Int = ( (base10 - (hour * 100)) * 60 ) / 100 //convert to 60
        
        let minute:Int = ( (base10 - (hour * 100)) * 60 ) / 100 //convert to 60
        
        return [hour, minute]
    }
    
    public class func convertToMinutes(base10:Int) -> Int {
        
        return (base10 * 60) / 100 //convert to 60
    }
    
    public class func convertToStandardTimeString(base10:Int) -> String {
        
        var hour:Int = Int(Float(base10/100))
        let minute:Int = ( (base10 - (hour * 100)) * 60 ) / 100 //convert to 60
        
        //determine am/pm
        var ampm:String = "am"
        if (hour >= 12 && hour < 24) {
            ampm = "pm"
        }
        
        //remove miltary +12
        if (hour > 12) {
            hour -= 12
        }
        
        //midnight as 12 instead of 00
        if (ampm == "am" && hour == 0){
            hour = 12
        }
        
        let hourString:String = addZeros(toTimeString: String(hour))
        let minString:String = addZeros(toTimeString: String(minute))
        
        return hourString + ":" + minString + " " + ampm
    }
    

    public class func convertToMilitaryTimeString(base10:Int) -> String {
        
        let hour:Int = Int(Float(base10/100))
        let minute:Int = ( (base10 - (hour * 100)) * 60 ) / 100 //convert to 60
        
        let hourString:String = addZeros(toTimeString: String(hour))
        let minString:String = addZeros(toTimeString: String(minute))
    
        return hourString + ":" + minString
    }
    
    //MARK: Convert to base 10 format
    
    //hourAndMinute = "10:30 pm"
    //hourAndMinute = "10:30"
    //hourAndMinute = "10:30pm"
    public class func convertToBase10(hourAndMinute:String) -> Int? {
        
        //incoming string requires colon
        if (!hourAndMinute.contains(":")) {
            print("Time: Error: convertToBase10(hourAndMinute: Incorrect format", hourAndMinute, "for conversion.")
            return nil
        }
        
        //remove spaces
        let timeNoSpacesLowercased:String = hourAndMinute.replacingOccurrences(of: " ", with: "").lowercased()
        
        //prep var
        var timeString:String = ""
        
        //PM
        if (timeNoSpacesLowercased.contains("pm")) {
        
            //remove pm
            timeString = timeNoSpacesLowercased.replacingOccurrences(of: "pm", with: "")
            
            //convert string to Int
            let components:[Int] = timeString.split { $0 == ":" } .map { (x) -> Int in return Int(String(x))! }
            var hours:Int = components[0]
            let minutes:Int = components[1]
           
            //convert to miltary
            if (hours < 12) {
                hours += 12
            }
            return convertToBase10(hour: hours, minute: minutes)
            
        } else {
            
            //remove am (if present)
            timeString = timeNoSpacesLowercased.replacingOccurrences(of: "am", with: "")
            
            //convert string to Int
            let components:[Int] = timeString.split { $0 == ":" } .map { (x) -> Int in return Int(String(x))! }
            let hours:Int = components[0]
            let minutes:Int = components[1]
            
            return convertToBase10(hour: hours, minute: minutes)
        }
    }
    
    public class func convertToBase10(hour:Int, minute:Int) -> Int {
        
        return (convertToBase10(hour: hour)) + (convertToBase10(minute: minute))
    }
    
    public class func convertToBase10(hour:Int) -> Int {
        
        return hour * 100
    }
    
    public class func convertToBase10(minute:Int) -> Int {
        
        return Int((minute * 100) / 60)
    }
    
    
    public class func addZeros(toTimeString:String) -> String {
        
        //grab var
        var twoDigitString:String = toTimeString
        
        //add zero in front if needed
        if (twoDigitString.count == 1) {
            twoDigitString = "0" + twoDigitString
        }
        
        return twoDigitString
    }
}
