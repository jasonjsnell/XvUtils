//
//  NumberUtils.swift
//  Refraktions
//
//  Created by Jason Snell on 11/9/15.
//  Copyright © 2015 Jason J. Snell. All rights reserved.
//

import Foundation

public class Number{
    
    //MARK:RANDOM NUMS
    public class func getRandomFloat() -> Float {
        return Float(arc4random()) / 0xFFFFFFFF
    }
    
    public class func getRandomFloat(betweenMin: Float, andMax: Float) -> Float {
        return getRandomFloat() * (andMax - betweenMin) + betweenMin
    }
    
    public class func getRandomDouble() -> Double {
        return Double(arc4random()) / 0xFFFFFFFF
    }
    
    public class func getRandomDouble(betweenMin: Double, andMax: Double) -> Double {
        return getRandomDouble() * (andMax - betweenMin) + betweenMin
    }
    
    public class func getRandomInt(within: Int) -> Int {
        return Int(arc4random_uniform(UInt32(within)))
    }
    
    public class func getRandomInt(betweenMin: Int, andMax: Int) -> Int {
        return Int(arc4random_uniform(UInt32(andMax - betweenMin + 1))) + betweenMin
    }
    
    //MARK:SUMMING
    public class func getTotal(ofArray:[Int]) -> Int {
        var total:Int = 0
        for value in ofArray {
            total += value
        }
        return total
    }
    
    public class func getAverage(ofArray:[Int]) -> Int {
        let total:Int = getTotal(ofArray: ofArray)
        return total / ofArray.count
    }
    
    //MARK:PERCENTAGES
    public class func getPercentage(value1:Int, ofValue2:Int) -> Int {
        return (value1 * 100) / ofValue2
    }
    
    public class func getPercentage(value1:Float, ofValue2:Float) -> Float {
        return (value1 * 100) / ofValue2
    }
    
    public class func get(percentage:Float, ofValue:Float) -> Float {
        return  (ofValue * percentage) / 100
    }
    
    //scale percentage
    //take a value and scale it to the screen
    
}
