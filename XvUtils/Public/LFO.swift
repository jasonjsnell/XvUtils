//
//  LFO.swift
//  XvUtils
//
//  Created by Jason Snell on 1/10/19.
//  Copyright © 2019 Jason J. Snell. All rights reserved.
//

import Foundation


public class LFO {
    
    //public attributes
    fileprivate var _speed:Double = 10.0
    public var speed:Double {
        get {return _speed}
        set {
            _speed = newValue
            refresh()
        }
    }
    
    fileprivate var _depth:Double = 10.0
    public var depth:Double {
        get {return _depth}
        set {
            _depth = newValue
            refresh()
        }
    }
    
    fileprivate var _offset:Double = 0.0
    public var offset:Double {
        get {return _offset}
        set {
            _offset = newValue
            refresh()
        }
    }
    
    
    fileprivate var _position:Double = 0.0
    public var position:Double {
        get {return _position}
    }
    public var invertedPosition:Double {
        get {return _position * -1}
    }
    
    //shape
    public var shape:String = "shapeTriangle"
    public let SHAPE_TRIANGLE:String = "shapeTriangle"
    
    //direction
    fileprivate var dir:Int = 1
    
    //timer
    fileprivate var timer:Timer = Timer()
    fileprivate var timerSpeed:TimeInterval = 0.1
    
    
    
    public init(){
        
    }
    
    //MARK: - TIMER
    //LFO can be powered by an internal timer, gui clock, or audio clock
    public func start(){
        refresh()
    }
    
    //MARK: - ANIM
    @objc func anim(){
        
        var nextPosition:Double = _position
        
        if (dir == 1){
            
            //going up
            
            nextPosition = _position + 1.0
            if (nextPosition >= depth) {
                nextPosition = depth
                dir = -1
            }
            
            
        } else if (dir == -1){
            
            //going down
            nextPosition = _position - 1.0
            if (nextPosition <= -depth) {
                nextPosition = -depth
                dir = 1
            }
        }
        
        _position = nextPosition
       
    }
    
    fileprivate func refresh(){
        
        //reset timer
        timer.invalidate()
        timerSpeed = 1.0 / speed
        timer = Timer.scheduledTimer(timeInterval: timerSpeed, target: self, selector: #selector(anim), userInfo: nil, repeats: true)
        
       
    }
    
}
