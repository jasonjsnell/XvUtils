//
//  NumberUtils.swift
//  Refraktions
//
//  Created by Jason Snell on 11/9/15.
//  Copyright © 2015 Jason J. Snell. All rights reserved.
//

import Foundation
import CoreGraphics

public class Number{
    
    
    //MARK: - ROUNDING
    public class func getRoundedToTenths(from:Double) -> Double {
        return (from * 10).rounded() / 10
    }
    
    public class func getRoundedToHundredths(from:Double) -> Double {
        return (from * 100).rounded() / 100
    }
    public class func getNumberOfDigits(from:Double) -> Double {
        return floor( log10( from ) ) + 1
    }
    
    //if a stream of values has the same floor but the first 3 digits are changing
    //this removes the thousands
    //example 173455 -> 455
    public class func getFirstHundred(of:Double) -> Double {
        
        if (of > 1000) {
            
            let digits:Double = Number.getNumberOfDigits(from: of)
            let base:Double = pow(10, digits-1)
            let roundedSample:Double = floor(of / (base/100)) * (base/100)
            return of - roundedSample
            
        } else {
            return of
        }
        
    }
    
    //MARK: - RANDOM
    public class func getRandomFloat() -> Float {
        return Float.random(in: 0 ..< 1)
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
    
    //MARK: - SUMMING
    public class func getTotal(ofArray:[Int]) -> Int {
        var total:Int = 0
        for value in ofArray {
            total += value
        }
        return total
    }
    
    public class func getTotal(ofArray:[Double]) -> Double {
        
        return ofArray.reduce(0, +)
    }
    
    //MARK: - Statistics
    public class func getAverage(ofArray:[Int]) -> Int {
        let total:Int = getTotal(ofArray: ofArray)
        return total / ofArray.count
    }
    
    public class func getAverage(ofArray:[Double]) -> Double {
        return getMean(ofArray: ofArray) //same as Mean
    }
    
    public class func getMean(ofArray:[Double]) -> Double {
        let total:Double = getTotal(ofArray: ofArray)
        return total / Double(ofArray.count)
    }
    
    public class func getMedian(ofArray: [Double]) -> Double {
        
        let sorted:[Double] = ofArray.sorted()
        if (sorted.count % 2 != 0) {
            return Double(sorted[sorted.count / 2])
        } else {
            return Double(sorted[sorted.count / 2] + sorted[sorted.count / 2 - 1]) / 2.0
        }
    }
    
    public class func getStandardDeviation(ofArray:[Double]) -> Double {
        
        let length:Double = Double(ofArray.count)
        let avg:Double = ofArray.reduce(0, {$0 + $1}) / length
        let sumOfSquaredAvgDiff:Double = ofArray.map { pow($0 - avg, 2.0)}.reduce(0, {$0 + $1})
        return sqrt(sumOfSquaredAvgDiff / length)
    }
    
    //MARK: - Multi-array functions
    //takes an array of arrays
    //and provides an average value for each position in the array
    //(each array must be the same length)
    //it returns an array with the averaged values
    
    public class func getAverageByIndex(arrays:[[Double]]) -> [Double]? {
        
        guard let length = arrays.first?.count else { return [] }

        // check all the elements have the same length, otherwise returns nil
        guard !arrays.contains(where:{ $0.count != length }) else { return nil }

        return (0..<length).map { index in
            let sum = arrays.map { $0[index] }.reduce(0, +)
            return sum / Double(arrays.count)
        }
    }
    
    public class func getSumByIndex(arrays:[[Double]]) -> [Double]? {
        
        guard let length = arrays.first?.count else { return [] }

        // check all the elements have the same length, otherwise returns nil
        guard !arrays.contains(where:{ $0.count != length }) else { return nil }

        return (0..<length).map { index in
            let sum = arrays.map { $0[index] }.reduce(0, +)
            return sum
        }
    }
    
    public class func getMaxByIndex(arrays:[[Double]]) -> [Double]? {
        
        guard let length = arrays.first?.count else { return [] }

        // check all the elements have the same length, otherwise returns nil
        guard !arrays.contains(where:{ $0.count != length }) else { return nil }

        return (0..<length).map { i in
            let max:Double? = arrays.map { $0[i] }.max()
            return max!
        }
    }
    
    //MARK: - PERCENTAGES
    public class func getPercentage(value1:Int, ofValue2:Int) -> Int {
        return (value1 * 100) / ofValue2
    }
    
    public class func getPercentage(value1:Float, ofValue2:Float) -> Float {
        return (value1 * 100) / ofValue2
    }
    
    public class func getPercentage(value1:Double, ofValue2:Double) -> Double {
        return (value1 * 100) / ofValue2
    }
    
    public class func getPercentage(value1:CGFloat, ofValue2:CGFloat) -> CGFloat {
        return (value1 * 100) / ofValue2
    }
    
    public class func get(percentage:Float, ofValue:Float) -> Float {
        return  (ofValue * percentage) / 100
    }
    
    public class func get(percentage:CGFloat, ofValue:CGFloat) -> CGFloat {
        return  (ofValue * percentage) / 100
    }
    
    public class func get(percentage:Double, ofValue:Double) -> Double {
        return  (ofValue * percentage) / 100
    }
    
    //MARK: - EXPONENTIALS
    public class func getGeometricSeries(exponent:Double, seriesLength:Int) -> [Double] {
        
        return Array(sequence(first: exponent, next: { $0 * exponent }).prefix(seriesLength))
    }
    
    //MARK: - GEOMETRY
    public class func getDistance(betweenPointA:CGPoint, andPointB:CGPoint) -> CGFloat {
        let xDist = betweenPointA.x - andPointB.x
        let yDist = betweenPointA.y - andPointB.y
        return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
    }
    
    //MARK: - CIRCLES
    public class func getRadian(ofView:UIView) -> Float {
        return (atan2f(Float(ofView.transform.b), Float(ofView.transform.a)))
    }
    
    public class func getDegree(ofView:UIView) -> Double {
        let radian:Float = getRadian(ofView: ofView)
        return getDegree(fromRadian: Double(radian))
    }
    
    public class func getRadian(fromDegree:Double) -> Double {
        return fromDegree * Double.pi / 180
    }
    
    public class func getDegree(fromRadian:Double) -> Double {
        return fromRadian * 180 / Double.pi
    }
    
    //MARK: - COMPARISON
    public class func isEven(number:Int) -> Bool {
        if number % 2 == 0 {
            return true
        } else {
            return false
        }
    }
    
    //MARK: - DATA
    
    // converts data type to Int32 types
    public class func getInt(fromData:Data) ->Int32 {
        
        //2020 v2
        var value:Int32 = 0
        let bytesCopied = withUnsafeMutableBytes(of: &value, { fromData.copyBytes(to: $0)} )
        assert(bytesCopied == MemoryLayout.size(ofValue: value))
        
        return value
    }
    
    //MARK: - MISC
    
    public class func getFahrenheit(fromCelsius:Float) -> Float {
        return (fromCelsius * 9 / 5) + 32.0
    }

}
