//
//  LogarithmicScaling.swift
//  XvUtils
//
//  Created by Jason Snell on 6/5/21.
//  Copyright © 2021 Jason J. Snell. All rights reserved.
//

//info about log() and exp(), translating std :: exp and std :: log from JUCE C++ example to Swift code
//logf is the same as std::log
//exp is the same as std::exp
//std::log(148.413) = 5
//std::exp(5) = 148.413
//print("logf", logf(148.413)) // = 5
//print("exp", exp(5.0)) // should equal 148

import Foundation

public class LogarithmicScaling {

    
    
    public var outputRange:Int
    public var smoothing:Bool = false
    
    public init(outputRange:Int, smoothing:Bool = false){
        
        self.outputRange = outputRange
        self.smoothing = smoothing
    }
    
    public func scaleCG(dataSet:[CGFloat]) -> [CGFloat] {
        return scaleF(dataSet: dataSet.map { Float($0) }).map { CGFloat($0) }
    }
    
    
    /*
     //https://stackoverflow.com/questions/31142335/how-to-plot-data-logarithmically
     // Map to rect coordinate space
     float logMinFreq = log10f(minFrequencyToDisplay);
     float x = (log10f(binFreq)-logMinFreq ) * (rect.size.width-1) /
               (log10f(44100.0 / 2)-logMinFreq );
     
     */
    
    public func scaleF(dataSet:[Float]) -> [Float] {
        
        //make an array of zeroes
        var outputSet:[Float] = Array(repeating: 0.0, count: outputRange)
        
        //loop through the data set
        let dataSetCount:Int = dataSet.count
        for i in 0..<dataSetCount {
            
            //This is the destination for the data, after the data slot num has been put through logf()
            var outputBinF:Float = log10f(Float(i)) * Float(outputRange) /
                log10f(Float(dataSetCount))
            
            //non numbers become zero
            if (outputBinF.isNaN || outputBinF.isInfinite){
                outputBinF = 0
            }
            
            //place the data value into the log scaled output position
            outputSet[Int(outputBinF)] = dataSet[i]
        }
        
        if (smoothing){
            
            var inZeroValley:Bool = false
            var zeroCount:Int = 0
            var lastActiveValue:Float = 0.0
            
            //loop through the output array backwards, because the end of the data has denser data
            for i in stride(from: outputSet.count-1, through: 0, by: -1) {
                
                //curr value in the loop
                let currValue:Float = outputSet[i]
                //print(i, "=", currValue)
                
                //if the value is active, meaning its not a zero
                if (currValue != 0.0 || i==0) {
                    
                    if (inZeroValley || i==0) {
                        //print("-------- LEAVING ZERO VALLEY", zeroCount, lastActiveValue, "-", currValue)
                        
                        for z in 1...zeroCount {
                            
                            let lastPos:Int = i+z
                            
                            let inc:Float = (currValue - lastActiveValue) / Float(zeroCount + 1)
                            
                            let add:Float = inc * Float(zeroCount-z+1)
                            //print("inc", inc, "x", z, "= add", add)
                            let smoothedValue:Float = lastActiveValue + add
                            outputSet[lastPos] = smoothedValue
                            //print("->", z, lastPos, "==", outputSet[lastPos])
                        }
                    }
                    
                    //save it, because this is one end of the smoothing
                    lastActiveValue = currValue
                    
                    //reset zero vars
                    inZeroValley = false
                    zeroCount = 0
                
                } else {
                    inZeroValley = true
                    zeroCount += 1
                }
            }
        }
      
        return outputSet
    }
}
