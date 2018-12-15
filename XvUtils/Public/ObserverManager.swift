//
//  ObserverManager.swift
//  XvUtils
//
//  Created by Jason Snell on 3/27/17.
//  Copyright © 2017 Jason J. Snell. All rights reserved.
//

import Foundation

open class ObserverManager:NSObject {
    
    public let nc:NotificationCenter = NotificationCenter.default
    public var notificationNames:[String] = []
    public var notificationSelectors:[Selector] = []
    
    override public init(){
        super.init()
    }
    
    public func addObservers(){
        
        removeObservers()
        
        if (notificationNames.count == notificationSelectors.count){
            for i:Int in 0..<notificationNames.count {
                
                nc.addObserver(
                    self,
                    selector: notificationSelectors[i],
                    name: Notification.Name(rawValue: notificationNames[i]),
                    object: nil
                )
            }
        } else {
            print("HELPER: Error: addObservers error, notification count != selector count")
        }
    }
    
    public func removeObservers(){
        
        for i:Int in 0..<notificationNames.count {
            nc.removeObserver(
                self,
                name: Notification.Name(rawValue:notificationNames[i]),
                object: nil)
        }
    }
    
    public func postNotification(name:String, userInfo:[AnyHashable : Any]?){
        
        let notification:Notification.Name = Notification.Name(rawValue: name)
        NotificationCenter.default.post(
            name: notification,
            object: nil,
            userInfo: userInfo)
    }
}
