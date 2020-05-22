//
//  Notifications.swift
//  XvUtils
//
//  Created by Jason Snell on 3/2/20.
//  Copyright © 2020 Jason J. Snell. All rights reserved.
//

import Foundation

public class Notifications {
    
    public class func postNotification(name:String, userInfo:[AnyHashable : Any]?){
        
        let notification:Notification.Name = Notification.Name(rawValue: name)
        NotificationCenter.default.post(
            name: notification,
            object: nil,
            userInfo: userInfo)
    }
    
}
